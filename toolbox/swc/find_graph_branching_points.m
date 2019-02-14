function [bp,sp] = find_graph_branching_points(graph)

bp.node = [];
sp.node = [];
bp.coor = [];
sp.coor = [];

Nnodes = size(graph.node,2);
for inode = 1:Nnodes
    switch(graph.node(inode).type)
        case 'root node'
            sp.node = [sp.node; inode];
            sp.coor = [sp.coor; graph.coor(inode,:)];
        case 'terminal node'
            sp.node = [sp.node; inode];
            sp.coor = [sp.coor; graph.coor(inode,:)];
        case 'bifurcation'
            sp.node = [sp.node; inode];
            sp.coor = [sp.coor; graph.coor(inode,:)];
            bp.node = [bp.node; inode];
            bp.coor = [bp.coor; graph.coor(inode,:)];
        case 'subnode'
    end
end

Nbp = size(bp.node,1);
Nsp = size(sp.node,1);

% Find geodistances
bp.gdm = Inf(Nbp,Nbp);
bp.gdm = sparse(zeros(Nbp,Nbp));
for i=1:Nbp
    geodists = Inf(1,Nbp);
    for j=i+1:Nbp
        [bp.gdm(i,j),dumb]=graphshortestpath(sparse(graph.dist),bp.node(i),bp.node(j),'Directed',false);
    end
%     [m,idx] = min(geodists(:));
%     bp.gdm(i,idx) = m;
%     bp.gdm(idx,i) = m;
end
bp.gdm = bp.gdm + bp.gdm';

% Find geodistances
sp.gdm = Inf(Nsp,Nsp);
sp.gdm = sparse(zeros(Nsp,Nsp));
for i=1:Nsp
    geodists = Inf(1,Nsp);
    for j=i+1:Nsp
        [sp.gdm(i,j),dumb]=graphshortestpath(sparse(graph.dist),sp.node(i),sp.node(j),'Directed',false);
    end
%     [m,idx] = min(geodists(:));
%     sp.gdm(i,idx) = m;
%     sp.gdm(idx,i) = m;
end
sp.gdm = sp.gdm + sp.gdm';
    
% % Structurate using a MST
% [mst] = graphminspantree(sparse(graph.dist));
% % Find geodistances full matrix
% [gdm] = graphallshortestpaths(mst+mst');
