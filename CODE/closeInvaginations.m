function  [invaginations2,invaginations2_P ] =  closeInvaginations(Hela_nuclei)

[rows,cols,levs]                = size(Hela_nuclei);
invaginations1(rows,cols,levs)  = 0;
DistFromOutside(rows,cols,levs) = 0;
%%

closeStrel                      = strel('disk',55);
openStrel                       = strel('disk',2);
for k=1:levs
    %k = 24;
    disp(k)
    tempNuc                     = imfill(Hela_nuclei(:,:,k),'holes');
    tempNuc2                    = imclose (tempNuc,closeStrel);
    tempNuc3                    = imerode(tempNuc2,ones(9));
    tempNuc4                    = imopen((tempNuc3>tempNuc),openStrel);
    invaginations1(:,:,k)       = tempNuc4;
    DistFromOutside(:,:,k)      = bwdist(1-tempNuc2);
    
    %imagesc(tempNuc+2*invaginations1)
    %drawnow
end

%%
%DistFromOutside                 = bwdist(1-Hela_nuclei);
invaginations1_L                = bwlabeln(invaginations1);
invaginations1_P                = regionprops3(invaginations1_L,'volume','SurfaceArea');

invaginations2                  = bwlabeln(ismember(invaginations1_L,find([invaginations1_P.Volume]>15000)));

invaginations2_P                = regionprops3(invaginations2,DistFromOutside,'volume','SurfaceArea','PrincipalAxisLength','MeanIntensity','MaxIntensity');


%%
% maxSlice            = levs;
% minSlice            = 1;

%%

% fstep=4;
% figure
%     % ***** display all the cells as surfaces in one 3D plot ****       
%         surf_Nuclei          = isosurface(yy_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
%                                           xx_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice) ,...
%                                           zz_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
%                                     Hela_nuclei(1:fstep:end,1:fstep:end,minSlice:maxSlice),0.7);
%         h4                  = patch(surf_Nuclei);
%         h4.FaceColor        = 'b';
%         h4.EdgeColor        = 'none';
%         h4.FaceAlpha        = 0.2;
% 
%                                 %
% 
%         surf_Invag         = isosurface(yy_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
%                                           xx_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
%                                           zz_3D(1:fstep:end,1:fstep:end,minSlice:maxSlice)  ,...
%                                      invaginations2(1:fstep:end,1:fstep:end,minSlice:maxSlice)>0,0.7);
% 
%         % Finally, let's display the surface, allocate random colours
%         h5                  = patch(surf_Invag);
%         h5.FaceColor        = 'r';
%         h5.EdgeColor        = 'none';
%         h5.FaceAlpha        = 0.7;
% 
% 
%  view(74,47)
%  lighting('phong');
% hLight1 = camlight ('left');
 %%
 %h4.FaceColor        = 'red';
        %h4.FaceColor        = 0.75*rand(1,3);
        
        % keep all the handles
     %  handlesNuclei{currCell}=h4;
     %   handlesCell  {currCell}=h5;