function [graph] = swc2graph1(swcTrees)
% make swctrees to graph
% Input: 
%   swcTrees is the array of swcTrees, swcTrees(i).swcTree
% Output:
%   graph is a struct with graph structure; 
%       graph.coor; graph.conn; graph.dist; graph.gdm is the geodesic distance; graph.node
Ntrees = size(swcTrees,2);

Ngraphnodes = 0;
for itrees=1:Ntrees
    swcTree = swcTrees(itrees).swcTree;
    Ngraphnodes = Ngraphnodes + max(swcTree(:,1));
end

inodes = 1;
iedges = 1;
graph.coor = zeros(Ngraphnodes, 3);
graph.radi = zeros(Ngraphnodes, 1);
graph.conn = sparse(zeros(Ngraphnodes,Ngraphnodes));
% graph.dist = sparse(zeros(Ngraphnodes,Ngraphnodes));
% graph.gdm = Inf(Ngraphnodes,Ngraphnodes);

% graphnodes = 0;

for itrees = 1:Ntrees
    swcTree = swcTrees(itrees).swcTree;

    for iswc = 1:length(swcTree) 
        if swcTree(iswc, 7) == -1
            inodes = swcTree(iswc, 1);
            graph.node(inodes).id = inodes;
            graph.node(inodes).type = 'root node'; 
            root = inodes;
            graph.node(inodes).x = swcTree(iswc,3);
            graph.node(inodes).y = swcTree(iswc,4);
            graph.node(inodes).z = swcTree(iswc,5);
            graph.node(inodes).rad = swcTree(iswc,6);
            graph.coor(inodes, :) = swcTree(iswc,3:5);
            graph.radi(inodes) = graph.node(inodes).rad;
%             graph.node(inodes).tup = swcTree(iswc,3:5);
%             graph.coor(inodes, :) = graph.node(inodes).tup;
            
        else 
            inodes = swcTree(iswc, 1);  % here may involve errors.
            graph.node(inodes).id = inodes;
            nodetype = sum(swcTree(1:length(swcTree),7) == swcTree(iswc,1));
            switch(nodetype)
                case 0
                    graph.node(inodes).type = 'terminal node';
                case 1
                    graph.node(inodes).type = 'subnode';
                otherwise
                    graph.node(inodes).type = 'bifurcation';
            end
            graph.node(inodes).x = swcTree(iswc,3);
            graph.node(inodes).y = swcTree(iswc,4);
            graph.node(inodes).z = swcTree(iswc,5);
            graph.node(inodes).rad = swcTree(iswc,6);
            graph.coor(inodes, :) = swcTree(iswc,3:5);
            graph.radi(inodes) = graph.node(inodes).rad;
%             graph.node(inodes).tup = swcTree(iswc,3:5);
%             graph.coor(inodes, :) = graph.node(inodes).tup;
                
            if swcTree(iswc,6) == 0 
                swcTree(iswc,6) = 1; 
            end

%             graph.edge(iedges).id = iedges;
%             graph.edge(iedges).from = swcTree(iswc,7) + graphnodes;
%             graph.edge(iedges).to = swcTree(iswc,1) + graphnodes;
%             graph.edge(iedges).flow = swcTree(iswc,6);
%             graph.edge(iedges).radius = swcTree(iswc,6);
            graph.conn(swcTree(iswc,1), swcTree(iswc,7)) = swcTree(iswc,6);
            graph.conn(swcTree(iswc,7), swcTree(iswc,1)) = swcTree(iswc,6);
    %         graph.dist(graph.edge(iedges).to, graph.edge(iedges).from) = sqrt(sum((swcTree(iswc,3:5) - swcTree(swcTree(iswc,7),3:5)).^2));
    %         graph.dist(graph.edge(iedges).from, graph.edge(iedges).to) = graph.dist(graph.edge(iedges).to,graph.edge(iedges).from);

            iedges = iedges + 1;
        end
    end
    
%     graphnodes = graphnodes + length(swcTree);
    
    % Structurate using a MST
%     [mst] = graphminspantree(graph.dist,root);
%     % Find geodistances full matrix
%     [gdm] = graphallshortestpaths(mst+mst');
%     graph.gdm = min(graph.gdm,gdm);
end

