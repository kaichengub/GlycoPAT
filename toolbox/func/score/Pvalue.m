function  [found,search,percentIonMatch,Top10]=Pvalue(SpectraA, SpectraC, MS2tol,MS2tolUnit)
%Pvalue: Compare SpectraA (experimental) with SpectraC (theoretical) to
% see which peaks match with an error tolerance of 'MS2tol'.
%
% Syntax: 
%    [found,search,percentIonMatch,Top10]=Pvalue(SpectraA, SpectraC, MS2tol,MS2tolUnit)
%  
% Input: Spectra A is experimental spectra arranged in descending order based on Intensity.
% Spectra C is theoretical spectra. MS2tol and MS2tolUnits specify
% tolerance used for comparison.
%
% Output: Search (N) is total number of fragment ions searched for. Found
% (k) is total number of matched fragment ions. Percent of ions matched and
% the number of experimental top 10 peaks identified are also output.
%
% Children function: None
%
%See also scoreProb. 

% Author: Sriram Neelamegham
% Date Lastly Updated: 8/11/14 by Gang Liu

search=size(SpectraC,1);
found=0;
Top10=0;
max10=10;
prevMatch2=0;
if (length(SpectraA)<10)
    max10=length(SpectraA);
end
for k=1:search
    if strcmpi(MS2tolUnit,'Da')           % Tol. units are Da
        match=find(abs(SpectraC(k,1)-SpectraA(:,1))<=MS2tol);
    elseif(strcmpi(MS2tolUnit,'ppm'))                                % MS2tolUnit is ppm
        match=find(abs(SpectraC(k,1)-SpectraA(:,1))<=MS2tol/1e6*SpectraA(:,1));
    else
        error('MATLAB:GlycoPAT:ERRORUNIT','INCORRECT UNIT');
    end
    if ~isempty(match)
        found=found+1;
    end
    if strcmpi(MS2tolUnit,'Da')          % for Top10
        match2=find(abs(SpectraC(k,1)-SpectraA(1:max10,1))<=MS2tol);  % assuming this is in units of Da
    elseif(strcmpi(MS2tolUnit,'ppm'))                                % MS2tolUnit is ppm
        match2=find(abs(SpectraC(k,1)-SpectraA(1:max10,1))<=MS2tol/1e6*SpectraA(1:max10,1));
    else
        error('MATLAB:GlycoPAT:ERRORUNIT','INCORRECT UNIT');
    end
    if ((~isempty(match2))&&(~any(ismember(match2,prevMatch2))))
        Top10=Top10+length(match2);
        prevMatch2=[prevMatch2,match2'];
    end
end
percentIonMatch=found/search*100;        % percent ions matched
end
