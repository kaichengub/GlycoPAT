    clear;
    directory      =pwd; % This is the directory where all files are located
    proteinInput   ='PSGL1.txt';                   % This is the file containing the protein sequence information
    fixedInput     ='fixedptmtest2a.txt';                % This file contains information on fixed PTM modifications
    variableInput  ='variableptmtest2a.txt';             % This file contains information on variable PTM modifications
    outputFile     ='output2aSoln.txt';            % name of output file located in 'directory'
    stdsolfilename ='Test2aSoln.txt';
    Enzyme         ={'Glu-C(V8 DE)'};                     % digesting enzyme (can be array of stings to allow for multiple cleavages)
    MissedMax      =2;                             % missed cleavage allowed
    MinPepLen      =4;                             % Min. length of digested peptide
    MaxPepLen      =15;                            % Max. length of digested peptide
    minPTM         =0;                             % If the analysis is to be restricted to variable PTM only
    maxPTM         =2;                             % Restrict number of variable PTM modifications
    testresult     =digesttest(directory,proteinInput,fixedInput,...
      variableInput,outputFile,Enzyme,MissedMax,MinPepLen,MaxPepLen,minPTM,maxPTM,...
      stdsolfilename);
  if(testresult)
      fprintf('%s passes testing\n',mfilename);
  else
      fprintf('%s does not pass testing\n',mfilename);
  end