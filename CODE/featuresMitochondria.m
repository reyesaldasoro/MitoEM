function  [Hela_mitochondria, Hela_mitochondria_P ] =  featuresMitochondria(Hela_mitochondria,Hela_nuclei,Hela_cell)

if isa('Hela_mitochondria','char')
    Hela_name = Hela_mitochondria;
    clear Hela_mitochondria
    dir0    = dir(Hela_name);
    Hela_mitochondria(2000,2000,300) = uint16(0) ; 
    % read all mitochondria from tiff

    for k=1:300
        disp(k)
        a = imread(dir0(k).name);
        Hela_mitochondria(:,:,k) = (uint16(a).*uint16(Hela_cell(:,:,k)));
    end
end


DistFromNuclei          = bwdist(Hela_nuclei);

Hela_mitochondria_P     = regionprops3(Hela_mitochondria,DistFromNuclei,'Volume','SurfaceArea','centroid','PrincipalAxisLength','MeanIntensity','MaxIntensity','Centroid');

% remove the rows of the table that are empty (not all values are represented in the
% mitochondria, some may have been present in other cells and not the cell of
% interest
qq                      = find([Hela_mitochondria_P.Volume]==0);
Hela_mitochondria_P(qq,:) =[];
