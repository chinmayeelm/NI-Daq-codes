f = 2;
fs = 10000;
dur = 4;
amplitude = 2;

[A,B] = loren_wav (f,fs,dur,amplitude);

%devices = daq.getDevices;
s = daq.createSession('ni');
s.Rate = fs;
addAnalogOutputChannel(s,'Dev2', 'ao3' ,'Voltage'); %check device ID

%random_data = (linspace(-1, 1, 1000)');
queueOutputData(s,B');

startBackground(s);

pause();
