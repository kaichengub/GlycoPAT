    clear;
    directory      = pwd; % This is the directory where all files are located
    proteinInput   ='fetuin.txt';                   % This is the file containing the protein sequence information
    fixedInput     ='fixedptmtest5.txt';                % This file contains information on fixed PTM modifications
    variableInput  ='variableptmtest5.txt';             % This file contains information on variable PTM modifications
    outputFile     ='output5aSoln.txt';            % name of output file located in 'directory'
    stdsolfilename ='Test5aSoln.txt';
    Enzyme         ={'Trypsin'};                     % digesting enzyme (can be array of stings to allow for multiple cleavages)
    MissedMax      =1;                             % missed cleavage allowed
    MinPepLen      =4;                             % Min. length of digested peptide
    MaxPepLen      =15;                            % Max. length of digested peptide
    minPTM         =0;                             % If the analysis is to be restricted to variable PTM only
    maxPTM         =3;                             % Restrict number of variable PTM modifications
    testresult     = digesttest(directory,proteinInput,fixedInput,...
      variableInput,outputFile,Enzyme,MissedMax,MinPepLen,MaxPepLen,minPTM,maxPTM,...
      stdsolfilename);
  if(testresult)
      fprintf('%s passes testing\n',mfilename);
  else
      fprintf('%s does not pass testing\n',mfilename);
  end