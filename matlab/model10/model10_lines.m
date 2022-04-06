
% one constraint %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 55% saa gsaa(:)
% 64% sbb gsbb(:)
% 60% scc gscc(:)
% 66% sdd gsdd(:)
% 65% see gsee(:)

% two constraints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 72% [saa, sbb] [gsaa(:), gsbb(:)]
% 66% [saa, scc] [gsaa(:), gscc(:)]
% 70% [saa, sdd] [gsaa(:), gsdd(:)]
% 75% [saa, see] [gsaa(:), gsee(:)]

% 73% [sbb, scc] [gsbb(:), gscc(:)]
% 75% [sbb, sdd] [gsbb(:), gsdd(:)]
% 78% [sbb, see] [gsbb(:), gsee(:)]

% 75% [scc, sdd] [gscc(:), gsdd(:)]
% 71% [scc, see] [gscc(:), gsee(:)]

% 75% [sdd, see] [gsdd(:), gsee(:)]

% three constraints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 84% [saa, sbb, scc] [gsaa(:), gsbb(:), gscc(:)]
% 80% [saa, sbb, sdd] [gsaa(:), gsbb(:), gsdd(:)]
% 77% [saa, sbb, see] [gsaa(:), gsbb(:), gsee(:)]
% 84% [saa, scc, sdd] [gsaa(:), gscc(:), gsdd(:)]
% 96% [saa, scc, see] [gsaa(:), gscc(:), gsee(:)] ***
% 85% [saa, sdd, see] [gsaa(:), gsdd(:), gsee(:)]

% 95% [sbb, scc, sdd] [gsbb(:), gscc(:), gsdd(:)] *
% 84% [sbb, scc, see] [gsbb(:), gscc(:), gsee(:)]
% 83% [sbb, sdd, see] [gsbb(:), gsdd(:), gsee(:)]

% 85% [scc, sdd, see] [gscc(:), gsdd(:), gsee(:)]

% four constraints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 92% [saa, sbb, scc, sdd] [gsaa(:), gsbb(:), gscc(:), gsdd(:)] *
% 96% [saa, sbb, scc, see] [gsaa(:), gsbb(:), gscc(:), gsee(:)] *
% 92% [saa, sbb, sdd, see] [gsaa(:), gsbb(:), gsdd(:), gsee(:)] *
% 94% [saa, scc, sdd, see] [gsaa(:), gscc(:), gsdd(:), gsee(:)] **

% 75% [sbb, scc, sdd, see] [gsbb(:), gscc(:), gsdd(:), gsee(:)]

% five constraints %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 70% [saa, sbb, scc, sdd, see] [gsaa(:), gsbb(:), gscc(:), gsdd(:), gsee(:)]

% selection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 95.7% 96.7% 95.0% ace
% 93.4% 93.6% 94.5% bcd

% 92.2% 92.2% 92.1% abcd
% 94.4% 95.1% 95.3% abce
% 93.6% 93.0% 94.0% abde
% 95.1% 94.6% 95.2% acde

function [neq, eq, gneq, geq] = model10_lines(x, R2, T2, row1n, row2n)
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

neq  = [];
gneq = [];
eq   = [];
geq  = [];

select = [true, false, true, false, true];

if (select(1))
    saa  = model10_saa( u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, row1n, row2n, T2(1), T2(2), T2(3), R2(1,1), R2(2,1), R2(3,1), R2(1,2), R2(2,2), R2(3,2), R2(1,3), R2(2,3), R2(3,3));
    gsaa = model10_gsaa(u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, row1n, row2n, T2(1), T2(2), T2(3), R2(1,1), R2(2,1), R2(3,1), R2(1,2), R2(2,2), R2(3,2), R2(1,3), R2(2,3), R2(3,3));
    eq   = [ eq,  saa];
    geq  = [geq, gsaa(:)];
end
if (select(2))
    sbb  = model10_sbb( u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, row1n, row2n, T2(1), T2(2), T2(3), R2(1,1), R2(2,1), R2(3,1), R2(1,2), R2(2,2), R2(3,2), R2(1,3), R2(2,3), R2(3,3));
    gsbb = model10_gsbb(u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, row1n, row2n, T2(1), T2(2), T2(3), R2(1,1), R2(2,1), R2(3,1), R2(1,2), R2(2,2), R2(3,2), R2(1,3), R2(2,3), R2(3,3));
    eq   = [ eq,  sbb];
    geq  = [geq, gsbb(:)];
end
if (select(3))
    scc  = model10_scc( u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, row1n, row2n, T2(1), T2(2), T2(3), R2(1,1), R2(2,1), R2(3,1), R2(1,2), R2(2,2), R2(3,2), R2(1,3), R2(2,3), R2(3,3));
    gscc = model10_gscc(u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, row1n, row2n, T2(1), T2(2), T2(3), R2(1,1), R2(2,1), R2(3,1), R2(1,2), R2(2,2), R2(3,2), R2(1,3), R2(2,3), R2(3,3));
    eq   = [ eq,  scc];
    geq  = [geq, gscc(:)];
end
if (select(4))
    sdd  = model10_sdd( u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, row1n, row2n, T2(1), T2(2), T2(3), R2(1,1), R2(2,1), R2(3,1), R2(1,2), R2(2,2), R2(3,2), R2(1,3), R2(2,3), R2(3,3));
    gsdd = model10_gsdd(u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, row1n, row2n, T2(1), T2(2), T2(3), R2(1,1), R2(2,1), R2(3,1), R2(1,2), R2(2,2), R2(3,2), R2(1,3), R2(2,3), R2(3,3));
    eq   = [ eq,  sdd];
    geq  = [geq, gsdd(:)];
end
if (select(5))
    see  = model10_see( u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, row1n, row2n, T2(1), T2(2), T2(3), R2(1,1), R2(2,1), R2(3,1), R2(1,2), R2(2,2), R2(3,2), R2(1,3), R2(2,3), R2(3,3));
    gsee = model10_gsee(u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e, row1n, row2n, T2(1), T2(2), T2(3), R2(1,1), R2(2,1), R2(3,1), R2(1,2), R2(2,2), R2(3,2), R2(1,3), R2(2,3), R2(3,3));
    eq   = [ eq,  see];
    geq  = [geq, gsee(:)];
end
end
