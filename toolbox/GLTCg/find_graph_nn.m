function neighbors = find_graph_nn(trees, K)
%find a geodesic path formed by K connected neighbors with a deep-first strategy
% input:
%		trees, Trees T is an N*7 matrix, with a node in each T(i, :) = [nodeID, tmp, px, py, pz, radius, PreID];
%		K, the length of geodesic path (with K connected neighbors)
% Output:
%		neighbors, an N*K matrix, in neighbors(i,:) recorded the index of K neighbors 
Num_node = length(trees);
neighbors = zeros(Num_node, K);

for inode = 1:Num_node
    K_find = 0;
    ID = trees(inode, 1);   PreID = trees(inode, end);
    while K_find < K &&~(PreID == -1 && ID == 0)
        if PreID ~= -1
            [pind, PreID, K_find] = findPreID(trees, PreID, K_find);
            neighbors(inode, K_find) = pind;
        end
        [ind, ID ] =  findPostID(trees, ID);
        if ID ~= 0
            L = min(length(ind), K - K_find);
            neighbors(inode, K_find+1 : K_find+L) = ind(1:L);
        end
    end

end
end
function [ind, preID, K_find] =  findPreID(trees, preID, K_find)
    IDs = find(trees(:,1) == preID);
    ind = IDs(1);
    K_find = K_find +1;
    preID = trees(ind, end);
end
function [ind, ID] =  findPostID(trees, ID)
    IDs = find(trees(:,end) == ID);
    if ~isempty(IDs) 
%         ind = IDs;        % cover certain branches
        ind = datasample(IDs,1);% deep first
%         K_find = K_find +1;
        Idtmp = datasample(ind, 1);
        ID = trees(Idtmp, 1);
    else
        ID = 0;
%         K_find = K_find;
        ind = 0;
    end
end
        