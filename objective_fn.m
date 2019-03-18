function [ out ] = objective_fn( x )
%OBJECTIVE_FN Summary of this function goes here

% Variables 
n = x(1);        % Number of wells
r_well = x(2);   % Radius of well
thick_end = x(3);    % Thickness of endplates

% Mechanical parameters
plate_size = 8e-2;  % 8 cm 
thick_wells = 1e-2; % 1 cm, thickness of wells and plates

% Thermal Parameters
k_6061 = 152;       % 152 W/m K
k_polyprop = 0.17;   % https://www.engineeringtoolbox.com/thermal-conductivity-d_429.html

% Calculate Resistances and Areas
area_end = plate_size^2;
area_wells = n * (pi * r_well^2);
area_plate = area_end - area_wells;

r_wells = thick_wells / (k_polyprop * area_wells);
r_plate = thick_wells / (k_6061 * area_plate);
r_end = thick_end / (k_6061 * area_end);
r_parallel = (1/r_wells + 1/r_plate)^-1;

% Total resistance: end > |wells, plate| > end
r_total = r_end * 2 + r_parallel;    

% Heat Balance
t_l = 100;  % Outer temperature, left side
t_r = 50;   % Outer temperature, right side
qdot_big = (t_l - t_r)/r_total;

% Calculate intermediate etmperatures
t_end_1 = -(r_end * qdot_big - t_l);
t_well = -(r_parallel * qdot_big - t_end_1);

% Actual objective function: distance from 20 degrees
% Minimize the distance from 20 degrees with these outside conditions
out = abs(20 - t_well);

end

