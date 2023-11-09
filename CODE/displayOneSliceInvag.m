load('/Users/ccr22/Desktop/Hela_Invaginations_Mitochondria/Hela_ROI_02_30_6005_4739_81_Cell.mat')
load('/Users/ccr22/Desktop/Hela_Invaginations_Mitochondria/Hela_ROI_02_30_6005_4739_81_Invaginations.mat')
load('/Users/ccr22/Desktop/Hela_Invaginations_Mitochondria/Hela_ROI_02_30_6005_4739_81_Nuclei.mat')
uiopen('/Users/ccr22/Academic/GitHub/MitoEM/CODE/OriginalImages/ROI_6005_4739_81_z0001.tif',1)

%%

res(:,:,1) = ROI_6005_4739_81_z0001 + 90* uint8(invaginations(:,:,1)) ;
res(:,:,3) = ROI_6005_4739_81_z0001 + 80* uint8(Hela_nuclei(:,:,1));
res(:,:,2) = ROI_6005_4739_81_z0001 + 0* uint8(invaginations(:,:,1));
imagesc(res)
