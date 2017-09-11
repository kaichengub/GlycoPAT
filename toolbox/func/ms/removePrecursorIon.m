function SpectraB = removePrecursorIon(SpectraA,MH,z,MS2tol,MS2tolUnit)
%REMOVEPRECURSORION: Remove Precursor Ion Peaks from MS2 Spectrum 
%
% Syntax: 
%     SpectraB = removePrecursorIon(SpectraA,MH,z,MS2tol,MS2tolUnit) 
%
%  Input:
%     SpectraA: MS2 Spectrum Input
%     MH: M+H of precursor ion
%     z: charge state of precursor ion
%     MS2tol: MS2 tolerance
%     MS2tolUnit: MS2 tolerance unit, either 'Da' or 'ppm'
% 
%  Output:
%    SpectraB: SpectraA without precursor ion peak 
% 
%  Example:
%    
% 
%See also PolishSpectra, PolishSpectraLocal

SpectraB = SpectraA;
Hmass = 1.007825032;

% find precursor ion peak
for i = 1: z
    zz = i;
    pMass = (MH+(zz-1)*Hmass)/zz;
    if strcmpi(MS2tolUnit,'Da')
        mzlist=find(abs(SpectraB(:,1)-pMass)<=MS2tol);  % assuming this is in units of Da
    elseif(strcmpi(MS2tolUnit,'ppm'))  % MS2tolUnit=ppm
        mzlist=find(abs(SpectraB(:,1)-pMass)<=MS2tol/1e6*pMass);    
    end
    SpectraB(mzlist,:)=[];
end

end