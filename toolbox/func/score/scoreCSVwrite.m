function scoreCSVwrite(csvheader, matchedSpectras, outputfilefullname) 
%SCORECSVWRITE: Write the scoring results to a csv file 
%  
% Syntax:
%   SCORECSVWRITE(csvheader,matchedSpectrasScores,outputfilefullname) 
% 
% Input: 
%   csvheader: header information for a CSV file
%   matchedSpectrasScores: scoring parameters for the matched spectras 
%   outputfilefullname: full file name for an output file
% 
% Output:
%   a local CSV file containing the score analysis result  
%
%See Also SCORECSVREAD, SCOREALLSPECTRA.

%Author: Gang Liu
%Date Lastly Updated: 08/04/14

% write header to output file
FID = fopen(outputfilefullname,'w');  % write output in same directory as Pepfile
if(FID==-2)
    error('MATLAB:GlycoPAT:FILEOPENERROR','FILE OPEN ERROR');
end
str=strcat('Peptide file name:,',csvheader.Pepfile);
fprintf(FID,'%s\n',str);
if(isfield(csvheader,'xmlfullfilename'))
    str=strcat('XML File Name:,',csvheader.xmlfullfilename);
elseif(isfield(csvheader,'DataDirectory'))
    str=strcat('Data Directory:,',csvheader.DataDirectory);
end
fprintf(FID,'%s\n',str);
str=strcat('Fragmentation Mode:,',csvheader.fragMode);
fprintf(FID,'%s\n',str);
str=strcat('MS1 Tolerance:,',num2str(csvheader.MS1tol),' ',csvheader.MS1tolUnit);
fprintf(FID,'%s\n',str);
str=strcat('MS2 Tolerance:,',num2str(csvheader.MS2tol),' ',csvheader.MS2tolUnit);
fprintf(FID,'%s\n',str);
str=strcat('nmFrag, ngFrag, npFrag=,',num2str(csvheader.nFrag));
fprintf(FID,'%s\n',str);
str=strcat('Cross Correlation maxLag=,',num2str(csvheader.maxlag));
fprintf(FID,'%s\n',str);
str=strcat('Spectra Cleanup param (CutOffMed and FracMax)=,',...
    num2str(csvheader.CutOffMed),', ',num2str(csvheader.FracMax));
fprintf(FID,'%s\n',str);
str=strcat('Select Peak=,',num2str(csvheader.selectPeak));
fprintf(FID,'%s\n',str);

% % write main body to csv file
if(iscell(matchedSpectras))  % support different format 
      numProt = length(matchedSpectras);
      for k = 1 : numProt 
         %convert select peak to string
         hit = matchedSpectras{k};
         for i = 1 : length(hit)
             peakstring = '';
             for j = 1 : length(hit(i).selectPeak)
                 peakstring = [peakstring, num2str(hit(i).selectPeak(j)),'*'];
             end
             hit(i).selectPeak = peakstring;
         end
      end

      for k=1:numProt
         if(k==1)
             showheader=1;
         else
             showheader=0;
         end

         hit = matchedSpectras{k};

         if(~isstruct(hit))
             warning('MATLAB:GlycoPAT:NOHITFOUND','NO HIT FOUND');
         else
             struct2csv(hit,FID,showheader);  % Write entire structure to file including one line headerend
         end
      end
else
    hit = matchedSpectras;
    if(~isstruct(hit))
        warning('MATLAB:GlycoPAT:NOHITFOUND','NO HIT FOUND');
    else
        struct2csv(hit,FID);  % Write entire structure to file including one line headerend
    end
end

fclose(FID);

end