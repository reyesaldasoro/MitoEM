function [xx_3D,yy_3D,zz_3D,hNucleus,hInvaginations,hMitochondria,hCell   ] = displayMitochondria(Hela_nuclei,invaginations,Hela_mitochondria,Hela_cell,fstep,plotType,xx_3D,yy_3D,zz_3D)

[rows,cols,levs]        = size(Hela_nuclei);

if ~exist("xx_3D",'var')
    % This is for the slices to create the surfaces
    numSlices               = levs;
    [x2d,y2d]               = meshgrid(1:rows,1:cols);
    z2d                     = ones(rows,cols);
    xx_3D                   = zeros(rows,cols,levs);
    yy_3D                   = zeros(rows,cols,levs);
    zz_3D                   = zeros(rows,cols,levs);
    for k=1:numSlices
        disp(k)
        zz_3D(:,:,k)        = z2d*k;
        xx_3D(:,:,k)        = x2d;
        yy_3D(:,:,k)        = y2d;
    end
end

%%
maxSlice            = levs;
minSlice            = 1;

%%
if ~exist("fstep",'var')
    fstep=4;
end
if ~exist("plotType",'var')
    plotType=1;
end
figure
% ***** display all the cells as surfaces in one 3D plot ****
surf_Nuclei          = isosurface(yy_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
    xx_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice) ,...
    zz_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
    Hela_nuclei(1:fstep:end,1:fstep:end,minSlice:maxSlice),0.7);
surf_Invag         = isosurface(yy_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
    xx_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
    zz_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
    invaginations(1:fstep:end,1:fstep:end,minSlice:maxSlice)>0,0.7);
%   for the mitochondria, verify that these do not belong to other cells,

Hela_mitochondria = Hela_mitochondria.*uint16(Hela_cell);
surf_Mitochondria         = isosurface(yy_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
    xx_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
    zz_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
    Hela_mitochondria(1:fstep:end,1:fstep:end,minSlice:maxSlice)>0,0.7);



surf_Cell         = isosurface(yy_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
    xx_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
    zz_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
    Hela_cell(1:fstep:end,1:fstep:end,minSlice:maxSlice)>0,0.7);

if plotType==2;
    subplot(1,4,1)
end
hNucleus                  = patch(surf_Nuclei);
hNucleus.FaceColor        = 'b';
hNucleus.EdgeColor        = 'none';
hNucleus.FaceAlpha        = 0.2;

%
if plotType==2;
    subplot(1,4,2)
end

% Finally, let's display the surface, allocate random colours
hInvaginations                  = patch(surf_Invag);
hInvaginations.FaceColor        = 'r';
hInvaginations.EdgeColor        = 'none';
hInvaginations.FaceAlpha        = 0.7;

%%
% Finally, let's display the surface, allocate random colours
if plotType==2;
    subplot(1,4,3)
end

hMitochondria                  = patch(surf_Mitochondria);
hMitochondria.FaceColor        = 'm';
hMitochondria.EdgeColor        = 'none';
hMitochondria.FaceAlpha        = 0.4;


if plotType==2;
    subplot(1,4,4)
end

hCell                  = patch(surf_Cell);
hCell.FaceColor        = 'c';
hCell.EdgeColor        = 'none';
hCell.FaceAlpha        = 0.1;

if plotType==2;
    subplot(1,4,1)
    camlight ('right');
    view(74,47)
    lighting('phong');
    camlight ('left');
    axis([1 cols 1 rows 1 levs])

    subplot(1,4,2)
    camlight ('right');
    view(74,47)
    lighting('phong');
    camlight ('left');
    axis([1 cols 1 rows 1 levs])

    subplot(1,4,3)
    camlight ('right');
    view(74,47)
    lighting('phong');
    camlight ('left');
    axis([1 cols 1 rows 1 levs])

    subplot(1,4,4)
    camlight ('right');
    view(74,47)
    lighting('phong');
    camlight ('left');
    axis([1 cols 1 rows 1 levs])
end

camlight ('right');
view(74,47)
lighting('phong');
camlight ('left');
%%
%hNucleus.FaceColor        = 'red';
%hNucleus.FaceColor        = 0.75*rand(1,3);

% keep all the handles
%  handlesNuclei{currCell}=hNucleus;
%   handlesCell  {currCell}=hInvaginations;