function [x_star, varargout] = Swarm3(obj, xlb, xub, varargin)
%Purpose:
%     Attempt to minimise a scalar valued objective function over a domain
%     specificed by an upper and lower bound on the values of the design 
%     variables
% Inputs:
%     obj - a function handle to an objective function taking a column vector
%     xlb - a vector of lower bounds for each of the design variables, set this
%             to negative infinity if there is no lower bound
%     xub - a vector of upper bounds for each of the design variables, set this
%             to positive infinity if there is no upper bound
%     stop_criteria - number of iterations of no change in best before exit
%     options - a struct that enables finer control over the particle swarm
%             and tuning of parameters. (NOT IMPLEMENTED)
% Outputs:
%     x_star - the optimum point found during the optimization, this may not be
%              global or local minium, however it is generally a very good guess
%     swarmLogObj - a structure holding information about the performance of the
%                 algorithim. The options struct controls the verbosity of this 
%                 information. LOW reports the best and worst particle position
%                 and objective value for each iteration. HIGH reports the 
%                 position and velocity of every particle for every iteration. 
%                 This is very memory intensive, and the program will probably
%                 crash.

    DEBUG = false;

    if nargin >=4
        stop_criteria = varargin{1};
    else 
        stop_criteria = 30;
    end
    if nargin >= 5
        if varargin{2} == 'high'
            HIGH_DETAIL = true;
        else
            HIGH_DETAIL = false;
        end
    else
        HIGH_DETAIL = false;
    end

    assert(isvector(xlb));
    assert(isvector(xub));
    SIZE_X = length(xub);
    assert(SIZE_X == length(xlb));

    npart = 40;     % number of particles.
    niter = 300;    % number of iterations.
    cbi = 2.5;      % Initial value of the individual-best acceleration factor.
    cbf = 0.5;      % Final value of the individual-best acceleration factor.
    cgi = 0.5;      % Initial value of the global-best acceleration factor.
    cgf = 2.5;      % Final value of the global-best acceleration factor.
    wi = 0.9;       % Initial value of the inertia factor.
    wf = 0.4;       % Final value of the inertia factor.
    vspaninit = 1;  % The initial velocity span.
    vmax = 0.3* max(xub-xlb);     % Absolute speed limit. It is the primary

    swarmLogObj = SwarmIterationHistory(niter, npart);

    Y = zeros(npart,1);
    %Initialize X with random variables
    X_range = xub - xlb;
    X = rand(SIZE_X,npart);
    X = bsxfun(@times, X_range, X);
    X = bsxfun(@plus, xlb, X);

    %check for best conditions
    tic
    Y(1) = obj(X(:,1));
    reg_time = toc;
    try
        gx0 = gpuArray(X);
        tic
        Y(1) = obj(gx0(:,1));
        gpu_time = toc;
    catch ME
        %disp('GPU disabled')
        gpu_time = Inf; 
    end

    %==============================================
    %           INITIALIZATION ROUTINE
    %==============================================
    %use this time to test if parfor is any good
    try
        if isempty(gcp('nocreate'))
            parpool(4)
        end
        %we have already found the first part
        parfor index = 2:npart
            Y(index) = obj(X(:,index));
        end
        tend = toc;
        par_time = tend/npart;
    catch ME
        par_time = Inf;
        %compute the native method
        for index = 2:npart
            Y(index) = obj(X(:,index));
        end 
    end

    Ybest = Y; % best individual score for each particle
    Xbest = X; % best individual position for each particle
    [GYbest, gbest] = min(Ybest);% GYbest is the best score within the entire swarm.
                                 % gbest is the index of particle that achived YGbest.
    InitialGYbest = GYbest; %store the original so we can compute performance ratio
    prev_GYbest = GYbest;
    gbest = gbest(1);% In event when more than one particle has the best
                     % score, pick the one with the lowest index as the
                     % best one.
    V = (rand(SIZE_X, npart)-0.5)*2.*repmat(npart, vspaninit.', 1);

    if par_time < gpu_time
        if par_time < reg_time
            STATE = 3;
        else
            STATE = 1;
        end
    elseif gpu_time < reg_time
        STATE = 2;
    else
        STATE = 1;
    end

    if STATE == 3
        if DEBUG
            disp('Parallel Mode')
        end
        overall_time = tic;
        scores = zeros(niter,1);
        iter_since_best_change = 0;
        for iter = 1:niter
            w = wi + ((wf-wi)/(niter))*(niter-iter);
            cp = cbi + ((cbf-cbi)/(niter))*(niter-iter);
            cg = cgi + ((cgf-cgi)/(niter))*(niter-iter);

            % For later calculations only
            GXbest = repmat(Xbest(:, gbest), 1, npart);

            % Calculating speeds
            V = w*V + cp*rand(size(V)).*(Xbest-X) + cg*rand(size(V)).*(GXbest-X);
            V = min(vmax, abs(V)).*sign(V);

            % Population is moving
            X = X + V;
            other_mask = X < repmat(xlb,1,npart);
            X = bsxfun(@times, other_mask, xlb)+ bsxfun(@times, ~other_mask, X);
            V = bsxfun(@times, -1*other_mask, V);
            third_mask = X > repmat(xub, 1, npart);
            X = bsxfun(@times, third_mask, xub) + bsxfun(@times, (~third_mask), X);
            V = bsxfun(@times, -1*third_mask, V);

            parfor eval_index = 1:npart
                Y(eval_index) = obj(X(:,eval_index));
            end
            % Calculating new individually best values
            mask = Y<Ybest;
            mask = mask.';
            mask = repmat(mask, SIZE_X, 1);
            Xbest = mask.*X +(~mask).*Xbest;
            Ybest = min(Y,Ybest);
            
            % Calculating new globally best value
            [GYbest, gbest] = min(Ybest);
            %disp(GYbest)
            gbest = gbest(1);
            ttotal = toc(overall_time);
            %test for convergence
            if GYbest < prev_GYbest
                iter_since_best_change = 0;
            else
                iter_since_best_change = iter_since_best_change + 1;
            end
            if iter_since_best_change >= stop_criteria
                %terminate the loop
                break;
            end
            prev_GYbest = GYbest;
            if HIGH_DETAIL
                swarmLogObj.m_highEditIteration(iter, X, V, gbest, GYbest);
            end
        end

    elseif STATE == 2
        if DEBUG
            disp('GPU Mode')
        end
        X = gpuArray(X);
        Y = gpuArray(Y);
        V = gpuArray(V);
        Xbest = gpuArray(Xbest);
        Ybest = gpuArray(Ybest);
        mask = gpuArray(zeros(size(Y)));
        overall_time = tic;
        scores = zeros(niter,1);
        iter_since_best_change = 0;
        for iter = 1:niter
            %disp(iter)
            w = wi + ((wf-wi)/(niter))*(niter-iter);
            cp = cbi + ((cbf-cbi)/(niter))*(niter-iter);
            cg = cgi + ((cgf-cgi)/(niter))*(niter-iter);

            % For later calculations only
            GXbest = repmat(Xbest(:, gbest), 1, npart);

            % Calculating speeds
            V = w*V + cp*rand(size(V)).*(Xbest-X) + cg*rand(size(V)).*(GXbest-X);
            V = min(vmax, abs(V)).*sign(V);

            % Population is moving
            X = X + V;
            other_mask = X < repmat(xlb,1,npart);
            X = bsxfun(@times, other_mask, xlb)+ bsxfun(@times, ~other_mask, X);
            V = bsxfun(@times, -1*other_mask, V);
            third_mask = X > repmat(xub, 1, npart);
            X = bsxfun(@times, third_mask, xub) + bsxfun(@times, (~third_mask), X);
            V = bsxfun(@times, -1*third_mask, V);

            for eval_index = 1:npart
                Y(eval_index) = obj(X(:,eval_index));
            end
            % Calculating new individually best values
            mask = Y<Ybest;
            mask = mask.';
            mask = repmat(mask, SIZE_X, 1);
            Xbest = mask.*X +(~mask).*Xbest;
            Ybest = min(Y,Ybest);
            
            % Calculating new globally best value
            [GYbest, gbest] = min(Ybest);
            gbest = gbest(1);
            ttotal = toc(overall_time);
                        %test for convergence
            if GYbest < prev_GYbest
                iter_since_best_change = 0;
            else
                iter_since_best_change = iter_since_best_change + 1;
            end
            if iter_since_best_change >= stop_criteria
                %terminate the loop
                break;
            end
            prev_GYbest = GYbest;
            if HIGH_DETAIL
                swarmLogObj.m_highEditIteration(iter, X, V, gbest, GYbest);
            end
        end
    elseif STATE == 1
        scores = zeros(niter,1);
        if DEBUG
            disp('Vanilla Mode')
        end
        overall_time = tic;
        iter_since_best_change = 0;
        for iter = 1:niter
            w = wi + ((wf-wi)/(niter))*(niter-iter);
            cp = cbi + ((cbf-cbi)/(niter))*(niter-iter);
            cg = cgi + ((cgf-cgi)/(niter))*(niter-iter);

            % For later calculations only
            GXbest = repmat(Xbest(:, gbest), 1, npart);

            % Calculating speeds
            V = w*V + cp*rand(size(V)).*(Xbest-X) + cg*rand(size(V)).*(GXbest-X);
            V = min(vmax, abs(V)).*sign(V);

            % Population is moving
            X = X + V;
            other_mask = X < repmat(xlb,1,npart);
            X = bsxfun(@times, other_mask, xlb)+ bsxfun(@times, ~other_mask, X);
            V = bsxfun(@times, -1*other_mask, V);
            third_mask = X > repmat(xub, 1, npart);
            X = bsxfun(@times, third_mask, xub) + bsxfun(@times, (~third_mask), X);
            V = bsxfun(@times, -1*third_mask, V);

            for eval_index = 1:npart
                Y(eval_index) = obj(X(:,eval_index));
            end
            % Calculating new individually best values
            mask = Y<Ybest;
            mask = mask.';
            mask = repmat(mask, SIZE_X, 1);
            Xbest = mask.*X +(~mask).*Xbest;
            Ybest = min(Y,Ybest);
            
            % Calculating new globally best value
            [GYbest, gbest] = min(Ybest);
            gbest = gbest(1);
            ttotal = toc(overall_time);
            %test for convergence
            if GYbest < prev_GYbest
                iter_since_best_change = 0;
            else
                iter_since_best_change = iter_since_best_change + 1;
            end
            if iter_since_best_change >= stop_criteria
                %terminate the loop
                break;
            end
            prev_GYbest = GYbest;
            if HIGH_DETAIL
                swarmLogObj.m_highEditIteration(iter, X, V, gbest, GYbest);
            end
        end
    end
    x_star = Xbest(:,gbest);
    if nargout >= 2 
        varargout{1} = GYbest;
    end
    if nargout >= 3
        varargout{2} = swarmLogObj;
    end
     return
end
