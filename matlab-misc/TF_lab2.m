clc
clear('all');
close('all');


G_INCH_WATER_TO_PSI = 0.0361396333;
G_INCH_SQ_PER_FT_SQ = 144;
G_INCH_PER_FT = 12;

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

%%General Boundary layer
BoundaryLayerExperiment = struct;
BoundaryLayerExperiment.free_stream_pressure = [];
BoundaryLayerExperiment.free_stream_y = [];
BoundaryLayerExperiment.delta_y = [];
BoundaryLayerExperiment.dynamic_pressure = [];
BoundaryLayerExperiment.data_sz = [];
%%Boundary layer 1 experiment, uses pressure transducer_1
% vv RECORD DATA HERE vv
%----------------------------
tmp_y = [] ./ G_INCH_PER_FT;
tmp_V = [];
tmp_free_stream_voltage = NaN;
tmp_free_stream_y = NaN;
%-----------------------------
assert(length(tmp_V) == length(tmp_y));
tmp_pressure = transducer_1(tmp_V);
INDX = 1;
BoundaryLayerExperiment.data_sz(INDX, 1) = length(tmp_y);
BoundaryLayerExperiment.delta_y(INDX, 1:length(tmp_y)) = tmp_y; 
BoundaryLayerExperiment.dynamic_pressure(INDX, 1:length(tmp_V)) = tmp_pressure;
BoundaryLayerExperiment.free_stream_pressure(INDX, 1) = transducer_1(tmp_free_stream_voltage);
BoundaryLayerExperiment.free_stream_y(INDX, 1) = tmp_free_stream_y;
clear tmp_y tmp_V tmp_pressure tmp_free_stream_y tmp_free_stream_voltage;
%%Boundary layer 2 experiment
% vv RECORD DATA HERE vv
%----------------------------
tmp_y = [1,2,3,4] ./ G_INCH_PER_FT; %convert inches to ft
tmp_V = [1,2,3,4];
tmp_free_stream_voltage = NaN;
tmp_free_stream_y = NaN;
%-----------------------------
assert(length(tmp_V) == length(tmp_y));
tmp_pressure = transducer_2(tmp_V);
INDX = 2;
BoundaryLayerExperiment.data_sz(INDX,1) = length(tmp_y);
BoundaryLayerExperiment.delta_y(INDX, 1:length(tmp_y)) = tmp_y; 
BoundaryLayerExperiment.dynamic_pressure(INDX, 1:length(tmp_V)) = tmp_pressure;
BoundaryLayerExperiment.free_stream_pressure(INDX, 1) = transducer_2(tmp_free_stream_voltage);
BoundaryLayerExperiment.free_stream_y(INDX, 1) = tmp_free_stream_y;
clear tmp_y tmp_V tmp_pressure tmp_free_stream_y tmp_free_stream_voltage;


%%First plot is nondimensional ration of u/U_infinity vs y/sigma


%%Seconf plot is Stanton number vs Reynolds number on log log plot
