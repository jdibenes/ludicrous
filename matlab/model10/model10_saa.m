function saa = model10_saa(u1a,u1b,u1c,u1d,u1e,u2a,u2b,u2c,u2d,u2e,row1,row2,T2_1,T2_2,T2_3,R2_1_1,R2_2_1,R2_3_1,R2_1_2,R2_2_2,R2_3_2,R2_1_3,R2_2_3,R2_3_3)
%MODEL10_SAA
%    SAA = MODEL10_SAA(U1A,U1B,U1C,U1D,U1E,U2A,U2B,U2C,U2D,U2E,ROW1,ROW2,T2_1,T2_2,T2_3,R2_1_1,R2_2_1,R2_3_1,R2_1_2,R2_2_2,R2_3_2,R2_1_3,R2_2_3,R2_3_3)

%    This function was generated by the Symbolic Math Toolbox version 8.3.
%    12-Jul-2020 19:08:22

t2 = u1a.*u1e;
t3 = u2a.*u2e;
t4 = row1.^2;
t5 = row2.^2;
t6 = u1a.^2;
t7 = u2a.^2;
t8 = u1e.^2;
t9 = u2e.^2;
t10 = -u1c;
t11 = -u2c;
t12 = -u1d;
t13 = -u2d;
t14 = -u1e;
t15 = -u2e;
t16 = t10+u1a;
t17 = t11+u2a;
t18 = t12+u1a;
t19 = t10+u1b;
t20 = t13+u2a;
t21 = t11+u2b;
t22 = t12+u1b;
t23 = t13+u2b;
t24 = t14+u1b;
t25 = t12+u1c;
t26 = t15+u2b;
t27 = t13+u2c;
t28 = t14+u1c;
t29 = t15+u2c;
t30 = t4+t6+1.0;
t31 = t5+t7+1.0;
t32 = t4+t8+1.0;
t33 = t5+t9+1.0;
t36 = t2+t4+1.0;
t37 = t3+t5+1.0;
t34 = t16.^2;
t35 = t17.^2;
t38 = 1.0./t16;
t39 = 1.0./t17;
t40 = 1.0./t22;
t41 = 1.0./t23;
t42 = 1.0./t28;
t44 = 1.0./t29;
t46 = 1.0./t30;
t47 = 1.0./t31;
t48 = 1.0./sqrt(t30);
t49 = 1.0./sqrt(t31);
t43 = t42.^2;
t45 = t44.^2;
t50 = t18.*t19.*t38.*t40.*4.0e+2;
t51 = t20.*t21.*t39.*t41.*4.0e+2;
t52 = t24.*t25.*t40.*t42.*4.0e+2;
t53 = t26.*t27.*t41.*t44.*4.0e+2;
t56 = t16.*t36.*t42.*t46.*2.0;
t57 = t17.*t37.*t44.*t47.*2.0;
t54 = -t52;
t55 = -t53;
t58 = t32.*t34.*t43.*t46;
t59 = t33.*t35.*t45.*t47;
t60 = -t56;
t61 = -t57;
t62 = t50+t54;
t63 = t51+t55;
t66 = t58+t60+1.0;
t67 = t59+t61+1.0;
t64 = t62.^2;
t65 = t63.^2;
t70 = 1.0./t66;
t71 = 1.0./t67;
t68 = t64+4.0e+4;
t69 = t65+4.0e+4;
t74 = sqrt(t70);
t75 = sqrt(t71);
t72 = sqrt(t68);
t73 = sqrt(t69);
saa = -(t50-t51).^2+(T2_3-t48.*t72.*t74+t49.*t73.*t75.*(R2_3_3+R2_3_2.*row2+R2_3_1.*u2a)).^2+(T2_2-row1.*t48.*t72.*t74+t49.*t73.*t75.*(R2_2_3+R2_2_2.*row2+R2_2_1.*u2a)).^2+(T2_1-t48.*t72.*t74.*u1a+t49.*t73.*t75.*(R2_1_3+R2_1_2.*row2+R2_1_1.*u2a)).^2;