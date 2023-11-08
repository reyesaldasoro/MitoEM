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
%% generate xx,yy,zz only first time
[rows,cols,levs]        = size(Hela_nuclei);

    % This is for the slices to create the surfaces
    numSlices               = levs;
    [x2d,y2d]               = meshgrid(1:rows,1:cols);
    z2d                     = ones(rows,cols);
    xx_3D                   = zeros(rows,cols,levs);
    yy_3D                   = zeros(rows,cols,levs);
    zz_3D                   = zeros(rows,cols,levs);
    for k=1:numSlices
        disp(k)
        zz_3D(:,:,k)        = z2d*k;
        xx_3D(:,:,k)        = x2d;
        yy_3D(:,:,k)        = y2d;
    end
%% Select a cell
cellSelected            = 1;
% Load data and ROIs
load (strcat(dirROIs,dirM(cellSelected).name))
load (strcat(dirROIs,dirC(cellSelected).name))
load (strcat(dirROIs,dirN(cellSelected).name))
load (strcat(dirROIs,dirI(cellSelected).name))
%%    Display
% 
[xx_3D,yy_3D,zz_3D,hN,hI,hM,hC] = displayMitochondria(Hela_nuclei,invaginations,mitochondria,Hela_cell,16,1,xx_3D,yy_3D,zz_3D);

