% example_analysis.m
%{
This script provides an example analysis for the paper "Topological
portraits of multiscale coordination dynamics" by Mengsen Zhang, William D.
Kalies, J. A. Scott Kelso, and Emmanuelle Tognoli. It produces results
shown in Fig 8 of the paper.

~~ created by Mengsen Zhang <mengsenzhang@gmail.com> 2020. ~~


%}
%% ===== dependencies ===== %%
addpath(genpath('./'))
%% ===== preprocess data ===== %%
% load either of the two files for data of examples trials: 
% "data/data_3agents.mat" or "data/data_8agents.mat"
%
load data/data_8agents.mat
theta_original=fullSqr2phase(raw_dat,false,{'spline',NaN}); % convert movement data to phase time series
%% ===== persistent homology and recurrence plots ===== %%
% --- parameters to extract the relevant time series
t0=EVENTS(3); % (s) onset of the social interaction period
tlimits=[1 48]; % (s) period for recurrence analysis
ds=25; % rate of down-sampling

% --- parameters for persistent homology
rmin=0.1; % smallest scale considered
rmax=0.5; % largeest scale considered
stepsize=0.005; % resolution of scales
Lpnorm = -1; % norm for compare persistent landscapes (-1=infty)

% --- regularization parameter for frequency-phase decomposition
beta=0.5;

% --- parameters for windowing the frequency-phase graph
winsize=2;
lag=1;

% -- decompose original phase to a slow frequency component + a fast residual phase component
[ freq,theta_res,tt ] = thetaDecompose(theta_original,tlimits(1)+t0:winsize:t0+tlimits(2)+1,sr,'regularization',beta);
theta_res=2*pi*theta_res;

% -- segment frequency-phase graph into windows
theta_win=windowdata(theta_res,winsize*sr,lag*sr);
[freq_win, t_win]=windowdata(freq,winsize*sr,lag*sr);
t_win=t_win/sr;
X=nan(size(theta_win,2),3,size(theta_win,1));
X(:,1,:)=theta_win';
X(:,2,:)=freq_win';
X(:,3,:)=(t_win-repmat(t_win(:,1),1,size(t_win,2)))';
X=X(1:ds:end,:,:);% downsampling

% -- define distance
% distance between points in a point cloud (for topological analysis)
d_pt = @(x,y) norm([wrapToPi(x(1)-y(1))/2/pi;...
                x(2)-y(2);...
                x(3)-y(3)]);
% distance for point-wise recurrence plot (non-topological)
d_recur = @(x,y) norm([wrapToPi(x(1:length(x)/3)-y(1:length(x)/3))/2/pi,...
                x(length(x)/3+1:length(x)*2/3)-y(length(x)/3+1:length(x)*2/3),...
                x(length(x)*2/3+1:end)-y(length(x)*2/3+1:end)]);

% --- compute topological recurrence and pointwise            
[distmatpd0,distmatpd1,distmatrecur,pd0,pd1, tlim] = topoRecur(X(:,:,t_win(:,1)>t0),...
    'SR',1,'tlim',tlimits,'distfun',d_pt,'recurdist',d_recur,...
    'r_max',rmax,'initialstep',rmin,'stepsize',stepsize,'topodist',Lpnorm);

% --- plotting the recurrence plots
figure('position',[1 1 1600 400])
subplot(1,3,1); imagesc(tlimits,tlimits,distmatpd0);colorbar;axis square;
xlabel('time (s)');ylabel('time (s)');title('H_0')
subplot(1,3,2); imagesc(tlimits,tlimits,distmatpd1);colorbar;axis square;
xlabel('time (s)');ylabel('time (s)');title('H_1')
subplot(1,3,3); imagesc(tlimits,tlimits,distmatrecur);colorbar;axis square;
xlabel('time (s)');ylabel('time (s)');title('pointwise')
