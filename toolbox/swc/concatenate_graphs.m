function [outgraph] = concatenate_graphs(graph1,graph2)

% outgraph = graph1;
Nnodes1 = size(graph1.node,2);
Nedges1 = Nnodes1 - 1;
Nnodes2 = size(graph2.node,2);
Nedges2 = Nnodes2 - 1;

outgraph.coor = [graph1.coor; graph2.coor];
outgraph.conn = sparse(Nnodes1+Nnodes2,Nnodes1+Nnodes2);
outgraph.conn(1:Nnodes1,1:Nnodes1) = graph1.conn;
outgraph.conn(Nnodes1+1:Nnodes1+Nnodes2,Nnodes1+1:Nnodes1+Nnodes2) = graph2.conn;
outgraph.distconn = sparse(Nnodes1+Nnodes2,Nnodes1+Nnodes2);
outgraph.distconn(1:Nnodes1,1:Nnodes1) = graph1.distconn;
outgraph.distconn(Nnodes1+1:Nnodes1+Nnodes2,Nnodes1+1:Nnodes1+Nnodes2) = graph2.distconn;
outgraph.node = graph1.node;
for inode =Nnodes1+1:Nnodes1+Nnodes2
    graph2.node(inode-Nnodes1).id = graph2.node(inode-Nnodes1).id + Nnodes1;
    outgraph.node(inode) = graph2.node(inode-Nnodes1);
end
outgraph.edge = graph1.edge;
for iedge =Nedges1+1:Nedges1+Nedges2
    graph2.edge(iedge-Nedges1).id = graph2.edge(iedge-Nedges1).id + Nedges1;
    graph2.edge(iedge-Nedges1).from = graph2.edge(iedge-Nedges1).from + Nnodes1;
    graph2.edge(iedge-Nedges1).to = graph2.edge(iedge-Nedges1).to + Nnodes1;
    outgraph.edge(iedge) = graph2.edge(iedge-Nedges1);
end

