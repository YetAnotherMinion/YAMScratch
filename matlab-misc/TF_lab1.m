clear('all');
close('all');
clc

%% Set up equipement parameters
experiment1 = struct;
experiment1.pipe_configuration = {'quarter_copper', 'half_copper', 'one_copper', 'half_PVC', 'half_steel', 'one_steel'};
%dia of pipes in feet
experiment1.pipe_inner_dia = [0.315, 0.545, 1.025, 0.480, 0.622, 1.049] ./ 12;
%distance between pressure taps in feet
experiment1.pressure_tap_L = [116.8, 131.5, 115.0, 124.0, 115.8, 114.0] ./12;

%sanity check that we manually entered data correctly;
assert(length(experiment1.pressure_tap_L) == length(experiment1.pipe_inner_dia));
assert(length(experiment1.pipe_configuration) == length(experiment1.pressure_tap_L));

%orifice flow plate, units of lbm,
Mass = [145, 123, 148.8, 48.2, 69.5, 64.3, 45.4, 32];
Time = [62.1, 39.3, 48.2, 23.8, 37, 35.1, 26.5, 23.7];
M_dot = Mass ./ Time;

Upstream_p = [36.5, 63.2, 62, 28.5, 24.1, 24.4, 25.8, 30.2];
Downstream_p = [0.95, -0.5402695674497, 0, 1.9 , 2, 2.7, 6.6, 18.6];
Delta_p = Upstream_p - Downstream_p; %<-- this is lb/in^2
%must convert to lb/ft^2 for units to cancel in final expression
gravity = 32.2;
Delta_p = Delta_p * 144;


%% Fluid properties at 50 F
rho = 62.4; %lbm/ft^3
mu = 88e-5; %lbf/(ft*sec)

%covert inches to feet
pipe_dia = 1.025 / 12; %upstream is one inch copper
orifice_dia = 0.3875 / 12; %taken from lab handout
A_pipe = pi * pipe_dia^2 / 4;
A_orifice = pi * orifice_dia^2 / 4;

B = orifice_dia/pipe_dia;

Q_ideal = A_orifice * sqrt((2 * Delta_p)./(rho/gravity *(1-B^4)));
Q_actual = M_dot / rho;

%note the C_0 should be a vector
C_0 = Q_actual ./ Q_ideal;

Velocity = Q_actual ./ A_orifice;

[shouldBeTrue, indx] = ismember('one_copper', experiment1.pipe_configuration);
assert(shouldBeTrue == true)
Reynolds = rho * Velocity * experiment1.pipe_inner_dia(indx) / mu;

%bind a constant to simplify expression below, rembering to correct for g
K1= A_orifice * sqrt(2/(rho/gravity * (1-B^4)));
%compute the sensitvities of the discharge coefficients to the measured variable
%uses precomputed values for volumeetric flow rate
dC_0dP = @(Q,P)( ((Q)/(K1)) * -0.5 * P^(-3/2) );
%sensitivity with respect to mass
dC_0dm = @(M,T,P)( 1 / (rho * T * sqrt(P) * K1) );
%sensitivity with respect to time
dC_0dt = @(M,T,P)( -M  / (rho * T^2 * sqrt(P) * K1));

%%Uncertainities in Reynolds number
%bind a constant to simplify calcs
[shouldBeTrue, indx] = ismember('one_copper', experiment1.pipe_configuration);
assert(shouldBeTrue == true)
K2 = experiment1.pipe_inner_dia(indx) / (mu * A_orifice);
%sensitivity with respect to mass
dRdm = @(M,T)( K2 / T );
%sensitivity with respect to time
dRdt = @(M,T)( -1 * K2 * M/ T^2 );

part1_fig = figure;
semilogx(Reynolds, C_0, 'kd');
xlabel('Reynolds number', 'interpreter', 'latex');
ylabel('Discharge Coefficient $C_{0}$', 'interpreter', 'latex')
%% plot literature values interpolated linearly for B = 0.38
x_r = [0.25, 0.5, 0.75, 1.0, 1.25] ./ 2.125;
x_r = ((ones(1,5) * 10) .^ x_r) * 10^5;
C_0_theory = [0.6006, 0.60095, 0.59905, 0.5986, 0.5981];
hold on
plot(x_r, C_0_theory, 'r-')
legend('Discharge Coefficient', 'Literature Values for C_0')

mass_uncertainity = 0.05; %accurate to first decimal place
time_uncertainity = 0.05; %accurate to first decimal place
%note that we add the uncertainities of the two pressure measurements
%to create a simpler expression for overall uncertainity
pressure_uncertainity = 2 * 0.05; %combining uncertainities of both pressure measurements

% arrayfun(dC_0dP, Q_actual, Delta_p)
% arrayfun(dC_0dm, Mass, Time, Delta_p)
% arrayfun(dC_0dt, Mass, Time, Delta_p)

error_C_0 = sqrt( (arrayfun(dC_0dP, Q_actual, Delta_p) * pressure_uncertainity).^2 + ...
					(arrayfun(dC_0dm, Mass, Time, Delta_p) * mass_uncertainity).^2 + ...
					(arrayfun(dC_0dt, Mass, Time, Delta_p) * time_uncertainity).^2);

error_Reynolds = sqrt( (arrayfun(dRdm, Mass, Time) * mass_uncertainity).^2 + ...
						(arrayfun(dRdt, Mass, Time) * time_uncertainity).^2 );
hold on
%plot the error bars manually
for tmp_indx = 1:length(Reynolds)
	%vertical bars
	tmp_x = [Reynolds(tmp_indx), Reynolds(tmp_indx)];
	tmp_y = [C_0(tmp_indx) - error_C_0(tmp_indx), C_0(tmp_indx) + error_C_0(tmp_indx) ];
	plot(tmp_x, tmp_y, 'k-')
	hold on
	%hortizontal bars
	tmp_x = [Reynolds(tmp_indx) - error_Reynolds(tmp_indx), Reynolds(tmp_indx) + error_Reynolds(tmp_indx)];
	tmp_y = [C_0(tmp_indx), C_0(tmp_indx) ];
	plot(tmp_x, tmp_y, 'k-')
end

xlim([1.5e5,3.9e5])

%%Friction factor determination
%%half PVC
[shouldBeTrue, indx] = ismember('half_PVC', experiment1.pipe_configuration);
assert(shouldBeTrue == true)

tmp_flow = [2.5,2.39,2.32,2.31,2.24,1.9,2.315,2.26,2.08];
experiment1.flow_turbine(indx,:) = 0.57 * (tmp_flow - 1.02);
tmp_upstream = [28.5, 24.9, 22.5, 22, 20.2, 11, 22.6, 23.2, 21.8];
tmp_downstream = [11.5 ,10.1 ,9.1 ,8.8, 8.1, 4.2 ,9.1 ,10.8, 17.6];
experiment1.pressure_psi(indx,:) = tmp_upstream - tmp_downstream;
experiment1.data_sz(indx,1) = length(tmp_flow);


%%quarter_copper
[shouldBeTrue, indx] = ismember('quarter_copper', experiment1.pipe_configuration);
assert(shouldBeTrue == true)

tmp_flow = [1.61 ,1.526 ,1.493 ,1.475 ,1.455 ,1.526];
experiment1.flow_turbine(indx,1:length(tmp_flow)) = 0.57 * (tmp_flow -1.02);
tmp_upstream = [43.6, 32.8, 29.2, 27, 30.8, 41.3];
tmp_downstream = [12.4 ,9.2 ,8.1 ,7.5 ,12.9 ,17.8];
experiment1.pressure_psi(indx,1:length(tmp_flow)) = tmp_upstream - tmp_downstream;
experiment1.data_sz(indx,1) = length(tmp_flow);

%%half_copper
[shouldBeTrue, indx] = ismember('half_copper', experiment1.pipe_configuration);
assert(shouldBeTrue == true)

tmp_flow = [2.29, 2.277, 2.23, 2.18, 2.09, 1.832, 1.564, 1.862, 1.364, 1.15];
experiment1.flow_turbine(indx,1:length(tmp_flow)) = 0.57 * (tmp_flow -1.02);
%here pressure is in inches of mercury, so we convert to psi
tmp_upstream = [10.8, 10.6, 9.98, 9.20, 7.80, 4.70, 2.4 , 5.13, 1.13, 0.34];
tmp_downstream = [10.65 ,10.5, 9.78 ,9.04 ,7.70 ,4.70 ,2.36 ,4.97 ,0.98 ,0.24];
experiment1.pressure_psi(indx,1:length(tmp_flow)) = 0.49109778 * (tmp_upstream + tmp_downstream);
experiment1.data_sz(indx,1) = length(tmp_flow);

%%half_steel
[shouldBeTrue, indx] = ismember('half_steel', experiment1.pipe_configuration);
assert(shouldBeTrue == true)

tmp_flow = [2.096 ,2.069 ,2.05 ,2.01 ,1.962 ,1.782 ,1.443 ,1.705 ,1.46 ,1.274];
experiment1.flow_turbine(indx,1:length(tmp_flow)) = 0.57 * (tmp_flow - 1.02);
%here pressure is in inches of mercury, so we convert to psi
tmp_upstream = [10.65 ,10.12 ,9.76 ,9.04 ,8.24 ,5.45 ,1.82 ,4.5 ,1.95 ,0.78];
tmp_downstream = [10.5 ,10 ,9.62 ,8.9 ,8.1 ,5.3 ,1.8 ,4.35 ,1.84 ,0.65];
experiment1.pressure_psi(indx,1:length(tmp_flow)) = 0.49109778 * (tmp_upstream + tmp_downstream);
experiment1.data_sz(indx,1) = length(tmp_flow);

%%one_steel
[shouldBeTrue, indx] = ismember('one_steel', experiment1.pipe_configuration);
assert(shouldBeTrue == true)

tmp_flow = [2.844 ,2.818 ,2.779 ,2.661 ,2.543 ,2.382 ,1.992 ,1.515 ,2.757 ,2.471];
experiment1.flow_turbine(indx,1:length(tmp_flow)) = 0.57 * (tmp_flow - 1.02);
%here pressure is in inches of mercury, so we convert to psi
tmp_voltage = [2.61638 ,2.52383 ,2.47136 ,2.18819 ,1.827 ,1.45679 ,0.788259 ,0.178216 ,2.38694 ,1.76701];
experiment1.pressure_psi(indx,1:length(tmp_flow)) = 0.5 *(tmp_voltage);
experiment1.data_sz(indx,1) = length(tmp_flow);

%%one_copper
[shouldBeTrue, indx] = ismember('one_copper', experiment1.pipe_configuration);
assert(shouldBeTrue == true)



tmp_flow = [2.88 ,2.819 ,2.699 ,2.477 ,2.237 ,1.917 ,1.692 ,1.478 ,2.303 ,1.785];
experiment1.flow_turbine(indx,1:length(tmp_flow)) = 0.57 * (tmp_flow - 1.02);
%here pressure is in inches of mercury, so we convert to psi
tmp_voltage = [1.44239 ,1.30612 ,1.11225 ,0.83447 ,0.624195 ,0.374341 ,0.268389 ,0.119979 ,0.769222 ,0.205644];
experiment1.pressure_psi(indx,1:length(tmp_flow)) = 0.5 *(tmp_voltage);
experiment1.data_sz(indx,1) = length(tmp_flow);


fig_array = [];
color_spec = {'kd', 'rd', 'bd', 'gd', 'md', 'gv'};
tmp_fig = figure;

for indx = 1:length(experiment1.pipe_configuration)
	nCols = experiment1.data_sz(indx);

	Q_actual = experiment1.flow_turbine(indx, 1:nCols) / rho;
	Velocity = Q_actual ./ A_orifice;
	Reynolds = rho * Velocity * experiment1.pipe_inner_dia(indx) / mu;
	%bind to constant the V^2/2g
	K3 = (Velocity.^2) ./ (2 * gravity);
	%covert to lbf/ft^2
	lhs = (experiment1.pressure_psi(indx, 1:nCols) * 144) / (rho * gravity);
	%subtract out the minor losses
	lhs = lhs - (0.16 * K3);
	tmp_val = lhs ./ K3;
	fric_factor = tmp_val .* experiment1.pipe_inner_dia(indx) / experiment1.pressure_tap_L(indx);
	plot(Reynolds, fric_factor, color_spec{indx});
	hold on
	%disp(experiment1.pipe_configuration{indx})
end
%hack to format the labels
tmp_spec = {};
for string = experiment1.pipe_configuration
	tmp_rep = regexprep(string, '\_', ' ');
	tmp_spec{end+1} = tmp_rep{1};
end

legend(tmp_spec{:})
xlabel('Reynolds number', 'interpreter', 'latex');
ylabel('Discharge Coefficient $C_{0}$', 'interpreter', 'latex')

