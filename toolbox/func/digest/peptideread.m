function pepdata = peptideread(varargin)
%PEPTIDEREAD: Read peptide sequence from a sequence file in FASTA format
%
% Syntax:
%      pepseq    = peptideread(pepfilefullname)
%      pepseq    = peptideread(pepfiledir,pepfilename)
%
% Input:
%    pepfilefullname: the full name for a peptide sequence file including its path 
%    pepfiledir: the name of the file directory
%    pepfilename: the name of a peptide sequence file 
%   (Note: e.g., if the file "fetuin.txt" is stored in the folder 'c:\glcopat\toolbox\test\demo',
%      the "pepfilefullname" is 'c:\glycopat\toolbox\test\demo\fetuin.txt'
%      the  "pepfiledir" is 'c:\glycopat\toolbox\test\demo'
%      the  "pepfilename " is 'fetuin.txt'.)
%
% Output:
%      pepdata: MATLAB structure containing two fields: i)sequence and ii) header.  
%
% Examples:
%   Example 1:
%      pepseq   = peptideread('c:\glycopat\toolbox\test\demo\fetuin.txt');
%
%   Example 2:
%      filedir  = 'c:\glycopat\toolbox\test\demo';
%      pepseq   = peptideread(filedir,'fetuin.txt');
%
%   Example 3:
%      pepseq   = peptideread('fetuin.txt');
%      disp(pepseq)
%
%
%See also fixedptmread,varptmread,cleaveProt,digestSGP

% Author: Gang Liu
% Lastly Updated: 08/03/14

narginchk(1,2);

if(nargin==1)
    pepfullfilename  = varargin{1};
elseif(nargin==2)
    pepfilepath = varargin{1};
    pepfilename = varargin{2};
    pepfullfilename = fullfile(pepfilepath,pepfilename);
end

% check file pathname is provided
fid = fopen(pepfullfilename);
if(fid==-1) % if file not found
    pepfullfilename = which(pepfullfilename);
    if(isempty(pepfullfilename))
        fclose(fid);
        error('MATLAB:GlycoPAT:FILENOTFOUND','file is not found in the search path');
    end    
end


[path,name,fileformat] = fileparts(pepfullfilename);
if(isequal(fileformat,'.txt') || isequal(fileformat,'.fasta') ...
        || isequal(fileformat,'.fas') || isequal(fileformat,'.fa') ...
        || isequal(fileformat,'.seq') || isequal(fileformat,'.fsa') ...
        || isequal(fileformat,'.faa'))
    
    % read sequence from fasta file
    % fid = fopen(pepfullfilename);
    try
        ftext = textscan(fid,'%s','delimiter','\n');
        fclose(fid);
        ftext = ftext{:};
    catch readingErr
        if strcmpi(readingErr.identifier,'MATLAB:nomem')
            error('MATLAB:GlycoPAT:NOMEM','FILE IS TOO BIG');
        else
            rethrow(readingErr);
        end
    end
    
    % support reading multiple sequences
    headerLines = strncmp(ftext,'>',1);
    
    if ~any(headerLines)
        error('MATLAB:GlycoPAT:FASTAREADERROR','NO COMMENT LINES IN FASTA FILE');
    end
    
    numSeqs = sum(headerLines);
    seqStarts = [find(headerLines);size(ftext,1)+1];
    pepdata(numSeqs,1).header = '';
    
    try
        for theSeq = 1:numSeqs
            % Check for > symbol ?
            pepdata(theSeq).header = ftext{seqStarts(theSeq)}(2:end);
            % convert 1x0 empty char array to '';
            if isempty(pepdata(theSeq).header)
                pepdata(theSeq).header = '';
            end
            
            firstRow = seqStarts(theSeq)+1;
            lastRow = seqStarts(theSeq+1)-1;
            numChars = cellfun('length',ftext(firstRow:lastRow));
            numSymbols = sum(numChars);
            pepdata(theSeq).sequence = repmat(' ',1,numSymbols);
            pos = 1;
            for i=firstRow:lastRow,
                str = strtrim(ftext{i});
                len =  length(str);
                if len == 0
                    break
                end
                pepdata(theSeq).sequence(pos:pos+len-1) = str;
                pos = pos+len;
            end
            pepdata(theSeq).sequence = strtrim(pepdata(theSeq).sequence);
        end
    catch allExceptions
        fclose(fid);
        error(message('MATLAB:GlycoPAT:INCORRECTFASTAFORMAT'))
    end
else
    fclose(fid);
    error('MATLAB:GlycoPAT:NONSUPPORTEDFILETYPE','FILE TYPE IS NOT SUPPORTED');
end

for i = 1 : length(pepdata)
    pepseq = pepdata(i).sequence;
    
    % covert small letter to capital letter if exist
    pepseq = (upper(pepseq))';
    
    % reshape character matrix to vector if exist
    % and remove any white space char
    pepseq = reshape(pepseq,1,size(pepseq,1)*size(pepseq,2));
    pepseq = strtrim(pepseq);
    
    % PEPTIDE SEQUENCE CHARACTER CHECK
    aaexpr = ['[^' Aminoacid.getaachar ']'];
    anynonletterchar = regexp(pepseq,aaexpr,'once');
    if(~isempty(anynonletterchar))
        error('MATLAB:GlycoPAT:NONPEPSEQ','INCORRECT PEPTIDE SEQUENCE CHARACTER');
    end
end

end