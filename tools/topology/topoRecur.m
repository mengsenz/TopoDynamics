function [distmatpd0,distmatpd1,distmatrecur,pd0,pd1, tlim] = topoRecur(X,varargin)
%TOPORECUR compute topological recurrence plot using persistent homology.
%The function can also compute regular recurrence plot for comparison. 
% [distmatpd0,distmatpd1,distmatrecur,pd0,pd1, tlim] = topoRecur(X,varargin)
%   input:
%       X: p-by-d-by-t matrix, p is the number of points per time point, d
%       the number of coordinates of each point, t the number of time points. 
%   output:
%       distmatpd0: recurrence plot based on 0th persistent homology.
%       distmatpd1: recurrence plot based on 1st persistent homology.
%       distmatrecur: regular recurrence plot given a distance function
%       (see parameter 'recurdist')
%       pd0: a cell array of 0th persistence diagrams
%       pd1: a cell array of 1st persistence diagrams 
%       tlim: time within the time limits. 
%   parameters: see below.
%{
~~ created by Mengsen Zhang <mengsenzhang@gmail.com> 2018 ~~
%}
p=inputParser;
p.addParameter('distfun',@norm) % distance between points at the same time point
% -- parameters for decomposition -- %
p.addParameter('SR',1,@isnumeric); % sampling rate
p.addParameter('tlim',[1 48]);% time limits of decomposition
% -- parameters for persistent homology -- %
p.addParameter('ambientdim',2); % ambient dimension, for computing (<ambientdim>-1)-th homology
p.addParameter('r_max',0.5); % maximal radius for Rips complex
p.addParameter('initialstep',0.005);% initial radius of each data point
p.addParameter('stepsize',0.005); % step size of filtration
p.addParameter('scaling',[1 1 1]) % scaling of the coordinates
p.addParameter('downsample',1,@isnumeric); % reduce temporal resolution by <downsample> for compute homology
% -- parameter for computing distance matrix
p.addParameter('topodist',-1); % L-p norm of landscape distance
p.addParameter('recurdist',@(x,y) norm([wrapToPi(x(1:length(x)/2)-y(1:length(x)/2)) ,x(length(x)/2+1:end)-y(length(x)/2+1:end)])); % distance function for recurrent quantification
p.parse(varargin{:});
par=p.Results;

% -- data dimensions
Npt=size(X,1);
Ndim=size(X,2);
Nt=size(X,3);
% -- trim data
t=(1:Nt)'/par.SR;
tidx=t>=par.tlim(1) & t<par.tlim(2);
X=X(:,:,tidx);
tlim=t(tidx);
% -- downsample data
X_=X(:,:,1:par.downsample:end);
Nt_=size(X_,3);

% -- compute persistent homology
[pd0,pd1]=deal(cell(1,Nt_));

for n=1:Nt_
    % --- extract data for window
    D=recurDist(squeeze(X_(:,:,n)),par.distfun);
    % --- compute PD
    [pd0{n},pd1{n}]=PD_RipsMat(D,par.ambientdim,...
        'stepsize',par.stepsize,'initialstep',par.initialstep,'maxradius',par.r_max);
end

% -- compute distance
distmatpd0=PD_distance(pd0,par.topodist);
distmatpd1=PD_distance(pd1,par.topodist);
distmatrecur=recurDist(reshape(X_,Npt*Ndim,Nt_)',par.recurdist);


end
