function [ dist ] = PD_distance( pds,p,varargin )
%PD_DISTANCE Compute Distance between persistence landscapes
% [ dist ] = PD_distance( pds,p,'toolboxpath',... )
% input:
%   pds: cell array of persistence diagrams
%   p: L_p norm to use
% parameters:
%   infty: what's the value of infinity. By default 'none', which means all
%   intervals containing negative b, d time will be removed. '-1' is what
%   landscape toolbox recognizes as infty. Any other value x will be used
%   to replace any negative number.
% output:
%   dist: distance matrix M_{i,j} is the distance between PD_i and PD_j
% -------------------
% NOTE: this function depends on the persistent landscape toolbox developed
% by Pawel Dlotko, which is available here: 
% https://www.math.upenn.edu/~dlotko/persistenceLandscape.html
%{
~~ created by Mengsen Zhang <mengsenzhang@gmail.com> 06/15/2017 ~~

%}
if nargin<2 || isempty(p)
    p=-1;% L_inf
end
ps=inputParser;
ps.addParameter('toolboxpath','.\tools\PLandscape\',@isfolder)
ps.addParameter('infty','none');% how to deal with infinit interval, default: ignore
ps.parse(varargin{:})
par=ps.Results;
% -- check configuration file
if ~exist([pwd '\configure'],'file')
    copyfile([par.toolboxpath 'configure'])
end
Npd=length(pds);
% -- print persistence diagrams (PDs) to text
fid=fopen('fnames.txt','w');% list of PDs
for i=1:Npd
    fname=sprintf('pd%i.txt',i);
    switch par.infty
        case 'none'
            pds{i}(any(pds{i}<0,2),:)=[];
        otherwise
            pds{i}(pds{i}<0)= par.infty;
    end
    dlmwrite(fname,pds{i},' ');
    fprintf(fid,[fname '\n']);
end
fclose(fid);
% -- compute distance matrix based on persistence landscape
system([par.toolboxpath 'DistanceMatrix fnames.txt ' num2str(p)]);
% -- convert to matlab format
dist=importdata('distances.txt');
% -- delete byproducts
pause(0.001);
system('del pd*.txt fnames.txt distances.txt');
end

