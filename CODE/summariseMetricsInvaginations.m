
clear all
close all

%% summarise metrics Invaginations

baseDir             = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\HeLa_Cell_Data\Matlab';
dir0                = dir(strcat(baseDir,filesep,'*Invag*')); 
%load('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\HeLa_Cell_Data\Matlab\Hela_ROI_01_30_876_1665_81_Invaginations.mat')

clear summary;
for k = 1:size(dir0,1)

    currFile        = strcat(baseDir,filesep,dir0(k).name);
    disp(currFile)
    load(currFile)
    summary{k,1} = k;
    summary{k,2} = dir0(k).name;
    summary{k,3} = size(invaginations_P,1);
    summary{k,4} = sum(table2array(invaginations_P(:,1)));
    summary{k,5} = mean(table2array(invaginations_P(:,5)));
    summary{k,6} = mean(table2array(invaginations_P(:,6)));
end

%%
for k=2:5
    for k2=7:12
        subplot(4,6,(k-2)*6+(k2-6) )
        currX       = a(:,k);
        currY       = a(:,k2);
        meanX       = mean(currX);
        meanY       = mean(currY);
        
        [rho,pval] = corr(currX,currY,'Type','Pearson');


        plot(currX,currY,'bo') %,[0.7 1.3]*meanX,[rho*0.7*meanX+meanY,'r-')

%        title(strcat(num2str(k),'-',num2str(k2),'-',num2str(rho)))
        title(num2str(rho))
        grid on

        rr(k,k2) = rho;
        pp(k,k2) = pval;
    end
end