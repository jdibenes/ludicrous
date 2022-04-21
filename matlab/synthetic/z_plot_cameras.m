
clear all

simulation_reference

% -------------------------------------------------------------------------

u = 64;
plane = 'zx';

% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

load(['./data/poses_1000_2000_' num2str(u) '.mat']);

figure();
plot3([-1, -1], [0, 1], [0, 0]);
hold on

plot3([-1   1], [0, 0], [0,   0],   'b');
plot3([-1, -1], [0, 0], [0,   0.5], 'b');
plot3([ 1,  1], [0, 0], [0,   0.5], 'b');
plot3([-1,  1], [0, 0], [0.5, 0.5], 'b');
plot3([ 0,  0], [0, 1], [0,   0],   'b');
plot3([ 0,  0], [0, 0], [0,   0.5], 'b');
plot3([ 0,  0], [1, 1], [0,   0.5], 'b');
plot3([ 0,  0], [0, 1], [0.5, 0.5], 'b');

xlabel('x');
ylabel('y');
zlabel('z');

old_pattern_scale = 100;

for k = 1:1000
    pose = old_pose_unpack(poses{k});

    R = pose.R;
    T = pose.T / old_pattern_scale;
    R2_g = pose.RR2;
    T2_g = pose.RT2T / old_pattern_scale;

    [R_w, T_w]   = pose_transform1(R, T);
    [R2_w, T2_w] = pose_transform1(R2_g, T2_g);

    plotCamera('Location', T,    'Orientation', R_w,  'Opacity', 0, 'Size', 1/16);
    plotCamera('Location', T2_g, 'Orientation', R2_w, 'Opacity', 0, 'Size', 1/16);
end

zlim([  0, 20]);
xlim([-20, 20]);
ylim([-20, 20]);

title('Cameras in the dataset', 'interpreter', 'latex')

%  0,   0 zx
% 90,   0 zy
% 90, -90 xy
switch (plane)
    case 'zx', vaz =  0; vel =   0;
    case 'zy', vaz = 90; vel =   0;
    case 'xy', vaz = 90; vel = -90;
end

view(vaz, vel);

ax          = gca;
outerpos    = ax.OuterPosition;
ti          = ax.TightInset; 
left        = outerpos(1) + ti(1);
bottom      = outerpos(2) + ti(2);
ax_width    = outerpos(3) - ti(1) - ti(3);
ax_height   = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom 0.98 * ax_width ax_height];

drawnow

print([plane num2str(u) '.eps'], '-depsc') 
