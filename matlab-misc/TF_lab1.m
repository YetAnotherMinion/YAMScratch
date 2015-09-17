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
Reynolds = rho * Velocity * experiment1.pipe_inner_dia(indx) / mu

%compute the sensitvities of the discharge coefficients to the measured variable
dC_0dP = @(X)(X)

part1_fig = figure;
semilogx(Reynolds, C_0, 'kd');
xlabel('Reynolds numbers');
ylabel('Discharge Coefficient')
%errorbars(x)
