
clear all

%--------------------------------------------------------------------------

name = 'sample_d0_ok';

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

load(['./' name '/imp_z_data.mat']);

test_direct   = load(['./' name '/direct_300.mat']);
test_optimize = load(['./' name '/optimize_300.mat']);

edges1 = data.edges1;

first_index = find(test_direct.ok, 1);
last_index  = find(test_direct.ok, 1, 'last');

direct_R   = test_direct.error(  first_index:last_index, 1);
direct_t   = test_direct.error(  first_index:last_index, 2);
optimize_R = test_optimize.error(first_index:last_index, 1);
optimize_t = test_optimize.error(first_index:last_index, 2);

first = edges1(first_index, 6);
last  = last_index - first_index;

figure()

plot(first + (0:last), direct_R);
hold on
plot(first + (0:last), optimize_R);
xlabel('Image 1 row');
ylabel('Error (degrees)');
title('Orientation error');
xlim([first, first + last]);
maxy = max([direct_R; optimize_R]);
Rstep = maxy / 16;
yticks(0:Rstep:maxy);
ytickformat('%.2f')
ylim([0, maxy]);
legend({'without refinement', 'with refinement'});

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom 0.98 * ax_width ax_height];

drawnow

print(['R_' name '.eps'], '-depsc')

figure()

plot(first + (0:last), direct_t * 100);
hold on
plot(first + (0:last), optimize_t * 100);
xlabel('Image 1 row');
ylabel('Error (%)');
title('Translation relative error');
xlim([first, first + last]);
maxy = max([direct_t; optimize_t]) * 100;
tstep = maxy / 16;
yticks(0:tstep:maxy);
ytickformat('%.2f')
ylim([0, maxy]);
legend({'without refinement', 'with refinement'});

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom 0.98 * ax_width ax_height];

drawnow

print(['T_' name '.eps'], '-depsc')
