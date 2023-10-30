clear all
close all

cd ('/Users/ccr22/Academic/GitHub/MitoEM/CODE')
dir0        = dir(strcat('OriginalImages',filesep,'*.tif'));
dirGT       = dir(strcat('GT_*.mat'));
figuresToSegment    = [1 30 60 116 150];
posFigures          = [1  6 11  17 22];
%% Draw figure




%% Display image to be delineated and neighbours
k1          = 5;
h1          = figure(1);
clf
h12          = gca;
dataIn      = imread(strcat('OriginalImages',filesep,dir0(posFigures(k1)).name));
dataOut     = dataIn;
imagesc(dataOut);
colormap gray

% Contiguous images

h2          = figure(2);
h2.Position = [ 820         48         770        1291];
clf

if k1>1
    dataIn_1      = imread(strcat('OriginalImages',filesep,dir0(posFigures(k1)-2).name));
    dataIn_2      = imread(strcat('OriginalImages',filesep,dir0(posFigures(k1)-1).name));
    h21          = subplot(411);
    imagesc(dataIn_1)
    
    h22          = subplot(412);
    imagesc(dataIn_2)
    
else
    h21          = subplot(411);
    cla
    h22          = subplot(412);
    cla
end

dataIn_3      = imread(strcat('OriginalImages',filesep,dir0(posFigures(k1)+1).name));
dataIn_4      = imread(strcat('OriginalImages',filesep,dir0(posFigures(k1)+2).name));
h23          = subplot(413);
imagesc(dataIn_3)
h24          = subplot(414);
imagesc(dataIn_4)
colormap gray


h1.Position = [ 1585 48 1844 1291];
h12.Position = [ 0.05 0.05 0.9 0.9];

%% existing GTs

load(dirGT(k1).name)

if ~exist('groundTruthM','var')
    groundTruthM    = zeros (size(dataIn));
    k               = 0;
else
    k               = size(groundTruthM,3);
    figure(1)
    imagesc(dataIn.*uint8(((1-imdilate(max(groundTruthM,[],3),ones(5))))))


end

%% draw lines, keep in a stack
k=k+1;
figure(1)
lineDrawn                   = drawassisted;
lineAsMask                  = createMask(lineDrawn);
groundTruthM(:,:,k)          = k*lineAsMask;
imagesc(dataIn.*uint8(((1-imdilate(max(groundTruthM,[],3),ones(5))))))

%% Use this to measure distance between GT and output
filename = strcat('GT2_',dir0(k1).name(1:end-3),'mat');
save (filename,'groundTruthM')
%%
dir1        = dir('GT2_*.mat');
MitoChondria = zeros(2000,2000,5);
for k2 = 1:5
    load(dir1(k2).name)
    MitoChondria(:,:,k2) = sum(groundTruthM,3)>0;
end

%%

imwrite(MitoChondria(:,:,1),'Mitochondria_001F.png');
imwrite(MitoChondria(:,:,2),'Mitochondria_030F.png');
imwrite(MitoChondria(:,:,3),'Mitochondria_060F.png');
imwrite(MitoChondria(:,:,4),'Mitochondria_116F.png');
imwrite(MitoChondria(:,:,5),'Mitochondria_150F.png');