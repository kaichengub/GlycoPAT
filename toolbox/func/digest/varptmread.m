function [varptmopt,varargout] = varptmread(varargin)
%VARPTMREAD: Load variable option for peptide posttranlational
%  modfication.
%
% Syntax: 
%   vptmopt = varptmread(varptmfilefullname)
%   vptmopt = varptmread(varptmfildir,varptmfilename)
%   [vptmopt,vptmoptstring]= varptmread(...)
%
% Input: 
%    varptmfilefullname: the full name for an mzXML file including its path 
%    varptmfildir: the name of the file directory
%    varptmfilename: the name of an mzXML file 
%   Note: if the file "variableptm.txt" is stored in the folder 
%      'C:\glycopat\toolbox\demo\fetuinvptm_bitritet.txt',
%      the "varptmfilename" is 'fetuinvptm_bitritet.txt'
%      the  "varptmfildir" is 'C:\glycopat\toolbox\demo'
%
%  Output: 
%    vptmopt: a MATLAB structure variable containing three fields:i) aaresidue;
%      ii) mod and iii) pos.
%    vptmoptstring: MATLAB string
%  
% Examples: 
% 
%  Example 1:
%        vptmopt = VARPTMREAD('C:\glycopat\toolbox\test\demo\fetuinvptm_bitritet.txt');
%        disp(vptmopt)
%        Answer: 
%            aaresidue:{16x1 cell}
%            mod:{16x1 cell}
%            pos:{16x1 cell}
%  Example 2:
%        filedir = 'C:\glycopat\toolbox\test\demo';
%        vptmopt = VARPTMREAD(filedir,'fetuinvptm_bitritet.txt');
%
%  Example 3:
%        [vptmopt,vptmoptstring] = VARPTMREAD('fetuinvptm_bitritet.txt');
%
% See also readmzXML,readmzDTA,fixedptmread,peptideread,varptmset,fixedptmset

% Author: Gang Liu
% Date Lastly Updated: 08/04/14 

narginchk(1,2);

if(nargin==1)
    vptmfullfilename  = varargin{1};
elseif(nargin==2)
    vptmfilepath       = varargin{1};
    vptmfilefilename   = varargin{2};
    vptmfullfilename   = fullfile(vptmfilepath,vptmfilefilename);
end

fid = fopen(vptmfullfilename);
if(fid==-1) % if file not found
    vptmfullfilename = which(vptmfullfilename);
    if(isempty(vptmfullfilename))
        error('MATLAB:GLYCOPAT:FILENOTFOUND','file is not found in the search path');
    end
end
fclose(fid);

[modif,aaresidue,pos]=textread(vptmfullfilename,'%s %s %s');
varptmopt = struct('aaresidue',[],...
    'mod',[],'pos',[]);
varptmopt.aaresidue = aaresidue;

pat = '<[a-z_A-Z]>';
pat_name = '<(?<mod>[a-z_A-Z])>';

nummod = length(aaresidue);

for i = 1 : nummod
    modifstring                = modif{i,1};
    modstringfound             = regexp(modifstring,pat,'once');
    isglycanmod                = isempty(modstringfound);
    
    if(~isglycanmod)
        varoptmod              =  regexp(modifstring,pat_name,'names');
        
        % check modification letter
        if (length(varoptmod.mod)==1)
            if(~isempty(regexpi(varoptmod.mod,'[^osicpabqefnc]','once')))
                error('MATLAB:GlycoPAT:NOTVALIDMODCHAR','NOT VALID MODIFICATION LETTER');
            end
        else
            error('MATLAB:GlycoPAT:NOTVALIDMODCHAR','NOT VALID MODIFICATION LETTER');
        end
        
        varptmopt.mod{i,1}       =  ['<',varoptmod.mod];
        varptmopt.mod{i,1}       =  [varptmopt.mod{i,1},'>'];
    else
        varptmopt.mod{i,1}       =  modifstring;
    end
    
    % posstring = pos{i,1};
    varptmopt.pos{i,1}           = str2num(pos{i,1});
end

for i = 1 : nummod
    % check amino acid letter
    if (length(varptmopt.aaresidue{i,1})<1) || ~isempty(regexpi(varptmopt.aaresidue{i,1},...
            '[^ARNDCQEGHILKMFPSTWYVBZX,]'))
        error('MATLAB:GlycoPAT:NOTVALIDAACHAR','NOT VALID AMINO ACID CHARACTER');
    end
    
    % check position
    if((~isnumeric(varptmopt.pos{i,1})) || (sum(isnan(varptmopt.pos{i,1}))>=1))
        error('MATLAB:GlycoPAT:NOTVALIDPOS','NOT VALID MODIFICATION POSITION');
    end
    
    % check position
    if(isempty(varptmopt.pos{i,1}))
        error('MATLAB:GlycoPAT:NOTVALIDPOS','NOT VALID MODIFICATION POSITION');
    end
    
end

%% output variable ptm string if necessary
if(nargout==2)
    varargout{1}=fileread(vptmfullfilename);
end


