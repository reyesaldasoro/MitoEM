function MitoChondria = segmentMitochondria (Hela,Hela_cell,Hela_nuclei,Hela_background,displaySlice)

% Regular input checks
[rows,cols,levs]                = size(Hela);
if ~exist('displaySlice','var')
    displaySlice = 1;
end
if levs==1
    displaySlice = 1;
end

%% Calculate intensities
% since some slices will not have mitochondria or nuclei it is best to
% calculate the intensities for the whole stack, this is slow so best to do
% once for all images
intensity_nuclei            = mean(Hela(Hela_nuclei==1));
intensity_background        = mean(Hela(Hela_background==1));
intensity_min_Hela          = min(Hela(:));
intensity_max_Hela          = max(Hela(:));
   
% find darker regions with order statistics (to avoid bias of noise)
intensitiesCellSorted       = sort(Hela(cellRegion==1));
intensity_min1_Cell          = intensitiesCellSorted(round(0.05*numel(intensitiesCellSorted)));
intensity_min2_Cell          = intensitiesCellSorted(round(0.01*numel(intensitiesCellSorted)));

%% Display
% displaySlice=30;
% figure(1)
% imagesc(Hela_nuclei(:,:,displaySlice)+2*Hela_background(:,:,displaySlice))
% figure(2)
% imagesc(Hela(:,:,displaySlice))
% colormap gray
% figure(3)
% imagesc(Hela_cell(:,:,displaySlice).*Hela(:,:,displaySlice).*(1-Hela_nuclei(:,:,displaySlice)))
% colormap gray
%% Segment Mitochondria
% 1 MC are darker than the surrounding, which is the same as the inside of
% the nucleus, take that as  background value
cellRegion                  = (Hela_cell==1).*(Hela_nuclei==0);



%% Very dark solid regions
currentSlice                = Hela(:,:,displaySlice);
currentRegion               = imerode(cellRegion(:,:,displaySlice),ones(9));
darkSolidRegions1           = currentRegion.*bwlabel(bwmorph(currentSlice<(intensity_min2_Cell),'majority'));
darkSolidRegions1_P         = regionprops(darkSolidRegions1,'area');
darkSolidRegions2           = ismember(darkSolidRegions1,find([darkSolidRegions1_P.Area]>100));
darkSolidRegions3           = imclose(imfill(darkSolidRegions2,'holes'),ones(5));

%% Intermediate regions with hollow sections
% regions that can be selected in between the intensity of nucleus and
% darker parts of the cell region
intermediateRegions             = (currentSlice<(0.6*intensity_min1_Cell+0.4*intensity_nuclei)).*currentRegion.*(1-imdilate(darkSolidRegions3,ones(5)));
intermediateRegions_L           = bwlabel(intermediateRegions);
intermediateRegions_P           = regionprops(intermediateRegions_L,'Area'); 
% only larger ones
intermediateRegions2            = bwlabel(ismember(intermediateRegions_L,find([intermediateRegions_P.Area]>200)));
intermediateRegions2_L          = bwlabel(imclose(intermediateRegions2,ones(3)));
intermediateRegions2_P          = regionprops(intermediateRegions2_L,'Area','FilledArea','FilledImage'); 

%% Select only regions that are fairly hollow
[intermediateRegions3_L,numR]   = bwlabel(ismember(intermediateRegions2_L,find(([intermediateRegions2_P.Area]./[intermediateRegions2_P.FilledArea])<=0.9)));
intermediateRegions4            = zeros(size(intermediateRegions));

closeReg                        = strel('disk',21);
for counterR = 1:numR
    intermediateRegions4        = intermediateRegions4+ counterR*(imclose(intermediateRegions3_L==counterR,closeReg));
end
% figure(4)
% imagesc(intermediateRegions4)
% figure(1)
% imagesc(currentSlice.*(intermediateRegions4==0))
%MitoChondria                    = (imerode(intermediateRegions4>0,ones(5))+  darkSolidRegions3)>0;
MitoChondria                    = (imerode(intermediateRegions4>0,ones(5)));
