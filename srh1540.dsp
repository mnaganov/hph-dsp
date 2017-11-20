declare name "SRH1540 Linearization Effect";
declare author "Mikhail Naganov";
declare version "1.0";

import("filter.lib");

pre_attn = db2linear(-4.8);
bcoeffs = (1.2935460135, -2.6882896883, 0.5805587189, 1.2009912395, 0.3177741055, -0.6171972024, -0.5218648194, 0.3340917147, 0.4054744762, -0.0405624307, -0.3558044851, -0.2043156860, 0.1685493924, 0.3015821067, 0.0558515813, -0.1788830569, -0.2144322685, 0.0633773691, 0.1560247988, 0.0357732992, -0.2182314505, -0.1293020231, 0.1598215774, 0.3392009523, 0.0669380381, -0.2685875972, -0.3164959869, 0.1179400379, 0.2915881431, 0.1009537396, -0.2997266253, -0.2080650240, 0.3020348203, 0.2177289908, -0.1476205804, -0.3482413495, 0.0295089412, 0.5948549229, -0.4211881016, -0.1423439997, 0.2024530153, 0.0981220491, -0.1291050607, 0.0216112163, -0.0249032360, 0.0082398647, 0.0128967430, 0.0035685833, -0.0058439433);
acoeffs = (-2.0453036147, 0.5230826068, 0.5959917005, 0.3782578067, -0.2473492988, -0.3709455169, 0.0311360871, 0.2669173188, 0.0594742354, -0.2207636452, -0.1597915526, 0.0799060582, 0.2223185951, 0.0526918140, -0.1152527826, -0.1582023376, 0.0283272530, 0.1000895451, 0.0376221536, -0.1430450222, -0.0904695454, 0.0958963276, 0.2442307901, 0.0686384197, -0.1710774133, -0.2460426797, 0.0514010297, 0.1949261624, 0.1074360542, -0.1904506404, -0.1606327151, 0.1858603684, 0.1540728526, -0.0672053663, -0.2506302585, -0.0141427715, 0.4233486162, -0.2869941425, -0.0492770840, 0.0795889921, 0.0541359186, -0.0511867369, 0.0399278043, -0.0624988749, 0.0082243893, 0.0219009896, 0.0032594689, -0.0073483114);

process = *(pre_attn), *(pre_attn) : iir(bcoeffs, acoeffs), iir(bcoeffs, acoeffs);