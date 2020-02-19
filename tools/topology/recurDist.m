function D = recurDist(X, distfun)
% RECURDIST calculate distant matrix for recurrent plot
% D = recurDist(X, distfun)
% 	input: 
% 		X: data points, each row is a observation
% 		distfun: self-defined pairwise distance.
% 	output:
% 		D: matrix of pairwise distance
%{
~~ created by Mengsen Zhang <mengsenzhang@gmail.com> 06-26-2018 ~~
modifications:
%}

% - default use L-2 norm
if nargin<2 || isempty(distfun)
	distfun=@(x,y) norm(x-y);
end


len = size(X,1);
pairs = nchoosek(1:len,2);
Npairs=size(pairs,1);
D=zeros(Npairs,1);

% -- calculate pairwise distance
for n=1:Npairs
	D(n)=distfun(X(pairs(n,1),:),X(pairs(n,2),:));
end
D=squareform(D);
end