function [ theta, idx ] = fullSqr2phase( x, bWrap, interpOpt)
%FULLSQR2PHASE Transform full sqaure wave to phase time series
% [ theta, idx ] = fullSqr2phase( x, bWrap, interpOpt)
% 
% IN:
%   x:  square wave time series; 1 col= 1 time series
%   bWrap: whether or not the wrap phase to (-pi,pi]
%   interpOpt: 1-by-2 cell array of interpolation and extrapolation
%   options, e.g. {'pchip','extrap'}.
%             interpolation options:
%                 'nearest'   nearest neighbor
%                 'linear'    linear
%                 'spline'    cubic spline
%                 'pchip'     piecewise cubic Hermite 
%                 'cubic'     same as pchip
%                 'v5cubic'   cubic without extrapolation
%   bHalfPeriod:  (bool) whether half period (pi/2) is included. Default:
%                false, meaning only rising edges, but no falling edges are
%                included as the source of interpolation.
% OUT:
%   theta:  phase
%   idx:    indice of rising edges   
%{
~~ created by Mengsen Zhang <mengsenzhang@gmail.com> 2016-01-04 ~~
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ----- check arguments
if nargin<3, interpOpt = {'pchip','extrap'};end
if nargin<2, bWrap = 1; end

[r,c]=size(x);
t=1:length(x);

theta=zeros(r,c);
idx=cell(1,c);
for i=1:c % for each column
    ons=findRising(x(:,i));% onsets of taps

    % ----- interpolate phase
    theta(:,i) = strobe2phase( ons, t, 2*pi, bWrap, interpOpt);
    idx{i}=ons;
end
end

