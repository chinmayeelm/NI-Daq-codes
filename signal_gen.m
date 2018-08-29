f = 2;
fs = 10000;
dur = 2;
amplitude = 2;

[A,B] = loren_wav (f,fs,dur,amplitude);
plot(B);
%plot(A);

s = daq.createSession('ni');
s.Rate = fs;
addAnalogOutputChannel(s,'cDAQ1Mod2',0,'Voltage'); %check device ID

queueOutputData(s,B);

startForeground(s);
