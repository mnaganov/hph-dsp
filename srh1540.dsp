declare name "SRH1540 Linearization Effect";
declare author "Mikhail Naganov";
declare version "1.0";

import("filter.lib");

pre_attn = 0.5754399373;  // -4.8 dB
bcoeffs = (1.2935460135e+00, -2.6882896883e+00, 5.8055871890e-01, 1.2009912395e+00, 3.1777410549e-01, -6.1719720238e-01, -5.2186481937e-01, 3.3409171468e-01, 4.0547447617e-01, -4.0562430717e-02, -3.5580448515e-01, -2.0431568604e-01, 1.6854939240e-01, 3.0158210667e-01, 5.5851581347e-02, -1.7888305686e-01, -2.1443226850e-01, 6.3377369076e-02, 1.5602479882e-01, 3.5773299204e-02, -2.1823145055e-01, -1.2930202313e-01, 1.5982157741e-01, 3.3920095233e-01, 6.6938038102e-02, -2.6858759718e-01, -3.1649598690e-01, 1.1794003790e-01, 2.9158814315e-01, 1.0095373958e-01, -2.9972662528e-01, -2.0806502400e-01, 3.0203482030e-01, 2.1772899084e-01, -1.4762058040e-01, -3.4824134950e-01, 2.9508941153e-02, 5.9485492288e-01, -4.2118810158e-01, -1.4234399973e-01, 2.0245301526e-01, 9.8122049100e-02, -1.2910506074e-01, 2.1611216268e-02, -2.4903236007e-02, 8.2398647132e-03, 1.2896743037e-02, 3.5685833114e-03, -5.8439432613e-03);
acoeffs = (-2.0453036147e+00, 5.2308260676e-01, 5.9599170051e-01, 3.7825780669e-01, -2.4734929883e-01, -3.7094551688e-01, 3.1136087081e-02, 2.6691731885e-01, 5.9474235377e-02, -2.2076364518e-01, -1.5979155260e-01, 7.9906058172e-02, 2.2231859507e-01, 5.2691813982e-02, -1.1525278263e-01, -1.5820233760e-01, 2.8327252993e-02, 1.0008954505e-01, 3.7622153555e-02, -1.4304502222e-01, -9.0469545371e-02, 9.5896327628e-02, 2.4423079012e-01, 6.8638419733e-02, -1.7107741332e-01, -2.4604267966e-01, 5.1401029742e-02, 1.9492616235e-01, 1.0743605420e-01, -1.9045064042e-01, -1.6063271511e-01, 1.8586036841e-01, 1.5407285257e-01, -6.7205366265e-02, -2.5063025848e-01, -1.4142771473e-02, 4.2334861620e-01, -2.8699414251e-01, -4.9277084047e-02, 7.9588992121e-02, 5.4135918603e-02, -5.1186736912e-02, 3.9927804326e-02, -6.2498874863e-02, 8.2243893343e-03, 2.1900989576e-02, 3.2594688503e-03, -7.3483113561e-03);

process = *(pre_attn), *(pre_attn) : iir(bcoeffs, acoeffs), iir(bcoeffs, acoeffs);
