function [finalallprod,varargout]=digestSGP(varargin)
% DIGESTSGP: Create a list of enzyme digested fragments given the protein  
%  sequence, list of glycan and non-glycan modifications, and other 
%  digestion parameters.
%
% Syntax:
%    glycopepfrag = digestSGP(protseq,enzname)
%    glycopepfrag = digestSGP(protseqfilefullname,enzname)
%    glycopepfrag = digestSGP(protseqfilepath,protseqfilename,enzname)
%    glycopepfrag = digestSGP(protseq,enzname,digestoptions)
%    glycopepfrag = digestSGP(protseqfilename,enzname,digestoptions)
%    glycopepfrag = digestSGP(protseqfilepath,protseqfilename,enzname,...
%                             digestoptions)
%    glycopepfrag = digestSGP(filedirectory,protseqfilename,...
%      fixedptmfilename,variableptmfilename,outputfilename,...
%      enzname,MissedMax,MinPepLen,MaxPepLen,minPTM,maxPTM)
%
%    [glycopepfrag,gpdigeststring]=digestSGP(...)
% 
% Input:
%   protseq: a MATLAB structure containing protein sequence and header
%     fields
%  
%   enzname: a cell string with name of one or more enzymes
%   
%   protseqfilename: the name of a text file with protein sequence in FASTA
%    format. File containing multiple protein inputs are supported.
%   
%   protseqfilepath: protein sequence file path
%   
%   digestoptions: a MATLAB structure variable containing 9 fields
%     including "missedmax","minpeplen",'maxpeplen","minptm","maxptm",
%     "isoutputfile","outputfilename","varptm", and "fixedptm". Use
%     DIGESTOPTIONSET to create digestion options. Type
%     "DIGESTOPTIONSET" for help documentation.
%   
%   filedirectory:  input files are stored and also where final 'outputFile'
%     will be located. 
%
%   fixedptmfilename: the name of a text file with two space-delimited columns. 
%     First column lists aminoacid being modified. Second column has either the 
%     name of the modification or number(units of Da) if this is a custom modification.
%
%   variableptmfilename: the name of a text file with three space-delimited columns.
%     First column has name of modification or number (units of Da) if it is a
%     custom modification.Second column names one or more aminoacid(s) separated by
%     comma that is being modified or 'X' if modification does not take place at 
%     specific a.acid.Third column has specific comma separated protein sites where 
%     variable modifications occur. This is useful when studying site-specific glycosylation.
%
%   MissedMax: Maximum number of missed enzyme cleavage sites
%
%   MinPepLen: Minimum length of output peptide
%
%   MaxPepLen: Maximum length of output peptide
%
%   minPTM: Minimum number of PTM variable modifications in output peptide
%
%   maxPTM: Maximum number of PTM variable modifications in output peptide
%
%   OutputFileName: Output file with list of digested peptides.
%    
% Output:
%    glycopepfrag: cell array containing a list of glycan fragments
%    gpdigeststring: digestion result string
%
%
% Examples: 
%  
%   Example 1:
%       pepfrag = digestSGP('19Fc.txt','Trypsin');
%
%   Example 2:
%       peptide  =  peptideread('19Fc.txt');
%       pepfrag  =  digestSGP(peptide,'Trypsin');
%
%   Example 3:
%       pepfilepath = 'c:\glycopat\toolbox\test\data\Digest\test3';
%       glycopepfrag = digestSGP(pepfilepath,'19Fc.txt','Trypsin');
%
%   Example 4:
%       options           = digestoptionset;
%       varptm            = varptmread('variableptm.txt');
%       fixedptm          = fixedptmread('fixedptm.txt');
%       options           = digestoptionset(options,'fixedptm',fixedptm,'varptm',varptm);
%       peptide           = peptideread('19Fc.txt');
%       glycopepfrag      = digestSGP(peptide,'Trypsin',options);
%
%   Example 5:
%           options           = digestoptionset;
%           varptm            = varptmread('variableptm.txt');
%           fixedptm          = fixedptmread('fixedptm.txt');
%           options           = digestoptionset(options,'fixedptm',fixedptm,'varptm',varptm);
%           glycopepfrag      = digestSGP('19Fc.txt','Trypsin',options);
%
%   Example 6:
%           options         = digestoptionset('missedmax',1,'minpeplen',3,'maxptm',2);
%           varptm          = varptmread('variableptm.txt');
%           fixedptm        = fixedptmread('fixedptm.txt');
%           options         = digestoptionset(options,'fixedptm',fixedptm,'varptm',varptm);
%           glycopepfrag    = digestSGP('19Fc.txt','Gluc',options);
%
%   Example 7:
%          fptmopt          = fixedptmset('aaresidue','c','mod','i','mw',57.0214617);
%          vptmopt          = varptmset('aaresidue','M','mod','o','pos',0);
%          vptmopt          = varptmset(vptmopt,'aaresidue','X','mod','s','pos',[7,9,12]);
%          vptmopt          = varptmset(vptmopt,'aaresidue','X','mod','{n{h{s}}} ','pos',18);
%          options          = digestoptionset('missedmax',1,'minpeplen',3,'maxptm',2);
%          options          = digestoptionset(options,'fixedptm',fptmopt,'varptm',vptmopt);
%          glycopepfrag     = digestSGP('19Fc.txt','Gluc',options);
% 
%
% Children Function: varFor, cleaveProt.
%
%See also cleaveProt,digestoptionset,fixedptmset,varptmset,fixedptmread,
%  varptmread,peptideread.

% Author: Sriram Neelamegham, Gang Liu
% Date Lastly Updated: 11/24/2014 Modified by Gang Liu

%% HANDLING INPUT ARGUMENT
if(nargin==11)
    directory          = varargin{1};
    proteinfilename    = varargin{2};
    fixedfilename      = varargin{3};
    variablefilename   = varargin{4};
    outputfilename     = varargin{5};
    enzname            = varargin{6};
    MissedMax          = varargin{7};
    MinPepLen          = varargin{8};
    MaxPepLen          = varargin{9};
    minPTM             = varargin{10};
    maxPTM             = varargin{11};
    outputfullfilename = fullfile(directory,outputfilename);
    
    % Read protein sequence into either one string or cell array
    prot   = peptideread(directory, proteinfilename);
    % read fixed ptm
    fixedptmopt = fixedptmread(directory, fixedfilename);
    % read variable ptm
    varptmopt = varptmread(directory, variablefilename);
    % set up option
    digestopt    = digestoptionset('missedmax',MissedMax,'minpeplen',MinPepLen,'maxptm',maxPTM);
    digestopt    = digestoptionset(digestopt,'fixedptm',fixedptmopt,'varptm',varptmopt);
    digestopt    = digestoptionset(digestopt,'minptm',minPTM,'maxpeplen',MaxPepLen,...
        'isoutputfile','yes','outputfilename',outputfullfilename); 
elseif(nargin==2)
    if(~isstruct(varargin{1})&& ~ischar(varargin{1}))
        error('MATLAB:GlycoPAT:INCORRECTINPUTTYPE','WRONG TYPE OF INPUT ARGUMENT 1');
    end
    if(ischar(varargin{1}))
        proteinfilename = varargin{1};
        prot   = peptideread(proteinfilename);
    elseif(isstruct(varargin{1}))
        prot   =   varargin{1};          
    end
    
    enzname            =  varargin{2};
    digestopt          =  digestoptionset;
    
elseif(nargin==3)
    if(isstruct(varargin{3}))
        digestopt = varargin{3};
        if(ischar(varargin{1}))
            proteinfilename = varargin{1};
            prot   = peptideread(proteinfilename);
        elseif(isstruct(varargin{1}))
            prot    = varargin{1};  % read string            
        else
            error('MATLAB:GlycoPAT:INCORRECTINPUTTYPE','WRONG INPUT TYPE'); 
        end
        enzname  = varargin{2};
    elseif(ischar(varargin{3}))
        proteinfilepath       = varargin{1};
        proteinfilename       = varargin{2};
        prot                  = peptideread(proteinfilepath,proteinfilename);
        enzname               = varargin{3};
        digestopt             = digestoptionset;
    else
        error('MATLAB:GlycoPAT:INCORRECTINPUTTYPE','WRONG INPUT TYPE');
    end
elseif(nargin==4)
    proteinfilepath = varargin{1};
    proteinfilename = varargin{2};
    prot    = peptideread(proteinfilepath,proteinfilename);
    enzname         = varargin{3};
    digestopt       = varargin{4};
else
    error('MATLAB:GlycoPAT:WRONGINPUTNUMBER','WRONG NUMBER OF INPUTS');
end

%% 
nProt = length(prot);
if(nProt>1)
    for i = 1 : nProt
        protOriginal{i} = prot(i).sequence;
        header{i}= prot(i).header;
    end
else
    protOriginal = prot.sequence;
    header = prot.header;    
end

%% check if there are multiple peptides and if the peptide sequence is valid sequence
if iscellstr(protOriginal)
    nProt = length(protOriginal);
    for i = 1 : nProt
        if(~isempty(regexp(protOriginal{i},Aminoacid.getaacharexpr)))
            error('MATLAB:GlycoPAT:INCORRECTAMINOACIDSEQ','INCORRECT PEPTIDE SEQUENCE CHARACTER');
        end
    end
else
    if(~isempty(regexp(protOriginal,Aminoacid.getaacharexpr)))
        error('MATLAB:GlycoPAT:INCORRECTAMINOACIDSEQ','INCORRECT PEPTIDE SEQUENCE CHARACTER');
    end
end

%% check if input of enzyme can be found in our local protease database
% cleave Prot now with the enzymes
proteasedb    =  Protease.mklocaldb;
if(iscell(enzname))
    for k=1:length(enzname)
        if(~proteasedb.isKey(upper(enzname{k})))
            error('MATLAB:GlycoPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
        end
    end
else
    if(~proteasedb.isKey(upper(enzname)))
        error('MATLAB:GlycoPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
    end
end

%% check option properties
if ( ((~isempty(digestopt.missedmax)) && (~isnumeric(digestopt.missedmax)))) || ...
        ((~isempty(digestopt.minpeplen)) && (~isnumeric(digestopt.minpeplen))) || ...
        ((~isempty(digestopt.maxpeplen)) &&  (~isnumeric(digestopt.maxpeplen))) || ...
        ((~isempty(digestopt.minptm)) && (~isnumeric(digestopt.minptm)))  || ....
        ((~isempty(digestopt.maxptm)) && (~isnumeric(digestopt.maxptm)))
    error('MATLAB:GlycoPAT:INCORRECTTYPE','Wrong input type for the propertyname');
end

if(  ((~isempty(digestopt.isoutputfile)) && (~ischar(digestopt.isoutputfile))) || ...
        ((~isempty(digestopt.outputfilename)) &&(~ischar(digestopt.outputfilename))) || ...
        ((~isempty(digestopt.varptm)) &&(~isstruct(digestopt.varptm))) || ...
        ((~isempty(digestopt.fixedptm)) &&(~isstruct(digestopt.fixedptm))))
    error('MATLAB:GlycoPAT:INCORRECTTYPE','Wrong input type for the propertyname');
end

% This part reads protein sequence, fixed modifications, variable modifications and digests Prot based on
% enzyme specificity (Enzyme), number of mixed cleavages (MissedMax) and minimum peptide length
% (MinPepLen) from digestopt

%% assign fixed modifications, variable modifications and other option parameters to local variables
fixedptmopt            = digestopt.fixedptm;          % fixed  posttrasnlational modification
varptmopt              = digestopt.varptm;            % variable posttrasnlational modification
MinPepLen              = digestopt.minpeplen;         % Min. length of digested peptide; default: 4
MaxPepLen              = digestopt.maxpeplen;         % Max. length of digested peptide; default: 12
minPTM                 = digestopt.minptm;            % If the analysis is to be restricted to variable PTM only; default=0
maxPTM                 = digestopt.maxptm;            % Restrict number of variable PTM modifications; default=2
MissedMax              = digestopt.missedmax ;        % missed cleavage allowed; default: 0
isoutputfile           = digestopt.isoutputfile;      % output result and save as a local file; default: 'no'

%% Read fixed modifications. Output from this section is the structure 'fixed'
fixed=struct('old',[],'new',[]);
if(~isempty(fixedptmopt))
    for i = 1 : length(fixedptmopt)
        fixed.old{i}= fixedptmopt.aaresidue{i,1};
        fixed.new{i}= [fixedptmopt.aaresidue{i,1} '<' fixedptmopt.mod{i,1} '>'];
    end
end

% [fixed.old,fixed.new]=textread(fixedPTM,'%s %s');% Read fixed modifications
startChar=97;                                      % Modify with char(97)= 'a'
for i=1:length(fixed.old)
    % fixed.replace(i)=cellstr(char(startChar));     % This is the temporary replacement character for fixed.old
    fixed.replace(i)={char(startChar)}; 
    startChar=startChar+1;
end
LastFixedChar=startChar-1;                         % This is the char of the last fixed mod.

%% Read variable PTM info. into cell array varData
%  fid     = fopen(variablePTM);
%  varData = textscan(fid, '%s%s%s');
%  fclose(fid);
if(~isempty(varptmopt))
    varData{1} = varptmopt.mod;
    varData{2} = varptmopt.aaresidue;
    varData{3} = varptmopt.pos;
else
    varData{1}=[];
    varData{2}=[];
    varData{3}=[];
end

%% process variable ptm
if isempty(varData{1})
    var.old={};
    var.letter={};
    var.number={};
    var.replaceWith={};
    modTable=[];
    modAacid=[];
    NXSTreplace='';
else
    [var,modAacid,modTable,NXSTreplace]=...
        formatVariableNew(varData,startChar);  % consolidate varData into modAacid, modTable & var structures
end

if(isfield(digestopt,'dispprog'))
    dispprogress = digestopt.dispprog;
else
    dispprogress = false;
end

if(dispprogress)
    count=0;
    h=waitbar(0,'Please wait...');
end

% Now do the analysis, one protein at a time
counttot=0;
for np=1:nProt
    if iscellstr(protOriginal)
        TempProt     = char(protOriginal(np));
        FASTAhead{np} = ['>',char(header(np))];
    else
        TempProt     = protOriginal;
        FASTAhead{1} = ['>',header];
    end
    
    % Make NST modifications since these are co-translated. They occur before fixed mod.
    % Sometimes there can be a site like 'NKT'. This would be N-linked but may get subsequently
    % cleaved at the K site by Trypsin. Thus NST modification is done before proteolysis
    arra=regexp(TempProt,'N[A-Z][ST]');
    if ~isempty(NXSTreplace)  % only done if N=glyans are present
        for k=1:length(arra)
            %TempProt=strcat(TempProt(1:arra(k)-1),char(NXSTreplace),TempProt(arra(k)+1:end));
            TempProt=[TempProt(1:arra(k)-1),char(NXSTreplace),TempProt(arra(k)+1:end)];
        end
    end
    
    for k=1:length(fixed.old)
        TempProt=regexprep(TempProt, char(fixed.old(k)), char(fixed.replace(k))); % Make fixed modifications
    end
    
    ProdArray{np}=cleaveProt(char(TempProt),enzname,MissedMax,MinPepLen,MaxPepLen); % calls the cleavage function
    counttot = counttot + length(ProdArray{np});
end

counttot=counttot+1;
if(dispprogress)
    count  =  count + 2;
    waitbar(count/counttot,h);
end

finalallprod=[];
% disp(['The number of the proteins is:',num2str(np)]);

for np=1:nProt
    Prod = ProdArray{np};
    % fixed modifications at site of digestion will inhibit cleavage
    
    % Variable modifications are applied on peptide products and not the original protein since this can
    % restrict enzymatic digestion if the site of variable modification is
    % also a site of protease digestion.
    % Here, the data available in 'var' is applied to modify all Prod
    %% commented by Gang 
     finalProd = cell(0,1);
    %% commented by Gang  
    
    if(isempty(Prod))
        if(dispprogress)
            waitbar(counttot/counttot,h);
            close(h);
            errordlg('MATLAB:GLYCOPAT:PROTEINNOTDIGESTED','PROTEIN CAN NOT BE DIGESTED');
        end        
    end
    
    ProdOld=Prod.pep;
    Prod=applyVarMod(Prod,var);
    % Analysis is performed on each peptide Prod individually
    % Part A has to do with classifying all the modifications for a given
    % peptide. This first part creates the Perm matrix that is used in Part B.
    % Here, it is ensured that no peptide has more than maxPTM modifications
    for i=1:length(Prod.pep)
        i;                                                      % Display for command window to follow computation progress
        str=char(Prod.pep(i));                                  % peptide name read into string (displayed in command window)
        originalPep=char(ProdOld(i));
        AA=cell2mat(Prod.pep(i));                                 % These two lines prevents variable mod. at the N-terminus (optional to include)
        str=[AA(1:length(AA)-1),originalPep(length(AA))];   % These two lines prevents variable mod. at the N-terminus (optional to include)
        % str=strcat(AA(1:length(AA)-1),originalPep(length(AA)));
        aacidPos=[];
        aacidPos=find(double(str)>LastFixedChar);               % Find aacid positions with variable modifications
        aacidName=[];
        mod=[];
        aacidNMod=[];
        for j=1:length(aacidPos)
          %% edited by Gang Liu
            % aacidName=[aacidName, cellstr(str(aacidPos(j)))];    % identify of amino acid at site of modification
            aacidName=[aacidName, {str(aacidPos(j))}];  % edited by Gang LIu
          %% edited by Gang Liu
            
            m=find(char(modAacid)==str(aacidPos(j)));            % index for modification
            interim=find(~cellfun(@isempty,modTable(m,:)));
            aacidNMod=[aacidNMod, length(interim)];     % count how many modifications at each site
        end
        nPos=length(aacidPos);  % count how many modification sites
        Perm=[];
        if maxPTM==0
            Perm=ones(nPos,1)';                 % return the original peptide
        elseif ((nPos<=maxPTM)&&(nPos>0))
            Perm=permutation(aacidNMod+1);      % +1 is added in order to include no modification condition
        elseif((nPos>maxPTM)&&(nPos>0))
            c=combnk(1:nPos,maxPTM);            % Find all combinations of modifications
            sz1=size(c);
            for k=1:sz1(1)
                for l=1:maxPTM
                    nPosVec(l)=aacidNMod(c(k,l));
                end
                YY=permutation(nPosVec+1);
                sz2=size(YY);
                for l=1:sz2(1)
                    XX(l,1:length(aacidNMod))=1;
                    for m=1:maxPTM
                        XX(l,c(k,m))=YY(l,m);
                    end
                end
                Perm=[Perm;XX];
                XX=[];
            end
            Perm=unique(Perm,'rows');
        end
        % Part B uses data in Perm to replace amino acids in Prod.pep in order to
        % obtain the finalProd. Here it is ensured that no. of modifications >= minPTM
        if isempty(aacidPos)
            str;
          %%%%% edited by Gang Liu
            % finalProd=[finalProd;cellstr(str)];                 % There are no variable modifications to consider if aacidPos is empty
            % finalProd=[finalProd;{str}];  % edited by Gang
            % finalProd=[finalProd;{str}];
            finalProd{end+1}=str;
         %%%%% edited by Gang Liu
        
        else
            % ct=1;
            for j=1:size(Perm,1)
                nPTM=length(find(Perm(j,:)>1));
                if ((nPTM>=minPTM)||(all(Perm(j,:)==1)))         % make sure that the number of PTMs is more than minPTM, provided its not the original peptide
                    pepX='';
                    for k=1:length(str)
                        %%%%% edited by Gang Liu
%                            if (any(aacidPos==k))
%                             pos=find(aacidPos==k);
%                             modNumber=Perm(j,pos);
                        pos=find(aacidPos==k);
                        if(~isempty(pos))
                       %%%%% edited by Gang Liu
                            
                            modNumber=Perm(j,pos);
                            %%%%% edited by Gang Liu
                            
                          %%%%% edited by Gang Liu
                            modAA = find(strcmp(str(k),modAacid));
                            % modAA=find(cell2mat(modAacid)==str(k));original codes
                        %%%%% edited by Gang Liu
                            
                            if (modNumber==1)
                                intPTM='';
                            else
                                intPTM=modTable(modAA,modNumber-1);
                            end
                        else
                            intPTM='';
                        end
                        intProd = [originalPep(k),char(intPTM)];
                        pepX    = [pepX,intProd];
                    end
                 %% edited by Gang Liu
                      % finalProd=[finalProd;cellstr(pepX)]; % commented by Gang Liu
                    % finalProd=[finalProd;{pepX}];
                    finalProd{end+1}=pepX;
                 %% edited by Gang Liu
                    
                    %   else
                    %finalProd=[finalProd;cellstr(str)];
                end
            end
        end
        
        if(dispprogress)
            count  =  count + 1;
            waitbar(count/counttot,h);
        end
    end
    
    % finally replace the fixed modifications and NST with the real ones
    for j=1:length(finalProd)
        for i=1:length(fixed.old)
            finalProd{j} = regexprep(char(finalProd(j)),fixed.replace(i),fixed.new(i));            
        end
        finalProd{j}=(regexprep(char(finalProd(j)),NXSTreplace,'N'));
    end
    
    finalProd        = unique(finalProd);   
    finalallprod{np} = finalProd';
end

%% write output to the file and the string
if(strcmpi(isoutputfile,'yes') && (~isempty(digestopt.outputfilename)))
    outputfilfullname = digestopt.outputfilename;
    fileID = fopen(outputfilfullname,'w+');        
    outputresult2file(fileID,nProt,FASTAhead,protOriginal,enzname,fixedptmopt...
    ,varptmopt,minPTM,maxPTM,MinPepLen,MaxPepLen,MissedMax,finalallprod)
    fclose(fileID);
end

if(length(finalallprod)==1)
    finalallprod = finalallprod{1};
end

if(nargout==2)
    varargout{1} = outputresult2string(nProt,FASTAhead,protOriginal,enzname,fixedptmopt...
    ,varptmopt,minPTM,maxPTM,MinPepLen,MaxPepLen,MissedMax,finalallprod);
end

if(dispprogress)
    close(h);
end

end

function [var,modAacid,modTable,NXSTreplace]=formatVariableNew(varData,startChar)
NXSTreplace='';
var.old={};
count=1;

% First deal with varData{2}, the amino acid characters
for i=1:length(varData{2})
    if ~(strcmp(varData{2}(i),'X'))
        aa=char(varData{2}(i));
        n=(size(aa,2)+1)/2;
        for j=1:n
            tf=false;
            for k=1:length(var.old)
                
              %% edited by Gang
%                 if char(cellstr(aa(2*j-1)))==char(var.letter(k))
                if strcmpi(aa(2*j-1),var.letter(k))
              %% edited by Gang    
                    
                    var.replaceWith{k}=[var.replaceWith{k},varData{1}(i)];
                    tf=true;
                end
            end
            if (~tf)
               %  var.old(count)=cellstr(char(startChar));
               %  var.replaceWith(count)=varData{1}(i);
               %  var.letter(count)=cellstr(aa(2*j-1));
               %  var.number(count)=num2cell(0);
                var.old(count)={char(startChar)};
                var.replaceWith(count)=varData{1}(i);
                var.letter(count)={aa(2*j-1)};
                var.number(count)={0}; %%% edited by Gang
                startChar=startChar+1;
                firstChar=char(varData{1}(i));
                if ((char(var.letter(count))=='N') && (firstChar(1)=='{'))
                    NXSTreplace=var.old(count);
                end
                count=count+1;
            end
        end
    end
end

% First deal with varData{3}, the position based modifications (amino acid
% based or position based)
%  try
for i=1:length(varData{3})
    %     if (char(varData{3}(i))~='0')
    %         str  = cell2mat(varData{3}(i));
    %         numb = str2num(str);
    %% edited by Gang Liu
%      numb = varData{3}(i);
%      numb = cell2mat(numb);
       numb = varData{3}{i};
    %% edited by Gang Liu
    
    if( length(numb)>1) ||( length(numb)==1 && numb(1)~=0 )
        %             numb = varData{3};
        %             numb = num{:};
        % n    = (size(numb,2)+1)/2;
        for j=1:length(numb)
            tf=false;
            for k=1:length(var.old)
              %% edited by Gang Liu
%                 if numb(j)==cell2mat(var.number(k))
                 varnum = var.number(k);
                 if numb(j)==varnum{:}

              %% edited by Gang Liu    
              
                    var.replaceWith{k}=[var.replaceWith{k},varData{1}(i)];
                    tf = true;
                end
            end
            
            if (tf == false)
              %% edited by Gang
                % var.old(count)=cellstr(char(startChar));
                var.old(count)={(char(startChar))};
              %% edited by Gang
                
                var.replaceWith(count)=varData{1}(i);
                var.letter(count)={'X'};
                var.number(count)=num2cell(numb(j));
                startChar=startChar+1;
                count=count+1;
            end
        end
    end
end
%  catch
%      disp('error');
%  end

modAacid=var.old';
for i=1:length(var.replaceWith)
    if iscell(var.replaceWith{i})
        counter=length(var.replaceWith{i});
        for j=1:counter
            modTable(i,j)=var.replaceWith{i}(j);
        end
    else
       %% edited by Gang Liu
        % modTable(i,1)=cellstr(var.replaceWith{i});
        modTable(i,1)={var.replaceWith{i}};
       %%
    end
end
end

function [var,modAacid,modTable,NXSTreplace]=formatVariable(varData,startChar)
NXSTreplace='';
% varTwo=cell2mat(varData{2});
tf=false;
for i=1:length(varData{2})
    %% edited by Gang Liu
     str=cell2mat(varData{1}(i));                     % To check if the modification is a glycan
    
    %% edited by Gang Liu
    
    if (i==1)
         %% edited by Gang Liu
        % var.old(i)=cellstr(char(startChar));
        var.old(i)={(char(startChar))};
       %% edited by Gang Liu
         
        var.replaceWith(i)=varData{1}(i);
        var.letter(i)=varData{2}(i);
        var.number(i)=varData{3}(i);
        startChar=startChar+1;
        count=1;
    else
        for j=1:length(var.old)                      % If this amino acid has been modified before, we simply add 1 element to the modTable
            varData{3}(i)
            var.number(j)
            ith=str2int(cell2mat(varData{3}(i)));
            jth=str2int(cell2mat(var.number(j)));
            if (all(cell2mat(varData{2}(i))==cell2mat(var.letter(j)))&&(length(ith)==length(jth))...
                    &&any(ismember(ith,jth))~=0)
                var.replaceWith{j}=[var.replaceWith{j},varData{1}(i)];
                tf=true;
            end
        end
        if (tf==true)
            tf=false;
        else                    % if this aminio acid/position was no modified before, then add an entire new line
            count=count+1;
          %% edited by Gang
            % var.old(count)=cellstr(char(startChar));
            var.old(count)={(char(startChar))};
            %% edited by Gang
            
            var.replaceWith(count)=varData{1}(i);
            var.letter(count)=varData{2}(i);
            var.number(count)=varData{3}(i);
            startChar=startChar+1;
        end
    end
    NXST=(char(varData{1}(i)));  % store the repalcement character if it is an N-X-S/T consensus sequence
    if (all(char(varData{2}(i))=='N') && (NXST(1)=='{'))
        NXSTreplace=var.old(count);
    end
end
modAacid=var.old';
for i=1:length(var.replaceWith)
    if iscell(var.replaceWith{i})
        counter=length(var.replaceWith{i});
        for j=1:counter
            modTable(i,j)=var.replaceWith{i}(j);
        end
    else
        %% edited by Gang Liu
        % modTable(i,1)=cellstr(var.replaceWith{i});
         modTable(i,1)={(var.replaceWith{i})};
        %% edited by Gang
    end
end
end

function Prod=applyVarMod(Prod,var)
for i=1:length(var.old)
    aa=char(var.letter(i));    % This allows the incorporation of variable modifications in comma-delimited form
    Numberaa=(length(aa)+1)/2;  % number of amino acids with identical modifications
    for j=1:Numberaa
        specificAA=aa(2*j-1);
        boo1=true;
        tempStr=char(var.replaceWith{i}(1));
        if ((specificAA=='N')&&(tempStr(1)=='{'))
            boo1=false;                                    % This is an N-glycan at N-X-S/T
        end
        if ((specificAA~='X')&&(boo1))    % if var.letter is not 'X' and this is not an NXS/T site
            %% edited by Gang
              varoldi = var.old(i);
              Prod.pep=regexprep(Prod.pep,specificAA,varoldi{:});  % modification at fixed aacid positions
             %% edited by Gang
        end
    end
    num=cell2mat(var.number(i));         % includes variable modifications when var.num ~=0
    %  num=str2num(str);
    if any(num~=0)
        for j=1:length(num)
            for k=1:length(Prod.pep)
                if ((num(j)>=Prod.start(k))&&(num(j)<=Prod.fin(k)))  % excludes now includes C-terminus modifications
                  %% edited by Gang Liu
                  % ProdTemp=cell2mat(Prod.pep(k));
                    ProdTemp = Prod.pep(k);
                    ProdTemp = ProdTemp{:};
                  %% edited by Gang Liu
                    
                    insertPos=num(j)-Prod.start(k);
                    ProdTemp=[ProdTemp(1:insertPos),cell2mat(var.old(i)),ProdTemp(insertPos+2:end)];
                    %   Prod.pep(k)=mat2cell(ProdTemp);
                    Prod.pep(k) = {ProdTemp};
                end
            end
        end
    end
end
end

function Perm=permutation(F)
j=length(F);     % number of places
i=max(F);        % maximum value
Perm=varFor([],i,j);
[a1,a2]=size(Perm);
for k=1:j
    l=0;
    while (l<a1)
        l=l+1;
        if Perm(l,k)>F(k)
            Perm(l,:)=[];
            l=l-1;
        end
        [a1,a2]=size(Perm);
    end
end
Perm=unique(Perm,'rows');
end

function outputstr = outputresult2string(nProt,FASTAhead,protOriginal,enzname,fixedptmopt...
    ,varptmopt,minPTM,maxPTM,MinPepLen,MaxPepLen,MissedMax,finalallprod)
    outputstr ='';    
    % print complete protein sequence
    if (nProt>1)
        for i = 1 : nProt
            newstr=sprintf('sequence %i: \n%s\n',i,protOriginal{i});
            outputstr = [outputstr,newstr];
        end
    else
        newstr = sprintf('sequence 1: \n%s\n',protOriginal);
        outputstr = [outputstr,newstr];
    end
    
    % print enzyme name
    proteasedb    =  Protease.mklocaldb;
    
    if(iscell(enzname))
        for k=1:length(enzname)
            if(proteasedb.isKey(upper(enzname{k})))
                   ezncleaveexpr =  proteasedb(upper(enzname{k}));
                   newstr = sprintf('Enzyme %i:  %s (name) %s (cleavage pattern)\n', k, ...
                    enzname{k},ezncleaveexpr);
                   outputstr = [outputstr,newstr];
            else
                error('MATLAB:GlycoPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
            end
        end
    else
        if(proteasedb.isKey(upper(enzname)))
            ezncleaveexpr =  proteasedb(upper(enzname));
            newstr=sprintf('Enzyme %s: (name) %s (cleavage pattern)\n', ...
                    enzname,ezncleaveexpr);  
            outputstr = [outputstr,newstr];
        else
            error('MATLAB:GlycoPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
        end
    end
    
    % print fixed ptm parameter
    if(~isempty(fixedptmopt))
        for i = 1 : length(fixedptmopt)
            newstr=sprintf('Fixed ptm: %s %s \n',fixedptmopt.aaresidue{i,1},fixedptmopt.mod{i,1});        
            outputstr = [outputstr,newstr];        
        end
    end
    
    % print variable ptm parameter
    if(~isempty(varptmopt))
        for i = 1 : length(varptmopt.aaresidue)
             newstr=sprintf('Variable ptm: %s %s %s\n',varptmopt.aaresidue{i,1},...
                varptmopt.mod{i,1},num2str(varptmopt.pos{i,1}));
             outputstr = [outputstr,newstr];    
        end
    end
    
    % printf minPTM,maxPTM,missedMax,minPepLen,maxPeplen
    newstr=sprintf('minPTM : %i\n',minPTM);
    outputstr = [outputstr,newstr];

    newstr=sprintf('maxPTM : %i\n',maxPTM);
    outputstr = [outputstr,newstr];

    newstr=sprintf('minPepLen : %i\n',MinPepLen);
    outputstr = [outputstr,newstr];
    
    newstr=sprintf('maxPepLen : %i\n',MaxPepLen);
    outputstr = [outputstr,newstr];
    
    newstr=sprintf('MissedMax : %i\n',MissedMax);
    outputstr = [outputstr,newstr];

    
    % print digestion result to the file
 if(nProt>1)
   for i =1: nProt
     newstr    = sprintf('%s\n',FASTAhead{i});
     outputstr = [outputstr,newstr];
   
     finalProd = finalallprod{i};
     for j= 1 : length(finalProd)
          newstr    = sprintf('%s\n',char(finalProd(j)));
          outputstr = [outputstr,newstr]; 
     end
   end
 elseif(nProt==1)
     newstr    = sprintf('%s\n',FASTAhead{1});
     outputstr = [outputstr,newstr];
     for j= 1 : length(finalallprod)
          newstr    = sprintf('%s\n',char(finalallprod(j)));
          outputstr = [outputstr,newstr]; 
     end     
 end
end

function outputresult2file(fileID,nProt,FASTAhead,protOriginal,enzname,fixedptmopt...
    ,varptmopt,minPTM,maxPTM,MinPepLen,MaxPepLen,MissedMax,finalallprod)
  % print complete protein sequence
    if (nProt>1)
        for i = 1 : nProt
            fprintf(fileID,'sequence %i : %s\n',i,protOriginal{i});
        end
    else
        fprintf(fileID,'sequence 1: %s\n',protOriginal);
    end
    
    % print enzyme name
    proteasedb    =  Protease.mklocaldb;
    
    if(iscell(enzname))
        for k=1:length(enzname)
            if(proteasedb.isKey(upper(enzname{k})))
                   ezncleaveexpr =  proteasedb(upper(enzname{k}));
                   fprintf(fileID,'Enzyme %i:  %s (name) %s (cleavage pattern)\n', k, ...
                    enzname{k},ezncleaveexpr);           
            else
                error('MATLAB:GlycoPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
            end
        end
    else
        if(proteasedb.isKey(upper(enzname)))
            ezncleaveexpr =  proteasedb(upper(enzname));
            fprintf(fileID,'Enzyme:  %s (name) %s (cleavage pattern)\n', ...
                enzname,ezncleaveexpr);       
        else
            error('MATLAB:GlycoPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
        end
    end
    
    % print fixed ptm parameter
    for i = 1 : length(fixedptmopt)
        fprintf(fileID,'Fixed ptm: %s %s \n',fixedptmopt.aaresidue{i,1},fixedptmopt.mod{i,1});         
    end
    
    % print variable ptm parameter
    for i = 1 : length(varptmopt.aaresidue)
        fprintf(fileID,'Variable ptm: %s %s %s\n',varptmopt.aaresidue{i,1},...
            varptmopt.mod{i,1},int2str(varptmopt.pos{i,1}));       
    end
    
    % printf minPTM,maxPTM,missedMax,minPepLen,maxPeplen
    fprintf(fileID,'minPTM : %i\n',minPTM);
    fprintf(fileID,'maxPTM : %i\n',maxPTM);
    fprintf(fileID,'minPepLen : %i\n',MinPepLen);
    fprintf(fileID,'maxPepLen : %i\n',MaxPepLen);
    fprintf(fileID,'MissedMax : %i\n',MissedMax);
         
    % print digestion result to the file
   for i =1: length(finalallprod)
     fprintf(fileID,'%s\n',FASTAhead{i});
      
     finalProd = finalallprod{i};
     for j= 1 : length(finalProd)
          fprintf(fileID,'%s\n',char(finalProd(j)));
     end
   end
end
