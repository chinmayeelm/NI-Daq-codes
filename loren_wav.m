function [X,Y] = loren_wav (freq, fs, dur, amplitude)
  T = 1000/freq;
  x = linspace(-T/2, T/2, fs);
  X = repmat(x, 1, freq);
  Y = amplitude./(X.^2+1);
  
endfunction