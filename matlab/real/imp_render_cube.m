
function imp_render_cube(center, scale, K1, R_w, t_w, im1, row, color) 
P1 = center + [ scale;  scale; 0];
P2 = center + [ scale; -scale; 0];
P3 = center + [-scale;  scale; 0];
P4 = center + [-scale; -scale; 0];
P5 = center + [ scale;  scale; 2*scale];
P6 = center + [ scale; -scale; 2*scale];
P7 = center + [-scale;  scale; 2*scale];
P8 = center + [-scale; -scale; 2*scale];

p11 = pose_project(K1, R_w, t_w, P1);
p21 = pose_project(K1, R_w, t_w, P2);
p31 = pose_project(K1, R_w, t_w, P3);
p41 = pose_project(K1, R_w, t_w, P4);
p51 = pose_project(K1, R_w, t_w, P5);
p61 = pose_project(K1, R_w, t_w, P6);
p71 = pose_project(K1, R_w, t_w, P7);
p81 = pose_project(K1, R_w, t_w, P8);

p11 = p11/p11(3);
p21 = p21/p21(3);
p31 = p31/p31(3);
p41 = p41/p41(3);
p51 = p51/p51(3);
p61 = p61/p61(3);
p71 = p71/p71(3);
p81 = p81/p81(3);

figure();
imshow(im1);
hold on

plot([1, 3840], [row, row], color, 'LineWidth', 4);

plot([p11(1), p21(1)], [p11(2), p21(2)], 'm', 'LineWidth', 4);
plot([p11(1), p31(1)], [p11(2), p31(2)], 'm', 'LineWidth', 4);
plot([p41(1), p21(1)], [p41(2), p21(2)], 'm', 'LineWidth', 4);
plot([p41(1), p31(1)], [p41(2), p31(2)], 'm', 'LineWidth', 4);
plot([p51(1), p61(1)], [p51(2), p61(2)], 'm', 'LineWidth', 4);
plot([p51(1), p71(1)], [p51(2), p71(2)], 'm', 'LineWidth', 4);
plot([p81(1), p61(1)], [p81(2), p61(2)], 'm', 'LineWidth', 4);
plot([p81(1), p71(1)], [p81(2), p71(2)], 'm', 'LineWidth', 4);
plot([p11(1), p51(1)], [p11(2), p51(2)], 'm', 'LineWidth', 4);
plot([p21(1), p61(1)], [p21(2), p61(2)], 'm', 'LineWidth', 4);
plot([p31(1), p71(1)], [p31(2), p71(2)], 'm', 'LineWidth', 4);
plot([p41(1), p81(1)], [p41(2), p81(2)], 'm', 'LineWidth', 4);

plot(p11(1), p11(2), '.m', 'MarkerSize', 32);
plot(p21(1), p21(2), '.m', 'MarkerSize', 32);
plot(p31(1), p31(2), '.m', 'MarkerSize', 32);
plot(p41(1), p41(2), '.m', 'MarkerSize', 32);
plot(p51(1), p51(2), '.m', 'MarkerSize', 32);
plot(p61(1), p61(2), '.m', 'MarkerSize', 32);
plot(p71(1), p71(2), '.m', 'MarkerSize', 32);
plot(p81(1), p81(2), '.m', 'MarkerSize', 32);

drawnow
end