declare name "Test Effect";
declare author "Mikhail Naganov";
declare version "1.0";

import("filter.lib");

bcoeffs = (0.0000001974, 0.0000007896, 0.0000011844, 0.0000007896, 0.0000001974);
acoeffs = (-3.8883119158, 5.6711306194, -3.6771261157, 0.8943105703);
process = iir(bcoeffs, acoeffs),
          iir(bcoeffs, acoeffs);
