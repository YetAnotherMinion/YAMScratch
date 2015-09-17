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
%also must convert lbm into lbf by multiplying by g
g = 32.2;
Delta_p = Delta_p * 144 * g;


%% Fluid properties at 50 F
rho = 62.4; %lbm/ft^3
mu = 88e-5; %lbm/(ft*sec)

%covert inches to feet
pipe_dia = 1.025 / 12; %upstream is one inch copper
orifice_dia = 0.3875 / 12; %taken from lab handout
A_pipe = pi * pipe_dia^2 / 4;
A_orifice = pi * orifice_dia^2 / 4;

B = orifice_dia/pipe_dia;

Q_ideal = A_orifice * sqrt((2 * Delta_p)./(rho*(1-B^4)));
Q_actual = M_dot / rho;

%note the C_0 should be a vector
C_0 = Q_actual ./ Q_ideal

Velocity = Q_actual ./ A_orifice;

[shouldBeTrue, indx] = ismember('one_copper', experiment1.pipe_configuration);
assert(shouldBeTrue == true)
Reynolds = rho * Velocity * experiment1.pipe_inner_dia(indx) / mu;

%bind a constant to simplify expression below
K1= A_orifice * sqrt(2/(rho * (1-B^4)));
%compute the sensitvities of the discharge coefficients to the measured variable
%uses precomputed values for volumeetric flow rate
dC_0dP = @(Q,P)( ((Q)/(K1)) * -0.5 * P^(-3/2) );
%sensitivity with respect to mass
dC_0dm = @(M,T,P)( 1 / (T * sqrt(P) * K1) );
%sensitivity with respect to time
dC_0dt = @(M,T,P)( -M  / (T^2 * sqrt(P) * K1));

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
xlabel('Reynolds numbers');
ylabel('Discharge Coefficient')

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
					(arrayfun(dC_0dt, Mass, Time, Delta_p) * time_uncertainity).^2)

error_Reynolds = sqrt( (arrayfun(dRdm, Mass, Time) * mass_uncertainity).^2 + ...
						(arrayfun(dRdt, Mass, Time) * time_uncertainity).^2 )
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

%errorbar(Reynolds, C_0, error_C_0)