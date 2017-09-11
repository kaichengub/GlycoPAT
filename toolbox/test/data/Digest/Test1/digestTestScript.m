function [out]=digestTestScript
% script running program digest.m

    directory='C:\Users\gangliu\Dropbox\gpat\testData\Digest\Test1';       % This is the directory where all files are located
    if(ispc)
       directory=[directory '\'];
    else
       directory=[directory '/'];
    end
    proteinInput='testProtein.txt';                % This is the file containing the protein sequence information
    fixedInput='fixedptm1.txt';                    % This file contains information on fixed PTM modifications
    variableInput='variableptm1.txt';              % This file contains information on variable PTM modifications
    outputFile='Test9Soln.txt';                    % name of output file located in 'directory'
    Enzyme={'Trypsin'};                            % digesting enzyme (can be array of stings to allow for multiple cleavages)
    MissedMax=1;                                   % missed cleavage allowed
    MinPepLen=4;                                   % Min. length of digested peptide
    MaxPepLen=15;                                  % Max. length of digested peptide
    minPTM=0;                                      % If the analysis is to be restricted to variable PTM only
    maxPTM=2;                                      % Restrict number of variable PTM modifications
    
    out=digestSGP(directory,proteinInput,fixedInput,variableInput,outputFile,Enzyme,MissedMax,MinPepLen,MaxPepLen,minPTM,maxPTM);
    disp('end');
end

% >test peptide
% ASFTKBSFFTKPCSFFFSTKRDSFFFFLRMFFFRAFFNDELRPAFFFMFFENDRNMTKNPS
% Default: % Enz.: Trypsin; MissedMax=1; MinPepLen=4; MaxPepLen=15; minPTM=0; maxPTM=2;

% Test 1 -a
% fixed: C C<i> ;Variable: <o> M 0
%     'ASFTK'
%     'BSFFTKPC<i>SFFFSTK'
%     'DSFFFFLR'
%     'DSFFFFLRM<o>FFFR'
%     'DSFFFFLRMFFFR'
%     'M<o>FFFR'
%     'MFFFR'
%     'NM<o>TK'
%     'NM<o>TKNPS'
%     'NMTK'
%     'NMTKNPS'
%     'RDSFFFFLR'

% Test 1 -b
% fixed: C C<i> ;Variable: <o> M 0
% MinPepLen=3, MaxPepLen=16;
%     'ASFTK'
%     'BSFFTKPC<i>SFFFSTK'
%     'BSFFTKPC<i>SFFFSTKR'   <-- added 16 a. acid peptide
%     'DSFFFFLR'
%     'DSFFFFLRM<o>FFFR'
%     'DSFFFFLRMFFFR'
%     'M<o>FFFR'
%     'MFFFR'
%     'NM<o>TK'
%     'NM<o>TKNPS'
%     'NMTK'
%     'NMTKNPS'
%     'NPS'                   <-- added 3 a. acid peptide
%     'RDSFFFFLR'

% Test 1 -c
% fixed: C C<i> ;Variable: <o> M 0
% MinPepLen=5, MaxPepLen=14;
%     'ASFTK'
%     'DSFFFFLR'          <-- lost 15 a. acid peptide from Test 1a
%     'DSFFFFLRM<o>FFFR'
%     'DSFFFFLRMFFFR'
%     'M<o>FFFR'
%     'MFFFR'
%     'NM<o>TKNPS'        <-- lost 4 a. acid modified and unmodified peptide from Test 1a
%     'NMTKNPS'
%     'RDSFFFFLR'

% Test 1 -d
% fixed: C C<i> ;Variable: <o> M 0
% Missed Max=0
%     'ASFTK'
%     'BSFFTKPC<i>SFFFSTK'
%     'DSFFFFLR'      <-- missed one peptide and modified verison here
%     'M<o>FFFR'
%     'MFFFR'
%     'NM<o>TK'       <-- two more peptides here
%     'NMTK'

% Test 1 -e
% fixed: C C<i> ;Variable: <o> M 0
% Missed Max=2
%     'ASFTK'
%     'BSFFTKPC<i>SFFFSTK'
%     'DSFFFFLR'
%     'DSFFFFLRM<o>FFFR'
%     'DSFFFFLRMFFFR'
%     'M<o>FFFR'
%     'MFFFR'
%     'NM<o>TK'
%     'NM<o>TKNPS'
%     'NMTK'
%     'NMTKNPS'
%     'RDSFFFFLR'
%     'RDSFFFFLRM<o>FFFR'     <-- added two peptides with two missed cleavages
%     'RDSFFFFLRMFFFR'
    
% Test 2
% fixed: None; Variable: None
%     'ASFTK'
%     'BSFFTKPCSFFFSTK'
%     'DSFFFFLR'
%     'DSFFFFLRMFFFR'     <- modified version missed from Test 1a
%     'MFFFR'             <- modified version missed from Test 1a
%     'NMTK'              <- modified version missed from Test 1a
%     'NMTKNPS'           <- modified version missed from Test 1a
%     'RDSFFFFLR'

% Test 3
% fixed: C C<i>; Variable: None
%     'ASFTK'
%     'BSFFTKPC<i>SFFFSTK'    <- identical to Test 2 except C is modified
%     'DSFFFFLR'
%     'DSFFFFLRMFFFR'
%     'MFFFR'
%     'NMTK'
%     'NMTKNPS'
%     'RDSFFFFLR'

% Test 4 -a
% fixed: None
% Variable: 
% <o> M 0
% {n{h{s}}} S 0
%     'ASFTK'
%     'AS{n{h{s}}}FTK'
%     'BSFFTKPCSFFFSTK'             <-- Cys is unmodified
%     'BSFFTKPCSFFFS{n{h{s}}}TK'    <-- 1 of 3 sites glycosylated
%     'BSFFTKPCS{n{h{s}}}FFFSTK'
%     'BSFFTKPCS{n{h{s}}}FFFS{n{h{s}}}TK'<-- 2/3 sites glycosylated
%     'BS{n{h{s}}}FFTKPCSFFFSTK'
%     'BS{n{h{s}}}FFTKPCSFFFS{n{h{s}}}TK'
%     'BS{n{h{s}}}FFTKPCS{n{h{s}}}FFFSTK'
%     'DSFFFFLR'
%     'DSFFFFLRM<o>FFFR'
%     'DSFFFFLRMFFFR'
%     'DS{n{h{s}}}FFFFLR'
%     'DS{n{h{s}}}FFFFLRM<o>FFFR'   <-- 1 glycosylation and one M<o> with missed cleavage
%     'DS{n{h{s}}}FFFFLRMFFFR'
%     'M<o>FFFR'
%     'MFFFR'
%     'NM<o>TK'
%     'NM<o>TKNPS'
%     'NMTK'
%     'NMTKNPS'
%     'RDSFFFFLR'
%     'RDS{n{h{s}}}FFFFLR'

% Test 5
% fixed: C C<i>
% Variable: 
% {n{h{s}}} S 4,28,29,61
%     'ASFTK'
%     'ASFT{n{h{s}}}K'            <- mod. at 4 (not seen in Test 4)
%     'AS{n{h{s}}}FTK'
%     'AS{n{h{s}}}FT{n{h{s}}}K'   <- mod. at 4 and S (not seen in Test 4)
%     'BSFFTKPC<i>SFFFSTK'
%     'BSFFTKPC<i>SFFFS{n{h{s}}}TK'
%     'BSFFTKPC<i>S{n{h{s}}}FFFSTK'
%     'BSFFTKPC<i>S{n{h{s}}}FFFS{n{h{s}}}TK'
%     'BS{n{h{s}}}FFTKPC<i>SFFFSTK'
%     'BS{n{h{s}}}FFTKPC<i>SFFFS{n{h{s}}}TK'
%     'BS{n{h{s}}}FFTKPC<i>S{n{h{s}}}FFFSTK'
%     'DSFFFFLR'                  <-- modification at N-terminus does not occur since this is not allowed
%     'DSFFFFLRMFFFR'
%     'DSFFFFLR{n{h{s}}}MFFFR'
%     'DSFFFFL{n{h{s}}}R'
%     'DSFFFFL{n{h{s}}}RMFFFR'
%     'DSFFFFL{n{h{s}}}R{n{h{s}}}MFFFR'   <-- modified at 28 and 29
%     'DS{n{h{s}}}FFFFLR'
%     'DS{n{h{s}}}FFFFLRMFFFR'
%     'DS{n{h{s}}}FFFFLR{n{h{s}}}MFFFR'
%     'DS{n{h{s}}}FFFFL{n{h{s}}}R'
%     'DS{n{h{s}}}FFFFL{n{h{s}}}RMFFFR'
%     'MFFFR'
%     'NMTK'
%     'NMTKNPS'       <-- note that T at 61 is also not modified eventhough this is the last a.acid in the sequence
%     'RDSFFFFLR'
%     'RDSFFFFL{n{h{s}}}R'
%     'RDS{n{h{s}}}FFFFLR'
%     'RDS{n{h{s}}}FFFFL{n{h{s}}}R'

% Test 6
% fixed: C C<i>
% Variable: 
% {n{h{s}}} S,T 28
% <o> M 27
%     'ASFTK'
%     'ASFT{n{h{s}}}K'
%     'AS{n{h{s}}}FTK'
%     'AS{n{h{s}}}FT{n{h{s}}}K'       <-- modification at both S and T
%     'BSFFTKPC<i>SFFFSTK'            <-- there are 5 S/T sites on this peptide
%     'BSFFTKPC<i>SFFFST{n{h{s}}}K'
%     'BSFFTKPC<i>SFFFS{n{h{s}}}TK'
%     'BSFFTKPC<i>SFFFS{n{h{s}}}T{n{h{s}}}K'
%     'BSFFTKPC<i>S{n{h{s}}}FFFSTK'
%     'BSFFTKPC<i>S{n{h{s}}}FFFST{n{h{s}}}K'
%     'BSFFTKPC<i>S{n{h{s}}}FFFS{n{h{s}}}TK'
%     'BSFFT{n{h{s}}}KPC<i>SFFFSTK'
%     'BSFFT{n{h{s}}}KPC<i>SFFFST{n{h{s}}}K'
%     'BSFFT{n{h{s}}}KPC<i>SFFFS{n{h{s}}}TK'
%     'BSFFT{n{h{s}}}KPC<i>S{n{h{s}}}FFFSTK'
%     'BS{n{h{s}}}FFTKPC<i>SFFFSTK'
%     'BS{n{h{s}}}FFTKPC<i>SFFFST{n{h{s}}}K'
%     'BS{n{h{s}}}FFTKPC<i>SFFFS{n{h{s}}}TK'
%     'BS{n{h{s}}}FFTKPC<i>S{n{h{s}}}FFFSTK'
%     'BS{n{h{s}}}FFT{n{h{s}}}KPC<i>SFFFSTK'
%     'DSFFFF<o>LR'           <-- In this peptide oxidation is allowed on F(27) and glycosylation on L(28)
%       'DSFFFF<o>LRM<o>FFFR'   <-- same as previous only with additional M<o>
%       'DSFFFF<o>LRMFFFR'
%     'DSFFFF<o>L{n{h{s}}}R'
%       'DSFFFF<o>L{n{h{s}}}RMFFFR'
%     'DSFFFFLR'
%       'DSFFFFLRM<o>FFFR'
%       'DSFFFFLRMFFFR'
%     'DSFFFFL{n{h{s}}}R'
%       'DSFFFFL{n{h{s}}}RM<o>FFFR'
%       'DSFFFFL{n{h{s}}}RMFFFR'
%     'DS{n{h{s}}}FFFF<o>LR'
%       'DS{n{h{s}}}FFFF<o>LRMFFFR'
%     'DS{n{h{s}}}FFFFLR'
%       'DS{n{h{s}}}FFFFLRM<o>FFFR'
%       'DS{n{h{s}}}FFFFLRMFFFR'
%     'DS{n{h{s}}}FFFFL{n{h{s}}}R'
%       'DS{n{h{s}}}FFFFL{n{h{s}}}RMFFFR'
%     'M<o>FFFR'
%     'MFFFR'
%     'NM<o>TK'
%       'NM<o>TKNPS'
%     'NM<o>T{n{h{s}}}K'
%       'NM<o>T{n{h{s}}}KNPS'
%     'NMTK'
%       'NMTKNPS'
%     'NMT{n{h{s}}}K'
%       'NMT{n{h{s}}}KNPS'
%     'RDSFFFF<o>LR'
%     'RDSFFFF<o>L{n{h{s}}}R'
%     'RDSFFFFLR'
%     'RDSFFFFL{n{h{s}}}R'
%     'RDS{n{h{s}}}FFFF<o>LR'
%     'RDS{n{h{s}}}FFFFLR'
%     'RDS{n{h{s}}}FFFFL{n{h{s}}}R'

% Test 7 -a
% missedMax=0
% fixed: C C<i>
% Variable: 
% <o> M 27
% {n{h{s}}} S 0
% {n} S,T 0
% {z} S 0
% {n{x{y}}} T 0
%     'ASFTK'         <-- 3 modifications for S and two for T
%     'ASFT{n{x{y}}}K'
%     'ASFT{n}K'
%     'AS{n{h{s}}}FTK'
%     'AS{n{h{s}}}FT{n{x{y}}}K'
%     'AS{n{h{s}}}FT{n}K'
%     'AS{n}FTK'
%     'AS{n}FT{n{x{y}}}K'
%     'AS{n}FT{n}K'
%     'AS{z}FTK'
%     'AS{z}FT{n{x{y}}}K'
%     'AS{z}FT{n}K'
%     'BSFFTKPC<i>SFFFSTK'
%     'BSFFTKPC<i>SFFFST{n{x{y}}}K'
%     'BSFFTKPC<i>SFFFST{n}K'
%     'BSFFTKPC<i>SFFFS{n{h{s}}}TK'
%     'BSFFTKPC<i>SFFFS{n{h{s}}}T{n{x{y}}}K'
%     'BSFFTKPC<i>SFFFS{n{h{s}}}T{n}K'
%     'BSFFTKPC<i>SFFFS{n}TK'
%     'BSFFTKPC<i>SFFFS{n}T{n{x{y}}}K'
%     'BSFFTKPC<i>SFFFS{n}T{n}K'
%     'BSFFTKPC<i>SFFFS{z}TK'
%     'BSFFTKPC<i>SFFFS{z}T{n{x{y}}}K'
%     'BSFFTKPC<i>SFFFS{z}T{n}K'
%     'BSFFTKPC<i>S{n{h{s}}}FFFSTK'
%     'BSFFTKPC<i>S{n{h{s}}}FFFST{n{x{y}}}K'
%     'BSFFTKPC<i>S{n{h{s}}}FFFST{n}K'
%     'BSFFTKPC<i>S{n{h{s}}}FFFS{n{h{s}}}TK'
%     'BSFFTKPC<i>S{n{h{s}}}FFFS{n}TK'
%     'BSFFTKPC<i>S{n{h{s}}}FFFS{z}TK'
%     'BSFFTKPC<i>S{n}FFFSTK'
%     'BSFFTKPC<i>S{n}FFFST{n{x{y}}}K'
%     'BSFFTKPC<i>S{n}FFFST{n}K'
%     'BSFFTKPC<i>S{n}FFFS{n{h{s}}}TK'
%     'BSFFTKPC<i>S{n}FFFS{n}TK'
%     'BSFFTKPC<i>S{n}FFFS{z}TK'
%     'BSFFTKPC<i>S{z}FFFSTK'
%     'BSFFTKPC<i>S{z}FFFST{n{x{y}}}K'
%     'BSFFTKPC<i>S{z}FFFST{n}K'
%     'BSFFTKPC<i>S{z}FFFS{n{h{s}}}TK'
%     'BSFFTKPC<i>S{z}FFFS{n}TK'
%     'BSFFTKPC<i>S{z}FFFS{z}TK'
%     'BSFFT{n{x{y}}}KPC<i>SFFFSTK'
%     'BSFFT{n{x{y}}}KPC<i>SFFFST{n{x{y}}}K'
%     'BSFFT{n{x{y}}}KPC<i>SFFFST{n}K'
%     'BSFFT{n{x{y}}}KPC<i>SFFFS{n{h{s}}}TK'
%     'BSFFT{n{x{y}}}KPC<i>SFFFS{n}TK'
%     'BSFFT{n{x{y}}}KPC<i>SFFFS{z}TK'
%     'BSFFT{n{x{y}}}KPC<i>S{n{h{s}}}FFFSTK'
%     'BSFFT{n{x{y}}}KPC<i>S{n}FFFSTK'
%     'BSFFT{n{x{y}}}KPC<i>S{z}FFFSTK'
%     'BSFFT{n}KPC<i>SFFFSTK'
%     'BSFFT{n}KPC<i>SFFFST{n{x{y}}}K'
%     'BSFFT{n}KPC<i>SFFFST{n}K'
%     'BSFFT{n}KPC<i>SFFFS{n{h{s}}}TK'
%     'BSFFT{n}KPC<i>SFFFS{n}TK'
%     'BSFFT{n}KPC<i>SFFFS{z}TK'
%     'BSFFT{n}KPC<i>S{n{h{s}}}FFFSTK'
%     'BSFFT{n}KPC<i>S{n}FFFSTK'
%     'BSFFT{n}KPC<i>S{z}FFFSTK'
%     'BS{n{h{s}}}FFTKPC<i>SFFFSTK'
%     'BS{n{h{s}}}FFTKPC<i>SFFFST{n{x{y}}}K'
%     'BS{n{h{s}}}FFTKPC<i>SFFFST{n}K'
%     'BS{n{h{s}}}FFTKPC<i>SFFFS{n{h{s}}}TK'
%     'BS{n{h{s}}}FFTKPC<i>SFFFS{n}TK'
%     'BS{n{h{s}}}FFTKPC<i>SFFFS{z}TK'
%     'BS{n{h{s}}}FFTKPC<i>S{n{h{s}}}FFFSTK'
%     'BS{n{h{s}}}FFTKPC<i>S{n}FFFSTK'
%     'BS{n{h{s}}}FFTKPC<i>S{z}FFFSTK'
%     'BS{n{h{s}}}FFT{n{x{y}}}KPC<i>SFFFSTK'
%     'BS{n{h{s}}}FFT{n}KPC<i>SFFFSTK'
%     'BS{n}FFTKPC<i>SFFFSTK'
%     'BS{n}FFTKPC<i>SFFFST{n{x{y}}}K'
%     'BS{n}FFTKPC<i>SFFFST{n}K'
%     'BS{n}FFTKPC<i>SFFFS{n{h{s}}}TK'
%     'BS{n}FFTKPC<i>SFFFS{n}TK'
%     'BS{n}FFTKPC<i>SFFFS{z}TK'
%     'BS{n}FFTKPC<i>S{n{h{s}}}FFFSTK'
%     'BS{n}FFTKPC<i>S{n}FFFSTK'
%     'BS{n}FFTKPC<i>S{z}FFFSTK'
%     'BS{n}FFT{n{x{y}}}KPC<i>SFFFSTK'
%     'BS{n}FFT{n}KPC<i>SFFFSTK'
%     'BS{z}FFTKPC<i>SFFFSTK'
%     'BS{z}FFTKPC<i>SFFFST{n{x{y}}}K'
%     'BS{z}FFTKPC<i>SFFFST{n}K'
%     'BS{z}FFTKPC<i>SFFFS{n{h{s}}}TK'
%     'BS{z}FFTKPC<i>SFFFS{n}TK'
%     'BS{z}FFTKPC<i>SFFFS{z}TK'
%     'BS{z}FFTKPC<i>S{n{h{s}}}FFFSTK'
%     'BS{z}FFTKPC<i>S{n}FFFSTK'
%     'BS{z}FFTKPC<i>S{z}FFFSTK'
%     'BS{z}FFT{n{x{y}}}KPC<i>SFFFSTK'
%     'BS{z}FFT{n}KPC<i>SFFFSTK'
%     'DSFFFF<o>LR'
%     'DSFFFFLR'
%     'DS{n{h{s}}}FFFF<o>LR'
%     'DS{n{h{s}}}FFFFLR'
%     'DS{n}FFFF<o>LR'
%     'DS{n}FFFFLR'
%     'DS{z}FFFF<o>LR'
%     'DS{z}FFFFLR'
%     'M<o>FFFR'
%     'MFFFR'
%     'NM<o>TK'
%     'NM<o>T{n{x{y}}}K'
%     'NM<o>T{n}K'
%     'NMTK'
%     'NMT{n{x{y}}}K'
%     'NMT{n}K'

% Test 7 -b
% missedMax=1
% fixed: C C<i>
% Variable: 
% <o> M 27
% {n{h{s}}} S 0
% {n} S,T 0
% {z} S 0
% {n{x{y}}} T 0
% maxPTM=minPTM=0
%     'ASFTK'
%     'BSFFTKPC<i>SFFFSTK'
%     'DSFFFFLR'
%     'DSFFFFLRMFFFR'
%     'MFFFR'
%     'NMTK'
%     'NMTKNPS'
%     'RDSFFFFLR'

% Test 7 -c
% missedMax=1
% fixed: C C<i>
% Variable: 
% <o> M 27
% {n{h{s}}} S 0
% {n} S,T 0
% {z} S 0
% {n{x{y}}} T 0
% maxPTM=minPTM=0
% Enzyme=Glu-C
%     'ELRPAFFFMFFE'
%     'LRPAFFFMFFE'
%     'LRPAFFFMFFEND'
%     'NDRNMTKNPS'
%     'RNMTKNPS'
    
% Test 7 -d
% Same as 7 -b, -c
% Enzyme={'Trypsin','Glu-C'}
%     'AFFND'
%     'AFFNDE'
%     'ASFTK'
%     'BSFFTKPC<i>SFFFSTK'
%     'DSFFFFLR'
%     'ELRPAFFFMFFE'
%     'LRPAFFFMFFE'
%     'LRPAFFFMFFEND'
%     'MFFFR'
%     'MFFFRAFFND'
%     'NMTK'
%     'NMTKNPS'
%     'RNMTK'
%     'SFFFFLR'
%     'SFFFFLRMFFFR'
   
% Test 7 -e
% missedMax=0
% fixed: C C<i>
% Variable: 
% <o> M 27
% {n{h{s}}} S 0
% {n} S,T 0
% {z} S 0
% {n{x{y}}} T 0
% maxPTM=minPTM=2
%   'ASFTK'
%     'AS{n{h{s}}}FT{n{x{y}}}K'
%     'AS{n{h{s}}}FT{n}K'
%     'AS{n}FT{n{x{y}}}K'
%     'AS{n}FT{n}K'
%     'AS{z}FT{n{x{y}}}K'
%     'AS{z}FT{n}K'
%   'BSFFTKPC<i>SFFFSTK'
%     'BSFFTKPC<i>SFFFS{n{h{s}}}T{n{x{y}}}K'
%     'BSFFTKPC<i>SFFFS{n{h{s}}}T{n}K'
%     'BSFFTKPC<i>SFFFS{n}T{n{x{y}}}K'
%     'BSFFTKPC<i>SFFFS{n}T{n}K'
%     'BSFFTKPC<i>SFFFS{z}T{n{x{y}}}K'
%     'BSFFTKPC<i>SFFFS{z}T{n}K'
%     'BSFFTKPC<i>S{n{h{s}}}FFFST{n{x{y}}}K'
%     'BSFFTKPC<i>S{n{h{s}}}FFFST{n}K'
%     'BSFFTKPC<i>S{n{h{s}}}FFFS{n{h{s}}}TK'
%     'BSFFTKPC<i>S{n{h{s}}}FFFS{n}TK'
%     'BSFFTKPC<i>S{n{h{s}}}FFFS{z}TK'
%     'BSFFTKPC<i>S{n}FFFST{n{x{y}}}K'
%     'BSFFTKPC<i>S{n}FFFST{n}K'
%     'BSFFTKPC<i>S{n}FFFS{n{h{s}}}TK'
%     'BSFFTKPC<i>S{n}FFFS{n}TK'
%     'BSFFTKPC<i>S{n}FFFS{z}TK'
%     'BSFFTKPC<i>S{z}FFFST{n{x{y}}}K'
%     'BSFFTKPC<i>S{z}FFFST{n}K'
%     'BSFFTKPC<i>S{z}FFFS{n{h{s}}}TK'
%     'BSFFTKPC<i>S{z}FFFS{n}TK'
%     'BSFFTKPC<i>S{z}FFFS{z}TK'
%     'BSFFT{n{x{y}}}KPC<i>SFFFST{n{x{y}}}K'
%     'BSFFT{n{x{y}}}KPC<i>SFFFST{n}K'
%     'BSFFT{n{x{y}}}KPC<i>SFFFS{n{h{s}}}TK'
%     'BSFFT{n{x{y}}}KPC<i>SFFFS{n}TK'
%     'BSFFT{n{x{y}}}KPC<i>SFFFS{z}TK'
%     'BSFFT{n{x{y}}}KPC<i>S{n{h{s}}}FFFSTK'
%     'BSFFT{n{x{y}}}KPC<i>S{n}FFFSTK'
%     'BSFFT{n{x{y}}}KPC<i>S{z}FFFSTK'
%     'BSFFT{n}KPC<i>SFFFST{n{x{y}}}K'
%     'BSFFT{n}KPC<i>SFFFST{n}K'
%     'BSFFT{n}KPC<i>SFFFS{n{h{s}}}TK'
%     'BSFFT{n}KPC<i>SFFFS{n}TK'
%     'BSFFT{n}KPC<i>SFFFS{z}TK'
%     'BSFFT{n}KPC<i>S{n{h{s}}}FFFSTK'
%     'BSFFT{n}KPC<i>S{n}FFFSTK'
%     'BSFFT{n}KPC<i>S{z}FFFSTK'
%     'BS{n{h{s}}}FFTKPC<i>SFFFST{n{x{y}}}K'
%     'BS{n{h{s}}}FFTKPC<i>SFFFST{n}K'
%     'BS{n{h{s}}}FFTKPC<i>SFFFS{n{h{s}}}TK'
%     'BS{n{h{s}}}FFTKPC<i>SFFFS{n}TK'
%     'BS{n{h{s}}}FFTKPC<i>SFFFS{z}TK'
%     'BS{n{h{s}}}FFTKPC<i>S{n{h{s}}}FFFSTK'
%     'BS{n{h{s}}}FFTKPC<i>S{n}FFFSTK'
%     'BS{n{h{s}}}FFTKPC<i>S{z}FFFSTK'
%     'BS{n{h{s}}}FFT{n{x{y}}}KPC<i>SFFFSTK'
%     'BS{n{h{s}}}FFT{n}KPC<i>SFFFSTK'
%     'BS{n}FFTKPC<i>SFFFST{n{x{y}}}K'
%     'BS{n}FFTKPC<i>SFFFST{n}K'
%     'BS{n}FFTKPC<i>SFFFS{n{h{s}}}TK'
%     'BS{n}FFTKPC<i>SFFFS{n}TK'
%     'BS{n}FFTKPC<i>SFFFS{z}TK'
%     'BS{n}FFTKPC<i>S{n{h{s}}}FFFSTK'
%     'BS{n}FFTKPC<i>S{n}FFFSTK'
%     'BS{n}FFTKPC<i>S{z}FFFSTK'
%     'BS{n}FFT{n{x{y}}}KPC<i>SFFFSTK'
%     'BS{n}FFT{n}KPC<i>SFFFSTK'
%     'BS{z}FFTKPC<i>SFFFST{n{x{y}}}K'
%     'BS{z}FFTKPC<i>SFFFST{n}K'
%     'BS{z}FFTKPC<i>SFFFS{n{h{s}}}TK'
%     'BS{z}FFTKPC<i>SFFFS{n}TK'
%     'BS{z}FFTKPC<i>SFFFS{z}TK'
%     'BS{z}FFTKPC<i>S{n{h{s}}}FFFSTK'
%     'BS{z}FFTKPC<i>S{n}FFFSTK'
%     'BS{z}FFTKPC<i>S{z}FFFSTK'
%     'BS{z}FFT{n{x{y}}}KPC<i>SFFFSTK'
%     'BS{z}FFT{n}KPC<i>SFFFSTK'
%     'DSFFFFLR'
%     'DS{n{h{s}}}FFFF<o>LR'
%     'DS{n}FFFF<o>LR'
%     'DS{z}FFFF<o>LR'
%     'MFFFR'
%     'NM<o>T{n{x{y}}}K'
%     'NM<o>T{n}K'
%     'NMTK'
    
% Test 8
% MissedMax=0;
% fixed C C<i>; 
% {n{100{s}}} S,T 2
% <777> M 0
%     'ASFTK'
%     'ASFT{n{100{s}}}K'
%     'AS{n{100{s}}}FTK'
%     'AS{n{100{s}}}FT{n{100{s}}}K'
%     'BSFFTKPC<i>SFFFSTK'
%     'BSFFTKPC<i>SFFFST{n{100{s}}}K'
%     'BSFFTKPC<i>SFFFS{n{100{s}}}TK'
%     'BSFFTKPC<i>SFFFS{n{100{s}}}T{n{100{s}}}K'
%     'BSFFTKPC<i>S{n{100{s}}}FFFSTK'
%     'BSFFTKPC<i>S{n{100{s}}}FFFST{n{100{s}}}K'
%     'BSFFTKPC<i>S{n{100{s}}}FFFS{n{100{s}}}TK'
%     'BSFFT{n{100{s}}}KPC<i>SFFFSTK'
%     'BSFFT{n{100{s}}}KPC<i>SFFFST{n{100{s}}}K'
%     'BSFFT{n{100{s}}}KPC<i>SFFFS{n{100{s}}}TK'
%     'BSFFT{n{100{s}}}KPC<i>S{n{100{s}}}FFFSTK'
%     'BS{n{100{s}}}FFTKPC<i>SFFFSTK'
%     'BS{n{100{s}}}FFTKPC<i>SFFFST{n{100{s}}}K'
%     'BS{n{100{s}}}FFTKPC<i>SFFFS{n{100{s}}}TK'
%     'BS{n{100{s}}}FFTKPC<i>S{n{100{s}}}FFFSTK'
%     'BS{n{100{s}}}FFT{n{100{s}}}KPC<i>SFFFSTK'
%     'DSFFFFLR'
%     'DS{n{100{s}}}FFFFLR'
%     'M<777>FFFR'
%     'MFFFR'
%     'NM<777>TK'
%     'NM<777>T{n{100{s}}}K'
%     'NMTK'
%     'NMT{n{100{s}}}K'

% Test 9
% changed last amino acid in peptide to 'S' to make sure N-glycans work
% well
% fixed C C<i>; 
% <o> M 0
% {n{h{s}}} T 1
% {n{n{h{h{h{h}}{h{h}}}}}} N 2
%     'ASFTK'
%     'ASFT{n{h{s}}}K'
%     'AS{n{n{h{h{h{h}}{h{h}}}}}}FTK'
%     'AS{n{n{h{h{h{h}}{h{h}}}}}}FT{n{h{s}}}K'
%     'A{n{h{s}}}SFTK'
%     'A{n{h{s}}}SFT{n{h{s}}}K'
%     'A{n{h{s}}}S{n{n{h{h{h{h}}{h{h}}}}}}FTK'
%     'BSFFTKPC<i>SFFFSTK'
%     'BSFFTKPC<i>SFFFST{n{h{s}}}K'
%     'BSFFT{n{h{s}}}KPC<i>SFFFSTK'
%     'BSFFT{n{h{s}}}KPC<i>SFFFST{n{h{s}}}K'
%     'DSFFFFLR'
%     'DSFFFFLRM<o>FFFR'
%     'DSFFFFLRMFFFR'
%     'M<o>FFFR'
%     'MFFFR'
%     'NM<o>TK'
%     'NM<o>TKNPS'
%     'NM<o>TKN{n{n{h{h{h{h}}{h{h}}}}}}PS'
%     'NM<o>T{n{h{s}}}K'
%     'NM<o>T{n{h{s}}}KNPS'
%     'NMTK'
%     'NMTKNPS'
%     'NMTKN{n{n{h{h{h{h}}{h{h}}}}}}PS'
%     'NMT{n{h{s}}}K'
%     'NMT{n{h{s}}}KNPS'
%     'NMT{n{h{s}}}KN{n{n{h{h{h{h}}{h{h}}}}}}PS'
%     'N{n{n{h{h{h{h}}{h{h}}}}}}M<o>TK'
%     'N{n{n{h{h{h{h}}{h{h}}}}}}M<o>TKNPS'
%     'N{n{n{h{h{h{h}}{h{h}}}}}}MTK'
%     'N{n{n{h{h{h{h}}{h{h}}}}}}MTKNPS'
%     'N{n{n{h{h{h{h}}{h{h}}}}}}MTKN{n{n{h{h{h{h}}{h{h}}}}}}PS'
%     'N{n{n{h{h{h{h}}{h{h}}}}}}MT{n{h{s}}}K'
%     'N{n{n{h{h{h{h}}{h{h}}}}}}MT{n{h{s}}}KNPS'
%     'RDSFFFFLR'    