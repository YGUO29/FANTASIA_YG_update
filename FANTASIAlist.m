% get list of file names and sound names
global TP
for i = 1:length(TP.EX.Dir.SesFileIndex)
    temp = TP.EX.D.File(TP.EX.Dir.SesFileIndex(i)).hSessMat.Load;
    fprintf([TP.EX.Dir.SesNames{i}, '\t',...
        num2str(temp.CycleNumTotal), '\t',...
        temp.SoundFile, '\n']);
end