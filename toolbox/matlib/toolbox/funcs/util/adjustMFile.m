function adjustMFile(mfilename, parametername, parameternevalue) 
    mfilestr = fileread(mfilename);
    
    %change q value
    strberep = [parametername ' = \w*;' ];
    strtorep =  [parametername ' = ' num2str(parameternevalue) ';'];
    mfilestr=regexprep(mfilestr,strberep,strtorep); 
    
    fid = fopen(mfilename,'w');
    fprintf(fid,'%s',mfilestr);
    fclose(fid);
   rehash toolboxcache ;
end