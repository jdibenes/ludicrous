
clear all

simulation_reference

block_size = 10000;
iterations = 10000;
point_size = 1;
range_y    = [ 0.25,  1.75];
range_x    = [-1.125, 1.375];
auto_lines = [ 1.125, 1.25];

f = pat_draw(pmodel, auto_lines, range_x, range_y, block_size, iterations, point_size);
%pat_border(f, [-1.125, 0.25, 1.375, 1.75], 0.125, ['g', 'r', 'b'], 0.1);
