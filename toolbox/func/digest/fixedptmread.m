function [fixedptmopt,varargout] = fixedptmread(varargin)
%fixedptmread: Load the option for fixed peptide post-translational
%  modification.
%  
% Syntax:
%    fptmopt = fixedptmread(fixedptfilefullname)
%
%    fptmopt = fixedptmread(fixedptfiledir,fixedptfilename)
%
%    [fptmopt,fptmstring] = fixedptmread()
%
% Input: 
%    fixedptmfilefullname: the full file name including the path.     
%    fixedptmfiledir: the directory where the fixed ptm file is stored.
%    fixedptmfilename: the file name without the path.
%  (Note: if the file "fixedptm.txt" is stored in the folder 
%      'c:\glycopat\toolbox\test\demo\fixedptm.txt',
%      the "fixedptfilefullname" is 'c:\glycopat\toolbox\test\demo\fixedptm.txt'
%      the "fixedptfiledir" is 'c:\glycopat\toolbox\test\demo'
%      the "fixedptfilename" is 'fixedptm.txt')
% 
% Output: 
%    fptmopt: a Matlab structure containing three fields: i) aaresidue; ii)
%     mod; and iii) mw.
%    
%    fptmstring: Matlab string
%
% Examples 
%    Example 1. 
%      fptmopt = fixedptmread('c:\glycopat\toolbox\test\demo\fixedptm.txt');
%      disp(fptmopt)
%      Answer: 
%           aaresidue: {'C'}
%           mod: {'i'}
%           mw: {[57.0214617]}
%    
%   Example 2. 
%      filedir = 'c:\glycopat\toolbox\test\demo';
%      fptmopt = fixedptmread(filedir,'fixedptm.txt');
%   
%   Example 3: 
%     [fptmopt,fptmstring] = fixedptmread('fixedptm.txt');
%     disp(fptmstring)
%     Answer: 
%       C C<i>
%
% See also: readmzXML,readmzDTA,varptmread,peptideread,varptmset,fixedptmset.

% Author: Gang Liu 
% Date Lastly Updated: 08/10/14

narginchk(1,2);

if(nargin==1)
    fptmfullfilename = varargin{1};
elseif(nargin==2)
    fptmfilepath = varargin{1};
    fptmfilefilename = varargin{2};
    fptmfullfilename = fullfile(fptmfilepath,fptmfilefilename);
end

fid = fopen(fptmfullfilename);
if(fid==-1) % if file not found
    fptmfullfilename = which(fptmfullfilename);
    if(isempty(fptmfullfilename))
        fclose(fid);
        error('MATLAB:GLYCOPAT:FILENOTFOUND','file is not found in the search path');
    end
end
fclose(fid);

[fixed.old,fixed.new] = textread(fptmfullfilename,'%s %s');
if(isempty(fixed.old))
    fixedptmopt=[];
    if(nargout==2)
      varargout{2} = '';
    end
    return;
end

fixedptmopt = struct('aaresidue',[],...
    'mod',[],'mw',[]);
pat = '(?<aa>[a-z_A-Z])<(?<mod>[a-z_A-Z])>';

for i = 1 : length(fixed.new)
    fixedptmoptstring          = fixed.new{i,1};
    fixoptnames                = regexp(fixedptmoptstring,pat,'names');
    
    % check amino acid letter 
    if (length(fixoptnames.aa)~=1) || ~Aminoacid.isaastring(fixoptnames.aa)
      error('MATLAB:GLYCOPAT:NOTVALIDAACHAR','NOT VALID AMINO ACID CHARACTER');
    end
    fixedptmopt.aaresidue{i,1} = fixoptnames.aa;
    
    % check modification letter
    if (length(fixoptnames.mod)==1)  
        if(~isempty(regexpi(fixoptnames.mod,'[^abcefinopqs]','once')))
           error('MATLAB:GLYCOPAT:NOTVALIDMODCHAR','NOT VALID MODIFICATION LETTER');
        end
    else
        error('MATLAB:GLYCOPAT:NOTVALIDMODCHAR','NOT VALID MODIFICATION LETTER');
    end
    fixedptmopt.mod{i,1}  = fixoptnames.mod;
    fixedptmopt.mw{i,1} = ptm(fixoptnames.mod);
end

%% check fixed modification 
if(nargout==2)
    fptmoptstring=[];
    newline = sprintf('\n','');
        for i = 1: length(fixed.new)
            if(i>1)
             fptmoptstring=[fptmoptstring,newline];
            end
            fptmoptstring=[fptmoptstring,fixed.old{i,1}];
            fptmoptstring=[fptmoptstring,' '];
            fptmoptstring=[fptmoptstring,fixed.new{i,1}];
        end
    varargout{1} = fptmoptstring;
end

end

