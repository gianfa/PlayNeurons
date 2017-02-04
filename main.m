%% PlayNeurons v0.1
% Visualize MEA neurons while firing.
% Play a specific sound for each firing neuron.

n_neurons = 64; %n of neurons or electrodes on MEA
tSim = 8;       %simulation time [s];
pps = 60;       %plot updating frequency [plot/s]
dta = 10;       %n of times on wich evaluate the fr; step

%% Initialize the spikes matrix (time serie)

% Generate a Spike Matrix
% spikeMat is a 0/1 matrix nxm: n neurons x times.
[spikeMat, tVec] = poissonSpikeGen(tSim, n_neurons, 30);

% Draw the Raster Plot
fig1 = figure();
subplot(1,2,1);
plotRaster(spikeMat, tVec*5000);
title('Raster Plot');
xlabel('Time [ms]');
ylabel('Neuron Number');

% Draw the Array-Wide Firing Rate Histogram
sumSpike = sum(spikeMat); %vector total spikes at t
subplot(1,2,2);
histogram( sumSpike );    %Histogram
title('Array-Wide Firing Rate Histogram');
xlabel('Firing Rate tot');
ylabel('Times at the fr');
fig1.Position = [156,260,560,420];

%% Initialize tones for each neuron
% You can uncomment the next 3 lines and use a linear spacing between 2
% frequencies you like, as first and last freq; or you can just use a Piano
% like ripartition (not rigorous), ready in sPiano function, which need 
% just th number of the key to play. 

%toneFirst = 200; 
%toneLast = 900;
%toni = linspace(toneFirst, toneLast, n_neurons );
toni = zeros( 1, n_neurons );
toni = sPiano( toni ); 


%% Generate the plot for a specific time
% unpack the matrix in rows
am = int8( spikeMat );
rMat = reshape(am,[1,size(am,1),size(am,2)]); %[1row: tot neurons: t instants]

plotxsec = pps;  %plot updating frequency [plot/s]
dlt = dta;       %number of instants over wich calculate the fr; step
dlt_s = (1/plotxsec)*dlt;   %dlt duration [s]
fig2 = figure();
fig2.Position = [759,260,560,420];

for t = 1:size(spikeMat,2)
    figure(fig2);
    meav_t = transpose( rMat(1,:,t) );  %mea at specific t, vectorized
    mea_lato = sqrt( size(meav_t, 1) ); 
    mea_t = reshape( meav_t, [ mea_lato, mea_lato] ); %mea "geometric" (squared)
    % evaluate the fr through a average
    if t == 1
        mea_fr = meav_t;
    elseif mod( t,dlt ) ~= 0
        mea_fr = mea_fr + meav_t;
    else %we're at dlt-th instant
        % Generate the sound
        sparanti = find( meav_t ); %indexes of firing neurons spiking at this t
        for nss = 1:length(sparanti)
            suona( toni( sparanti(nss) ), dlt_s*0.8 );
        end
        % Update the plot
        mea_fr = mea_fr./dlt;   %frequecies : spikes sum/step
        mea_fr_t = reshape( meav_t, [ mea_lato, mea_lato ] ); %mea "geometric"
        mea_fr_norm = mea_fr_t./max(max( mea_fr_t )); %normalized mea
        % Plotto %
        subplot(1,2,1);
        bar3(mea_fr_t, barDim);
        axis( [0,mea_lato+1, 0,mea_lato+1, 0,1.2] );
        mea_fr = int8( zeros( size(meav_t) ) );
        title('Spikes on MEA - averaged');
        zlabel('spike');
    end
    
    %heights = ones( mea_lato);
    barDim = 0.9;
    subplot(1,2,2);
    title('Spikes on MEA');
    zlabel('spike');
    bar3( mea_t*5, barDim );
    axis( [0,mea_lato+1, 0,mea_lato+1, 0,5*1.2] );
    pause( 1/plotxsec );
end


