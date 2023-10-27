clear all
close all

%% running on Windows Alienware
%baseDir8000             = 'C:\Users\sbbk034\Documents\Acad\Crick\Hela8000_tiff\';
baseDirROIs             = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\HeLa_Cell_Data';
%dirData                 = strcat(baseDirROIs,filesep,'Tiffs',filesep);
dirROIs                 = strcat(baseDirROIs,filesep,'Matlab',filesep);
% 30 ROIs for data, but not all were processed, so only 25 ROIs with
% classes x2 as one has nuclei and other has cell
%dir0                    = dir(strcat(dirData,'He*'));
dir1                    = dir(strcat(dirROIs,'He*Nuc*'));

%numFoldersData          = size(dir0,1);
numFoldersROIS          = size(dir1,1);

%% Select a cell
for cellSelected            = 9:numFoldersROIS
    disp(cellSelected)
    clear invag*
    load (strcat(dirROIs,dir1(cellSelected).name))
    [invaginations,invaginations_P ] =  closeInvaginations(Hela_nuclei);

    saveName    = strcat(dirROIs,dir1(cellSelected).name(1:end-10),'Invaginations');
    % for saving only use the logical to save space and memory
    invaginations=invaginations>0;
    save(saveName,"invaginations","invaginations_P",'-v7.3')
end
