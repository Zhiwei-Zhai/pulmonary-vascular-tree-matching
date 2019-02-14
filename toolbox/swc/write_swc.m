function write_swc(swcTree, file)

txt=[];
for i=1:length(swcTree)
    txt = [txt sprintf('%d %d %f %f %f %f %d\n', ...
        swcTree(i,1), swcTree(i,2), swcTree(i,3), swcTree(i,4), swcTree(i,5), swcTree(i,6), swcTree(i,7) )];
end
fid = fopen(file,'w');
fprintf(fid, '%s', txt);
fclose(fid);