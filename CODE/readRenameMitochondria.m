dir0=dir('Hela*');

for k=1:25
    disp(k)
    currentFile = dir0(k).name;
    load(currentFile)
    mitochondria = predictions;
    saveFile = strcat(currentFile(1:end-4),'_Mitochondria.mat');
    save(saveFile,'mitochondria','-v7.3')
end