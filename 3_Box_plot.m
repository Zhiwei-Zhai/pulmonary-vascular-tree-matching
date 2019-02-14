clear all; close all;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0.- Load libraries and set paths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
method = {'nonrigid','GLTC', 'gltcg'};
ResultChar = {'CPD','GLTP','Our method'};
G = cell(30, 1);
G(1:10,1) = ResultChar(1);  G(11:20,1) = ResultChar(2);  
G(21:30,1) = ResultChar(3);  
G_char = char( G);
ResultData = zeros(30,5);

for i=1:3
    dir = sprintf('./results/NodeOnly%s/', string(method(i)) );
    res_file = sprintf('%sVessel_result.txt', dir);
    res = load(res_file);
    starI = (i-1)*10+1; endI = (i-1)*10+10;
    ResultData(starI: endI, :) = res;    
end

Fontsize = 7;
%% box plot of average distance
handle = figure; hold on
boxplot(ResultData(:,4), G_char); ylim([-0.5, 10.5])
ylabel('Euclidean Distance (mm)'); title('Average of residual distance');
file1 = sprintf('./results/AverageDistance');
set(handle, 'PaperUnits', 'centimeters', 'PaperPosition',[5 5 6 4.8]);
set(gca, 'FontName', 'Arial'); set(handle, 'renderer', 'opengl')
set(gca, 'fontsize', Fontsize);
print(file1,'-depsc','-r600', '-opengl')
print(file1,'-dpng','-r600', '-opengl')
close(handle);
disp(['CPD average distance, mean:', num2str(mean(ResultData(1:10,4))), '  STD:' num2str(std(ResultData(1:10,4)))] );
disp(['GLTP average distance, mean:', num2str(mean(ResultData(11:20,4))), '  STD:' num2str(std(ResultData(11:20,4)))] );
disp(['Our method average distance, mean:', num2str(mean(ResultData(21:30,4))), '  STD:' num2str(std(ResultData(21:30,4)))] );
%% box plot of std distance
handle = figure; hold on
boxplot(ResultData(:,5), G_char);ylim([-0.5, 10.5])
ylabel('Euclidean Distance (mm)'); title('STD of residual distance');
file1 = sprintf('./results/STDDistance');
set(handle, 'PaperUnits', 'centimeters', 'PaperPosition',[5 5 6 4.8]);
set(gca, 'FontName', 'Arial'); set(handle, 'renderer', 'opengl')
set(gca, 'fontsize', Fontsize);
print(file1,'-depsc','-r600', '-opengl')
print(file1,'-dpng','-r600', '-opengl')
% print(file1,'-dpng')
close( handle );