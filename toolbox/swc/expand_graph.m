function [expgraph] = expand_graph(graph, Nsubnodes)

Nnodes = size(graph.node,2);
Nedges = size(graph.edge,2);
for inodes = 1:Nnodes
    if strcmp(graph.node(inodes).type,'root node'),
        root = inodes;
    end
end

% generating expanded graph structure
iexpedges = 1;
iexpnodes = 1;
expgraph.edge = [];
expgraph.node = [];
expgraph.conn = [];
expgraph.coor = [];
Nexpnodes = Nnodes + Nedges*(Nsubnodes-2);

%root node
expgraph.node(iexpnodes).id = iexpnodes;
expgraph.node(iexpnodes).synthid = graph.node(root).id;
expgraph.node(iexpnodes).type = graph.node(root).type;
expgraph.node(iexpnodes).x = graph.node(root).x;
expgraph.node(iexpnodes).y = graph.node(root).y;
expgraph.node(iexpnodes).z = graph.node(root).z;
expgraph.node(iexpnodes).tup = ...
    [expgraph.node(iexpnodes).x ...
     expgraph.node(iexpnodes).y ...
     expgraph.node(iexpnodes).z];
expgraph.coor = [expgraph.coor; expgraph.node(iexpnodes).tup];
iexpnodes = iexpnodes + 1;
% explore graph
for iedges = 1:Nedges
    % find nodes 'from' and 'to'
    from = find([graph.node(:).id] == graph.edge(iedges).from);
    to = find([graph.node(:).id] == graph.edge(iedges).to);

    % create new nodes
    for isubnodes = 2:Nsubnodes
        if isubnodes == Nsubnodes
            expgraph.node(iexpnodes).id = iexpnodes;
            expgraph.node(iexpnodes).synthid = graph.node(to).id;
            expgraph.node(iexpnodes).type = graph.node(to).type;
            expgraph.node(iexpnodes).x = graph.node(to).x;
            expgraph.node(iexpnodes).y = graph.node(to).y;
            expgraph.node(iexpnodes).z = graph.node(to).z;
            expgraph.node(iexpnodes).tup = ...
                [expgraph.node(iexpnodes).x ...
                 expgraph.node(iexpnodes).y ...
                 expgraph.node(iexpnodes).z];
            expgraph.coor = [expgraph.coor; expgraph.node(iexpnodes).tup];
        else
            expgraph.node(iexpnodes).id = iexpnodes;
            expgraph.node(iexpnodes).synthid = 0;
            expgraph.node(iexpnodes).type = 'subnode';
            expgraph.node(iexpnodes).x = graph.edge(iedges).path(isubnodes,1);
            expgraph.node(iexpnodes).y = graph.edge(iedges).path(isubnodes,2);
            expgraph.node(iexpnodes).z = graph.edge(iedges).path(isubnodes,3);
            expgraph.node(iexpnodes).tup = ...
                [expgraph.node(iexpnodes).x ...
                 expgraph.node(iexpnodes).y ...
                 expgraph.node(iexpnodes).z];
            expgraph.coor = [expgraph.coor; expgraph.node(iexpnodes).tup];
        end
        iexpnodes = iexpnodes + 1;
    end
    
    % create new edges
    for isubnodes = 1:Nsubnodes-1
        if isubnodes == 1,
            from = find([expgraph.node(:).synthid] == graph.edge(iedges).from);
            to = find([expgraph.node(:).synthid] == graph.edge(iedges).to) - (Nsubnodes-2);
            expgraph.edge(iexpedges).id = iexpedges;
            expgraph.edge(iexpedges).to = expgraph.node(to).id;
            expgraph.edge(iexpedges).from = expgraph.node(from).id;
            expgraph.edge(iexpedges).flow = graph.edge(iedges).flow;
            expgraph.edge(iexpedges).radius = graph.edge(iedges).radius;            
        elseif isubnodes == Nsubnodes-1,
            from = to;
            to = find([expgraph.node(:).synthid] == graph.edge(iedges).to);
            expgraph.edge(iexpedges).id = iexpedges;
            expgraph.edge(iexpedges).to = expgraph.node(to).id;
            expgraph.edge(iexpedges).from = expgraph.node(from).id;
            expgraph.edge(iexpedges).flow = graph.edge(iedges).flow;
            expgraph.edge(iexpedges).radius = graph.edge(iedges).radius;
        else
            from = to;
            to = to + 1;
            expgraph.edge(iexpedges).id = iexpedges;
            expgraph.edge(iexpedges).to = expgraph.node(to).id;
            expgraph.edge(iexpedges).from = expgraph.node(from).id;
            expgraph.edge(iexpedges).flow = graph.edge(iedges).flow;
            expgraph.edge(iexpedges).radius = graph.edge(iedges).radius;
        end
        expgraph.conn(to,from) = expgraph.edge(iexpedges).radius;
        expgraph.conn(from,to) = expgraph.edge(iexpedges).radius;
        iexpedges = iexpedges + 1;
    end     
end


