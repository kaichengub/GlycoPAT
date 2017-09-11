function newSpectra=deleteIsoPeaks(varargin)
%
% Deletes isotopic peaks from input SpectraA and returns newSpectra
%
% Children Function:  findIsotopePeaks 
%
if (nargin==3)
    SpectraA = varargin{1};
    MS2tol= varargin{2};
    MS2tolUnit= varargin{3};
else  % lines for debugging program
    mzDTA = readmzDTA('C:\glycopat_submit\toolbox\test\data\score\dta files from paper');
    SpectraA=mzDTA.spectra{1};
    MS2tol=1;
    MS2tolUnit='Da';
%    h=bar(SpectraA(:,1),SpectraA(:,2),0.5,'r'); % Plot MS2 spectra
%    set(h,'EdgeColor','r')
end

newSpectra=SpectraA;
[~,isoPeaks]=findIsotopePeaks(SpectraA,MS2tol,MS2tolUnit);
A=[isoPeaks.iso];
location=ismember(SpectraA(:,1),A);
newSpectra(location,2)=0.1;       % remove isotope peak (set to 0.1) for scoring but maintain size of newSpectra
end