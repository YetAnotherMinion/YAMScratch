clc
clear('all');
close('all');


G_INCH_WATER_TO_PSI = 0.0361396333;
G_INCH_SQ_PER_FT_SQ = 144;

%convert plate dimensions from inches to ft
plate_width = 10/12;
plate_legnth = 60/12;

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

%%First plot is nondimensional ration of u/U_infinity vs y/sigma


%%Seconf plot is Stanton number vs Reynolds number on log log plot
