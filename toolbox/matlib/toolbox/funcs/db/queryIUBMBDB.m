function queryEnzRes = queryIUBMBDB(ecno,varargin)
%queryIUBMBDB retrieve enzyme information from IUBMB website
%
% queryEnzRes = queryIUBMBDB(ecno) searches for the enzyme based on
%   its ecno in the IUBMB  Database and returns a structure queryEnzRes.
%   queryEnzRes contains five fields: 1) systematic name; 2) accepted name;
%   3)comments;  4)reaction and 5) other names.
%
% Example:
%     queryEnzResult = queryIUBMBDB([2;3;1;29]);
%
% See also queryGlycomeDB,dbExactStructSearch.

% Author: Gang Liu
% Date Last Updated: 1/24/13

% error handling
error(nargchk(1,1,nargin));

% check input variables
if(~isnumeric(ecno))
    errorReport(mfilename,'NonStringInput');
end

IUBMBFullName = 'http://www.chem.qmul.ac.uk/iubmb/enzyme/EC';

for i=1:4
    IUBMBFullName = strcat(IUBMBFullName,num2str(ecno(i)));
    if(i~=4)
        IUBMBFullName = strcat(IUBMBFullName,'/');
    end
end
IUBMBFullName = strcat(IUBMBFullName,'.html');

try
    queryRes = urlread(IUBMBFullName);
catch err
    error('MATLAB:GEAT:WEBACCESS','Network Down Or Wrong ECNO');
end

names = regexp(queryRes,'<b>Accepted name:</b>(?<first>.*)<p>.*<b>Reaction','names');
acceptname = names.first;
acceptname = regexprep(acceptname,'<[^>]*>','');
%acceptname  = regexprep(acceptname,'(&alpha;','alpha');
acceptname  = regexprep(acceptname,'&alpha;','alpha');
%acceptname  = regexprep(acceptname,')','');
%acceptname  = regexprep(acceptname,'(&beta;','beta');
acceptname  = regexprep(acceptname,'&beta;','beta');
acceptname  = regexprep(acceptname,'&rarr;','->');

names = regexp(queryRes,'<b>Reaction:</b>(?<first>.*)<p>.*<b>Other name','names');
rxn = names.first;
rxn = regexprep(rxn,'<[^>]*>','');
%rxn  = regexprep(rxn,'(&alpha;','alpha');
rxn  = regexprep(rxn,'&alpha;','alpha');
%rxn  = regexprep(rxn,'(&beta;','beta');
rxn  = regexprep(rxn,'&beta;','beta');
rxn  = regexprep(rxn,'&rarr;','->');
%rxn  = regexprep(rxn,')','');

names = regexp(queryRes,'<b>Other name.s.:</b>(?<first>.*)<p>.*<b>Systematic','names');
othernames  = names.first;
othernames  = regexprep(othernames,'<[^>]*>','');
%othernames  = regexprep(othernames,'(&alpha;','alpha');
othernames  = regexprep(othernames,'&alpha;','alpha');
%othernames  = regexprep(othernames,'(&beta;','beta');
othernames  = regexprep(othernames,'&beta;','beta');
othernames  = regexprep(othernames,'&rarr;','->');
othernames  = regexprep(othernames,')','');

names = regexp(queryRes,'<b>Systematic name:</b>(?<first>.*)<p>.*<b>Comments:','names');
systname  = names.first;
systname  = regexprep(systname,'<[^>]*>','');
%systname  = regexprep(systname,'(&alpha;','alpha');
systname  = regexprep(systname,'&alpha;','alpha');
%systname  = regexprep(systname,'(&beta;','beta');
systname  = regexprep(systname,'&beta;','beta');
systname  = regexprep(systname,'&rarr;','->');
%systname  = regexprep(systname,')','');

names     = regexp(queryRes,'<b>Comments:</b>(?<first>.*)<p>.*<b>Links to other databases','names');
comments  = names.first;
comments  = regexprep(comments,'<[^>]*>','');

queryEnzRes.comments = strtrim(comments);
queryEnzRes.systname = strtrim(systname);
queryEnzRes.othernames = strtrim(othernames);
queryEnzRes.name = strtrim(acceptname);
queryEnzRes.rxn = strtrim(rxn);

end
