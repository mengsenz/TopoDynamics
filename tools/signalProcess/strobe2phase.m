function [theta,pp] = strobe2phase( ons, t, phaseChange, bWrap, interpOpt)
%STROBE2PHASE transform discrete events, e.g. onsets of tapping, to phases
%of continuous oscillation. 
%   theta = strobe2phase( ons, phaseChange, bWrap, interpOpt)
%   inputs: 
%       ons: time of occurrence
%       phaseChange: how much change in phase between consecutive events
%       (in radians)
%       bWrap: wrap phase to (-pi,pi]?
%       interpOpt: what kind of interpolation?
%   output:
%       theta: phase
%{ 
~~ created by Mengsen Zhang <mengsenzhang@gmail.com> 2016-04-30 ~~
Modifications:


%}

if nargin<5, interpOpt = {'pchip','extrap'};end
if nargin<4, bWrap = 1; end
if nargin<3, phaseChange = 2*pi; end

onPhase=0:length(ons)-1;   onPhase=onPhase*phaseChange; % set the phase of rising edges to 2pi
% -- interp and extrap
if length(ons)>1
    extrapedPhase = interp1(ons(:),onPhase(:),t,interpOpt{:});
    pp = spline(ons(:),onPhase(:));
elseif length(ons)==1
    extrapedPhase = onPhase*ones(size(t));
end

% -- wrap the phase between -pi to pi
if bWrap
    theta=wrapToPi(extrapedPhase);
else
    theta=extrapedPhase;
end

end

