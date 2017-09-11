function val = displayget(options,name,varargin)
%DISPLAYGET get DISPLAY OPTIONS parameters.
% 
% VAL = DISPLAYGET(OPTIONS,'NAME') extracts the value of the named property
%  from options structure OPTIONS, returning an empty matrix if
%  the property name is not specified in OPTIONS. It is sufficient to type
%  only the leading characters that uniquely identify the property.[] is a 
%  valid OPTIONS argument. It is case insensitive. 
%
% VAL = DISPLAYGET([],'NAME') returns the default value of the named property
%  from default options structure OPTIONS, returning an empty matrix if
%  the property name is not specified in OPTIONS.
%
% Example 1:
%  options  = displayset('showmass',true)
%  showMass = displayget(options,'showMass')
%
% Example 2:
%  showMass = displayget([],'showMass')
%   
% See also displayset,glycanViewer,glycanNetViewer,glycanFileViewer,
% glycanNetFileViewer.

% Author: Gang Liu
% CopyRight 2012, Neelamegham Lab Modified Code from ODEGET  

% check the number of the inputs
if(~verLessThan('matlab','7.13'))
    narginchk(2,3);
else
    error(nargchk(2,3,nargin));
end

% undocumented usage for fast access with no error checking
if (nargin == 3) 
    flag = varargin{1};
   if(isequal(flag,'fast'))
        val = getknownfield(options,name);
   else
        val = [];
   end
   return
end

if ~isempty(options) && ~isa(options,'struct')
  errorReport(mfilename,'IncorrectInputType');
end

if(isempty(options))
     options = struct( 'showMass', false,  'showLinkage',false, 'showRedEnd',false,   ...
        'Isotope',  'MONO', 'Derivatization','perMe', 'IonCloudCharge','Na','NetLayout','CompactTree',...
        'NetFrameHeight',600,'NetFrameWidth',800,'NetFitToFrame',true,'dbname','glycomedb',...
             'dbusername','postgres','dbpassword','gnat');
end

optionfieldnames = char( 'showMass        ',   'showLinkage      ',    'showRedEnd     ',   ...
    'Isotope                 ',        'Derivatization   ',   'IonCloudCharge' ,   'NetLayout         ',   ...
    'NetFrameHeight ',        'NetFrameWidth',    'NetFitToFrame   ', 'dbname ',...
      'dbusername','dbpassword');

names = cellstr(lower(optionfieldnames));

lowName = lower(name);
j = find(strncmp(lowName,names,length(lowName)));
if isempty(j)               % if no matches
   errorReport(mfilename,'InvalidPropName');
elseif length(j) > 1            % if more than one match
  % Check for any exact matches (in case any names are subsets of others)
   k = find(strcmp(lowName,names));
  if length(k) == 1
    j = k;
  else
    matches = deblank(optionfieldnames(j(1),:));
    for k = j(2:length(j))'
      matches = [matches ', ' deblank(optionfieldnames(k,:))]; %#ok<AGROW>
    end
      errorReport(mfilename,'AmbiguousPropName');
  end
end

if any(strcmpi(fieldnames(options),deblank(optionfieldnames(j,:))))
  val = options.(deblank(optionfieldnames(j,:)));
  if isempty(val)
    val = [];
  end
else
  val = [];
end

% --------------------------------------------------------------------------
function v = getknownfield(s, f, d)
%GETKNOWNFIELD  Get field f from struct s, or else yield default d.

if isfield(s,f)   % s could be empty.
  v = s.(f);
  if isempty(v)
    v = d;
  end
else
  v = d;
end

