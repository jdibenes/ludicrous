
function [R, t] = pxp_upnp(R2, t2, pat1, pat2)
[R_all, t_all] = pxp_upnp_all(R2, t2, pat1, pat2);
[R, t] = pxp_select(R_all, t_all, R2, t2, pat2.ne, pat2.E);    
end
