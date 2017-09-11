function varptmopt = varptmset(varargin)
%VARPTMSET: Set variable modification options for peptide posttranslational
%  modfication.
%
%    vptmopt = VARPTMSET('aaresidue', aaresiduename,
%    'mod',modsymbolname,'pos',poslist);
%
%    newvptmopt = VARPTMSET(vptmopt,'aaresidue', aaresiduename, 'mod',modsymbolname,
%    ,'pos',poslist);
%
%   Example 1:  vptmopt = VARPTMSET('aaresidue','c','mod','i','pos',3);
%
%   Example 2:  vptmopt = VARPTMSET('aaresidue','c','mod','i','pos',3);
%        newvptmopt = VARPTMSET(vptmopt,'aaresidue','c','mod','c','pos',4);
%
%   Example 3: vptmopt = VARPTMSET('aaresidue','M','mod','o','pos',0);
%     vptmopt = VARPTMSET(vptmopt,'aaresidue','X','mod','s','pos',[7,9,12]);
%     vptmopt = VARPTMSET(vptmopt,'aaresidue','X','mod','{n{h{s}}} ','pos',18);
%     vptmopt = VARPTMSET(vptmopt,'aaresidue','X','mod','{n{s{h{s}}}}','pos',18);
%
% See also fixedptmset, digest.

% Date Lastly Updated: 9/7/13
if(nargin==0)
    error('MATLAB:GLYCOPAT:ERRORINPUTNUMBER','INCORRECT INPUT NUMBER');
end

optionfieldnames = char( 'aaresidue', ...
    'mod',  'pos');
numFields  =size(optionfieldnames,1);
names        = cellstr(lower(optionfieldnames));

% initialization to default values
varptmopt = [];
for j = 1:numFields
    varptmopt.(deblank(optionfieldnames(j,:))) = [];
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
            errorReport(mfilename,'NoPropNameOrStruct');
        end
        
        for j = 1:numFields
            if any(strcmpi(fieldnames(arg),deblank(optionfieldnames(j,:))))
                val = arg.(deblank(optionfieldnames(j,:)));
            else
                val = [];
            end
            
            if ~isempty(val)
                varptmopt.(deblank(optionfieldnames(j,:))) = val;
            end
            
        end
    end
    i = i + 1;
end

% A finite state machine to  name-value pairs.
% parse
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
        if(isempty(varptmopt.(deblank(optionfieldnames(j,:)))))
            fieldvalue{1,1}=arg;
            varptmopt.(deblank(optionfieldnames(j,:))) =fieldvalue;
        else
            fieldvalue = varptmopt.(deblank(optionfieldnames(j,:)));
            fieldsize =length(fieldvalue);
            fieldvalue{fieldsize+1,1}=arg;
            varptmopt.(deblank(optionfieldnames(j,:))) =fieldvalue;
        end
        expectval = 0;
        
    end
    i = i + 1;
end

nummod = length(varptmopt.mod);
for i = 1 : nummod
    modifstring                   = varptmopt.mod{i,1};
    if( ~ strcmp(modifstring(1),'{') &&  ~ strcmp(modifstring(1),'<') );
        varptmopt.mod{i,1} =  strcat('<',modifstring);
        varptmopt.mod{i,1} =  strcat(varptmopt.mod{i,1},'>');
    else
        varptmopt.mod{i,1} =  modifstring;
    end
end

if expectval
    error('MATLAB:GlycoPAT:WRONGVALUE','No Value For Propertyname');
end

end