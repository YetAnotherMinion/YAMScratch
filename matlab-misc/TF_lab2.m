clc
clear('all');
close('all');


G_INCH_WATER_TO_PASCAL = 249.088908333;
G_INCH_SQ_PER_FT_SQ = 144;
G_INCH_PER_METER = 39.3700787;
%assumtions about temperature from engineering toolbox
%http://www.engineeringtoolbox.com/air-density-specific-weight-d_600.html

G_DENSITY_AIR = 1.177; %kg per m^3 @ 27C
G_VISCOSITY_AIR = 1.846e-5; %kg / m s @ 300 K
%translation factor from centerline of piot tube input to bottom edge
G_PIOT_OFFSET = 0.0; %offset in inches
%which is the zeroed when the bottom of the tube

%convert plate dimensions from inches to ft
plate_width = 10/12;
plate_length = 60/12;

%covert the measurement of voltage into lbf/ft^2
raw_transducer_1 = @(V)(0.2026*V - 0.5142);
raw_transducer_2 = @(V)(0.04*V - 0.1018);
transducer_1 = @(V)(raw_transducer_1(V) * G_INCH_WATER_TO_PASCAL);
transducer_2 = @(V)(raw_transducer_2(V) * G_INCH_WATER_TO_PASCAL);

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
		1.90, 2.00] + G_PIOT_OFFSET) ./ G_INCH_PER_METER;
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
BoundaryLayerExperiment.free_stream_velocity(INDX, 1) = sqrt(2 * transducer_1(tmp_free_stream_voltage) / G_DENSITY_AIR);
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
		1.90, 2.00] + G_PIOT_OFFSET) ./ G_INCH_PER_METER; %convert inches to ft
tmp_V = [3.32709, 3.67425, 3.78969, 3.87310, 3.93556, 4.01625, ...
 		4.06472, 4.13817, 4.17743, 4.21463, 4.30555, 4.36680, ... 
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
BoundaryLayerExperiment.free_stream_velocity(INDX, 1) = sqrt( 2 * transducer_2(tmp_free_stream_voltage)/ G_DENSITY_AIR );
BoundaryLayerExperiment.free_stream_y(INDX, 1) = tmp_free_stream_y;
clear tmp_y tmp_V tmp_pressure tmp_free_stream_y tmp_free_stream_voltage;

%% Plot developed flows
layer_fig = figure;
BoundaryLayerExperiment.velocity(1,:) = sqrt(2 * BoundaryLayerExperiment.dynamic_pressure(1,:) / G_DENSITY_AIR);

plot(BoundaryLayerExperiment.velocity(1,:), ...
	BoundaryLayerExperiment.delta_y(1,:), 'kd-')
hold on
BoundaryLayerExperiment.velocity(2,:) = sqrt(2 * BoundaryLayerExperiment.dynamic_pressure(2,:) / G_DENSITY_AIR);
plot(BoundaryLayerExperiment.velocity(2,:), ...
	BoundaryLayerExperiment.delta_y(2,:), 'rd-')

xlabel('Velocity (m/s)', 'interpreter', 'latex', 'FontSize', 16);
ylabel('Height above plate (m)', 'interpreter', 'latex', 'FontSize', 16);
title('Isothermal Velocity Boundary Layers', 'FontSize', 16)
legend('Flow From Full Speed Fan', 'Flow From Half Speed Fan', 'FontSize', 12)

set(layer_fig,'visible','off')

KAPPA = 0.38;
BETA = 4.1;
NU = G_VISCOSITY_AIR / G_DENSITY_AIR; %kinematic viscosity
%%First plot is nondimensional ration of u/U_infinity vs y/sigma
FrictionvVelocityFactory = @(U, Y)(@(X)( (1/KAPPA) * log(Y * X ./ NU) + BETA - (U * X.^-1)));

BoundaryLayerExperiment.Cf = NaN * zeros(size(BoundaryLayerExperiment.velocity));

for row = 1:2
	for indx = 1:BoundaryLayerExperiment.data_sz(row)
		tmp_f = FrictionvVelocityFactory( ...
					BoundaryLayerExperiment.velocity(row, indx), ...
					BoundaryLayerExperiment.delta_y(row,indx));

		tmp_u_t = fzero(tmp_f, 1);
		tau_s = tmp_u_t ^2 / G_DENSITY_AIR;
		Cf = tau_s / (0.5 * G_DENSITY_AIR * BoundaryLayerExperiment.free_stream_velocity(1)^2);
		BoundaryLayerExperiment.Cf(row,indx) = Cf;
	end
	%the location where we reach free stream velocity is different for each row
	if row == 1
		SLICE_END = 21;
		fprintf('Full Speed\n')

	elseif row == 2
		SLICE_END = 26;
		fprintf('Half Speed\n')
	else
		error('There are only two experiments');
	end
	% we also want to reset the free stream velocity to the maximum we have seen,
	% since we see the reynolds decreases as we get closer to the top wall of the
	% wind tunnel
	BoundaryLayerExperiment.free_stream_velocity(row) = BoundaryLayerExperiment.velocity(row, SLICE_END);
	BoundaryLayerExperiment.free_stream_y = BoundaryLayerExperiment.delta_y(row, SLICE_END);
	%show the mean and standard deviation of the skin friction coeffcient
	BoundaryLayerExperiment.Cf_mean(row, 1) = mean(BoundaryLayerExperiment.Cf(row, 1:SLICE_END));
	BoundaryLayerExperiment.Cf_std(row, 1) = std(BoundaryLayerExperiment.Cf(row, 1:SLICE_END));
	fprintf('\tSlice end is %d\n', SLICE_END);
	fprintf('\tMean C_f = %10.7f\n', BoundaryLayerExperiment.Cf_mean(row,1));
	fprintf('\tstddev C_f = %10.7f\n', BoundaryLayerExperiment.Cf_std(row, 1));	
	fprintf('====================\n')
end
%clean up temporary variables used for this section
clear SLICE_END tmp_u_t tmp_f Cf tau_s


%%literature predictions using 1/7th power law
x0 = 0;
x1 = 0.1;
x2 = 3;
tmp_x = [linspace(x0, x1, 100), [linspace(x1, x2, 100)]];
tmp_y = tmp_x .^ (1/7);

BL_fig = [];

%%plot the physical upper limit of u/U_infinity

%first compute the free stream reynold number
for row = 1:2
	BL_fig(row) = figure;
	semilogx(tmp_x, tmp_y, 'k-');
	hold on
	X = 47.5 / G_INCH_PER_METER;
	Reynolds = G_DENSITY_AIR * BoundaryLayerExperiment.free_stream_velocity(row) ...
				* X / G_VISCOSITY_AIR;
	%assue both rows are turbulent in free stream
	sigma = 0.382 * X / (Reynolds^0.2);
	if row == 1
		SLICE_END = 21;
		legend_txt = [];
		title_txt = 'Non-dimensionalized Velocity Profile of Full Speed Fan';
	elseif row == 2
		SLICE_END = 26;
		legend_txt = [''];
		title_txt = 'Non-dimensionalized Velocity Profile of Half Speed Fan';
	else
		error('There are only two experiments');
	end
	y_s = BoundaryLayerExperiment.delta_y(row,1:SLICE_END) / sigma;
	u_U = BoundaryLayerExperiment.velocity(row,1:SLICE_END) / ...
			BoundaryLayerExperiment.free_stream_velocity(row);
	plot(y_s, u_U, 'rd-');

	xlabel('Non-dimensional distance $\frac{y}{\sigma}$', 'interpreter', 'latex', 'FontSize', 18);
	ylabel('Non-dimensional velocity $\frac{u}{U_{\infty}}$', 'interpreter', 'latex', 'FontSize', 16);
	xlim([1e-2, 1.5])
	title(title_txt, 'FontSize', 16)
	l = legend('$1/7^{th}$ power law' ,'Experimental Non-dimensional Velocity');
	set(l, 'Interpreter', 'latex', 'FontSize', 12)	

end

%set(BL_fig(1),'visible','off')
%set(BL_fig(2),'visible','off')

clear Reynolds
%clean up these temporary plotting variables
clear tmp_x tmp_y x0 x1 x2


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
top_d = [0.125, 	0.5,		1.125, 		2.125, ...
 3.5, 		5.125, 		10.125, 	16, ...
 18, 		21, 		29, 		33, ...
 48,		54] ./ G_INCH_PER_METER;
top_t = [31.7542, 	35.1604, 	38.43, 		44.1132 ,...
 45.1662, 	46.4592, 	49.36663, 	38.32623, ...
 38.719625, 39.155425,	39.258225,	40.155825, ...
 40.829625,	45.508425];

bot_d = [0, 12, 36] ./ G_INCH_PER_METER;
bot_t = [29.4546, 28.33143, 37.68503];
%----------------------

%%prepare plot of plate temperatures on top and bottom
temp_fig = figure;
plot(top_d, top_t, 'rd-')
hold on
plot(bot_d, bot_t, 'bd-')
title('Thermocouple Temperature vs. Distance from Plate Leading Edge', 'FontSize', 16)
legend('Top Surface Temperatures', 'Bottom Surface Temperatures')
xlabel('Distace from leading edge $m$', 'interpreter', 'latex', 'FontSize', 16)
tmp_s = sprintf('Temperature %cC', char(176));
ylabel(tmp_s, 'FontSize', 16)


%%record the voltage and current to heaters at steady state
heater_voltage = 28.00; %units of Volts
heater_current = 7.451; % units of Amps

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

f = piecewise_interpolator([2,3, 4], [5,8, 8])

f(3.5)