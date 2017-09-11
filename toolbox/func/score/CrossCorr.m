function [peakLag,htCenter,htAvg]=CrossCorr(SpectraA,SpectraB,maxlag)
% CROSSCORR: Perform a cross-correlation analysis between SpectraA and SpectraB
% to determine how well they are correlated
%
% Syntax: 
%    [peakLag,htCenter,htAvg]=CrossCorr(SpectraA,SpectraB,maxlag)
%
% Input: 'Spectra A' and 'Spectra B' which have to be compared, and 
% maxLag, the distance by which they are offset initially.
%
% Output: Peak value of the normalized Crosscorrelation function at the center (i.e 
% htCenter at lag <= |1|), ht at center with respect to the overall mean, and the 
% offset when this function peaks.
%
% Children Function: None
%
% See also scoreAllSpectra, Pvalue, scoreProb, score1Spectra,
% scoreAllSpectra. 

% Author: Sriram Neelamegham
% Date Lastly Updated: 8/11/14 by Gang Liu

% Note: For more infor regarding xcorr, see: 
% "http://www.mathworks.com/matlabcentral/answers/19652-xcorr"
% maxlag=50        % by default, we look for lag=+/-50
% Last edited on 12/22/2013

maxA=ceil(max(SpectraA(:,1)));  % find the range of SpectraA
A=zeros(maxA+1,1);  % initialize A and B, arrays with one element for each m/z
B=A;

for i=1:length(SpectraA)
  bottom=floor(SpectraA(i,1));         % even if high resolution we digitize by 1Da
  top=ceil(SpectraA(i,1));
  if (bottom>0)
    A(bottom)=A(bottom)+SpectraA(i,2); % This adds Spectra value to upper and lower bounds of A
    A(top)=A(top)+SpectraA(i,2);       % Note: if top=bottom, this is added twice and this is ok
  end
end

for i=1:length(SpectraB)
  bottom = floor(SpectraB(i,1));
  top    = ceil(SpectraB(i,1));
  if ((bottom>1) && (top <= maxA))
    B(bottom) = B(bottom)+SpectraB(i,2);    % This adds Spectra value to upper and lower bounds of B
    B(top)    = B(top)+SpectraB(i,2);       % Note: if top=bottom, this is added twice and this is ok
  end
end

[c,lags] = xcorr(A,B,maxlag,'coeff');   % option 'co-eff' provides normalized plot where peak Xcorr=1
peakLag  = lags(find(c==max(c)));          % Lag value at which XCorr function peaks
peakLag  = max(abs(peakLag));
htCenter = max(c(maxlag:maxlag+2));       % ht. at center
htAvg    = htCenter/mean(c);                 % ht. at center with respect to overall mean
end
