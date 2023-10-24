clear all
close all

%%
if strcmp(filesep,'/')
    % Running in Mac
    
    cd ('/Users/ccr22/Academic/GitHub/MitoEM/CODE')
    load('Hela_ROI_02_30_6005_4739_81_Cell.mat')
    load('Hela_ROI_02_30_6005_4739_81_Nuclei.mat')
    Hela(:,:,1) = imread('/Users/ccr22/Academic/GitHub/MitoEM/CODE/ROI_6005_4739_81_z0001.tif');
    Hela(:,:,2) = imread('/Users/ccr22/Academic/GitHub/MitoEM/CODE/ROI_6005_4739_81_z0030.tif');
    Hela(:,:,3) = imread('/Users/ccr22/Academic/GitHub/MitoEM/CODE/ROI_6005_4739_81_z0060.tif');
    Hela(:,:,4) = imread('/Users/ccr22/Academic/GitHub/MitoEM/CODE/ROI_6005_4739_81_z0116.tif');
    Hela(:,:,5) = imread('/Users/ccr22/Academic/GitHub/MitoEM/CODE/ROI_6005_4739_81_z0150.tif');
    
    slicesToSegment         = [1 30 60 116 150];
    Hela_background         = Hela_background(:,:,[1 30 60 116 150]);
    Hela_cell               = Hela_cell(:,:,[1 30 60 116 150]);
    Hela_nuclei             = Hela_nuclei(:,:,[1 30 60 116 150]);

    slicesToSegment         = [1 2 3 4 5];
    
else
    % running on Windows Alienware
    baseDir8000             = 'C:\Users\sbbk034\Documents\Acad\Crick\Hela8000_tiff\';
    baseDirROIs             = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\HeLa_Cell_Data';
    dirData                 = strcat(baseDirROIs,filesep,'Tiffs',filesep);
    dirROIs                 = strcat(baseDirROIs,filesep,'Matlab',filesep);
    % 30 ROIs for data, but not all were processed, so only 25 ROIs with
    % classes x2 as one has nuclei and other has cell
    dir0                    = dir(strcat(dirData,'He*'));
    dir1                    = dir(strcat(dirROIs,'He*'));
    
    numFoldersData          = size(dir0,1);
    numFoldersROIS          = size(dir1,1);

    %% Select a cell
    cellSelected            = 2;
    if cellSelected<10
        cellSelectedStr     = strcat('0',num2str(cellSelected));
    else
        cellSelectedStr     = num2str(cellSelected);
    end
    
    for k=1:numFoldersROIS
        if ~isempty(strfind(dir1(k).name,strcat('_',cellSelectedStr,'_')))
            ROISelected     = k;
            return;
        end
    end
    %% Load data and ROIs
    load (strcat(dirROIs,dir1(ROISelected).name))
    load (strcat(dirROIs,dir1(ROISelected+1).name))
    
    dir3 = dir(strcat(dirData,dir0(cellSelected).name,filesep,'R*'));
    numFiles            = size(dir3,1);
    Hela(2000,2000,300) = 0;
    for k=1:numFiles
        disp(k)
        Hela(:,:,k) = imread(strcat(dirData,dir0(cellSelected).name,filesep,dir3(k).name));
    end
    slicesToSegment         = [1 30 60 116 150];
end
cellRegion                  = (Hela_cell==1).*(Hela_nuclei==0);
%% Segment Mitochondria

 [MitoChondria,confidenceSegmentation] = segmentMitochondria (Hela,Hela_cell,Hela_nuclei,slicesToSegment);
%%
for k=1:5
    qq(:,:,3) = Hela(:,:,k)+uint8(((MitoChondria(:,:,k)))*50);
    qq(:,:,2) = Hela(:,:,k);
    qq(:,:,1) = Hela(:,:,k);
    
    figure(k+10)
    imagesc(qq)
    axis([400 1700 300 1600])
    figure(k+20)
    imagesc(confidenceSegmentation(:,:,k))
    axis([400 1700 300 1600])
    colormap jet
end
%%
imwrite(MitoChondria(:,:,1),'Mitochondria_001D.png');
imwrite(MitoChondria(:,:,2),'Mitochondria_030D.png');
imwrite(MitoChondria(:,:,3),'Mitochondria_060D.png');
imwrite(MitoChondria(:,:,4),'Mitochondria_116D.png');
imwrite(MitoChondria(:,:,5),'Mitochondria_150D.png');

%% Display
displaySlice=30;
figure(1)
imagesc(Hela_nuclei(:,:,displaySlice)+2*Hela_background(:,:,displaySlice))
figure(2)
imagesc(Hela(:,:,displaySlice))
colormap gray
figure(3)
imagesc(Hela_cell(:,:,displaySlice).*Hela(:,:,displaySlice).*(1-Hela_nuclei(:,:,displaySlice)))
colormap gray




%% Segment Mitochondria
% 1 MC are darker than the surrounding, which is the same as the inside of
% the nucleus, take that as  background value
intensity_nuclei            = mean(Hela(Hela_nuclei==1));
intensity_background        = mean(Hela(Hela_background==1));
intensity_min_Hela          = min(Hela(:));
intensity_max_Hela          = max(Hela(:));
   

intensitiesCellSorted       = sort(Hela(cellRegion==1));
intensity_min1_Cell          = intensitiesCellSorted(round(0.05*numel(intensitiesCellSorted)));
intensity_min2_Cell          = intensitiesCellSorted(round(0.01*numel(intensitiesCellSorted)));


%% Very dark solid regions

displaySlice=30;
currentSlice                = Hela(:,:,displaySlice);
currentRegion               = imerode(cellRegion(:,:,displaySlice),ones(9));


darkSolidRegions1           = currentRegion.*bwlabel(bwmorph(currentSlice<(intensity_min2_Cell),'majority'));
darkSolidRegions1_P         = regionprops(darkSolidRegions1,'area');
darkSolidRegions2           = ismember(darkSolidRegions1,find([darkSolidRegions1_P.Area]>100));
darkSolidRegions3           = imclose(imfill(darkSolidRegions2,'holes'),ones(5));

%%

intermediateRegions             = (currentSlice<(0.6*intensity_min1_Cell+0.4*intensity_nuclei)).*currentRegion.*(1-imdilate(darkSolidRegions3,ones(5)));
intermediateRegions_L           = bwlabel(intermediateRegions);
intermediateRegions_P           = regionprops(intermediateRegions_L,'Area'); 

intermediateRegions2            = bwlabel(ismember(intermediateRegions_L,find([intermediateRegions_P.Area]>200)));
intermediateRegions2_L          = bwlabel(imclose(intermediateRegions2,ones(3)));
intermediateRegions2_P          = regionprops(intermediateRegions2_L,'Area','FilledArea','FilledImage'); 

[intermediateRegions3_L,numR]   = bwlabel(ismember(intermediateRegions2_L,find(([intermediateRegions2_P.Area]./[intermediateRegions2_P.FilledArea])<=0.9)));
%%
intermediateRegions4            = zeros(size(intermediateRegions));

closeReg                        = strel('disk',21);
for counterR = 1:numR
    intermediateRegions4        = intermediateRegions4+ counterR*(imclose(intermediateRegions3_L==counterR,closeReg));
end
figure(4)
imagesc(intermediateRegions4)
figure(1)
imagesc(currentSlice.*(intermediateRegions4==0))

%imagesc(currentSlice.*(intermediateRegions))
%imagesc(currentSlice.*(1-(edge(currentSlice.*currentRegion,'canny',[],3.5))))
%xis([400 900 600 1200])
%%
caxis([intensity_min_Hela intensity_max_Hela])

colormap gray
%%
%dir0                = 'D:\Acad\GitHub\HeLa-Cell-Segmentation\Code';
dir0                = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\HeLa-Cell-Segmentation\Code';
dir1                = dir(strcat(dir0,filesep,'Hela_RO*.mat'));
numFiles            = size(dir1,1);
%%
%figure
for k=9%1:numFiles
    disp(k)
    q=strfind(dir1(k).name,'_');
    currCell  = dir1(k).name(q(2)+1:q(3)-1);
    load(dir1(k).name);
    subplot(5,6,str2num(currCell))
    imagesc(squeeze(Hela_background(:,1000,:)+2*Hela_nuclei(:,1000,:)))
    title(currCell,'fontsize',10)
    volumeCell(k) = sum(sum(sum(Hela_nuclei)))/2000/2000/300;
end
%%
cells_to_discard = [1 6 15 27 28 29 30];
for k=1:numFiles
    q=strfind(dir1(k).name,'_');
    currCell  = str2num(dir1(k).name(q(2)+1:q(3)-1));
    if ~any(intersect(15,cells_to_discard))
    volumeCell2(currCell)= volumeCell(k);
    subplot(5,6,(currCell))
    title(strcat(num2str(currCell),',',32,num2str(100*volumeCell(k),2),'%'),'fontsize',10)
    end
end

%% Cells percentage of the volume:
%     1.0000    0.0364          % discard [*876*,1665,*81*]
%     2.0000    6.4039
%     3.0000    8.2434
%     4.0000    9.0499
%     5.0000    7.4914
%     6.0000    0.0094          % discard [6700,*7775*,101]
%     7.0000    6.3754
%     8.0000   11.6284
%     9.0000    8.4197
%    10.0000    7.1331
%    11.0000    6.5987
%    12.0000   14.0224
%    13.0000    9.1660
%    14.0000    5.9829
%    15.0000    0.4070          % discard [6688,*432*,241]
%    16.0000    7.7108
%    17.0000    5.6142
%    18.0000    7.9064
%    19.0000    8.1155
%    20.0000    7.8176
%    21.0000    9.6202
%    22.0000    6.9922
%    23.0000    6.7998
%    24.0000    6.5423
%    25.0000    4.7663
%    26.0000    3.4005
%    27.0000    0.0105          % discard [*7737*,*7703*,381]
%    28.0000    0.0645          % discard [7604,*465*,*421*]
%    29.0000    0.0047          % discard [6853,2802,*421*]
%    30.0000    0.8341          % discard [2051,3944,*441*]
   
   
%%
dir0                = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\HeLa-Cell-Segmentation\Code';
dir1                = dir(strcat(dir0,filesep,'Hela_RO*.mat'));
numFiles            = size(dir1,1);
load('final_coords.mat')
load('Hela_ROI_1_30_876_1665_81_Nuclei.mat')
%% Prepare for 3D display 
% This is for the slices:

[rows,cols,levs]        = size(Hela_nuclei);
numFiles = levs;
[x2d,y2d]               = meshgrid(1:rows,1:cols);
z2d                     = ones(rows,cols);
zz_3D = zeros(rows,cols,levs);
for k=1:numFiles
    disp(k)
    zz_3D(:,:,k)        = ones(rows,cols)*k;
end
xx_3D                   = repmat(x2d,[1 1 numFiles]);
yy_3D                   = repmat(y2d,[1 1 numFiles]);
%% This is for the surface 
% We could create the surface directly with this, but as the volume is rather large,
% the number of faces of the surface would be rather high, it would be slow and may
% crash in a computer with low memory. This it is better to generate the reference
% framework to create a isosurface with fewer faces

% We can now generate the isosurface of the cell, with a certain step; using fstep =1
% would be the same as the whole surface. With 8, the results are still visually good
% and hard to distinguish with smaller steps.

maxSlice            = levs;
minSlice            = 1;
fstep               = 16;
numFiles            = size(dir1,1);
%%
figure
numFiles            = size(dir1,1);
cells_to_discard = [1 6 15 27 28 29 30];
for k=1:numFiles
   
    q=strfind(dir1(k).name,'_');
    currCell  = str2num(dir1(k).name(q(2)+1:q(3)-1));
    %disp(currCell)
    if ~any(intersect(currCell,cells_to_discard))
         disp(currCell)
        load(dir1(k).name);
        %subplot(5,6,(currCell))
        %imagesc(squeeze(Hela_background(:,1000,:)+2*Hela_nuclei(:,1000,:)))
        
        %if (currCell==12)|(currCell==20)
            %Hela_nuclei         = Hela_nuclei.*(1-imdilate(Hela_background,ones(39,39,23))) ;
           % Hela_nuclei         = smooth3(Hela_nuclei);
        %end
        surf_Nuclei         = isosurface(xx_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice) +final_coords(currCell,1) ,...
                                          yy_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice) +final_coords(currCell,3) ,...
                                          zz_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice) +final_coords(currCell,5) ,...
                                    Hela_nuclei(1:fstep:end,1:fstep:end,minSlice:maxSlice),0.7);
                    
        % Finally, let's display the surface
        h4 =  patch(surf_Nuclei);
        h4.FaceColor=0.75*rand(1,3);
%        set(h4,'facecolor','red')
        set(h4,'edgecolor','none')     
        handlesNuclei{currCell}=h4;
        %title(strcat(num2str(currCell),',',32,num2str(100*volumeCell(k),2),'%'),'fontsize',10)
        %title(strcat(num2str(currCell)))
    end
    rotate3d on
end
%%
view(398,43)
lighting phong
%camlight left
camlight right
axis tight
        
       
%%
numFiles            = size(dir1,1);
for k=1:numFiles
        q=strfind(dir1(k).name,'_');
    currCell  = str2num(dir1(k).name(q(2)+1:q(3)-1));
    if ~any(intersect(currCell,cells_to_discard))
        q=strfind(dir1(k).name,'_');
        currCell  = str2num(dir1(k).name(q(2)+1:q(3)-1));
        
        handleText(k) = text(0.5*final_coords(currCell,1)+0.5*final_coords(currCell,2),...
            0.5*final_coords(currCell,3)+0.5*final_coords(currCell,4),...
            final_coords(currCell,6)+50,num2str(currCell),...
            'Color','red','FontSize',14);
    else
   q=strfind(dir1(k).name,'_');
        currCell  = str2num(dir1(k).name(q(2)+1:q(3)-1));
        
        handleText(k) = text(0.5*final_coords(currCell,1)+0.5*final_coords(currCell,2),...
            0.5*final_coords(currCell,3)+0.5*final_coords(currCell,4),...
            final_coords(currCell,6)+50,num2str(currCell),...
            'Color','blue','FontSize',10);
        
        
    end
end


 axis([1 8000 1 8000 1 520])
 
 %%
 
 baseDir             = 'C:\Users\sbbk034\Documents\Acad\Crick\Hela8000_tiff\';

 
 %%
 
 currentSlice = 120;

imagesc(1*Hela_background(:,:,currentSlice)+2*Hela_nuclei(:,:,currentSlice)+3*Hela_cell(:,:,currentSlice))


%%

cell_P  = regionprops(Hela_cell,'Area','centroid');
rr      = sqrt((yy_3D-cell_P.Centroid(1)).^2 +(xx_3D-cell_P.Centroid(2)).^2 +(zz_3D-cell_P.Centroid(3)).^2  );

%%

currentSlice = 210;
subplot(211)
temp = rr(:,:,currentSlice).*Hela_cell(:,:,currentSlice);
temp2 = temp(:);
temp2(temp==0)=[];
[yradius,xradius]=hist(temp2,100);
imagesc(temp)
subplot(212)
plot(xradius,yradius)

%%
segmentCellHelaEM_3D(Hela_nuclei(:,:,currentSlice),Hela_background(:,:,currentSlice),Hela_cell(:,:,currentSlice-1))


