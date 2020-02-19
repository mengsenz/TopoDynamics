function [ freq,theta,t ] = thetaDecompose( THETA, NknotsOrBreaks,SR,varargin )
%THETADECOMPOSE this function decomposes a continuous series of phase
%onsets into smooth frequency time series and phase time series (phase fluctuation)
%   [ freq,theta,t ] = onsetDecompose( THETA, NknotsOrBreaks, SR, ...)
% input: 
%   THETA: N-by-M matrix, columns are vectors of time series of phase. N is
%   the number of sample points, M is the number channels.
%   NknotsOrBreaks: number of breaks in the smoothing process or the break points.
%   SR: sampling rate of the time series, default 250 Hz.
% Parameters:
%   tlimits: actual time limits between which the decomposition is wanted
%   regularization: robust fitting parameter "beta" - to use with spline
%   fit toolbox. Default 0.5 (must be between0 and 1).
% Output:
%   freq: interpolated and regularized instantaneous frequency
%   theta: interpolated residual phase flunctuation.
%   t: time axis.
% --------------------
% NOTE: this function depends on the SPLINEFIT toolbox developed by Jonas Lundgren, 
% which is available here: https://www.mathworks.com/matlabcentral/fileexchange/71225-splinefit
%{
~~ created by Mengsen Zhang <mengsenzhang@gmail.com> 2017-06-08 ~~
modifications:
%}
if nargin<3 || isempty(SR)
    SR=250;
end

p=inputParser();
p.addParameter('tlimits',[]) % min and max time to extract
p.addParameter('regularization',0.5,@(x) x>0&x<1) % how much regularization: a value in (0,1)
p.parse(varargin{:})
par=p.Results;

Npt=size(THETA,1);
if isempty(par.tlimits)
    par.tlimits=[0 Npt]/SR;
end
tmin=par.tlimits(1);
tmax=par.tlimits(2);
t=(1:Npt)'/SR; % time to interpolate
tidx=t>=tmin&t<=tmax;
% --- compute regularized onset sequence
if length(NknotsOrBreaks)==1
    breaks=linspace(tmin,tmax,NknotsOrBreaks);
else
    breaks=NknotsOrBreaks;
end
pp=splinefit(t,THETA',breaks,par.regularization);% coarse onset function
theta=(THETA-ppval(pp,t)')/2/pi;
freq=ppval(ppdiff(pp,1),t)'/2/pi;

theta=theta(tidx,:);
freq=freq(tidx,:);
t=t(tidx,:);
end

