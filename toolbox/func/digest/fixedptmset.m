function fixedptmopt = fixedptmset(varargin)
%FIXEDPTMSET: Set common modification options for peptide posttranslational
%  modfication.
%
% Syntax:
%
%    fptmopt = FIXEDPTMSET('aaresidue', aaresiduename, 'mod',modsymbolname,
%    'mw',molweight);
%
%    newfptmopt = FIXEDPTMSET(fptmopt,'aaresidue', aaresiduename, 'mod',modsymbolname,
%    'mw',molweight);
%
% Examples: 
%  
%   Example 1:  fptmopt = FIXEDPTMSET('aaresidue','c','mod','i','mw',57.0214617);
%
%   Example 2:  fptmopt = FIXEDPTMSET('aaresidue','c','mod','i','mw',57.0214617);
%               newfptmopt = FIXEDPTMSET(fptmopt,'aaresidue','c','mod','c','mw',58.00548);
%
%
% See also varptmset, digestoptionset, digestSGP, cleaveProt.

% Author: Gang Liu 
% Date Lastly Updated: 9/7/13

if(nargin==0)
    fixedptmopt = struct('aaresidue',[],...
        'mod',[],'mw',[]);
    return
end

optionfieldnames = char( 'aaresidue', ...
    'mod',  'mw');
numFields        = size(optionfieldnames,1);
names            = cellstr(lower(optionfieldnames));

% initialization to default values
fixedptmopt = [];
for j = 1:numFields
    fixedptmopt.(deblank(optionfieldnames(j,:))) = [];
end

i = 1;
while i <= nargin
    arg = varargin{i};
    if ischar(arg)                 % arg is an option name
        psIndex = i;               %  index starting position for name-value pairs
        break;
    end
    if ~isempty(arg)                      % [] is a valid options argument
        
        if ~isa(arg,'struct')
            error('MATLAB:GlycoPAT:NoPropNameOrStruct','NoPropNameOrStruct');
        end
        
        for j = 1:numFields
            if any(strcmpi(fieldnames(arg),deblank(optionfieldnames(j,:))))
                val = arg.(deblank(optionfieldnames(j,:)));
            else
                val = [];
            end
            
            if ~isempty(val)
                fixedptmopt.(deblank(optionfieldnames(j,:))) = val;
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
        fixedptmopt.(deblank(optionfieldnames(j,:))) =[fixedptmopt.(deblank(optionfieldnames(j,:)));arg];
        expectval = 0;
        
    end
    i = i + 1;
end

 fixedptmopt.aaresidue=num2cell(fixedptmopt.aaresidue);
 fixedptmopt.mod=num2cell(fixedptmopt.mod);
 fixedptmopt.mw=num2cell(fixedptmopt.mw);

if expectval
    error('MATLAB:GlycoPAT:WRONGVALUE','No Value For Propertyname');
end

end

