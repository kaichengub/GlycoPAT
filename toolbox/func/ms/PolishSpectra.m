function CleanSpectra=PolishSpectra(Spectra, CutOffMed, FracMax)
%POLISHSPECTRA: Remove small peaks corresponding to instrument noise from 
% input 'Spectra'. These noisy peaks have intensity < 'CutOffMed'*median
% provided they have intensity <'FracMac'*max Intensity (By default 
% CutOffMed=3 and FracMax=0.02)
%
% Syntax: 
%     CleanSpectra=PolishSpectra(Spectra, CutOffMed, FracMax)
%
% Input: 'Spectra', 'CutOffMed' and 'FracMax'
%
% Output: CleanSpectra, which contains the noise reduced Spectra
%
% Children function: None
%
%See also PolishSpectraLocal, removePrecursorIon 

% Author: Sriram Neelamegham
% Date Lastly Updated: 8/11/14 by Gang Liu

IntMedian=median(Spectra(:,2));
IntMax=max(Spectra(:,2));
jj=1;
for j=1:length(Spectra)
  if not((Spectra(j,2)<CutOffMed*IntMedian) & (Spectra(j,2)<FracMax*IntMax))  % if int<3*median and <2%Max
    CleanSpectra_int(jj,:)=Spectra(j,:);  % After polish data are placed in 'CleanSpectra'
    jj=jj+1;
  end
end
CleanSpectra=sortrows(CleanSpectra_int,-2); %CleanSpectra is rank ordered 
%based on intensity since this helps output
end