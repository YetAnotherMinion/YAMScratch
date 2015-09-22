clear
clc
close('all')

%measurement on caliber +- 0.0005
shaft_diameter = [0.2490, 0.2485, 0.2850, 0.2480, 0.2490];
shaft_radius = 
%use the sample stddev, which is the default
shaft_radius_stddev = std(shaft_diameter .* 0.5);

pulley_diameter = 
pulley_radius = avg() 
pulley_radius_stddev = std(pulley_diameter .* 0.5)