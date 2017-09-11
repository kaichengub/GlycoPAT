function [actmethod,fragMode]=setfragMode(fragMode,mzXMLobj,ScanNumber)
%
% Determines the activation method (actmethod) and fragMode for subsequent
% calculations
%
if(strcmpi(fragMode,'ETD')||strcmpi(fragMode,'ETDSpecial'))
    actmethod = 'ETD';
elseif(strcmpi(fragMode,'CID')||strcmpi(fragMode,'CIDSpecial'))
    actmethod = 'CID';
elseif(strcmpi(fragMode,'HCD')||strcmpi(fragMode,'HCDSpecial'))
    actmethod = 'HCD';
elseif(strcmpi(fragMode,'Auto'))
    actmethod = 'Auto';
elseif(strcmpi(fragMode,'CID/HCD'))
    actmethod =  'CID/HCD';
else
    error('MATLAB:GlycoPAT:NOTSUPPORTEDFRAGMENTATION','THE FRAGMENTATION MODE IS NOT SUPPORTED');
end

if(strcmpi(actmethod,'Auto'))
    actmetfromdata = mzXMLobj.retrieveActMethod('scannum',ScanNumber);
    if(~isempty(strfind(upper(actmetfromdata),'ETD')))
        actmethod ='ETD';
    elseif(~isempty(strfind(upper(actmetfromdata),'CID')))
        actmethod ='CID';
    elseif(~isempty(strfind(upper(actmetfromdata),'HCD')))
        actmethod ='HCD';
    else
        error('MATLAB:GlycoPAT:NOTSUPPORTEDFRAGMENTATION','THE FRAGMENTATION MODE IS NOT SUPPORTED');
    end
    fragMode = actmethod;
    
elseif(strcmpi(actmethod,'CID/HCD'))
    actmetfromdata = mzXMLobj.retrieveActMethod('scannum',ScanNumber);
    if(~isempty(strfind(upper(actmetfromdata),'CID')))
        actmethod = 'CID';
    elseif(~isempty(strfind(upper(actmetfromdata),'HCD')))
        actmethod = 'HCD';
    else
        error('MATLAB:GlycoPAT:INCORRECTFRGMENTATION','THE FRAGMENTATION MODE IS NOT SAME AS in MZXML');
    end
    fragMode =  actmethod;
    
elseif(~isempty(actmethod))
    actmetfromdata = mzXMLobj.retrieveActMethod('scannum',ScanNumber);
    if(isempty(strfind(upper(actmetfromdata),upper(actmethod))))
        error('MATLAB:GlycoPAT:INCORRECTFRGMENTATION','THE FRAGMENTATION MODE IS NOT SAME AS in MZXML');
    end
    actmethod = fragMode;
else
    error('MATLAB:GlycoPAT:NOTSUPPORTEDFRAGMENTATION','THE FRAGMENTATION MODE IS NOT SUPPORTED');
end
end