function fragparam = getFragParam(SmallGlyPep,fragModeInput,nmFrag,ngFrag,npFrag)
%getFragParam: find specific fragmentation parameter for a glycopeptide
%
%Syntax: 
%    fragparam = getFragParam(SmallGlyPep,fragModeInput,nmFrag,ngFrag,npFrag)
%
%Input:
%    SmallGlyPep: glycopeptide in SGP format
%    fragModeInput: fragmentation mode input 
%    nmFrag: the number of fragmention points for non-glyan modification 
%    ngFrag: the number of fragmention points for glycan 
%    npFrag: the number of fragmention points for peptide 
%
% Examples:
%    Example 1:
%
%
%See also breakGlyPep.

%Author: Gang Liu
%Date Lastly Updated: 12/14/15

if(isnumeric(fragModeInput))
    fragModeInputDigit = fragModeInput;
elseif(ischar(fragModeInput))
    if(strcmpi(fragModeInput,'CID'))
        fragModeInputDigit = 1;
    elseif(strcmpi(fragModeInput,'HCD'))
        fragModeInputDigit = 2;
    elseif(strcmpi(fragModeInput,'ETD'))
        fragModeInputDigit = 3;
    elseif(strcmpi(fragModeInput,'CIDSpecial'))
        fragModeInputDigit = 4;
    elseif(strcmpi(fragModeInput,'HCDSpecial'))
        fragModeInputDigit = 5;
    elseif(strcmpi(fragModeInput,'ETDSpecial'))
        fragModeInputDigit = 6;
    elseif(strcmpi(fragModeInput,'AUTO'))
        error('MATLAB:GLYCOPAT:ERRORINPUTSTRING','INCORRECT INPUT STRING');
    end                   
end

monosaccharidenumlimit =4;
peptide_aalimit        =1;
glycan_monolimit       =2;

[pepMat,glyMat,modMat]=breakGlyPep(SmallGlyPep);
if(fragModeInputDigit==1||(fragModeInputDigit==2))      %strcmpi(fragMode,'CID') || strcmpi(fragMode,'HCD')
    fragparam.nmFrag=0;
    fragparam.ngFrag=0;
    fragparam.npFrag=0;
    if (~isempty(pepMat))
        fragparam.npFrag=peptide_aalimit;               % CID typically fragments peptide
    end
    if (~isempty(modMat))  % (exception: it can also fragment modification especially in the case of sulfation and phosphorylation)
        % addition of modificaiton type check
        fragparam.nmFrag=0;
    end
    if (~isempty(glyMat))   % it prefers to fragment glycan instead of peptide if it is a glycopeptide
        glyNumber=0;
        for m=1:length(glyMat)
            glyNumber=glyNumber+glyMat(m).len;
        end
        if ((glyNumber<monosaccharidenumlimit)&&(~isempty(pepMat)))  % if number of monosaccharides <4 then we fragment on peptide backbone also once
            fragparam.ngFrag=glycan_monolimit;
            fragparam.npFrag=peptide_aalimit;
        else
            fragparam.ngFrag=glycan_monolimit;
            fragparam.npFrag=0;
        end
    end
elseif(fragModeInputDigit==3)              %(strcmpi(fragMode,'ETD'))
    fragparam.ngFrag   = 0;
    fragparam.nmFrag   = 0;
    fragparam.npFrag   = peptide_aalimit;  
elseif(fragModeInputDigit==4)||(fragModeInputDigit==5)||(fragModeInputDigit==6)
    fragparam.ngFrag=ngFrag;
    fragparam.nmFrag=nmFrag;
    fragparam.npFrag=npFrag;    
else
    error('MATLAB:GlycoPAT:FRAGMODEERROR',...
        'FRAGMENTATION MODE IS NOT CURRENTLY SUPPORTED');
end

end