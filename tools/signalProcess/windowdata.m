function [Xwin,twin] = windowdata(X,winsize, lag,varargin)
%WINDOWDATA given multidimensional timeseries, segment them to discrete
%windows.
% [Xwin,twin] = windowdata(X,winsize, lag,...)
%   input:
%       X: p-by-d matrix, p is the number of points, d is the dimension of the space.
%       winsize: number of samples per window
%       lag: distance between consecutive window in samples
%   output:
%       Xwin: windowed data.
%       twin: time in each window
%{
~~ created by Mengsen Zhang <mengsenzhang@gmail.com> 6-28-2018 ~~
modifications:

%}
[Nt,Ndim]=size(X);
t=int32((1:Nt)'*ones(1,Ndim));

win_t0=int32(1:lag:Nt-winsize+1);
Nw=length(win_t0);

% -- windowing data
[Xwin,twin]=deal(NaN(Nw,Ndim*winsize));
for w=1:Nw
    tidx=t>=win_t0(w) & t<win_t0(w) + winsize;
    Xwin(w,:)=X(tidx)';
    twin(w,:)=t(tidx)';
end
end

