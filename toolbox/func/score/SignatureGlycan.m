function foundSelectPeak=SignatureGlycan(Spectra,selectPeak,MS2tol,MS2tolUnit)
%SIGNATUREGLYCAN: Determine if any peaks that correspond to glycan
% signatures appear in the Spectra
%
% Syntax: 
%    foundSelectPeak=SignatureGlycan(Spectra,selectPeak,MS2tol,MS2tolUnit)
%
% Input: MS2 spectra ('Spectra'), list of glycan peaks ('selectPeak) and
% MS2 tolerance (MStol, MS2tolUnit)
%
% Output: Array containing the list of glycan peaks identified in Spectra
% ('foundSelectPeaks')
%
% Children function: None
%
%See also score1Spectra, scoreAllSpectra. 

% Author: Sriram Neelamegham
% Date Lastly Updated: 8/11/14 by Gang Liu

foundSelectPeak=[];
if strcmpi(MS2tolUnit,'ppm')  % for ppm
     ms2unitppm=1;   
elseif (strcmpi(MS2tolUnit,'Da'))
     ms2unitppm=0;     
else    
     error('MATLAB:GPAT:ERRORUNIT','INCORRECT UNIT FOR MS2 TOL');
end

for k=1:length(selectPeak)  % Look to see if there are signature glycan peaks
    if ms2unitppm  % for ppm
        if (any(abs(Spectra(:,1)-selectPeak(k))<=MS2tol/1e6*selectPeak(k))) % if tolerance is given in ppm units
            foundSelectPeak=[foundSelectPeak,selectPeak(k)];
        end
    else 
        if (any(abs(Spectra(:,1)-selectPeak(k))<=MS2tol)) % if tolerance is given in Da units
            foundSelectPeak=[foundSelectPeak,selectPeak(k)];
        end
    end
end

end
