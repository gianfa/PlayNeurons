function [spikeMat, tVec] = poissonSpikeGen(tSim, nTrials, fr)
% Generate a Spike Matrix
% source: https://praneethnamburi.wordpress.com/2015/02/05/simulating-neural-spike-trains/
%   fr: firing-rate, [spike/s];
%   tSim: simulation time, [s];
%   nTrials: number of trials, or MEA electrodes.

verbose = 0;
if verbose == 1
    disp('Generating Raster');
end
dt = 1/1000; % [s]
nBins = floor(tSim/dt);
spikeMat = rand(nTrials, nBins) < fr*dt;
tVec = 0:dt:tSim-dt;
if verbose == 1
    disp('Raster Ready');
end
