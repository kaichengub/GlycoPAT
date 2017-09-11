function checkifpathvalidOglycanpath(subpathlist,subgroupArray,...
    iniSubsArray,inputGlycanArray)
numpath = subpathlist.length;
pathremoveindex = [];
for i = 1: numpath
    opath = subpathlist.get(i);
    if(~isvalidOglycanpath(opath,subgroupArray,iniSubsArray,inputGlycanArray))
        pathremoveindex = [pathremoveindex;i];
    end
end

subpathlist.remove(pathremoveindex);
end