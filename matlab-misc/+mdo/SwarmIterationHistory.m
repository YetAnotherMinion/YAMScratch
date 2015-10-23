classdef SwarmIterationHistory < handle
	properties
		niterations
		nparticles
		xlb
		xub
		Velocities
		Positions
		Xbest
		Xbestindex
		Xworst
		Xworstindex
		Ybest
		Ybestindex
		Yworst
		Yworstindex
	end
	methods

		function obj = SwarmIterationHistory(niter, npart)
			obj.niterations = niter;
			obj.nparticles = npart;
			return
		end
		function m_lowEditIteration(obj, iteration, Xbest, Ybest, varargin)
		%Usage:
		%	m_lowEditIteration(iteration, Xbest, Ybest)
		%	m_lowEditIteration(iteration, Xbest, Ybest, Xworst, Yworst)

			assert(0 < iteration );
			assert(obj.niterations >= iteration);
			assert(isvector(Xbest));
			assert(isscalar(Ybest));
			obj.Xbest(iteration,:) = Xbest;
			obj.Ybest(iteration,1) = Ybest;
			if nargin == 4
				assert(isvector(varargin{1}));
				assert(isscalar(varargin{2}));
				obj.Xworst(iteration,:) = varargin{1};
				obj.Yworst(iteration,1) = varargin{2};
			end
		end
		function m_highEditIteration(obj, iteration, positions, velocities, xbestndx, Ybest)
			assert( 0 < iteration);
			assert(obj.niterations >= iteration);
			assert(isscalar(xbestndx));
			assert(isscalar(Ybest));
			%rows should be design variables
			%columns are individual particles
			[r,c] = size(positions);
			%don't waste a function call
			assert(all([r,c] == size(velocities)));
			assert(obj.nparticles == c);
			obj.Positions(:,:,iteration) = positions;
			obj.Velocities(:,:,iteration) = velocities;
			obj.Xbestindex(iteration) = xbestndx;
			obj.Ybest(iteration) = Ybest; 

		end
	end
end