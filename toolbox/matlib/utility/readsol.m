function protstring=readsol(filename)
   fullfilename = which(filename);
   if(isempty(fullfilename))
       error('MATLAB:GPAT:FILENOTEXIST','FILE IS NOT FOUND');
   end
   
   ftext  = textread(fullfilename,'%s','delimiter','\n');
   headerlines = strncmp(ftext,'>',1);

   if ~any(headerlines)
        error('MATLAB:GPAT:NOTSUPPORTFILETYPE','WRONG FAST FILE');        
   end
   
   startpos = find(headerlines);
   
   
   if length(startpos)>1
      error('MATLAB:GPAT:UNSUPPORTEDFORMAT','CAN NOT HANDLE MULTIPLE PROTEIN YET'); 
   end
   
   headerlines(1:startpos)=1;
   
   digestedpepfrag = ~headerlines;
   protstring = ftext(digestedpepfrag);
end

