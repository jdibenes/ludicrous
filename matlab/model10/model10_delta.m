
function [f, gf] = model10_delta(x, x_start)
u1a = x(1);
u1b = x(2);
u1c = x(3);
u1d = x(4);
u1e = x(5);

u2a = x(6);
u2b = x(7);
u2c = x(8);
u2d = x(9);
u2e = x(10);

m1a = x_start(1);
m1b = x_start(2);
m1c = x_start(3);
m1d = x_start(4);
m1e = x_start(5);

m2a = x_start(6);
m2b = x_start(7);
m2c = x_start(8);
m2d = x_start(9);
m2e = x_start(10);

f  = model10_f( u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, m1a, m1b, m1c, m1d, m1e, m2a, m2b, m2c, m2d, m2e);
gf = model10_gf(u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, m1a, m1b, m1c, m1d, m1e, m2a, m2b, m2c, m2d, m2e);
end
