clear
clc
close('all')

%% Question 1
%volumetric flow rate
V_dot = 1e-5; %m^3/sec
C_0 = 0.6; % dimesionless
%A_1 is the area of the pipe
%A_2 is the area of the constriction
d_1 = 0.05; % in meters
d_2 = 0.0025; % in meters
% density of water at 300K in kg/m^3
rho = 996.51; % using interpolation from table in kamenski & jennings


A_1 = (pi * d_1^2)/4;
A_2 = (pi * d_2^2)/4;

tmp_left = (V_dot / (C_0 * A_2))^2;

tmp_left = tmp_left * rho;

delta_p = tmp_left * (1 - (A_2/A_1)^2) * 0.5;

%convert to torr which is the same thing as millimeters of mercury
mm_mercury = delta_p * 0.00750061683 % conversion factor from Google instant

%%Part B
%now we solve equation from other side
delta_p2 = 500 / 0.00750061683; % convert to pascals

Q = C_0 * A_2 * sqrt((2*delta_p2)/(rho * (1 - (A_2/A_1)^2)^-1)) % units of m^3/s


%%Part C
mu = (7.79 + 0.6*(8.72 - 7.79)) * 1e-4; % interpolation from table in kamenski & jennings
Velocity = V_dot / A_1; % take Reynolds number at orifice
Re = rho * Velocity * d_1 / mu

disp('========================================')
%%Question 2
delta_p = 50; %psi
%absolute roughness
e = 5 *1e-6; % smooth copper from http://www.efunda.com/formulae/fluids/roughness.cfm
d = 1/24; % in ft from problem statment
L = 100/12; %in ft from problem statment
%density at 50 F from table B-6 kamenski & jennings
rho = 62.4; %lbm/ft^3
%earth gravity
g = 32.2 ; %ft/s^2
head_loss = 144 * delta_p / (rho); %in ft
mu = 88e-5; % lbm/(ft*sec)

% we assume Re > 2000, so we then use Swamee and Jain curve fits to Moody
% diagram to avoid iteration, we will then recompute the reynolds number and
% check that our assumption was valid
V_dot = -0.965 * sqrt((g * d^5* head_loss)) * log( (e/(3.7*d)) + sqrt( (3.17 * mu^2 * L)/(g * rho^2 * d^3 * head_loss)) )
A_pipe = pi * d^2 / 4;
calc_v = V_dot / A_pipe
Re_calc = calc_v * rho * d / mu
assert(Re_calc > 2000)
%this check passes so our assumption was valid
m_dot = V_dot * rho
Voltage = m_dot/5 + 0.1

disp('========================================')

%%Question 3
%use the same T points
T = linspace(10,70,7);


frame_fig = figure;
dynamic_viscosity_fig = subplot(2,2,1);
nu = [1.29, 0.987, 0.782, 0.639, 0.535, 0.460, 0.402] * 1e-6;
plot(T, nu, 'kd-');
xlabel('Temperature (C)');
ylabel('Dynamic Viscosity (m^2/sec)')
%find the relative change over the range
change = -(nu(1) / nu(end) - 1)


%entropy and enthalpy from http://www.kostic.niu.edu/350/_350-posted/350Chengel7th/Appendix1Udated.pdf
entropy_fig = subplot(2,2,2);
S = [0.1511, 0.2965, 0.4368, 0.5724, 0.7038, 0.8313, 0.9551]; %kJ/(kg * K)
plot(T, S, 'kd-');
xlabel('Temperature (C)');
ylabel('Entropy (kJ/(kg * K))');
change = (S(end) / S(1)) - 1


enthalpy_fig = subplot(2,2,3);
H = [42.022, 83.915, 125.74, 167.53, 209.34, 251.18, 293.07];
plot(T, H, 'kd-');
xlabel('Temperature');
ylabel('Enthalpy (kJ/kg)')
change = (H(end) / H(1)) - 1

density_fig = subplot(2,2,4);
rho = [999.6, 998.2, 995.6, 992.2, 988, 983.2, 977.7];
plot(T, rho, 'kd-')
xlabel('Temperature (C)')
ylabel('density (kg/m^3)')

change = - (rho(1)/ rho(end) - 1)
