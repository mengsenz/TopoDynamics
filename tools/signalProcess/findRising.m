function [ idxRise ] = findRising( x )
%FINDRISING find rising edges of square waves for a single vector
%   x   a single data vector
%   idxRise index of rising edges
dx=diff(x);
[~, idxRise] = findpeaks(dx);
idxRise = idxRise+1;


end

