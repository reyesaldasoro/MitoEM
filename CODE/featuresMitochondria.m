function  [Hela_mitochondria, Hela_mitochondria_P ] =  featuresMitochondria(Hela_mitochondria,Hela_nuclei,Hela_cell)

if isa('Hela_mitochondria','char')
    Hela_name = Hela_mitochondria;
    clear Hela_mitochondria
    dir0    = dir(strcat(Hela_name,filesep,'*.tiff'));
    Hela_mitochondria(2000,2000,300) = uint16(0) ; 
    % read all mitochondria from tiff

    for k=1:300
        disp(k)
        a = imread(strcat(Hela_name,filesep,dir0(k).name));
        Hela_mitochondria(:,:,k) = (uint16(a).*uint16(Hela_cell(:,:,k)));
    end
end


DistFromNuclei          = bwdist(Hela_nuclei);

Hela_mitochondria_P     = regionprops3(Hela_mitochondria,DistFromNuclei,'Volume','SurfaceArea','centroid','PrincipalAxisLength','MeanIntensity','MaxIntensity','Centroid');

% remove the rows of the table that are empty (not all values are represented in the
% mitochondria, some may have been present in other cells and not the cell of
% interest
qq                      = find([Hela_mitochondria_P.Volume]==0);
qq2                      = find([Hela_mitochondria_P.Volume]>0);
Hela_mitochondria_P(qq,:) =[];
numMito                 = size(Hela_mitochondria_P,1);


% Calculate the angle where the mitochondrias' centroid is located
try
    %centroidNuc                     = regionprops3(Hela_nuclei,'Centroid');
    [maxIntensityProj,numR]          = bwlabel(max(Hela_nuclei,[],3));
    centroidNuc                     = regionprops(maxIntensityProj,'Centroid','Area');
    if numR>1
        % several disconnected regions, select the largest
        [a,b]=max([centroidNuc.Area]);
        centroidNuc = centroidNuc(b);
    end
    relCentroidsMito                    = repmat([centroidNuc.Centroid 150],[numMito,1])-Hela_mitochondria_P.Centroid;
    Hela_mitochondria_P.Angles          = 180*angle(relCentroidsMito(:,1)+1i*relCentroidsMito(:,2))/pi;
    Hela_mitochondria_P.distCentroids   = abs(relCentroidsMito(:,1)+1i*relCentroidsMito(:,2)) ;
    Hela_mitochondria_P.label               = qq2;
catch
    qqq=1;
end
