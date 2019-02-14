function [F1, precision, recall] = F1evaluation(Xtree, Ytree, Cmap)
%   X, Y       two trees (point lists) with size of N*7 and M*7: Y were
%              mapped to X
%   Cmap       map list, Y = X(Cmap, :)    
%     [N, D] = size(Xtree);   [M, D] = size(Ytree);

    Overlap = ismember( Ytree(:,1), Xtree(:,1) ); 
    Idx = find( Overlap );  Num_over = length(Idx);
    YID_map = Xtree(Cmap, 1);   YID = Ytree(:,1);
    TP = sum(YID_map(Idx) == YID(Idx));
    Num_maped = length( unique( YID_map(Idx) ));
    FN = Num_over-Num_maped;  FP = Num_over - TP;
    precision = TP/(TP + FP);
    recall = TP/(TP+FN);
    F1 = (2*TP)/(2*TP+FP+FN);
    

end
