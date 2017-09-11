function dispoptions = displayset(varargin)
%DISPLAYSET create/alter display options structure for visualization of
% glycan structure and network
%
% DISPOPTIONS = DISPLAYSET('NAME1',VALUE1,'NAME2',VALUE2,...) creates an
%  options structure in the named properties with the specified
%  values. Any unspecified properties have default values. Case is
%  insensitive for the filed names.
%
% DISPOPTIONS = DISPLAYSET(OLDDISPOPTS,'NAME',VALUE1,...) replaces an existing
%  options structure OLDDISPOPTS.
%
% DISPOPTIONS = DISPLAYSET with no input arguments creates an options structure with 
%  all filed names and their default values 
%
%DISPLAYSET properties:
%
% showMass -  Display molecular mass [on|{off}]      
%
% showLinkage - Display glycan linkage information [on|{off}]
%
% showRedEnd - Display reducing end [on|{off}]
%
% Isotope - Monoisotopic or average mass [{'MONO'}, 'AVG']
%
% Derivatization - Sample derivatization used in MS [{perMe}| perDMe|perAc|perDAc |Und ]
%  Sample derivatization procedure used in MS, Choices are
%  perMethylation, perDMethylation, perAcetylation, perDAcetylation
%
% IonCloudCharge - Ion used in MS  [ 0 | H | Li | {Na} | K | Und ]
%
% NetLayout - Layout format  [CompactTree|Circle|Hierarchical]
%  frame layout choice for network visualization
%
% NetFrameHeight - Height of the frame (pixels)  [{400}|custom]
%  frame height choice for network visualization   
%
% NetFrameWidth - Width of the frame (pixels) [{800}|custom]
%  frame width choice for network visualization   
%
% NetFitToFrame - If the network figure is auto-scaled to the frame size  [{on}|off]
%          
% dbname  - database name for GLYCOMEDB database  [{glycomedb}|custom]
%
% dbusername - username for access to database [{postgres}|custom]
%
% dbpassword  - password for access to database [{gnat}|custom]
%
% Example 1:
%  defaultOptions = displayset
%
% Example 2:
%  displayOptions = displayset('showMass',true,'showLinkage',true,'showRedEnd',true)
%
% Example 3:
%  displayOptions = displayset('showmass',true,'showLinkage',true,'showRedEnd',true)
%  displayOptions2= displayset(displayOptions, 'Isotope','avg','Derivatization','perDMe','IonCloudCharge','K')
%
% See also glycanViewer, glycanFileViewer, glycanNetViewer, glycanNetFileViewer,displayget. 

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab. Part of codes are Modified  from ODESET

% Print out possible values of properties.
if (nargin == 0)
    dispoptions = struct( 'showMass', false,  'showLinkage',false, 'showRedEnd',false,   ...
        'Isotope',  'MONO', 'Derivatization','perMe', 'IonCloudCharge','Na','NetLayout','CompactTree',...
        'NetFrameHeight',400,'NetFrameWidth',800,'NetFitToFrame',true,...
        'dbname','glycomedb','dbusername','postgres','dbpassword','gnat');
    return;
end

optionfieldnames = char( 'showMass        ',   'showLinkage      ',    'showRedEnd     ',   ...
    'Isotope                 ',        'Derivatization   ',   'IonCloudCharge' ,   'NetLayout         ',   ...
    'NetFrameHeight ',        'NetFrameWidth',    'NetFitToFrame   ', 'dbname',...
    'dbusername','dbpassword');

% the codes below were modified from ODESET
numFields  =size(optionfieldnames,1);
names        = cellstr(lower(optionfieldnames));

%Combine all leading options structures o1, o2, ... in odeset(o1,o2,...).

% initialization to default values
dispoptions = [];
for j = 1:numFields
    dispoptions.(deblank(optionfieldnames(j,:))) = [];
end

%set default values;
dispoptions.showMass=false;
dispoptions.showLinkage=false;
dispoptions.showRedEnd=false;
dispoptions.Isotope= 'MONO';
dispoptions.Derivatization= 'perMe';
dispoptions.IonCloudCharge = 'Na';
dispoptions.NetLayout= 'CompactTree';
dispoptions.NetFrameHeight= 400;
dispoptions.NetFrameWidth = 800;
dispoptions.NetFitToFrame=true;
dispoptions.dbname= 'glycomedb';
dispoptions.dbusername = 'postgres';
dispoptions.dbpassword='gnat';

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
                dispoptions.(deblank(optionfieldnames(j,:))) = val;
            end
            
        end
    end
    i = i + 1;
end

% A finite state machine to parse name-value pairs.

% check inputs are name-value pairs
if rem(nargin-psIndex+1,2) ~= 0
    errorReport(mfilename,'ArgNameValueMismatch');
end

expectval = 0;                          % start expecting a name, not a value
while i <= nargin
    arg = varargin{i};
    
    if ~expectval
        if ~ischar(arg)
            errorReport(mfilename,'NoPropName');
        end
        
        lowArg = lower(arg);
        j = find(strncmp(lowArg,names,length(lowArg)));
        if isempty(j)                       % if no matches
            errorReport(mfilename,'InvalidPropName');
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
                errorReport(mfilename,'AmbiguousPropName');
                %  error(message('GlycoSim:displaySet:AmbiguousPropName',arg,matches));
            end
        end
        expectval = 1;                      % we expect a value next
        
    else
        dispoptions.(deblank(optionfieldnames(j,:))) = arg;
        expectval = 0;
        
    end
    i = i + 1;
end

if expectval
    errorReport(mfilename, 'NoValueForProp');
end

end