devices = daq.getDevices;
s = daq.createSession('ni');
addAnalogInputChannel(s,'Dev1', 0, 'Voltage'); %For recording neuron
addAnalogInputChannel(s,'Dev1', 1, 'Voltage'); %Force output from indenter
addAnalogOutputChannel(s,'Dev1', 0, 'Voltage'); %Waveform generator
s.Rate = 20000;

%s.DurationInSeconds = 40;

% step = sin(linspace(0,10*pi,10000)');
% queueOutputData(s,step);
% step = sin(linspace(10*pi,20*pi,10000)');
% queueOutputData(s,step);

amplitude = 1.4;
%step waveform
start_time = 1000;
end_time = 9000;
step = zeros(1,s.Rate);
step(start_time:end_time) = amplitude;

%square wave
t=0:1/s.Rate:120;
freq = 2;
square_wave = - square(2*pi*freq*t, 50);
stimulus = amplitude*square_wave;
stimulus(length(stimulus))=0;
%square_wave(1:start_time) = 0
queueOutputData(s,stimulus');

%figure();
%plot(step);
%title('Output Data Queued')

[data,time,triggerTime] = s.startForeground;
figure();
plot(time,data); hold on;
plot(time, stimulus);
xlabel('Time (secs)');
ylabel('Voltage');

trial =1;
filename_rec = sprintf("PTN_rec_%d_%d_trial%d.txt", amplitude, freq, trial);
filename_stim = sprintf("PTN_stim_%d_%d_trial%d.txt", amplitude, freq, trial);
%filename_stim_fb = sprintf("PTN_stim_fb_%d_%d_trial%d.txt", amplitude, freq, trial);


f_rec = fopen(filename_rec, 'w');
f_stim = fopen(filename_stim, 'w');
%f_stim_fb = fopen(filename_stim_fb, 'w');

fprintf(f_rec, "%f\n", data);
fprintf(f_stim, "%f\n%f\n", stimulus, time);
%fprintf(f_stim_fb, "%f\n", data);

fclose(f_rec);
fclose(f_stim);
%fclose(f_stim_fb);

