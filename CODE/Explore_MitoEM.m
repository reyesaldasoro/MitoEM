
clear all
%%
baseDir = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\MitoEM\';
dataDir = strcat(baseDir,filesep,'Data');
%%
dir0 = dir(strcat(dataDir,filesep,'EM*'));
dir01 = dir(strcat(dataDir,filesep,dir0(1).name,filesep,'m*'));
dir02 = dir(strcat(dataDir,filesep,dir0(2).name,filesep,'m*'));

dir011 = dir(strcat(dataDir,filesep,dir0(1).name,filesep,dir01(1).name,filesep,'*.tif'));
dir012 = dir(strcat(dataDir,filesep,dir0(1).name,filesep,dir01(2).name,filesep,'*.tif'));
dir021 = dir(strcat(dataDir,filesep,dir0(2).name,filesep,dir01(1).name,filesep,'*.tif'));
dir022 = dir(strcat(dataDir,filesep,dir0(2).name,filesep,dir01(2).name,filesep,'*.tif'));

dirH_train =  dir(strcat(dataDir,filesep,'EM30-H*',filesep,'*train*',filesep,'*.tif'));
dirH_val   =  dir(strcat(dataDir,filesep,'EM30-H*',filesep,'*val*',filesep,'*.tif'));
dirR_train =  dir(strcat(dataDir,filesep,'EM30-R*',filesep,'*train*',filesep,'*.tif'));
dirR_val   =  dir(strcat(dataDir,filesep,'EM30-R*',filesep,'*val*',filesep,'*.tif'));

%%
clear EMImages;
EMImages(4096,4096,numel(dirH_val)) = 0;

for k=1:numel(dirH_val)
    EMImages(:,:,k) = imread(strcat(dataDir,filesep,dir0(1).name,filesep,dir01(1).name,filesep,dir011(k).name));
    disp(k)
end
