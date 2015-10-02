clc
clear('all');
close('all');


G_INCH_WATER_TO_PSI = 0.0361396333;
G_INCH_SQ_PER_FT_SQ = 144;
G_INCH_PER_FT = 12;
%assumtions about temperature
G_DENSITY_AIR = NaN;
G_VISCOSITY_AIR = NaN;
%translation factor from centerline of piot tube input to bottom edge
G_PIOT_OFFSET = 0.0; %offset in inches
%which is the zeroed when the bottom of the tube

%convert plate dimensions from inches to ft
plate_width = 10/12;
plate_length = 60/12;

%covert the measurement of voltage into lbf/ft^2
raw_transducer_1 = @(V)(0.2026*V - 0.5142);
raw_transducer_2 = @(V)(0.04*V - 0.1018);
transducer_1 = @(V)(raw_transducer_1(V) * G_INCH_WATER_TO_PSI * G_INCH_SQ_PER_FT_SQ);
transducer_2 = @(V)(raw_transducer_2(V) * G_INCH_WATER_TO_PSI * G_INCH_SQ_PER_FT_SQ);

%Thermocouple map of distances, if NaN
thermocouple_map = struct;
%measure distance from leading edge in ft
thermocouple_map.distance = [0.125, 0.5, 1.125, 2.125, 3.5, 5.125, 7.125, ...
	9.375, 10.125, 11.25, 12, 13, 14.5, 16, 18, 21, 22.5, 24, 26, 29, ...
	33, 36, 42, 48, 54, 7.125, 7.125, 18, 18, 12, 24, 36] ./ 12;
thermocouple_map.distance(1, 33:35) = [NaN, NaN, NaN];
%string descrition of thermocouple, should only be populated for
%a few special thermocouples
thermocouple_map.descrition = {};
thermocouple_map.descrition{1,33} = 'leading_edge';
thermocouple_map.descrition{1,34} = 'trailing_edge';
thermocouple_map.descrition{1,35} = 'ambient_air';
%as per manual thermocouples 8 13 and 18 are not used
thermocouple_map.descrition{1, 8} = 'not_used';
thermocouple_map.descrition{1, 13} = 'not_used';
thermocouple_map.descrition{1, 18} = 'not_used';
G_USEABLE_THERMOCOUPLE_MASK = [1:7,9:12,14:17,19:35];

%%General Boundary layer
BoundaryLayerExperiment = struct;
BoundaryLayerExperiment.free_stream_velocity = [];
BoundaryLayerExperiment.free_stream_y = [];
BoundaryLayerExperiment.delta_y = [];
BoundaryLayerExperiment.dynamic_pressure = [];
BoundaryLayerExperiment.data_sz = [];
%%Boundary layer 1 experiment, uses pressure transducer_1
% vv RECORD DATA HERE vv
%----------------------------
tmp_y = ([0.04, 0.09, 0.14, 0.19, 0.24, 0.29, ...
		0.34, 0.39, 0.44, 0.49, 0.54, 0.59, ...
		0.64, 0.69, 0.74, 0.79, 0.84, 0.89, ...
		0.94, 0.99, 1.04, 1.09, 1.14, 1.19, ...
		1.30, 1.40, 1.50, 1.60, 1.70, 1.80, ...
		1.90, 2.00] + G_PIOT_OFFSET) ./ G_INCH_PER_FT;
tmp_V = [3.32305, 3.49870, 3.56802, 3.61611, 3.66251, 3.71333, ...
		3.74977, 3.81280, 3.85159, 3.90400, 3.94449, 3.99117, ...
		4.03673, 4.07139, 4.10173, 4.14230, 4.16222, 4.17706, ...
		4.18880, 4.19462, 4.20552, 4.20054, 4.20073, 4.19829, ...
		4.19857, 4.19415, 4.19152, 4.19443, 4.18532, 4.17358, ...
		4.16504, 4.15010];
tmp_free_stream_voltage = 4.11826;
tmp_free_stream_y = 2.35 - G_PIOT_OFFSET; %this value may not be relevant
%-----------------------------
assert(length(tmp_V) == length(tmp_y));
tmp_pressure = transducer_1(tmp_V);
INDX = 1;
BoundaryLayerExperiment.data_sz(INDX, 1) = length(tmp_y);
BoundaryLayerExperiment.delta_y(INDX, 1:length(tmp_y)) = tmp_y; 
BoundaryLayerExperiment.dynamic_pressure(INDX, 1:length(tmp_V)) = tmp_pressure;
BoundaryLayerExperiment.free_stream_velocity(INDX, 1) = transducer_1(tmp_free_stream_voltage);
BoundaryLayerExperiment.free_stream_y(INDX, 1) = tmp_free_stream_y;
clear tmp_y tmp_V tmp_pressure tmp_free_stream_y tmp_free_stream_voltage;
%%Boundary layer 2 experiment
% vv RECORD DATA HERE vv
%----------------------------
tmp_y = ([0.04, 0.09, 0.14, 0.19, 0.24, 0.29, ...
		0.34, 0.39, 0.44, 0.49, 0.54, 0.59, ...
		0.64, 0.69, 0.74, 0.79, 0.84, 0.89, ...
		0.94, 0.99, 1.04, 1.09, 1.14, 1.19, ...
		1.30, 1.40, 1.50, 1.60, 1.70, 1.80, ...
		1.90, 2.00] + G_PIOT_OFFSET) ./ G_INCH_PER_FT; %convert inches to ft
tmp_V = [3.32709, 3.67425, 3.78969, 3.87310, 3.93556, 4.01625, ...
 		4.06472, 4.13817, 4.17743, 4,21463, 4.30555, 4.36680, ... 
 		4.40841, 4.45396, 4.50337, 4.53512, 4.56987, 4.60782, ...
 		4.61627, 4.62529, 4.63281, 4.64981, 4.64661, 4.65535, ...
 		4.65356, 4.65713, 4.64736, 4.64577, 4.62857, 4.62933, ...
 		4.62708, 4.61956];
tmp_free_stream_voltage = 4.58866;
tmp_free_stream_y = 2.35; %this value may not be relevant
%-----------------------------
assert(length(tmp_V) == length(tmp_y));
tmp_pressure = transducer_2(tmp_V);
INDX = 2;
BoundaryLayerExperiment.data_sz(INDX,1) = length(tmp_y);
BoundaryLayerExperiment.delta_y(INDX, 1:length(tmp_y)) = tmp_y; 
BoundaryLayerExperiment.dynamic_pressure(INDX, 1:length(tmp_V)) = tmp_pressure;
BoundaryLayerExperiment.free_stream_velocity(INDX, 1) = transducer_2(tmp_free_stream_voltage);
BoundaryLayerExperiment.free_stream_y(INDX, 1) = tmp_free_stream_y;
clear tmp_y tmp_V tmp_pressure tmp_free_stream_y tmp_free_stream_voltage;

KAPPA = 0.38;
BETA = 4.1;
NU = G_DENSITY_AIR
%%First plot is nondimensional ration of u/U_infinity vs y/sigma
FrictionvVelocityFactory = @(U, Y)(@(U_t)( U / (U_t/KAPPA * log( Y * U_t/ NU) + BETA * U_t)))

for indx = 1:BoundaryLayerExperiment.data_sz(1)
	tmp_velocity = 
	tmp_f = FrictionvVelocityFactory( ...
				BoundaryLayerExperiment.free_stream_velocity(indx), ...
				BoundaryLayerExperiment.delta_y(indx));
	fzero(tmp_f)
end



%literature predictions using 1/7th power law
x0 = 0;
x1 = 0.1;
x2 = 3;
tmp_x = [linspace(x0, x1, 100), [linspace(x1, x2, 100)]];
tmp_y = tmp_x .^ (1/7);
BL_fig = figure;
semilogx(tmp_x, tmp_y, 'k-');
hold on
%plot the physical upper limit of u/U_infinity
plot(tmp_x, ones(1,length(tmp_x)), 'k--')

xlabel('$\frac{y}{\sigma}$', 'interpreter', 'latex', 'FontSize', 16);
ylabel('$\frac{u}{U_{\infty}}$', 'interpreter', 'latex', 'FontSize', 18);

%%===============================================================

%%Find the free stream velocity
%pressure of each piot tube
% vv RECORD DATA HERE vv
%----------------------------
tmp_P = [];
tmp_P = NaN * ones(1,5);
%----------------------
assert(length(tmp_P) == 5);



% vv RECORD DATA HERE vv
%----------------------------
tmp_T = [];
tmp_T = 1:32; %just to make the below work until data is recorded
%----------------------
%remember that we dont use three thermocouples
assert(length(tmp_T) == 32)
thermocouple_map.temperature(1, G_USEABLE_THERMOCOUPLE_MASK) = tmp_T(:);

%%record the voltage and current to heaters at steady state
heater_voltage = NaN; %units of Volts
heater_current = NaN; % units of Amps

heater_power = heater_current * heater_voltage; %units of watts

Q_in = heater_power / (plate_width * plate_length); %units of W/ft^2

%%Second plot is Stanton number vs Reynolds number on log log plot
G_PRANDTL_NUMBER = 0.7;
%literature predictions
laminar_stanton = @(Re)(0.453 * (Re .^(-0.5)) * G_PRANDTL_NUMBER ^ (-2/3) );
turbulent_stanton = @(Re)(0.0307 * (Re .^(-0.2)) * G_PRANDTL_NUMBER ^(-0.4) );
%generate some representative reynolds numbers for laminar and turbulent
laminar_Re = logspace(4, 5.5, 100);
turbulent_Re = logspace(5, 6, 100);
Stanton_fig = figure;
loglog(laminar_Re, laminar_stanton(laminar_Re), 'k-');
hold on;
loglog(turbulent_Re, turbulent_stanton(turbulent_Re), 'k--');

xlabel('Reynolds number $(Re_x)$', 'interpreter', 'latex', 'FontSize', 16);
ylabel('Stanton number $(St_x)$', 'interpreter', 'latex', 'FontSize', 16);
