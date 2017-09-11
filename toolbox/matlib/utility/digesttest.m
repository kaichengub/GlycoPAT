function testresult=digesttest(directory,proteinInput,fixedInput,...
      variableInput,outputFile,Enzyme,MissedMax,MinPepLen,MaxPepLen,minPTM,maxPTM,...
      stdsolfilename)
  protein=digestSGP(directory,proteinInput,fixedInput,...
      variableInput,outputFile,Enzyme,MissedMax,MinPepLen,MaxPepLen,minPTM,maxPTM);
%   stdtest9soln='stdtest9soln.txt';

  stdpepfragresult = readsol(stdsolfilename);
  if(length(stdpepfragresult)~=length(protein))
      testresult=false;
      return;
  end
  
  for i=1:length(protein)
      pepfragseq = protein{i,1};
      if~(sum(strcmpi(pepfragseq,stdpepfragresult))==1)          
          testresult=false;
       %   disp('false');
          return
      end
  end
  
  for i=1:length(stdpepfragresult)
      pepfragseq = stdpepfragresult{i,1};
      if~(sum(strcmpi(pepfragseq,protein))==1)          
          testresult=false;
       %   disp('false');
          return
      end
  end
  testresult = true;
end

