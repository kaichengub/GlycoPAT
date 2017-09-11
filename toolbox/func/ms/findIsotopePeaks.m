function [isoIndex,isoPeaks]=findIsotopePeaks(varargin)
% Reads experimental data in SpectraA. Finds isotope peaks usng MS2
% resolution info with focus only on the most intense peaks. Classifies
% these peaks into either monoisotopic or higher order isotopic peaks
%
% Input: SpectraA, MStol and units
% Output: isoPeaks which specifies the peaks (.mono or .iso). Corresponding Index
%         numbers are provided in Index
%
% Example usage: [isoIndex,isoPeaks]=findIsotopePeaks(SpectraA, MS2tol, MS2tolUnit)
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
    h=bar(SpectraA(:,1),SpectraA(:,2),0.5,'r'); % Plot MS2 spectra
%    set(h,'EdgeColor','r')
end
temp_spectra=PolishSpectra(SpectraA,6,0.05); % more than 6 times median and more than 5% of max peak.
int_SpectraA=sortrows(temp_spectra, 1);
%    figure;
%    h=bar(int_SpectraA(:,1),int_SpectraA(:,2),0.5,'g');
nPeaks=length(int_SpectraA);
isoPeaks.mono=[];
isoPeaks.iso=[];

% i=2;
% jj=1;
% MS2tol=MS2tol*1.2;
% 
% while (i<nPeaks-4)
%     if strcmpi(MS2tolUnit,'Da')
%         tol=MS2tol;
%     else                % MS2tolUnit=ppm
%         tol=MS2tol/1e6*int_SpectraA(i,1);
%     end
%     
%     rangeA=0;
%     if ((int_SpectraA(i,1)-int_SpectraA(i-1,1))<tol)
%         rangeA=(int_SpectraA(i,2)-int_SpectraA(i-1,2))/int_SpectraA(i-1,2);  % -0.6 to 0.3
%         if rangeA>0
%             isoPeaks(jj).mono=[int_SpectraA(i-1,1),int_SpectraA(i,1)]; % include both
%         else
%             isoPeaks(jj).mono=int_SpectraA(i-1,1); % include only one and put other as isotope
%             isoPeaks(jj).iso=int_SpectraA(i,1);
%         end
%         rangeB=0;
%         while ((int_SpectraA(i+1,1)-int_SpectraA(i,1))<tol)  % if next peak is close by
%             isoPeaks(jj).iso=[isoPeaks(jj).iso,int_SpectraA(i+1,1)];
%             i=i+1;
%             rangeB=-1;
%         end
%         jj=jj+1;
%     end
%     i=i+1;
% end


%A=[isoPeaks.iso];
%location=ismember(SpectraA(:,1),A);

mzlist = [int_SpectraA(:,1);int_SpectraA(end,1)+100];
intlist = int_SpectraA(:,2);
if strcmpi(MS2tolUnit,'Da')
    intlist = [intlist;int_SpectraA(end,2)+MS2tol*2];
else
    intlist = [intlist;int_SpectraA(end,1)+MS2tol/1e6*int_SpectraA(end,1)*2];
end
grpop = 1;
grped = 1;
tempgrp = [];
for grped = grped:length(mzlist(:,1))                            % 'grped' is bigger than the end number of last group by 1, here the loop includes all remaining peptides
    tempgrp = [tempgrp;grpop];
    if strcmpi(MS2tolUnit,'Da')
        tol=MS2tol;
    else                % MS2tolUnit=ppm
        tol=MS2tol/1e6*int_SpectraA(grpop,1);
    end
    if (mzlist(grped) - mzlist(grpop)) <= tol
        tempgrp = [tempgrp;grped];                             % write the index of satisfactory peptide
        continue
    else
        tempgrp = unique(tempgrp);
        [~,localmaxind] = max(intlist(tempgrp));
        isoPeaks.mono = [isoPeaks.mono;mzlist(tempgrp(localmaxind))];
        isoPeaks.iso = [isoPeaks.iso;mzlist(setdiff(tempgrp,tempgrp(localmaxind)))];
        grpop = grped;
        tempgrp = [];
    end
end

isoIndex.mono=[];
isoIndex.iso=[];
for i=1:length(isoPeaks)
    isoIndex(i).mono=find(ismember(SpectraA(:,1),isoPeaks(i).mono))';  %take transpose for find to work
    isoIndex(i).iso=find(ismember(SpectraA(:,1),isoPeaks(i).iso))';
end

end