function [ varargout ] = PD_RipsMat(dm, abdim, varargin)
% PD_RipsMat compute the persistence diagram of a point cloud defined by
% distant matrix using Rips complexes.
%   [ pd0, pd1, ..., dm ] = PD_RipsMat(X, abdim, ...)
% input:
%   D: a distance matrix
%   abdim: ambient dimension of the object. 
% output:
%   pd0: persistence diagram for H_0
%   pd1: persistence diagram for H_1
%   ...: ... (there are as many diagrams as <abdim>)
%   dm: distance matrix used to compute Rips complex.
% parameters:
%   stepsize: step size of filtration (default=0.001)
%   initialstep: the initial radius of each point (default=stepsize).
%   Perseus doesn't like zero
%   maxradius: when to stop filtration (default=2)
%   toolboxpath: where's Perseus
% -------------
% NOTE: this function depends on "perseusWin.exe" developed by Vidit Nanda,
% which can be found here: http://people.maths.ox.ac.uk/nanda/perseus/
%{
~~ created by Mengsen Zhang <mengsenzhang@gmail.com> 2017-06-27 ~~
%}
p=inputParser();
p.addParameter('stepsize',0.005,@isnumeric)
p.addParameter('initialstep',[],@isnumeric)
p.addParameter('maxradius',2,@isnumeric)
p.addParameter('toolboxpath','.\tools\topology\',@isfolder)
p.parse(varargin{:})
par=p.Results;

if isempty(par.initialstep)
    par.initialstep=par.stepsize;
end
% --- For rips complex
num_steps=(par.maxradius-par.initialstep)/par.stepsize;

% --- create input file for perseus
Npt=size(dm,1);
tic
fid=fopen('tmp\rips_dm.txt','wt');
fprintf(fid,'%i\n',Npt);
fprintf(fid,'%g %i %i %i\n',par.initialstep,par.stepsize,num_steps,abdim);
for i=1:size(dm,1)
    for j=1:size(dm,2)
        fprintf(fid,'%g ',dm(i,j)); 
    end
    fprintf(fid,'\n');
end    
fclose(fid);
toc

% --- call perseus
tic
system([par.toolboxpath,'perseusWin distmat tmp\rips_dm.txt tmp\output']);
system('del tmp\rips_dm.txt');
toc

% --- scale persistence diagrams
varargout=cell(1,nargout);
for i=0:nargout-1
    if i<abdim
        if exist(['tmp\output_' num2str(i) '.txt'],'file')
            pd=load(['tmp\output_' num2str(i) '.txt']);
        else
            pd=[];
        end
        varargout{i+1}=par.initialstep.*(pd>=0) +pd*par.stepsize;
    elseif i<abdim+1
        pd=load('tmp\output_betti.txt');
        pd=pd(:,1:end-1);
        pd(:,1)=par.initialstep.*(pd(:,1)>=0)+pd(:,1)*par.stepsize;
        varargout{i+1}=pd;
    elseif i<abdim+2
        varargout{i+1}=dm;
    end
end

!del tmp\output_*.txt

end

