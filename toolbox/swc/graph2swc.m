function [swcTree] = graph2swc(graph, region, scale_factor)

% graph.gdm(graph.gdm==Inf)=0;
% [s,C] = graphconncomp(sparse(graph.gdm));
% gtree = [];
% gtree.conn = graph.conn(C==region,C==region);
% gtree.coor = graph.coor(C==region,:);
% gtree.node = graph.node(C==region);
% edges = find(C==region)-region; edges(1) = [];
% gtree.edge = graph.edge(edges);
%% %%%%%%%%% changed by zhai  %%%%%%%%%%%%%%%%%%%%%
% graph.gdm(graph.gdm==Inf)=0; 
% [s,C] = graphconncomp(sparse(graph.gdm));
gtree = [];
gtree.conn = graph.conn;
gtree.coor = graph.coor;
gtree.node = graph.node;
gtree.edge = graph.edge;
%% %%%%%%%%% changed by zhai  %%%%%%%%%%%%%%%%%%%%%

Nnodes = size(gtree.node,2);
Nedges = size(gtree.edge,2);
for inodes = 1:Nnodes
    if strcmp(gtree.node(inodes).type,'root node'),
        root = inodes;
    end
end

swcTree = [1 region gtree.node(root).x.*scale_factor.x ...
                    gtree.node(root).y.*scale_factor.y ...
                    gtree.node(root).z.*scale_factor.z 0 -1];
for iedges=1:Nedges
%     disp([gtree.edge(iedges).from,gtree.edge(iedges).to]);
    from = find([gtree.node(:).id] == gtree.edge(iedges).from);
    to = find([gtree.node(:).id] == gtree.edge(iedges).to);
    swcTree = [ swcTree;
                to ...
                region ...
                gtree.node(to).x .* scale_factor.x...
                gtree.node(to).y .* scale_factor.y ...
                gtree.node(to).z .* scale_factor.z ...
                gtree.edge(iedges).radius .* scale_factor.r ...
                from];            
    if from == 1, swcTree(1,6) = gtree.edge(iedges).radius .* scale_factor.r; end;
end
