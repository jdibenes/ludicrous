
clear all

%%

% -------------------------------------------------------------------------

min_u = 256;
s     = 0.5;
loc   = 'southeast';
%loc   = 'northwest';

% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

%%

load(['./data/' 'results_ogv_' num2str(min_u) '_' num2str(s) '_final.mat']);

labels = {'six-point', 'ten-point', 'upnp', 'simple', 'six-point*', 'ten-point*', 'upnp*', 'simple*'};

remI7 = error_R7 == 0;
remI8 = error_R8 == 0;

error_R7(remI7) = [];
error_R8(remI8) = [];
error_T7(remI7) = [];
error_T8(remI8) = [];

%%

x = 0:(0.25/2):5;

y1 = bin_R(error_R1, x);
y2 = bin_R(error_R2, x);
y3 = bin_R(error_R3, x);
y4 = bin_R(error_R4, x);
y5 = bin_R(error_R5, x);
y6 = bin_R(error_R6, x);
y7 = bin_R(error_R7, x);
y8 = bin_R(error_R8, x);

figure()
hold on
plot(x, y2, '-');  % six
plot(x, y1, '-');  % ten
plot(x, y5, '-');  % upnp
plot(x, y7, '-');  % simp
plot(x, y4, '--'); % six  opt
plot(x, y3, '--'); % ten  opt
plot(x, y6, '--'); % upnp opt
plot(x, y8, '--'); % simp opt
grid on

title(['Orientation error for $\sigma=' num2str(s) '$'], 'interpreter','latex');
xlabel('Error (degrees)', 'interpreter','latex');
ylabel('Cumulative', 'interpreter','latex');
legend(labels, 'interpreter','latex', 'Location', loc);

ylim([0, 1000]);
xticks(0:0.5:5)

print(['R_ogv_h' num2str(min_u) '_' num2str(s*100) '.eps'], '-depsc') 

%%

x = 0:(0.01/2):0.1;

y1 = bin_T(error_T1, x);
y2 = bin_T(error_T2, x);
y3 = bin_T(error_T3, x);
y4 = bin_T(error_T4, x);
y5 = bin_T(error_T5, x);
y6 = bin_T(error_T6, x);
y7 = bin_T(error_T7, x);
y8 = bin_T(error_T8, x);

x = x * 100;

figure()
hold on
plot(x, y2, '-');  % six
plot(x, y1, '-');  % ten
plot(x, y5, '-');  % upnp
plot(x, y7, '-');  % sim
plot(x, y4, '--'); % six  opt
plot(x, y3, '--'); % ten  opt
plot(x, y6, '--'); % upnp opt
plot(x, y8, '--'); % sim  opt
grid on

title(['Translation relative error for $\sigma=' num2str(s) '$'], 'interpreter','latex');
xlabel('Relative error (\%)', 'interpreter','latex');
ylabel('Cumulative', 'interpreter','latex');
legend(labels, 'interpreter','latex', 'Location', loc);

ylim([0, 1000]);
xticks(0:1:10)

print(['T_ogv_h' num2str(min_u) '_' num2str(s*100) '.eps'], '-depsc')

%%

function y = bin_R(error_R, list)
y = zeros(1, numel(list));
for k = 1:numel(list), y(k) = sum(error_R <= list(k)); end
end

function y = bin_T(error_T, list)
y = zeros(1, numel(list));
for k = 1:numel(list), y(k) = sum(error_T <= list(k)); end
end
