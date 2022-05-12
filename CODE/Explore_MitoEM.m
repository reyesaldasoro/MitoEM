
clear all
%%
baseDir = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\MitoEM\';
dataDir = strcat(baseDir,filesep,'Data');
%%
dir0 = dir(strcat(dataDir,filesep,'EM*'));
dir01 = dir(strcat(dataDir,filesep,dir0(1).name,filesep,'m*'));
dir02 = dir(strcat(dataDir,filesep,dir0(2).name,filesep,'m*'));
dirH_train =  dir(strcat(dataDir,filesep,'EM30-H*',filesep,'*train*',filesep,'*.tif'));
dirH_val   =  dir(strcat(dataDir,filesep,'EM30-H*',filesep,'*val*',filesep,'*.tif'));
dirR_train =  dir(strcat(dataDir,filesep,'EM30-R*',filesep,'*train*',filesep,'*.tif'));
dirR_val   =  dir(strcat(dataDir,filesep,'EM30-R*',filesep,'*val*',filesep,'*.tif'));

%%
k = 1;
currSlide = imread(strcat(dataDir,filesep,'EM30-R*',filesep,dirR_val(k).name));
imagesc(currSlide)