function  [invaginations2,invaginations2_P ] =  closeInvaginations(Hela_nuclei)

% regular dimensions check and initialise variables that will be iterated
[rows,cols,levs]                = size(Hela_nuclei);
invaginations1(rows,cols,levs)  = 0;
DistFromOutside(rows,cols,levs) = 0;
%% Loop per slice to find invaginations

closeStrel                      = strel('disk',55);
openStrel                       = strel('disk',2);
for k=1:levs
    %k = 24;
    disp(k)
    % first, close the nuclei in case there are some holes inside a slice
    tempNuc                     = imfill(Hela_nuclei(:,:,k),'holes');
    % close with a big structural element to fill in any possible
    % invagination
    tempNuc2                    = imclose (tempNuc,closeStrel);
    % erode the closed nuclei, this will be used later to remove closed
    % regions that are close to the surface of the nucleus
    tempNuc3                    = imerode(tempNuc2,ones(9));
    % find the regions of tempNuc3 that are greater than tempNuc, those are
    % the invaginations that are not close to the surface, and open with a
    % small structural element to remove small noise
    tempNuc4                    = imopen((tempNuc3>tempNuc),openStrel);
    % save per slice
    invaginations1(:,:,k)       = tempNuc4;
    % calculate distance from outside, this will help to know how deep each
    % invagination is
    DistFromOutside(:,:,k)      = bwdist(1-tempNuc2);
end

% label to remove all the small artifacts
invaginations1_L                = bwlabeln(invaginations1);
invaginations1_P                = regionprops3(invaginations1_L,'volume','SurfaceArea');
[invaginations2,numInvag]       = bwlabeln(ismember(invaginations1_L,find([invaginations1_P.Volume]>15000)));
% once small artifacts are removed, calculate, volume, surface, and the
% intensities that indicate depth
invaginations2_P                = regionprops3(invaginations2,DistFromOutside,'volume','SurfaceArea','PrincipalAxisLength','MeanIntensity','MaxIntensity','Centroid');

% Calculate the angle where the invagiations' centroid is located
centroidNuc                     = regionprops3(Hela_nuclei,'Centroid');
relCentroidsInvag               = repmat(centroidNuc.Centroid,[numInvag,1])-invaginations2_P.Centroid;
invaginations2_P.Angles         = 180*angle(relCentroidsInvag(:,1)+1i*relCentroidsInvag(:,2))/pi;
invaginations2_P.distCentroids  = abs(relCentroidsInvag(:,1)+1i*relCentroidsInvag(:,2)) ;
