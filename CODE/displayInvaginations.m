function displayInvaginations(Hela_nuclei,invaginations2,xx_3D,yy_3D,zz_3D,fstep)

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


%%
maxSlice            = levs;
minSlice            = 1;

%%
if ~exist("fstep",'var')
    fstep=4;
end
figure
    % ***** display all the cells as surfaces in one 3D plot ****       
        surf_Nuclei          = isosurface(yy_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
                                          xx_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice) ,...
                                          zz_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
                                    Hela_nuclei(1:fstep:end,1:fstep:end,minSlice:maxSlice),0.7);
        h4                  = patch(surf_Nuclei);
        h4.FaceColor        = 'b';
        h4.EdgeColor        = 'none';
        h4.FaceAlpha        = 0.2;
                                
                                %
                                
        surf_Invag         = isosurface(yy_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
                                          xx_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
                                          zz_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
                                     invaginations2(1:fstep:end,1:fstep:end,minSlice:maxSlice)>0,0.7);
                    
        % Finally, let's display the surface, allocate random colours
        h5                  = patch(surf_Invag);
        h5.FaceColor        = 'r';
        h5.EdgeColor        = 'none';
        h5.FaceAlpha        = 0.7;
       
 
 view(74,47)
 lighting('phong');
 camlight ('left');
 %%
 %h4.FaceColor        = 'red';
        %h4.FaceColor        = 0.75*rand(1,3);
        
        % keep all the handles
     %  handlesNuclei{currCell}=h4;
     %   handlesCell  {currCell}=h5;