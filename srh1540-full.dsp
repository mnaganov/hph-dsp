declare name "SRH1540 Crossfeed and Linearization Effect";
declare author "Mikhail Naganov";
declare version "1.0";

import("filter.lib");

cf_pre_attn = 0.5069907083;
d_bcoeffs = (1.3922589117, -0.1671886707, -0.3900848919, -0.2609142131, -0.3148044725, -0.2134394791, -0.1957839015, -0.0807061748, -0.0887963165, -0.0180883859, 0.0350882442, 0.0637338379, -0.0201605796, -0.0090717694, 0.0231320277, 0.0921629468, 0.0560207339, 0.0618578353, -0.0497107379, 0.0470489467, 0.0256121565, 0.1323512997, -0.0020002313, -0.0883802218, -0.0129688278);
d_acoeffs = (-0.1129403942, -0.2727873359, -0.1827000490, -0.2229877300, -0.1521366090, -0.1407647106, -0.0592798300, -0.0655907149, -0.0152774659, 0.0228200172, 0.0436231436, -0.0162197293, -0.0082752179, 0.0148246054, 0.0645635654, 0.0391380484, 0.0437206249, -0.0360483241, 0.0332509090, 0.0180501678, 0.0949150900, -0.0008989325, -0.0628379705, -0.0091819141);
o_bcoeffs = (0.9141694726, -0.1127635557, -0.0881471039, -0.0939509156, -0.0883839602, -0.0882451526, -0.0826659823, -0.0801528041, -0.0764742448, -0.0720208571, -0.0637180011, -0.0589303959, -0.0535325674, -0.0446329674, -0.0357088157, -0.0292512277, -0.0185360888, -0.0073673874, 0.0010375189, 0.0159059830, 0.0231105552, 0.0413518324, 0.0459948502, 0.0786203629, 0.0166152739);
o_acoeffs = (-0.1337734910, -0.1026681154, -0.1085870213, -0.1008947578, -0.0998820140, -0.0925990543, -0.0890478344, -0.0841071847, -0.0785473366, -0.0687504424, -0.0630119486, -0.0565990941, -0.0465052360, -0.0364403365, -0.0292228985, -0.0173716205, -0.0051774368, 0.0039183684, 0.0199906621, 0.0275570833, 0.0471440559, 0.0516994849, 0.0868659694, 0.0181916700);
opp_attn = 0.4206297637;

pre_attn = 0.5754399373;  // -4.8 dB
bcoeffs = (1.2935460135e+00, -2.6882896883e+00, 5.8055871890e-01, 1.2009912395e+00, 3.1777410549e-01, -6.1719720238e-01, -5.2186481937e-01, 3.3409171468e-01, 4.0547447617e-01, -4.0562430717e-02, -3.5580448515e-01, -2.0431568604e-01, 1.6854939240e-01, 3.0158210667e-01, 5.5851581347e-02, -1.7888305686e-01, -2.1443226850e-01, 6.3377369076e-02, 1.5602479882e-01, 3.5773299204e-02, -2.1823145055e-01, -1.2930202313e-01, 1.5982157741e-01, 3.3920095233e-01, 6.6938038102e-02, -2.6858759718e-01, -3.1649598690e-01, 1.1794003790e-01, 2.9158814315e-01, 1.0095373958e-01, -2.9972662528e-01, -2.0806502400e-01, 3.0203482030e-01, 2.1772899084e-01, -1.4762058040e-01, -3.4824134950e-01, 2.9508941153e-02, 5.9485492288e-01, -4.2118810158e-01, -1.4234399973e-01, 2.0245301526e-01, 9.8122049100e-02, -1.2910506074e-01, 2.1611216268e-02, -2.4903236007e-02, 8.2398647132e-03, 1.2896743037e-02, 3.5685833114e-03, -5.8439432613e-03);
acoeffs = (-2.0453036147e+00, 5.2308260676e-01, 5.9599170051e-01, 3.7825780669e-01, -2.4734929883e-01, -3.7094551688e-01, 3.1136087081e-02, 2.6691731885e-01, 5.9474235377e-02, -2.2076364518e-01, -1.5979155260e-01, 7.9906058172e-02, 2.2231859507e-01, 5.2691813982e-02, -1.1525278263e-01, -1.5820233760e-01, 2.8327252993e-02, 1.0008954505e-01, 3.7622153555e-02, -1.4304502222e-01, -9.0469545371e-02, 9.5896327628e-02, 2.4423079012e-01, 6.8638419733e-02, -1.7107741332e-01, -2.4604267966e-01, 5.1401029742e-02, 1.9492616235e-01, 1.0743605420e-01, -1.9045064042e-01, -1.6063271511e-01, 1.8586036841e-01, 1.5407285257e-01, -6.7205366265e-02, -2.5063025848e-01, -1.4142771473e-02, 4.2334861620e-01, -2.8699414251e-01, -4.9277084047e-02, 7.9588992121e-02, 5.4135918603e-02, -5.1186736912e-02, 3.9927804326e-02, -6.2498874863e-02, 8.2243893343e-03, 2.1900989576e-02, 3.2594688503e-03, -7.3483113561e-03);

channel_process(x, y) = (x : iir(d_bcoeffs, d_acoeffs)) + ((y : iir(o_bcoeffs, o_acoeffs)) * opp_attn);
crossfeed(x, y) = channel_process(x, y), channel_process(y, x);
process = *(cf_pre_attn), *(cf_pre_attn) : crossfeed : *(pre_attn), *(pre_attn) : iir(bcoeffs, acoeffs), iir(bcoeffs, acoeffs);
