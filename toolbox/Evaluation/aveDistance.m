function [aveDist, stdDist] = aveDistance(Xtree, Ytree_T)
%   X, Y       two trees (point lists) with size of N*7 and M*7: Ytree_T were
%              the tree transfered to X
%   Cmap       map list, Y = X(Cmap, :)    
[N, D] = size(Xtree);   [M, D] = size(Ytree_T);
NLoop = min(N,M);
SumDist = 0;    SumDist2 = 0;
for i = 1:NLoop
	Idx = Xtree(i, 1);
    Idy = find(Ytree_T(:,1) == Idx);
    if ~isempty(Idy)
        Px = Xtree(i,3:5);
        Py = Ytree_T(Idy(1),3:5);
        Dxy = sqrt(sum((Px-Py).^2));
        SumDist = SumDist + Dxy;
        SumDist2 = SumDist2 + Dxy^2;
    end
end
aveDist = SumDist / NLoop;
stdDist = sqrt(SumDist2/NLoop - SumDist^2/NLoop^2);
end
