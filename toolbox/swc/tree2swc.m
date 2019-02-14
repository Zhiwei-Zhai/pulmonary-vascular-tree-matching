function [STree] = tree2swc(Tree,X)

parent = -1;
parid = -1;
node = 1;
k=1;
family = [node parent parid];
while(~isempty(family))    
    parent = family(1,2);
    node = family(1,1);
    parid = family(1,3);
    family(1,:) = [];
    STree(k,:) = [k 1 X(node,:) 1 parid];
    if parid~=-1
        Tree(node,parent) = 0;
        Tree(parent,node) = 0;
    end
    
    children = [find(Tree(:,node))]';
    children = [children find(Tree(node,:))]';
    if(~isempty(children))
        family = [family; [children repmat(node,length(children),1) repmat(k,length(children),1)]];
    end
    k = k+1;
end

