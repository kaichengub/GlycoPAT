function [peaklist,pfwhh]= msprocess(msrawdata,varargin)
%MSPROCESS convert raw peak data to a peak list and their half height width column
% using a four-step method. The method starts with background adjustment,
% followed by the normalization, signal noise removal, and ends with peak
% finding.
%
% [p,pfwhh]= MSPROCESS(msrawdata) uses default options which
%   are 0.3 for oversegmentationfilter, 5 for heightfilter, true for
%   showplot. The peak list p is a matrix with two columns of peak
%   locations, and peak intensities. The matrix pfwhh has two columns
%   indicating the left and right location of the full width height.
%
% Example:
%     mzInt = readMS('testCHO.msd');
%     options.showplot =true;
%     [peaklist,pfwhh]= MSPROCESS(mzInt,options);
%
%See also readMS.

% Author: Gang Liu
% Date Lastly Updated: 8/2/13.
if(length(varargin)==1)
    options=varargin{1};
    if(isfield(options,'OverSegmentationFilter'))
        OverSegmentationFilter = options.OverSegmentationFilter;
    else
        OverSegmentationFilter = 0.3;
    end
    
    if(isfield(options,'HEIGHTFILTER'))
        HEIGHTFILTER = options.HEIGHTFILTER;
    else
        HEIGHTFILTER = 5;
    end
    
    if(isfield(options,'showplot'))
        showplot = options.showplot;
    else
        showplot = false;
    end
else
    OverSegmentationFilter = 0.3;
    HEIGHTFILTER =5;
    showplot = true;
end

mz            = msrawdata(:, 1);
intensity  = msrawdata(:,2);   % msviewer(mz,intensity);

% first step baseline correction
winsize = 200;
[bsCorrectedInt] = msbackadj(mz, intensity,...
    'WindowSize', winsize,...
    'RegressionMethod', 'spline',...
    'ShowPlot', false,'Quantile',0.10);
%msviewer(mz,bsCorrectedInt,'ylabel','Baseline Corrected');

% remove noise signal smooth signal using mssgolay (polynomial filters)
noiseremInt = mssgolay(mz,bsCorrectedInt,...
    'span',35,'showplot',false);

% second step normalization
normInt = msnorm(mz,noiseremInt,...
    'LIMITS',[300 inf],'MAX',100);

%  if(false)
%    msviewer(mz,normInt,'ylabel','Normalized');
%  end

% peak finding with wavelets denoising
[peaklist,pfwhh]= mspeaks(mz,normInt,...
    'DENOISING',false,'HEIGHTFILTER',HEIGHTFILTER,...
    'OverSegmentationFilter', OverSegmentationFilter,...
    'SHOWPLOT',showplot);
end