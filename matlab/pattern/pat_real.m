
function pat = pat_real(pmodel, K, R, T, row)
[pat.a, pat.za, pat.Pa] = pat_find(K, R, T, pmodel.p11_3D, pmodel.n1, row);
[pat.b, pat.zb, pat.Pb] = pat_find(K, R, T, pmodel.p21_3D, pmodel.n2, row);
[pat.c, pat.zc, pat.Pc] = pat_find(K, R, T, pmodel.p31_3D, pmodel.n3, row);
[pat.d, pat.zd, pat.Pd] = pat_find(K, R, T, pmodel.p41_3D, pmodel.n4, row);
[pat.e, pat.ze, pat.Pe] = pat_find(K, R, T, pmodel.p51_3D, pmodel.n5, row);

pat.row = row;
end
