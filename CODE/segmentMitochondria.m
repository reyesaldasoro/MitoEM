function MitoChondria = segmentMitochondria (Hela,Hela_cell,Hela_nuclei,slicesToSegment)

% Regular input checks
[rows,cols,levs]                = size(Hela);
if ~exist('slicesToSegment','var')
    slicesToSegment = 1;
end
if levs==1
    slicesToSegment = 1;
end

%% Calculate intensities
% since some slices will not have mitochondria or nuclei it is best to
% calculate the intensities for the whole stack, this is slow so best to do
% once for all images
intensity_nuclei            = mean(Hela(Hela_nuclei==1));
%intensity_background        = mean(Hela(Hela_background==1));
%intensity_min_Hela          = min(Hela(:));
%intensity_max_Hela          = max(Hela(:));

% find darker regions with order statistics (to avoid bias of noise)
cellRegion                  = (Hela_cell==1).*(Hela_nuclei==0);
intensitiesCellSorted       = sort(Hela(cellRegion==1));
intensity_min1_Cell          = intensitiesCellSorted(round(0.05*numel(intensitiesCellSorted)));
intensity_min2_Cell          = intensitiesCellSorted(round(0.01*numel(intensitiesCellSorted)));



%% Segment Mitochondria
% 1 MC are darker than the surrounding, which is the same as the inside of
% the nucleus, take that as  background value

numSlices                   = numel(slicesToSegment);

MitoChondria                = zeros(rows,cols,numSlices);
for counterSlices           = 1:numSlices
    displaySlice            = slicesToSegment(counterSlices);
    disp(displaySlice)

    %% Very dark solid regions
    currentSlice                = Hela(:,:,displaySlice);
    currentRegion               = imerode(cellRegion(:,:,displaySlice),ones(9));
    darkSolidRegions1           = currentRegion.*bwlabel(bwmorph(currentSlice<(intensity_min2_Cell),'majority'));
    darkSolidRegions1_P         = regionprops(darkSolidRegions1,'area');
    darkSolidRegions2           = ismember(darkSolidRegions1,find([darkSolidRegions1_P.Area]>100));
    darkSolidRegions3           = imclose(imfill(darkSolidRegions2,'holes'),ones(5));

    %% Intermediate regions with hollow sections
    % regions that can be selected in between the intensity of nucleus and
    % darker parts of the cell region too low can merge separate MC, too
    % high and can break them go in stages to build them 
    alfaP                           = 0.65;
    intermediateRegions             = (currentSlice<(alfaP*intensity_min1_Cell+(1-alfaP)*intensity_nuclei)).*currentRegion.*(1-imdilate(darkSolidRegions3,ones(5)));
    intermediateRegions_L           = bwlabel(intermediateRegions);
    intermediateRegions_P           = regionprops(intermediateRegions_L,'Area'); %#ok<*MRPBW>
    % only larger ones
    intermediateRegions2            = (ismember(intermediateRegions_L,find([intermediateRegions_P.Area]>100)));
    intermediateRegions2_L          = bwlabel(imclose(intermediateRegions2,ones(3)));
    intermediateRegions2_P          = regionprops(intermediateRegions2_L,'Area','EulerNumber','FilledArea','FilledImage','ConvexArea','ConvexImage','Solidity','Eccentricity','MajorAxisLength','MinorAxisLength');
    %imagesc(currentSlice.*(intermediateRegions2_L==0))
    %
    % Select regions on a number of conditions:
    % 1 have many holes holes and are are that are fairly hollow
    manyHoles                       = find([intermediateRegions2_P.EulerNumber]<-2);
    intermediateRegions3a           = imfill(imclose(ismember(intermediateRegions2_L,manyHoles), strel('disk',11)),'holes');
    % 2 are fairly compact and are hollow (not by holes necessarily
    compactHollow                   =  setdiff(find(([intermediateRegions2_P.Area]./[intermediateRegions2_P.FilledArea])<=0.85),manyHoles);
    %compactHollow                   =  setdiff(find([intermediateRegions2_P.Solidity]<0.5),manyHoles);
    intermediateRegions3b           = imfill(imclose(ismember(intermediateRegions2_L,compactHollow), strel('disk',9)),'holes');
    %intermediateRegions3b           = imclose(ismember(intermediateRegions2_L,find([intermediateRegions2_P.EulerNumber]<-3)), strel('disk',18));
    
    %intermediateRegions3a           = (ismember(intermediateRegions2_L,find(([intermediateRegions2_P.Area]./[intermediateRegions2_P.FilledArea])<=0.9)));
    
 %   imagesc(intermediateRegions2+intermediateRegions3b+intermediateRegions3a)

%  This may work better than anything else, check on Monday:
% threshold low to grab a lot of the dark regions, then thin to infinity,
% that will leave lines or closed regions, fill the holes and erod, that
% will remove all the open lines

    alfaP                           = 0.45;

    intermediateRegions             = (currentSlice<(alfaP*intensity_min1_Cell+(1-alfaP)*intensity_nuclei)).*currentRegion.*(1-imdilate(darkSolidRegions3,ones(5)));
    intermediateRegions_L           = bwlabel(intermediateRegions);
    intermediateRegions_P           = regionprops(intermediateRegions_L,'Area'); %#ok<*MRPBW>
    % only larger ones
    intermediateRegions2            = (ismember(intermediateRegions_L,find([intermediateRegions_P.Area]>100)));
    intermediateRegions2_L          = bwlabel(imclose(intermediateRegions2,ones(3)));

    a1 = bwmorph(intermediateRegions2_L,'thin','inf');
    a2 = imfill(a1,'holes');
    a3 = imopen(a2,ones(3)); % 'spur','inf');
    a3_L = bwlabel(a3);
    a3_P =regionprops(a3_L,'Area');
    intermediateRegions3c = (ismember(a3_L,find([a3_P.Area]>500)));


%imagesc(a3+(intermediateRegions3c|intermediateRegions3b|intermediateRegions3a))

intermediateRegions5            = (intermediateRegions3c|intermediateRegions3b|intermediateRegions3a);






    %
    %[intermediateRegions3_L,numR]   = bwlabel(ismember(intermediateRegions2_L,find(([intermediateRegions2_P.Area]./[intermediateRegions2_P.FilledArea])<=0.9)));
    % intermediateRegions5            = zeros(rows,cols);
    % 
    % closeReg                        = strel('disk',7);
    % for counterR = 1:numR
    %     % process per region
    %     intermediateRegions4a       = (imclose(intermediateRegions3_L==counterR,closeReg));
    %     intermediateRegions4b       = imfill(intermediateRegions4a,'holes');
    %     intermediateRegions4c       = imopen(intermediateRegions4b,closeReg);
    %     intermediateRegions5        = intermediateRegions5+ counterR*(intermediateRegions4c);
    % end
    % figure(4)
    % imagesc(intermediateRegions4)
    % figure(1)
   %  imagesc(currentSlice.*(intermediateRegions5==0))
    
    %MitoChondria                    = (imerode(intermediateRegions4>0,ones(5))+  darkSolidRegions3)>0;
    %MitoChondria(:,:,counterSlices)  = (imerode(intermediateRegions5>0,ones(5)));
    MitoChondria(:,:,counterSlices)  = (imerode(intermediateRegions5>0,ones(1)));

end
