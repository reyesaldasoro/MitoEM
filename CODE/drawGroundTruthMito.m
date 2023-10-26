cd ('/Users/ccr22/Academic/GitHub/MitoEM/CODE')
dir0        = dir('*.tif');


%% Draw ground truth 
h1          = figure(1);
h2          = gca;
clf
h1.Position = [ 1441 48 1844 1291];
h2.Position = [ 0.05 0.05 0.9 0.9];

%% Display image to be delineated
k1          = 5;

dataIn      = imread(dir0(k1).name);
dataOut     = dataIn;
groundTruthM = zeros (size(dataIn));
imagesc(dataOut);
colormap gray
k=0;
%% draw lines, keep in a stack 
k=k+1;
lineDrawn                   = drawassisted;
lineAsMask                  = createMask(lineDrawn);
groundTruthM(:,:,k)          = k*lineAsMask;
imagesc(dataIn.*uint8(((1-imdilate(max(groundTruthM,[],3),ones(5))))))

%% Use this to measure distance between GT and output
filename = strcat('GT_',dir0(k1).name(1:end-3),'mat');
save (filename,'groundTruthM')
%%
dir1        = dir('GT_*.mat');
MitoChondria = zeros(2000,2000,5);
for k2 = 1:5
    load(dir1(k2).name)
    MitoChondria(:,:,k2) = sum(groundTruthM,3)>0;
end

%%

imwrite(MitoChondria(:,:,1),'Mitochondria_001E.png');
imwrite(MitoChondria(:,:,2),'Mitochondria_030E.png');
imwrite(MitoChondria(:,:,3),'Mitochondria_060E.png');
imwrite(MitoChondria(:,:,4),'Mitochondria_116E.png');
imwrite(MitoChondria(:,:,5),'Mitochondria_150E.png');