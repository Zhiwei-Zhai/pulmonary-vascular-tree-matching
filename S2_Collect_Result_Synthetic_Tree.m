%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-rigid transformations 3d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% method = 'nonrigid';
% method = 'GLTC';
method = 'gltcg';
datatype = 'Vessel';   Total_Num = 10; ref_Num = 5;
resultfile = sprintf('./results/NodeOnly%s/%s_result.txt',method, datatype);
fid = fopen(resultfile, 'w'); fclose(fid);

for i = 1: Total_Num
    inputfileA =  sprintf('%sNode%02d_deformed',datatype, ref_Num);
    inputfileB =  sprintf('%sNode%02d_deformed',datatype, i);
    resultspath = sprintf('./results/NodeOnly%s/%s_%s/',method, inputfileA,inputfileB);

    resultData = sprintf('%sresults.mat',resultspath);
    load(resultData);
    resultM = [statistics.result.F1, statistics.result.precision, statistics.result.recall, statistics.result.aveDist, statistics.result.stdDist];
    dlmwrite(resultfile,resultM,'-append')    
end



