clear;
close all
import mdo.*

DEBUG = false;
PLOT_OBJECTIVE = false;
COLLECT_STATS = false;

d = datestr(clock);
filename = regexprep(d, '\s|-|:', '_');

%Define Constants
N_ult = 2.5;
t_over_c = 0.12;
W_0 = 4940;
rho = 1.23;         %density of air
mu = 17.8e-6;       %viscosity of air
k = 1.2;            %form factor
e = 0.96;           %Oswald efficiency factor
S_wet_ratio = 2.05;
Velocity = 35;

V_min = 22;         %maximum landing velocity
C_L_max = 2;        %maximum coefficient of lift at landing

X_0 = [35; 35];
%===========================================================
%The plane object that holds all of the methods
plane = mdo.ComputeAirPlane2(N_ult, t_over_c, W_0, rho, mu, k, e, S_wet_ratio, Velocity);
fig_1 = figure;

if PLOT_OBJECTIVE
	a = [5:1e-1:35]; % A
	s = [5:1e-1:40]; % S
	[AA,SS] = meshgrid(a,s);
	tic
	Drag = arrayfun(@plane.m_DragForce, AA, SS);
	toc
	contour(AA,SS,Drag,50);
	hold on
	%mesh(AA, SS, Drag)
	xlabel('A');
	ylab = ylabel('S','Rotation',0);
	set(ylab,'Units','Normalized','Position',[-0.07 0.5 0]);
	hold on
	disconline = a*0.85^2;
	disconline(disconline < 5) = NaN;
	plot(a,disconline,'r--')
end


%===========================================================
obj = @(X)(plane.m_DragForce(X(1), X(2)));
if COLLECT_STATS
	stop_criteria = [1:50];
	num_samples = 200;
	fvals_accum = zeros(length(stop_criteria), num_samples);
	run_times = zeros(length(stop_criteria), num_samples);

	for nnn = 1:length(stop_criteria)
		for ndata = 1:num_samples
			tstart = tic;
			flag_1 = true;
			try
			[x_star, fval] = Swarm3(obj, [5;5], [40;40], stop_criteria(nnn));
			catch ME
				flag_1 = false;
			end
			run_times(nnn, ndata) = toc(tstart);
			if flag_1
				fvals_accum(nnn, ndata) = fval;
			else
				fvals_accum(nnn, ndata) = NaN;
			end
		end
		disp('===============================')
	end
	save(filename, 'fvals_accum', 'S_devs', 'f_means', 'run_times', 'stop_criteria')
else
	while true
		filename = input('Enter filename with pso statistics to load: ', 's')
		response = input(strcat('Do you want to load: ', filename, ' [N/y]? '), 's');
		if response == 'y'
			try
			 	load(filename);
			 	break
			catch ME
				disp('could not load file, try again')
			end
			
		end
	end
	[x_star, fval] = Swarm3(obj, [5;5], [40;40]);
end
%rows are convergence criteria, columns are individual tests
[r1,c1] = size(fvals_accum);

%std computes column wise and our samples are row wise so transpose
S_devs = std(fvals_accum.');
f_means = mean(fvals_accum, 2).';
%plot the best of each values as well
best_vals = min(fvals_accum, [], 2).';
worst_vals = max(fvals_accum, [], 2).';
overall_best_val = min(best_vals);

time_S_devs = std(run_times.');
time_means = mean(run_times.');
%generate mean squares for each run
gev_coefficients = zeros(r1, 3);
for index = 1:r1
	gev_coefficients(index, :) =  mle(fvals_accum(index,:),'distribution', 'gev');
end

compare_gev_mean_to_best_fig = figure;
semilogy(1:50, gev_coefficients(:,3) - overall_best_val,'rd')
xlabel('Exit condition (iterations)');
ya1 = ylabel('u_k - f^*','Rotation',0);
set(ya1,'Units','Normalized','Position',[-0.17 0.5 0]);

low_bound_gev_fig = figure;
low_bound_gev = gev_coefficients(:,3) - (gev_coefficients(:,2) ./ gev_coefficients(:,1));

semilogy(1:50, low_bound_gev.' - best_vals, 'kd')


data_fig = figure;
errorbar(stop_criteria, gev_coefficients(:,3), gev_coefficients(:,1))
hold on
plot(stop_criteria, best_vals, 'g-')
hold on
plot(stop_criteria, worst_vals, 'r-')

time_fig = figure;
errorbar(stop_criteria, time_means, time_S_devs)

plott_fig = figure;

NUM_LINSPACE = 1500;

first_time_fig = subplot(3,1,1);
selector = 1;
[N,bincntr] = hist(fvals_accum(selector,:),50);
hist(fvals_accum(selector,:),50)
binWidth = bincntr(2) - bincntr(1);
hold on
 fvals_accum(selector,:);
A_gev = gev_coefficients(selector,1);
B_gev = gev_coefficients(selector,2);
C_gev = gev_coefficients(selector,3);
max_val = max(fvals_accum(selector,:));
temp_vals(1,:) = linspace(low_bound_gev(selector), max_val,NUM_LINSPACE);
temp_vals(2,:) = pdf('gev',temp_vals(1,:), A_gev, B_gev, C_gev);
[ax, p1, p2] = plotyy(temp_vals(1,:), zeros(1,NUM_LINSPACE),temp_vals(1,:), temp_vals(2,:), 'plot', 'plot');
delete(p1)
%recolor the bloody axis
set(ax(1), 'YColor', 'k')
set(ax(2), 'YColor', 'r')
set(p2,'Color', 'r')

x_low_bound = gev_coefficients(selector,3) - 2*(gev_coefficients(selector,2)./gev_coefficients(selector,1));
x_high_bound = gev_coefficients(selector,3) + 7*binWidth;
set(ax(1), 'XLim', [x_low_bound, x_high_bound])
set(ax(2), 'XLim', [x_low_bound, x_high_bound])

%====================================================
third_time_fig = subplot(3,1,2);
selector = 3;
[N,bincntr] = hist(fvals_accum(selector,:),50);
hist(fvals_accum(selector,:),50)
binWidth = bincntr(2) - bincntr(1);
hold on
 fvals_accum(selector,:);
A_gev = gev_coefficients(selector,1);
B_gev = gev_coefficients(selector,2);
C_gev = gev_coefficients(selector,3);
max_val = max(fvals_accum(selector,:));
temp_vals(1,:) = linspace(low_bound_gev(selector), max_val,NUM_LINSPACE);
temp_vals(2,:) = pdf('gev',temp_vals(1,:), A_gev, B_gev, C_gev);
[ax, p1, p2] = plotyy(temp_vals(1,:), zeros(1,NUM_LINSPACE),temp_vals(1,:), temp_vals(2,:), 'plot', 'plot');
delete(p1)
%recolor the bloody axis
set(ax(1), 'YColor', 'k')
set(ax(2), 'YColor', 'r')
set(p2,'Color', 'r')

x_low_bound = gev_coefficients(selector,3) - 2*(gev_coefficients(selector,2)./gev_coefficients(selector,1));
x_high_bound = gev_coefficients(selector,3) + 7*binWidth;
set(ax(1), 'XLim', [x_low_bound, x_high_bound])
set(ax(2), 'XLim', [x_low_bound, x_high_bound])

%====================================================
fifth_time_fig = subplot(3,1,3);
selector = 5;
[N,bincntr] = hist(fvals_accum(selector,:),50);
hist(fvals_accum(selector,:),50)
binWidth = bincntr(2) - bincntr(1);
hold on
 fvals_accum(selector,:);
A_gev = gev_coefficients(selector,1);
B_gev = gev_coefficients(selector,2);
C_gev = gev_coefficients(selector,3);
max_val = max(fvals_accum(selector,:));
temp_vals(1,:) = linspace(low_bound_gev(selector), max_val,NUM_LINSPACE);
temp_vals(2,:) = pdf('gev',temp_vals(1,:), A_gev, B_gev, C_gev);
[ax, p1, p2] = plotyy(temp_vals(1,:), zeros(1,NUM_LINSPACE),temp_vals(1,:), temp_vals(2,:), 'plot', 'plot');
delete(p1)
%recolor the bloody axis
set(ax(1), 'YColor', 'k')
set(ax(2), 'YColor', 'r')
set(p2,'Color', 'r')

x_low_bound = gev_coefficients(selector,3) - 2*(gev_coefficients(selector,2)./gev_coefficients(selector,1));
x_high_bound = gev_coefficients(selector,3) + 7*binWidth;
set(ax(1), 'XLim', [x_low_bound, x_high_bound])
set(ax(2), 'XLim', [x_low_bound, x_high_bound])


%{
tenth_time_fig = subplot(3,2,4);
hist(fvals_accum(10,:),50)

twentyfive_time_fig = subplot(3,2,5);
hist(fvals_accum(25,:),50)

fifty_time_fig = subplot(3,2,6);
hist(fvals_accum(50,:),50)
%}

%===========================================================
%				BFGS SEARCH
%===========================================================
figure(fig_1)
plot(x_star(1), x_star(2), 'kd')

linesearch = @mdo.ProfLinesearch;
%configure the linesearch parameters here
mu_1 = 1e-4;
mu_2 = 0.9;
alpha_init = .5;
alpha_max = 10;
tolerance = 5e-5;
ls_parameters = [mu_1, mu_2, alpha_init, alpha_max, tolerance];
e_g = 1e-6;
e_a = 1e-6;
e_r = 1e-6;

grad = @(X) (plane.mH_gradDragForce(X(1), X(2)));

qn_log = MajorIterationHistory();

try
	[xk, hessian] = QuasiNewtonBFGS(linesearch, obj, grad, X_0, e_g, e_a, e_r, qn_log, ls_parameters);
	plot(xk(1),xk(2),'rd')
catch ME

end
%plot the convergence of the algorithm
hold on 
plot(qn_log.x(:,1), qn_log.x(:,2), 'kd-')
