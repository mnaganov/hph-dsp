declare name "Advanced Crossfeed";
declare id "adv_xfeed";
declare author "Radoslaw Szkodzinski";
declare email "astralstorm@gmail.com";
declare version "2.0";

import("filter.lib");
import("effect.lib");
import("math.lib");

// LICENCE: ISC (like BSD 2-clause, but shorter.)
/*
Copyright (c) 2013, Radosław Szkodziński <astralstorm@gmail.com>

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee
is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE
INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

Delaylen = 512; // enough for 0.75 ms delay @ 192000 HZ. Must be > 2 * Order. Power of 2 is faster.
delayfun = fdelay5;

// Defaults are tweaked by ear.
freq = nentry("Corner frequency (Hz)[unit:Hz]", 1500, 150, 6000, 10);
lgain = nentry("LF feed level (dB)[unit:dB]", -4.5, -48, 0, 0.1) : db2linear;
hgain = nentry("HF feed level (dB)[unit:dB]", -9, -48, 0, 0.1) : db2linear;
gain = nentry("Gain (dB)[unit:dB]", -12.0, -24, 12, 0.1) : db2linear;
//itd_delay = nentry("Inter-aural time delay (us)[unit:us]", 33.5, 0, 750, 1) : *(0.000001);
angle = nentry("Speaker spread angle (degrees)", 60, 0, 120, 1) / 2 / 180 * PI;
diameter = nentry("Head diameter L/R (cm)", 14, 8, 24, 0.01) * 0.01;
itd_fine = nentry("ITD fine tune (us)[unit:us]", 0, -100, 100, 0.1) : *(0.000001);
alpha = nentry("Filter steepness", 0.33, 0.01, 6, 0.01);
// This approximates imperfect summing. Perfect would be 6 dB.
center_focus = nentry("Center boost (dB)[unit:dB]", 4.5, 0, 9, 0.1) : db2linear : -(1.0);
//curvature = nentry("Directionality (percent)[unit:%%]", 15, 0, 100, 1) : *(0.01);
bypass = checkbox("Bypass");

// Knee frequency for the filter. Only approximate, as is Kaiser vs a bessel eq.
ft = freq/SR;

// Extra reading.
// http://www.music.miami.edu/programs/mue/Research/jwest/Chap_3/Chap_3_IID_Based_Panning_Methods.html

// Pattern match doesn't work here, so a slow if was necessary.
// Trimmed to prevent clipping, which could happen at some knee frequencies.
sinc(M, i) = if(i == M/2, 2*ft, sin(2*PI*ft*(i - M/2))/(PI*(i - M/2))) : min(2*ft);
sinc_inv(M, i) = if(i == M/2, 1-2*ft, 0-sin(2*PI*ft*(i - M/2))/(PI*(i - M/2))) : min(1-2*ft);

fact(0) = 1;
fact(1) = 1;
fact(k) = k * fact(k-1);

// Modified Bessel function of the first kind, approximated.
I0(K, x) = I0_part(K, K, x)
with {
    I0_part(K, 0, x) = 1;
    I0_part(K, i, x) = x^(2*i)/(2^(2*1)*fact(i)^2) + I0_part(K, i-1, x);
};

// Without the float twiddle this will explode.
// Trimmed to prevent clipping, which did happen at some knee frequencies.
kaiser(N, alpha, N+i) = 0;
kaiser(N, alpha, i) = I0(15, PI*alpha*sqrt(1 - (2*i/float(N))^2))/I0(15, PI*alpha) : min(1.0);

kaiser2(N, alpha, i) = kaiser(N, alpha, i - N/2);

// Must be even for the highpass to work properly.
// If you increase it, make sure to increase Delaylen too.
// Directly affects CPU usage. If too low, filter becomes allpass non-complementary.
// Transition band might have artifacts in such case and filter becomes inaccurate at lower corner frequencies.
// If it's very high, the faust compile will take a very long time.
Order = 192;

lp_fir_coeffs = par(i,Order,sinc(Order, i) * kaiser2(Order, alpha, i));
hp_fir_coeffs = par(i,Order,sinc_inv(Order, i) * kaiser2(Order, alpha, i));

mid(x,y) = (x+y)/2.0;
side(x,y) = (x-y)/2.0;
// Parabolic weighting function, also rejects side cancellation
// BROKEN, DO NOT USE. Huge harmonic distortion.
//mid(x,y) = pow(abs(x+y)/2.0, curvature)*((x+y)/2.0) + (1.0-pow(abs(x+y)/2.0, curvature))*x;
//side(x,y) = ((x-y)/2.0)*pow(abs(x+y)/2.0, curvature) + (1.0-pow(abs(x+y)/2.0, curvature))*x;

r(x,y) = sqrt(x^2+y^2);
phi(x,y) = atan2(y, x);

// Owen Cramer, "JASA, 93, p. 2510, 1993", with saturation vapor pressure taken from Richard S. Davis, "Metrologia, 29, p. 67, 1992",
// and a mole fraction of carbon dioxide of 0.0004. (0.8% carbon dioxide?)
// Thanks to http://www.sengpielaudio.com/calculator-airpressure.htm

// Humidity has an effect in range of 2 m/s on speed of sound.
// Pressures in normal 90-110 kPa range below 0.1 m/s.
// Temperature has a high effect; in range of 0-30 °C, ITD can change up to 20 us, meaning +/- 5 degrees spread.
// Therefore it's not necessary to include any realtime compensation other than fine tuning.

soundspeed = 346; // m/s, manually calculated; normal pressure, 24 °C, 20% humidity.

// Humidity-dependent distance/frequency attenuation?
// We don't know the reference humidity for measurement of speakers, and it's definitely not 0%.
// For headphones, we can easily assume there's no humidity-related high frequency attenuation.
// For speakers, it only begins to matter at higher distances.
// ISO 9613-1:1993, the effect can be audible with longer distances (10m) > 4000 Hz,
// with 0.5 dB/m at 16kHz, 24 °C, 20% humidity, 0.05 dB/m @ 4kHz.
// However, the headphone's HRTF should take it into consideration already
// and almost all have some degree of high frequency roll-off.
// We don't do equalization here and the side signal distance difference is tiny, easily dwarfed by head attenuation.

// Lord Rayleigh's spherical model - diameter in m, angle in radians
// Accurate in range 0-50 degrees vs Nordlund's (1962) measurements, which means up to 100 deg spread.
// See: http://www.frontiersin.org/computational_neuroscience/10.3389/fncom.2010.00018/full
itd(diam, theta) = diam/2 / soundspeed * (theta + sin(theta)); 

// fdelay5 can be replaced with a faster fdelay, obviously after fixing the FIR delay correction.
// This will very slightly reduce sound quality and bring a minor speedup.
channel_process = _ <: fir(lp_fir_coeffs), fir(hp_fir_coeffs) : *(lgain),*(hgain) : + : delayfun(Delaylen, ((itd(diameter, angle) + itd_fine) : max(0)) * SR);
// Delay correction to avert FIR combing.
crossfeed(x,y) = (
    (channel_process(side(y,x)) + delayfun(Delaylen, Order/2, x + mid(x,y)*center_focus)),
    (channel_process(side(x,y)) + delayfun(Delaylen, Order/2, y + mid(y,x)*center_focus))
);

// 100% correlated white noise for testing.
//process = noise <: fir(lp_fir_coeffs) + fir(hp_fir_coeffs); // FIR allpass test. Too low filter order fails it.
//process = noise <: crossfeed;
//process(x,y) = crossfeed(x,y) : (*(gain),*(gain));
process(x,y) = bypass2(bypass, crossfeed, x*(gain), y*(gain));

polar(x,y) = (
    r(x,y)*cos(phi(x,y)+offset),
    r(x,y)*sin(phi(x,y)-offset)
);

offset = nentry("Polar offset", PI/4, 0, PI/2, 0.01);

//process(x,y) = (x*(gain),y*(gain)) : polar;

