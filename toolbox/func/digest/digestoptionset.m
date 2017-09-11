function digestopt = digestoptionset(varargin)
%DIGESTOPTIONSET: Create/alter options for glycopeptide digestion
%
% Syntax: 
%   digestopt = DIGESTOPTIONSET('NAME1',VALUE1,'NAME2',VALUE2,...) creates an
%     option(s) structure for properties with the specified
%     values. Any unspecified properties have default values. Case is
%     insensitive for the filed names.
%
%   digestopt = DIGESTOPTIONSET(OLDDIGESTOPT,'NAME',VALUE1,...) replaces an existing
%      option structure OLDDIGESTOPT.
%
%   digestopt = DIGESTOPTIONSET with no input arguments creates an options structure with
%       all filed names and their default values
%
%  digestopt properties:
%
%    missedmax  -  missed cleavage allowed [default=0]
%
%    minpeplen - Min. length of digested peptide [default=04]
%
%    maxpepLen - Max. length of digested peptide [default=30]
%
%    minptm - minimal PTM (posttranslational modifications) [default=0]
%
%    maxptm - maximal PTM  [default=2]
%
%    isoutputfile - output full file name [gui|no|yes (default='no')]
%
%    outputfilename - output file name [default='digestedpep.txt']
%
%    varptm - variable posttranslational modification option [no default];
%
%    fixedptm - fixed posttranslational modification option [no default];
%
%
% Examples: 
%   Example 1:   digestopt = DIGESTOPTIONSET;
%
%   Example 2:   digestopt = DIGESTOPTIONSET('missedmax',1,'minpeplen',3,'maxptm',2);
%
%   Example 3:   digestopt = DIGESTOPTIONSET('missedmax',1,'minpeplen',3,'maxptm',2);
%            newdigestopt = DIGESTOPTIONSET(digestopt,'minptm',1);
%
%
% See also varptmset, fixedptmset, digestSGP, cleaveProt.

% Author: Gang Liu
% Date Lastly Updated: 08/03/14

% initialization to default values
digestopt = struct('missedmax',0,'minpeplen',4,'maxptm',2,...
        'maxpeplen',30,'minptm',0,'isoutputfile','no','outputfilename',...
        'digestedpep.txt','varptm',[],'fixedptm',[]);

if(nargin==0)
    return
end

optionfieldnames = char( 'missedmax', ...
    'minpeplen',  'maxptm','maxpeplen',  'minptm',...
    'isoutputfile','varptm','fixedptm','outputfilename');
numFields  =size(optionfieldnames,1);
names        = cellstr(lower(optionfieldnames));

for j = 1:numFields
    digestopt.(deblank(optionfieldnames(j,:))) = [];
end

i = 1;
while i <= nargin
    arg = varargin{i};
    if  ischar(arg)                 % arg is an option name
        psIndex = i;               %  index starting position for name-value pairs
        break;
    end
    if ~isempty(arg)                      % [] is a valid options argument
        
        if ~isa(arg,'struct')
            error('MATLAB:GlycoPAT:NoPropNameOrStruct','Not A Valid Name For the Argument');
        end
        
        for j = 1:numFields
            if any(strcmpi(fieldnames(arg),deblank(optionfieldnames(j,:))))
                val = arg.(deblank(optionfieldnames(j,:)));
            else
                val = [];
            end
            
            if ~isempty(val)
                digestopt.(deblank(optionfieldnames(j,:))) = val;
            end
            
        end
    end
    i = i + 1;
end

% A finite state machine to parse name-value pairs.

% check inputs are name-value pairs
if rem(nargin-psIndex+1,2) ~= 0
    error('MATLAB:GlycoPAT:MISMATCHOPTION','Arg Name Value Mismatch');
end

expectval = 0;                          % start expecting a name, not a value
while i <= nargin
    arg = varargin{i};
    
    if ~expectval
        if ~ischar(arg)
            error('MATLAB:GlycoPAT:WRONGOPTIONNAME','Wrong Prop Name');
        end
        
        lowArg = lower(arg);
        j = find(strncmp(lowArg,names,length(lowArg)));
        if isempty(j)                       % if no matches
            error('MATLAB:GlycoPAT:WRONGOPTIONNAME','Wrong Prop Name');
        elseif length(j) > 1                % if more than one match
            % Check for any exact matches (in case any names are subsets of others)
            k = find(strncmp(lowArg,names,length(lowArg)));
            if length(k) == 1
                j = k;
            else
                matches = deblank(optionfieldnames(j(1),:));
                for k = j(2:length(j))'
                    matches = [matches ', ' deblank(optionfieldnames(k,:))]; %#ok<AGROW>
                end
                error('MATLAB:GlycoPAT:AmbiguousPropName','Property Name does not match');
                %  error(message('GlycoSim:displaySet:AmbiguousPropName',arg,matches));
            end
        end
        expectval = 1;                      % we expect a value next
        
    else
%         digestopt.(deblank(optionfieldnames(j,:))) =...
%             [digestopt.(deblank(optionfieldnames(j,:)));arg];
        digestopt.(deblank(optionfieldnames(j,:))) =arg;
        expectval = 0;
        
    end
    i = i + 1;
end

if ( ((~isempty(digestopt.missedmax)) && (~isnumeric(digestopt.missedmax)))) || ...
      ((~isempty(digestopt.minpeplen)) && (~isnumeric(digestopt.minpeplen))) || ...
      ((~isempty(digestopt.maxpeplen)) &&  (~isnumeric(digestopt.maxpeplen))) || ...
      ((~isempty(digestopt.minptm)) && (~isnumeric(digestopt.minptm)))  || ....
      ((~isempty(digestopt.maxptm)) && (~isnumeric(digestopt.maxptm)))        
    error('MATLAB:GlycoPAT:INCORRECTTYPE','Wrong input type for the propetyname');
end

if(  ((~isempty(digestopt.isoutputfile)) && (~ischar(digestopt.isoutputfile))) || ...
     ((~isempty(digestopt.outputfilename)) &&(~ischar(digestopt.outputfilename))) || ...
      ((~isempty(digestopt.varptm)) &&(~isstruct(digestopt.varptm))) || ...
      ((~isempty(digestopt.fixedptm)) &&(~isstruct(digestopt.fixedptm))))        
    error('MATLAB:GlycoPAT:INCORRECTTYPE','Wrong input type for the propetyname');
end

% set up default value for each property 
if(isempty(digestopt.missedmax))
    digestopt.missedmax=0;
end

if(isempty(digestopt.minpeplen))
    digestopt.minpeplen=4;
end

if(isempty(digestopt.maxptm))
    digestopt.maxptm=2;
end

if(isempty(digestopt.maxpeplen))
    digestopt.maxpeplen=30;
end

if(isempty(digestopt.minptm))
    digestopt.minptm=0;
end

if(isempty(digestopt.isoutputfile))
    digestopt.isoutputfile='no';
end

if(isempty(digestopt.outputfilename))
    digestopt.outputfilename='digestedpep.txt';
end

if expectval
    error('MATLAB:GlycoPAT:WRONGVALUE','No Value For Propertyname');
end

end



