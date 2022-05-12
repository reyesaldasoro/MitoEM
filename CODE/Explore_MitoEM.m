
baseDir = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\MitoEM\';

%%
dir0 = dir(strcat(baseDir,filesep,'Data',filesep,'EM*'));
dirH_train =  dir(strcat(baseDir,filesep,'Data',filesep,'EM30-H*',filesep,'*train*',filesep,'*.tif'));
dirH_val   =  dir(strcat(baseDir,filesep,'Data',filesep,'EM30-H*',filesep,'*val*',filesep,'*.tif'));
dirR_train =  dir(strcat(baseDir,filesep,'Data',filesep,'EM30-R*',filesep,'*train*',filesep,'*.tif'));
dirR_val   =  dir(strcat(baseDir,filesep,'Data',filesep,'EM30-R*',filesep,'*val*',filesep,'*.tif'));
