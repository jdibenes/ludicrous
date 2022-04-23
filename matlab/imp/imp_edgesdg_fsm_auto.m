
function [edges, ok, cr_min] = imp_edgesdg_fsm_auto(line, th, cr_th)
width = numel(line);
line  = abs(line);

line(line < th) = 0;

state = 0;
index = 0;

target   = pat_crossratio(-1, 0,     1,     1.125);
target2  = pat_crossratio(-1, 0,     1,     1.25);
target3  = pat_crossratio(-1, 0,     1,     1.375);
target4  = pat_crossratio(-1, 0,     1.125, 1.25);
target5  = pat_crossratio(-1, 0,     1.125, 1.375);
target6  = pat_crossratio(-1, 0,     1.25,  1.375);
target7  = pat_crossratio(-1, 1,     1.125, 1.25);
target8  = pat_crossratio(-1, 1,     1.125, 1.375);
target9  = pat_crossratio(-1, 1,     1.25,  1.375);
target10 = pat_crossratio(-1, 1.125, 1.25,  1.375);
target11 = pat_crossratio( 0, 1,     1.125, 1.25);
target12 = pat_crossratio( 0, 1,     1.125, 1.375);
target13 = pat_crossratio( 0, 1,     1.25,  1.375);
target14 = pat_crossratio( 0, 1.125, 1.25,  1.375);
target15 = pat_crossratio( 1, 1.125, 1.25,  1.375);

edges_wnd = zeros(1, 8);
edges     = ones(1, 8);
cr_min    = Inf;

for col = 2:(width - 1)
data = line(col);

en = false;

switch (state)
case 0
    if     (data >  0),    x1 = col; prev = data; state = 1;            end
case 1
    if     (data >= prev), x1 = col; prev = data;
    elseif (data == 0),                           state = 0; en = true; 
    end
end

if (~en), continue; end

y1 = line(x1 - 1);
y2 = line(x1);
y3 = line(x1 + 1);

edges_wnd(1) = edges_wnd(2);
edges_wnd(2) = edges_wnd(3);
edges_wnd(3) = edges_wnd(4);
edges_wnd(4) = edges_wnd(5);
edges_wnd(5) = edges_wnd(6);
edges_wnd(6) = edges_wnd(7);
edges_wnd(7) = edges_wnd(8);
edges_wnd(8) = x1 + 0.5 * ((y1 - y3) / (y1 - 2*y2 + y3));

index = index + 1;
if (index < 8), continue; end

cr   = pat_crossratio(edges_wnd(1), edges_wnd(3), edges_wnd(5), edges_wnd(6));
cr2  = pat_crossratio(edges_wnd(1), edges_wnd(3), edges_wnd(5), edges_wnd(7));
cr3  = pat_crossratio(edges_wnd(1), edges_wnd(3), edges_wnd(5), edges_wnd(8));
cr4  = pat_crossratio(edges_wnd(1), edges_wnd(3), edges_wnd(6), edges_wnd(7));
cr5  = pat_crossratio(edges_wnd(1), edges_wnd(3), edges_wnd(6), edges_wnd(8));
cr6  = pat_crossratio(edges_wnd(1), edges_wnd(3), edges_wnd(7), edges_wnd(8));
cr7  = pat_crossratio(edges_wnd(1), edges_wnd(5), edges_wnd(6), edges_wnd(7));
cr8  = pat_crossratio(edges_wnd(1), edges_wnd(5), edges_wnd(6), edges_wnd(8));
cr9  = pat_crossratio(edges_wnd(1), edges_wnd(5), edges_wnd(7), edges_wnd(8));
cr10 = pat_crossratio(edges_wnd(1), edges_wnd(6), edges_wnd(7), edges_wnd(8));
cr11 = pat_crossratio(edges_wnd(3), edges_wnd(5), edges_wnd(6), edges_wnd(7));
cr12 = pat_crossratio(edges_wnd(3), edges_wnd(5), edges_wnd(6), edges_wnd(8));
cr13 = pat_crossratio(edges_wnd(3), edges_wnd(5), edges_wnd(7), edges_wnd(8));
cr14 = pat_crossratio(edges_wnd(3), edges_wnd(6), edges_wnd(7), edges_wnd(8));
cr15 = pat_crossratio(edges_wnd(5), edges_wnd(6), edges_wnd(7), edges_wnd(8));

cr_err   = abs(cr   - target);
cr2_err  = abs(cr2  - target2);
cr3_err  = abs(cr3  - target3);
cr4_err  = abs(cr4  - target4);
cr5_err  = abs(cr5  - target5);
cr6_err  = abs(cr6  - target6);
cr7_err  = abs(cr7  - target7);
cr8_err  = abs(cr8  - target8);
cr9_err  = abs(cr9  - target9);
cr10_err = abs(cr10 - target10);
cr11_err = abs(cr11 - target11);
cr12_err = abs(cr12 - target12);
cr13_err = abs(cr13 - target13);
cr14_err = abs(cr14 - target14);
cr15_err = abs(cr15 - target15);
        
cr_err_v = [
    cr_err;
    cr2_err;
    cr3_err;
    cr4_err;
    cr5_err;
    cr6_err;
    cr7_err;
    cr8_err;
    cr9_err;
    cr10_err;
    cr11_err;
    cr12_err;
    cr13_err;
    cr14_err;
    cr15_err;
];

cr_err = max(cr_err_v);

if (cr_err >= cr_min), continue; end

cr_min = cr_err;
edges  = edges_wnd;
end

ok = cr_min <= cr_th;
end
