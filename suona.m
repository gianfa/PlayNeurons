function [] = suona( f, T )
% Generate a sound
%   f: frequency [Hz]
%   T: duration [s]

if nargin == 1
    T = 0.5;
end
fs = 8000;      %sample frequency [Hz]
t = 0:(1/fs):T; %sample duration from 0 a T
%f = 130.81;    
a = 0.8;        %amplitude
y = a*sin(2*pi*f*t);
sound(y, fs);
