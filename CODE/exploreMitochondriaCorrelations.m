clear all
close all

%%
if strcmp(filesep,'/')
    % Running in Mac
    cd ('/Users/ccr22/Academic/GitHub/MitoEM/CODE')
    load('Hela_ROI_02_30_6005_4739_81_Cell.mat')
    load('Hela_ROI_02_30_6005_4739_81_Nuclei.mat')
    Hela(:,:,1) = imread('/Users/ccr22/Academic/GitHub/MitoEM/CODE/OriginalImages/ROI_6005_4739_81_z0001.tif');
else
    % running on Windows Alienware
    % baseDir8000             = 'C:\Users\sbbk034\Documents\Acad\Crick\Hela8000_tiff\';
    baseDirROIs             = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\HeLa_Cell_Data';
    % dirData                 = strcat(baseDirROIs,filesep,'Tiffs',filesep);
    dirROIs                 = strcat(baseDirROIs,filesep,'Matlab',filesep);
    % 30 ROIs for data, but not all were processed, so only 25 ROIs with
    % classes x2 as one has nuclei and other has cell
    %dir0                    = dir(strcat(dirData,'He*'));
    dir1                    = dir(strcat(dirROIs,'He*'));
    dirN                    = dir(strcat(dirROIs,'He*Nuc*'));
    dirM                    = dir(strcat(dirROIs,'He*Mito*'));
    dirC                    = dir(strcat(dirROIs,'He*Cell*'));
    dirI                    = dir(strcat(dirROIs,'He*invag*'));

    % numFoldersData          = size(dir0,1);
    % numFoldersROIS          = size(dir1,1);
end

load (strcat(dirROIs,dirN(1).name))
%% Select a cell, load invaginations, cell, nuclei, mitochondria and extract metrics
for cellSelected=1:25
    disp(cellSelected)
    %cellSelected            = 1;
    % Load data and ROIs
    load (strcat(dirROIs,dirM(cellSelected).name))
    load (strcat(dirROIs,dirC(cellSelected).name))
    load (strcat(dirROIs,dirN(cellSelected).name))
    load (strcat(dirROIs,dirI(cellSelected).name))

    % remove mitochondria outside the cell
    mitochondria = mitochondria.*uint16(Hela_cell);

    %    Invaginations
    summary{cellSelected,1} = cellSelected;
    summary{cellSelected,2} = dirN(cellSelected).name(1:end-11);
    summary{cellSelected,3} = size(invaginations_P,1);
    summary{cellSelected,4} = sum(table2array(invaginations_P(:,1)));
    summary{cellSelected,5} = mean(table2array(invaginations_P(:,5)));
    summary{cellSelected,6} = mean(table2array(invaginations_P(:,6)));
    summary{cellSelected,7} = mean(table2array(invaginations_P(:,8)));

    % Nuclei Volume
    summary{cellSelected,8} = sum(Hela_nuclei(:));
    % Cell Volume
    summary{cellSelected,9} = sum(Hela_cell(:));
    % Volume between Nucleus and Cell
    summary{cellSelected,10} = summary{cellSelected,8}-summary{cellSelected,7};
    % Mitochondria
    uniqueMito              = unique(mitochondria);
    mitochondria_P          = regionprops3(mitochondria,'Volume','PrincipalAxisLength');
    mitochondria_P2         = mitochondria_P(uniqueMito(2:end),:);
    % number mitochondria
    summary{cellSelected,11} = numel(uniqueMito0)-1;
    % total volume
    summary{cellSelected,12} = sum([mitochondria_P2.Volume]);
    % average volume
    summary{cellSelected,13} = mean([mitochondria_P2.Volume]);
    % aspect ratio
    summary{cellSelected,14} = mean( ([mitochondria_P2.PrincipalAxisLength(:,3)])./([mitochondria_P2.PrincipalAxisLength(:,1)]));

end


%%


