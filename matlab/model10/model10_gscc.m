function gscc = model10_gscc(u1a,u1b,u1c,u1d,u1e,u2a,u2b,u2c,u2d,u2e,row1,row2,t2_1,t2_2,t2_3,R2_1_1,R2_2_1,R2_3_1,R2_1_2,R2_2_2,R2_3_2,R2_1_3,R2_2_3,R2_3_3)
%MODEL10_GSCC
%    GSCC = MODEL10_GSCC(U1A,U1B,U1C,U1D,U1E,U2A,U2B,U2C,U2D,U2E,ROW1,ROW2,T2_1,T2_2,T2_3,R2_1_1,R2_2_1,R2_3_1,R2_1_2,R2_2_2,R2_3_2,R2_1_3,R2_2_3,R2_3_3)

%    This function was generated by the Symbolic Math Toolbox version 8.6.
%    12-Apr-2022 14:34:22

t2 = u1a.*u1c;
t3 = u2a.*u2c;
t4 = u1c.*u1e;
t5 = u2c.*u2e;
t6 = u1a+u1e;
t7 = u2a+u2e;
t8 = row1.^2;
t9 = row2.^2;
t10 = u1a.*2.0;
t11 = u2a.*2.0;
t12 = u1a.*4.0;
t13 = u2a.*4.0;
t14 = u1c.*2.0;
t15 = u2c.*2.0;
t16 = u1c.*4.0;
t17 = u2c.*4.0;
t18 = u1e.*2.0;
t19 = u2e.*2.0;
t20 = u1e.*4.0;
t21 = u2e.*4.0;
t24 = -t2_1;
t25 = -t2_2;
t26 = -t2_3;
t27 = -u1c;
t29 = -u2c;
t33 = u1c.*8.0;
t34 = u2c.*8.0;
t35 = -u1d;
t36 = -u2d;
t37 = -u1e;
t39 = -u2e;
t41 = u1a.*u1e.*-2.0;
t42 = u2a.*u2e.*-2.0;
t22 = t10.*u1e;
t23 = t11.*u2e;
t28 = -t14;
t30 = -t15;
t31 = -t16;
t32 = -t17;
t38 = -t18;
t40 = -t19;
t43 = -t33;
t44 = -t34;
t45 = t27+u1a;
t46 = t29+u2a;
t47 = t35+u1a;
t48 = t27+u1b;
t49 = t36+u2a;
t50 = t29+u2b;
t51 = t37+u1a;
t52 = t35+u1b;
t53 = t39+u2a;
t54 = t36+u2b;
t55 = t37+u1b;
t56 = t35+u1c;
t57 = t39+u2b;
t58 = t36+u2c;
t59 = t37+u1c;
t61 = t39+u2c;
t65 = t10+t27;
t66 = t11+t29;
t83 = t2+t4+t41;
t84 = t3+t5+t42;
t60 = t38+u1c;
t62 = t40+u2c;
t63 = t6+t28;
t64 = t7+t30;
t67 = 1.0./t45;
t69 = 1.0./t46;
t71 = 1.0./t52;
t73 = 1.0./t54;
t75 = 1.0./t59;
t77 = 1.0./t61;
t81 = t6.*2.0+t31;
t82 = t7.*2.0+t32;
t85 = t6.*4.0+t43;
t86 = t7.*4.0+t44;
t87 = t83.^2;
t88 = t84.^2;
t68 = t67.^2;
t70 = t69.^2;
t72 = t71.^2;
t74 = t73.^2;
t76 = t75.^2;
t78 = t77.^2;
t79 = t63.^2;
t80 = t64.^2;
t89 = t47.*t67.*t71.*2.0;
t90 = t48.*t67.*t71.*2.0;
t91 = t49.*t69.*t73.*2.0;
t92 = t50.*t69.*t73.*2.0;
t93 = t55.*t71.*t75.*2.0;
t94 = t56.*t71.*t75.*2.0;
t95 = t57.*t73.*t77.*2.0;
t96 = t58.*t73.*t77.*2.0;
t115 = t49.*t50.*t69.*t73.*-2.0;
t118 = t55.*t56.*t71.*t75.*-2.0;
t121 = t57.*t58.*t73.*t77.*-2.0;
t97 = -t93;
t98 = -t94;
t99 = -t95;
t100 = -t96;
t101 = t48.*t89;
t102 = t47.*t48.*t67.*t72.*2.0;
t103 = t47.*t48.*t68.*t71.*2.0;
t104 = t50.*t91;
t105 = t49.*t50.*t69.*t74.*2.0;
t106 = t49.*t50.*t70.*t73.*2.0;
t107 = t56.*t93;
t108 = t55.*t56.*t71.*t76.*2.0;
t109 = t55.*t56.*t72.*t75.*2.0;
t110 = t58.*t95;
t111 = t57.*t58.*t73.*t78.*2.0;
t112 = t57.*t58.*t74.*t77.*2.0;
t113 = -t102;
t114 = -t103;
t116 = -t105;
t117 = -t106;
t119 = -t108;
t120 = -t109;
t122 = -t111;
t123 = -t112;
t128 = t101+t118;
t129 = t104+t121;
t164 = t101+t107+t115+t121;
t124 = t90+t114;
t125 = t92+t117;
t126 = t94+t119;
t127 = t96+t122;
t130 = t128.^2;
t131 = t129.^2;
t158 = t89+t93+t114+t119;
t159 = t89+t98+t109+t113;
t160 = t90+t97+t109+t113;
t161 = t91+t95+t117+t122;
t162 = t91+t100+t112+t116;
t163 = t92+t99+t112+t116;
t132 = t130+1.0;
t133 = t131+1.0;
t165 = t79.*t124.*t128.*2.0;
t166 = t80.*t125.*t129.*2.0;
t167 = t79.*t126.*t128.*2.0;
t168 = t80.*t127.*t129.*2.0;
t173 = t87.*t124.*t128.*2.0;
t174 = t88.*t125.*t129.*2.0;
t175 = t87.*t126.*t128.*2.0;
t176 = t88.*t127.*t129.*2.0;
t177 = t79.*t128.*t158.*2.0;
t178 = t79.*t128.*t159.*2.0;
t179 = t79.*t128.*t160.*2.0;
t180 = t80.*t129.*t161.*2.0;
t181 = t80.*t129.*t162.*2.0;
t182 = t80.*t129.*t163.*2.0;
t189 = t87.*t128.*t158.*2.0;
t190 = t87.*t128.*t159.*2.0;
t191 = t87.*t128.*t160.*2.0;
t192 = t88.*t129.*t161.*2.0;
t193 = t88.*t129.*t162.*2.0;
t194 = t88.*t129.*t163.*2.0;
t134 = t79.*t132;
t135 = t80.*t133;
t136 = t81.*t132;
t137 = t82.*t133;
t140 = t85.*t132;
t141 = t86.*t133;
t142 = t87.*t132;
t143 = t88.*t133;
t148 = t6.*t83.*t132.*2.0;
t149 = t7.*t84.*t133.*2.0;
t152 = t83.*t132.*(t18+t27).*-2.0;
t153 = t84.*t133.*(t19+t29).*-2.0;
t154 = t65.*t83.*t132.*2.0;
t155 = t66.*t84.*t133.*2.0;
t169 = t8.*t165;
t170 = t9.*t166;
t171 = t8.*t167;
t172 = t9.*t168;
t183 = t8.*t177;
t184 = t8.*t178;
t185 = t8.*t179;
t186 = t9.*t180;
t187 = t9.*t181;
t188 = t9.*t182;
t138 = t8.*t134;
t139 = t9.*t135;
t144 = t8.*t136;
t145 = t9.*t137;
t146 = t8.*t140;
t147 = t9.*t141;
t150 = -t148;
t151 = -t149;
t156 = -t154;
t157 = -t155;
t228 = t178+t184+t190;
t229 = t179+t185+t191;
t230 = t181+t187+t193;
t231 = t182+t188+t194;
t195 = t134+t138+t142;
t196 = t135+t139+t143;
t232 = t136+t144+t152+t165+t169+t173;
t233 = t137+t145+t153+t166+t170+t174;
t234 = t136+t144+t156+t167+t171+t175;
t235 = t137+t145+t157+t168+t172+t176;
t236 = t140+t146+t150+t177+t183+t189;
t237 = t141+t147+t151+t180+t186+t192;
t197 = 1.0./sqrt(t195);
t199 = 1.0./sqrt(t196);
t198 = t197.^3;
t200 = t199.^3;
t201 = t132.*t197;
t202 = R2_1_3.*t133.*t199;
t203 = R2_2_3.*t133.*t199;
t204 = R2_3_3.*t133.*t199;
t207 = R2_1_2.*row2.*t133.*t199;
t208 = R2_2_2.*row2.*t133.*t199;
t209 = R2_3_2.*row2.*t133.*t199;
t210 = R2_1_1.*t133.*t199.*u2c;
t211 = R2_2_1.*t133.*t199.*u2c;
t212 = R2_3_1.*t133.*t199.*u2c;
t205 = row1.*t201;
t206 = t201.*u1c;
t213 = t51.*t201;
t214 = t53.*t202;
t215 = t53.*t203;
t216 = t53.*t204;
t219 = t53.*t207;
t220 = t53.*t208;
t221 = t53.*t209;
t222 = t53.*t210;
t223 = t53.*t211;
t224 = t53.*t212;
t217 = t51.*t205;
t218 = t51.*t206;
t225 = -t213;
t227 = t27.*t213;
t226 = -t217;
t238 = t26+t216+t221+t224+t225;
t240 = t24+t214+t219+t222+t227;
t239 = t25+t215+t220+t223+t226;
gscc = [t238.*(t201+t51.*t124.*t128.*t197.*2.0-(t51.*t132.*t198.*t232)./2.0).*-2.0-t124.*t164.*2.0-t239.*(t205+row1.*t51.*t124.*t128.*t197.*2.0-(row1.*t51.*t132.*t198.*t232)./2.0).*2.0-t240.*(t206+t14.*t51.*t124.*t128.*t197-(t51.*t132.*t198.*t232.*u1c)./2.0).*2.0;t164.*(t89+t94+t113+t120).*-2.0-t239.*(row1.*t51.*t128.*t159.*t197.*2.0-(row1.*t51.*t132.*t198.*t228)./2.0).*2.0-t240.*(t51.*t128.*t159.*t197.*u1c.*2.0-(t51.*t132.*t198.*t228.*u1c)./2.0).*2.0-t238.*(t51.*t128.*t159.*t197.*2.0-(t51.*t132.*t198.*t228)./2.0).*2.0;t164.*(t89+t97+t108+t114).*2.0+t239.*(row1.*t51.*t128.*t158.*t197.*2.0-(row1.*t51.*t132.*t198.*t236)./2.0).*2.0+t238.*(t51.*t128.*t158.*t197.*2.0-(t51.*t132.*t198.*t236)./2.0).*2.0-t240.*(t213-t51.*t128.*t158.*t197.*u1c.*2.0+(t51.*t132.*t198.*t236.*u1c)./2.0).*2.0;t164.*(t90+t93+t113+t120).*2.0+t239.*(row1.*t51.*t128.*t160.*t197.*2.0-(row1.*t51.*t132.*t198.*t229)./2.0).*2.0+t240.*(t51.*t128.*t160.*t197.*u1c.*2.0-(t51.*t132.*t198.*t229.*u1c)./2.0).*2.0+t238.*(t51.*t128.*t160.*t197.*2.0-(t51.*t132.*t198.*t229)./2.0).*2.0;t238.*(t201-t51.*t126.*t128.*t197.*2.0+(t51.*t132.*t198.*t234)./2.0).*2.0+t126.*t164.*2.0+t239.*(t205-row1.*t51.*t126.*t128.*t197.*2.0+(row1.*t51.*t132.*t198.*t234)./2.0).*2.0+t240.*(t206-t51.*t126.*t128.*t197.*u1c.*2.0+(t51.*t132.*t198.*t234.*u1c)./2.0).*2.0;t125.*t164.*2.0+t240.*(t202+t207+t210+R2_1_3.*t53.*t125.*t129.*t199.*2.0-(R2_1_3.*t53.*t133.*t200.*t233)./2.0+R2_1_2.*row2.*t53.*t125.*t129.*t199.*2.0-(R2_1_2.*row2.*t53.*t133.*t200.*t233)./2.0+R2_1_1.*t15.*t53.*t125.*t129.*t199-(R2_1_1.*t53.*t133.*t200.*t233.*u2c)./2.0).*2.0+t239.*(t203+t208+t211+R2_2_3.*t53.*t125.*t129.*t199.*2.0-(R2_2_3.*t53.*t133.*t200.*t233)./2.0+R2_2_2.*row2.*t53.*t125.*t129.*t199.*2.0-(R2_2_2.*row2.*t53.*t133.*t200.*t233)./2.0+R2_2_1.*t15.*t53.*t125.*t129.*t199-(R2_2_1.*t53.*t133.*t200.*t233.*u2c)./2.0).*2.0+t238.*(t204+t209+t212+R2_3_3.*t53.*t125.*t129.*t199.*2.0-(R2_3_3.*t53.*t133.*t200.*t233)./2.0+R2_3_2.*row2.*t53.*t125.*t129.*t199.*2.0-(R2_3_2.*row2.*t53.*t133.*t200.*t233)./2.0+R2_3_1.*t15.*t53.*t125.*t129.*t199-(R2_3_1.*t53.*t133.*t200.*t233.*u2c)./2.0).*2.0;t164.*(t91+t96+t116+t123).*2.0+t240.*(R2_1_3.*t53.*t129.*t162.*t199.*2.0-(R2_1_3.*t53.*t133.*t200.*t230)./2.0+R2_1_2.*row2.*t53.*t129.*t162.*t199.*2.0-(R2_1_2.*row2.*t53.*t133.*t200.*t230)./2.0+R2_1_1.*t53.*t129.*t162.*t199.*u2c.*2.0-(R2_1_1.*t53.*t133.*t200.*t230.*u2c)./2.0).*2.0+t239.*(R2_2_3.*t53.*t129.*t162.*t199.*2.0-(R2_2_3.*t53.*t133.*t200.*t230)./2.0+R2_2_2.*row2.*t53.*t129.*t162.*t199.*2.0-(R2_2_2.*row2.*t53.*t133.*t200.*t230)./2.0+R2_2_1.*t53.*t129.*t162.*t199.*u2c.*2.0-(R2_2_1.*t53.*t133.*t200.*t230.*u2c)./2.0).*2.0+t238.*(R2_3_3.*t53.*t129.*t162.*t199.*2.0-(R2_3_3.*t53.*t133.*t200.*t230)./2.0+R2_3_2.*row2.*t53.*t129.*t162.*t199.*2.0-(R2_3_2.*row2.*t53.*t133.*t200.*t230)./2.0+R2_3_1.*t53.*t129.*t162.*t199.*u2c.*2.0-(R2_3_1.*t53.*t133.*t200.*t230.*u2c)./2.0).*2.0;t164.*(t91+t99+t111+t117).*-2.0+t240.*(R2_1_1.*t53.*t133.*t199-R2_1_3.*t53.*t129.*t161.*t199.*2.0+(R2_1_3.*t53.*t133.*t200.*t237)./2.0-R2_1_2.*row2.*t53.*t129.*t161.*t199.*2.0+(R2_1_2.*row2.*t53.*t133.*t200.*t237)./2.0-R2_1_1.*t53.*t129.*t161.*t199.*u2c.*2.0+(R2_1_1.*t53.*t133.*t200.*t237.*u2c)./2.0).*2.0+t239.*(R2_2_1.*t53.*t133.*t199-R2_2_3.*t53.*t129.*t161.*t199.*2.0+(R2_2_3.*t53.*t133.*t200.*t237)./2.0-R2_2_2.*row2.*t53.*t129.*t161.*t199.*2.0+(R2_2_2.*row2.*t53.*t133.*t200.*t237)./2.0-R2_2_1.*t53.*t129.*t161.*t199.*u2c.*2.0+(R2_2_1.*t53.*t133.*t200.*t237.*u2c)./2.0).*2.0+t238.*(R2_3_1.*t53.*t133.*t199-R2_3_3.*t53.*t129.*t161.*t199.*2.0+(R2_3_3.*t53.*t133.*t200.*t237)./2.0-R2_3_2.*row2.*t53.*t129.*t161.*t199.*2.0+(R2_3_2.*row2.*t53.*t133.*t200.*t237)./2.0-R2_3_1.*t53.*t129.*t161.*t199.*u2c.*2.0+(R2_3_1.*t53.*t133.*t200.*t237.*u2c)./2.0).*2.0;t164.*(t92+t95+t116+t123).*-2.0-t240.*(R2_1_3.*t53.*t129.*t163.*t199.*2.0-(R2_1_3.*t53.*t133.*t200.*t231)./2.0+R2_1_2.*row2.*t53.*t129.*t163.*t199.*2.0-(R2_1_2.*row2.*t53.*t133.*t200.*t231)./2.0+R2_1_1.*t53.*t129.*t163.*t199.*u2c.*2.0-(R2_1_1.*t53.*t133.*t200.*t231.*u2c)./2.0).*2.0-t239.*(R2_2_3.*t53.*t129.*t163.*t199.*2.0-(R2_2_3.*t53.*t133.*t200.*t231)./2.0+R2_2_2.*row2.*t53.*t129.*t163.*t199.*2.0-(R2_2_2.*row2.*t53.*t133.*t200.*t231)./2.0+R2_2_1.*t53.*t129.*t163.*t199.*u2c.*2.0-(R2_2_1.*t53.*t133.*t200.*t231.*u2c)./2.0).*2.0-t238.*(R2_3_3.*t53.*t129.*t163.*t199.*2.0-(R2_3_3.*t53.*t133.*t200.*t231)./2.0+R2_3_2.*row2.*t53.*t129.*t163.*t199.*2.0-(R2_3_2.*row2.*t53.*t133.*t200.*t231)./2.0+R2_3_1.*t53.*t129.*t163.*t199.*u2c.*2.0-(R2_3_1.*t53.*t133.*t200.*t231.*u2c)./2.0).*2.0;t127.*t164.*-2.0-t240.*(t202+t207+t210-R2_1_3.*t53.*t127.*t129.*t199.*2.0+(R2_1_3.*t53.*t133.*t200.*t235)./2.0-R2_1_2.*row2.*t53.*t127.*t129.*t199.*2.0+(R2_1_2.*row2.*t53.*t133.*t200.*t235)./2.0-R2_1_1.*t53.*t127.*t129.*t199.*u2c.*2.0+(R2_1_1.*t53.*t133.*t200.*t235.*u2c)./2.0).*2.0-t239.*(t203+t208+t211-R2_2_3.*t53.*t127.*t129.*t199.*2.0+(R2_2_3.*t53.*t133.*t200.*t235)./2.0-R2_2_2.*row2.*t53.*t127.*t129.*t199.*2.0+(R2_2_2.*row2.*t53.*t133.*t200.*t235)./2.0-R2_2_1.*t53.*t127.*t129.*t199.*u2c.*2.0+(R2_2_1.*t53.*t133.*t200.*t235.*u2c)./2.0).*2.0-t238.*(t204+t209+t212-R2_3_3.*t53.*t127.*t129.*t199.*2.0+(R2_3_3.*t53.*t133.*t200.*t235)./2.0-R2_3_2.*row2.*t53.*t127.*t129.*t199.*2.0+(R2_3_2.*row2.*t53.*t133.*t200.*t235)./2.0-R2_3_1.*t53.*t127.*t129.*t199.*u2c.*2.0+(R2_3_1.*t53.*t133.*t200.*t235.*u2c)./2.0).*2.0];
