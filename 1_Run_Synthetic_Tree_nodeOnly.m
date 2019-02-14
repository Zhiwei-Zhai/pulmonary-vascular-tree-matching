%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-rigid transformations 3d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0.- Load libraries and set paths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('./toolbox'))

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.0.- Load input
% method = 'nonrigid';
% method = 'GLTC';
method = 'gltcg';
datatype = 'Vessel';   Total_Num = 10; ref_Num = 5;
for i = 1: Total_Num
    inputpath = sprintf('./inputs/%sNode_deformed',datatype);
    inputfileA =  sprintf('%sNode%02d_deformed',datatype, ref_Num);
    inputfileB =  sprintf('%sNode%02d_deformed',datatype, i);
    resultspath = sprintf('./results/NodeOnly%s/%s_%s/',method, inputfileA,inputfileB);
    if ~exist(resultspath, 'dir'),  mkdir(resultspath); end;

    fileA = sprintf('%s/%s.txt',inputpath,inputfileA);
    fileB = sprintf('%s/%s.txt',inputpath,inputfileB);

    swcTreeA = read_swc(fileA); swcTreesA(1).swcTree = swcTreeA;
    swcTreeB = read_swc(fileB); swcTreesB(1).swcTree = swcTreeB;

    % generate graphs from swc
    graphA = swc2graph1( swcTreesA );
    graphB = swc2graph1( swcTreesB );
    %% CPD
    Indx = find(graphA.coor(:,1)~=0);
    Indy = find(graphB.coor(:,1)~=0);
    Xall = [graphA.coor(Indx,1), graphA.coor(Indx,2), graphA.coor(Indx,3)];
    Yall = [graphB.coor(Indy,1), graphB.coor(Indy,2), graphB.coor(Indy,3)];
    
% ------------------- Start of Point set registration -----------------
    figure;
    opt.method=method;
    opt.corresp= 1;
    opt.max_it = 100;
    opt.beta=1;
    opt.lambda = 3;
    opt.outliers=0.05;
    opt.viz=1;

    tic 
    if strcmpi(method, 'gltcg')
        Neighbors = find_graph_nn(swcTreeB, 5);
        [Transform, Cmap]=cpd_register(Xall, Yall, opt, Neighbors);
    else
        [Transform, Cmap]=cpd_register(Xall, Yall,opt);
    end
    statistics.time.cpd = toc;
    
    Xnlcpd = Transform.Y;
    Xnlcpd = [Xnlcpd(:,1) Xnlcpd(:,2) Xnlcpd(:,3)];
    swcTreeB_T = swcTreeB;
    swcTreeB_T(:,3:5) = [Xnlcpd(:,1) Xnlcpd(:,2) Xnlcpd(:,3)];
    [statistics.result.F1, statistics.result.precision, statistics.result.recall] = F1evaluation(swcTreeA, swcTreeB, Cmap);
    [statistics.result.aveDist, statistics.result.stdDist] = aveDistance(swcTreeA, swcTreeB_T);

    result_file = sprintf('%s/results.mat',resultspath);
    save(result_file);
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    posi = [5 5 5.6 7]; Az = 115; el=20;    Fontsize=7;
    h8=figure(8); hold on;  
%     title('Initial: Moving in red and Target in blue');
    subplot(1,2,1);    gplot23D(graphA.conn, [graphA.coor(:,1) graphA.coor(:,2) graphA.coor(:,3)],'r-','LineWidth',2)
    hold off; view([Az, el]); axis equal;    xlabel([]);ylabel([]);zlabel([]);
    subplot(1,2,2);    gplot23D(graphB.conn, [graphB.coor(:,1) graphB.coor(:,2) graphB.coor(:,3)],'b-','LineWidth',2)
    hold off; view([Az, el]); axis equal;    xlabel([]);ylabel([]);zlabel([]);
    set(h8, 'PaperUnits', 'centimeters', 'PaperPosition',posi);
    set(h8, 'renderer', 'opengl')
    set(gca, 'fontsize', Fontsize); set(gca, 'FontName', 'Arial');
    file = sprintf('%s/Initial_graphs',resultspath);

%     saveas(h8,file,'fig') 
    print(file,'-depsc','-r600', '-opengl')
    close( h8 );

    graphD = graphB;
    graphD.coor(Indy, 1) = Xnlcpd(:,1); 
    graphD.coor(Indy, 2) = Xnlcpd(:,2); 
    graphD.coor(Indy, 3) = Xnlcpd(:,3); 
    for inode=1:size(graphD.node,2) 
        graphD.node(inode).x = graphD.coor(inode,1);
        graphD.node(inode).y = graphD.coor(inode,2);
        graphD.node(inode).z = graphD.coor(inode,3);
        graphD.node(inode).tup = graphD.coor(inode,:);
    end
    h9=figure(9); hold on;
    gplot23D(graphA.conn, [graphA.coor(:,1) graphA.coor(:,2) graphA.coor(:,3)],'r-','LineWidth',1)
    gplot23D(graphD.conn, [graphD.coor(:,1) graphD.coor(:,2) graphD.coor(:,3)],'g-','LineWidth',1)
    hold off; view([Az, el]); axis equal;
    xlabel([]);ylabel([]);zlabel([]);   set(h9, 'PaperUnits', 'centimeters', 'PaperPosition',posi);
	set(h9, 'renderer', 'opengl')
    set(gca, 'fontsize', Fontsize); set(gca, 'FontName', 'Arial');
    
    file = sprintf('%s/output-cpd',resultspath);
%     saveas(h9,file,'fig') 
    print(file,'-depsc','-r600', '-opengl')
    close(h9)
    close all;
end



