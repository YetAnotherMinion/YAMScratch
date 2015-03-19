clear
close('all');
import mdo.*

linesearch = @mdo.ProfLinesearch;
%configure the linesearch parameters here
mu_1 = 1e-4;
mu_2 = 0.3;
alpha_init = 1;
alpha_max = 20;
tolerance = 1e-6;
ls_parameters = [mu_1, mu_2, alpha_init, alpha_max, tolerance];
%create the objective function and the gradient
obj = @(X) (mdo.DragTotal(X(1), X(2)).');
grad = @GradientDragTotal;
X_0 = [25;
		35];

%===============================================
%			Steepest Descent
%===============================================
steep_log = MajorIterationHistory();
x_star = SteepestDescent(linesearch, obj, grad, X_0, steep_log, ls_parameters);


%plot the objective function
SD_fig = figure();
ContourDragTotal(SD_fig, steep_log, 'kd-', x_star);
figure(SD_fig);

%===============================================
%			Conjugate gradient method
%===============================================
 e_g = 1e-6;
 e_a = 1e-6;
 e_r = 1e-6;
congj_log = MajorIterationHistory();
x_star = ConjugateGradient(linesearch, obj, grad, X_0, e_g, e_a, e_r, congj_log, ls_parameters);

%plot the objective function
CG_fig = figure();
ContourDragTotal(CG_fig, congj_log, 'ko-.', x_star);
figure(CG_fig);
title('Conjugate Gradient Method')
%===============================================
%			    Quasi Newton Method
%===============================================


%plot the objective function
qn_log = MajorIterationHistory();
x_star = QuasiNewtonBFGS(linesearch, obj, grad, X_0, e_g, e_a, e_r, qn_log, ls_parameters);
QN_fig = figure();
ContourDragTotal(QN_fig, qn_log, 'kd-', x_star);
figure(QN_fig);

%===============================================
%			Newton Conjugate Gradient
%===============================================

%plot the objective function
%NCG_fig = figure();

%===============================================
% 			Plotting all together
%===============================================
all_algs_fig = figure;
figure(all_algs_fig)
ContourDragTotal(all_algs_fig, steep_log, 'kd-', x_star);
ContourDragTotal(all_algs_fig, congj_log, 'ko-.');
ContourDragTotal(all_algs_fig, qn_log, 'k<--');

figure(all_algs_fig);
title('All methods side by side');

gradients_fig = figure;
semilogy(1,1)
PlotMajorIterationConvergance(gradients_fig, steep_log, 'kd-');
PlotMajorIterationConvergance(gradients_fig, congj_log, 'ko-.');
PlotMajorIterationConvergance(gradients_fig, qn_log, 'k<--');
figure(gradients_fig);
xlabel('Major Iterations');
ylabel('Batman')

minor_fig = figure;
PlotMinorIterationConvergance(minor_fig)



%===============================================
%===============================================

%IMPORTANT: must pass in a column vector for X
quad_obj_factory = @(n) (@(X) (sum((X.^2)./[1:n].') ));
quad_grad_factory = @(n) (@(X) (2*X./[1:n].'));
%varying dimensionality of objective for algorithm comparison
quad_obj_2 = quad_obj_factory(2);
quad_grad_2 = quad_grad_factory(2);
quad_obj_10 = quad_obj_factory(10);
quad_grad_10 = quad_grad_factory(10);
quad_obj_50 = quad_obj_factory(50);
quad_grad_50 = quad_grad_factory(50);

%===============================================
%         now test the three algorithms
%===============================================
simple_quad = figure();
x_0 = ones(2,1);
quad2_SD_log = MajorIterationHistory();
x_star = SteepestDescent(linesearch, quad_obj_2, quad_grad_2, x_0, quad2_SD_log, ls_parameters );
x1 = [-2:1e-1:2];
x2 = [-2:1e-1:2];
[X1, X2] = meshgrid(x1,x2);
temp_fun = @(x,y) (quad_obj_2([x; y]));
quad_out = arrayfun(temp_fun ,X1, X2);
contour(x1, x2, quad_out, 30);
hold on
plot(quad2_SD_log.x(:, 1), quad2_SD_log.x(:, 2), 'kd-')
hold on
plot(x_star(1), x_star(2), 'k*')

quad2_CG_log = MajorIterationHistory();
x_star_CG = ConjugateGradient(linesearch, quad_obj_2, quad_grad_2, x_0, e_g, e_a, e_r, quad2_CG_log, ls_parameters);
hold on
plot(quad2_CG_log.x(:, 1), quad2_CG_log.x(:, 2), 'gd-')

quad2_QN_log = MajorIterationHistory();
x_star_QN = QuasiNewtonBFGS(linesearch, quad_obj_2, quad_grad_2, x_0, e_g, e_a, e_r, quad2_QN_log, ls_parameters);
hold on
plot(quad2_QN_log.x(:, 1), quad2_QN_log.x(:, 2), 'rd-')

quad2_gradients_fig = figure;
semilogy(1,1)
PlotMajorIterationConvergance(quad2_gradients_fig, quad2_SD_log, 'kd-');
PlotMajorIterationConvergance(quad2_gradients_fig, quad2_CG_log, 'ko-.');
PlotMajorIterationConvergance(quad2_gradients_fig, quad2_QN_log, 'k<--');
figure(quad2_gradients_fig);
xlabel('Major Iterations');
ylabel('Batman')
title('Quadratic Function in \Re^{2}')

%===============================================
% 		Computation for Higher Dimensions
%===============================================
x_0 = ones(10,1);

quad10_SD_log = MajorIterationHistory();
x_star_SD_10 = SteepestDescent(linesearch, quad_obj_10, quad_grad_10, ...
								x_0, quad10_SD_log, ls_parameters);

quad10_CG_log = MajorIterationHistory();
x_star_CG_10 = ConjugateGradient(linesearch, quad_obj_10, quad_grad_10, ...
								 x_0, e_g, e_a, e_r, quad10_CG_log, ls_parameters);

quad10_QN_log = MajorIterationHistory();
x_star_QN_10 = QuasiNewtonBFGS(linesearch, quad_obj_10, quad_grad_10, ...
 								x_0, e_g, e_a, e_r, quad10_QN_log, ls_parameters);


quad10_gradients_fig = figure;
semilogy(1,1)
PlotMajorIterationConvergance(quad10_gradients_fig, quad10_SD_log, 'kd-');
PlotMajorIterationConvergance(quad10_gradients_fig, quad10_CG_log, 'ko-.');
PlotMajorIterationConvergance(quad10_gradients_fig, quad10_QN_log, 'k<--');
figure(quad10_gradients_fig);
xlabel('Major Iterations');
ylabel('Batman')
title('Quadratic Function in \Re^{10}')
%Dimension R50
x_0 = ones(50,1);
quad50_SD_log = MajorIterationHistory();
x_star_SD_50 = SteepestDescent(linesearch, quad_obj_50, quad_grad_50, ...
								 x_0, quad50_SD_log, ls_parameters);

quad50_CG_log = MajorIterationHistory();
x_star_CG_50 = ConjugateGradient(linesearch, quad_obj_50, quad_grad_50, ...
								 x_0, e_g, e_a, e_r, quad50_CG_log, ls_parameters);

quad50_QN_log = MajorIterationHistory();
x_star_QN_50 = QuasiNewtonBFGS(linesearch, quad_obj_50, quad_grad_50, ...
								 x_0, e_g, e_a, e_r, quad50_QN_log, ls_parameters);


quad50_gradients_fig = figure;
semilogy(1,1)
PlotMajorIterationConvergance(quad50_gradients_fig, quad50_SD_log, 'kd-');
PlotMajorIterationConvergance(quad50_gradients_fig, quad50_CG_log, 'ko-.');
PlotMajorIterationConvergance(quad50_gradients_fig, quad50_QN_log, 'k<--');
figure(quad50_gradients_fig);
xlabel('Major Iterations');
ylabel('Batman')
title('Quadratic Function in \Re^{50}')
