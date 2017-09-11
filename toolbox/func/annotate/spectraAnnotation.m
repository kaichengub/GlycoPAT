function spectraAnnotation(varargin)
%SPECTRAANNOTATION: Annotate the spectra against SGP
%
%
%
%See Annotate1SpecraDTA.

%Author: Gang Liu
%Date Lastly Updated: 12/23/14
spacing = 1.2;
scannum             = varargin{1};
spectra             = varargin{2};
peakMatchIndex      = varargin{3};
peakMatchIonIndex   = varargin{4};
foundPeaks          = varargin{5};
sgp                 = varargin{6};
z                   = varargin{7};
precursorMz         = varargin{8};
ionFragmentMatrix   = varargin{9};
score               = varargin{10};
fragMode            = varargin{11};
MS2tol              = varargin{12};
MS2tolUnit          = varargin{13};

if(nargin==14)
    figopt              = varargin{14};
    
    if(isfield(figopt,'export'))
        figexport   = figopt.export;
    else
        figexport   = 0;
    end
    
    if(isfield(figopt,'exportfolder'))
        figexportfolder   = figopt.exportfolder;
    else
        figexportfolder   = pwd;
    end
    
    if(isfield(figopt,'figstruct'))
        figstruct   = figopt.figstruct;
    else
        figstruct   = 3;
    end
    
    if(isfield(figopt,'display'))
        figdisplay   = figopt.display;
    else
        figdisplay   = 0;
    end
    
    if(isfield(figopt,'ionmark'))
        peakionannotate   = figopt.ionmark;
    else
        peakionannotate   = 1;
    end
    
    if(isfield(figopt,'massmark'))
        peakmassannotate   = figopt.massmark;
    else
        peakmassannotate   = 1;
    end
    
else
    figexport    = 0;
    figstruct    = 3;
    figdisplay   = 1;
    peakionannotate = 1;
    peakmassannotate=1;
    figexportfolder   = pwd;
end

figfilename = ['Spectra' num2str(scannum) '_' fragMode ...
    '_glycopeptideanalysis.jpg'];
figfilename = fullfile(figexportfolder,sprintf('%s',figfilename));
figdispname  = ['Glycoproteomics Analysis of ','Single Spectrum (scan number= ',...
    strtrim(int2str(scannum)),')'];
%%set up figure properties
h = figure('Name',figdispname,'NumberTitle','off',...
    'Position',[300 200 1200 600],'visible','off');
%% set up figure structure

if(figstruct==2)
    % set up spectra plot
    set(h,'Position',[300 200 1200 600]);
    spectraplot = axes('position',[0.30 .1 .68 .8],'parent',h);
    
    % set up ion table
    iontable_handle = uitable(h,'Units','normalized','Position',...
        [0.01 0.1 0.22 0.8]);
elseif(figstruct==3)
    % set up spectra plot
    set(h,'Position',[300 200 1200 700]);
    % use uipanel
    h_panel=uipanel('Title','','position',[0.005 0.005 0.99 0.99],...
        'parent',h,'units','normalized','BackgroundColor','white','Clipping','on');
    h_upper_panel=uipanel('position',[0.005 0.005 0.99 0.39],...
        'parent',h_panel,'units','normalized','BackgroundColor','white','Clipping','on');
    h_below_panel=uipanel('position',[0.005 0.405 0.99 0.59],...
        'parent',h_panel,'units','normalized','BackgroundColor','white','Clipping','on');
    
    % spectraplot =subplot(5,5,[2 3 4 5 7 8 9 10 12 13 14 15],'parent',h_below_panel);
    spectraplot = axes('position',[0.25 .1 .73 .87],'parent',h_below_panel);
    
    % set up ion table
    iontable_handle = uitable('Units','normalized','Position',...
        [0.02 0.02 0.18 0.96],'parent',h_below_panel);  % [0.3 .08  .65  .85]) %'Units','normalized',
    %set(iontable_handle,'ColumnWidth',{50,50,50,50})
    % set(iontable_handle,'ColumnFormat',{'char','char','char','char'})
    
    % set up found peak list table
    foundpeaktable_handle = uitable('Units','normalized','Position',...
        [0.02 0.02 0.96 0.96],'parent',h_upper_panel);  % [0.3 .08  .65  .85]) %'Units','normalized',
elseif(figstruct==1)
    % set up spectra plot
    set(h,'Position',[300 200 1200 600]);
    spectraplot = axes('position',[0.1 .1 .8 .8],'parent',h);
else
    error('MATLAB:GLYCOPAT:ERRORINPUT','INCORRECT INPUT');
end

set(h,'unit','normalized','Tag','MainFigure'); % set figure as non-resizable and unit as normalized
% set uicontrol default value
set(h,'defaultuicontrolunits','normalized'); % set uicontrol default value unit as normalized
set(h,'defaultuicontrolfontsize',8);  % set uicontrol default value fontsize as 11
set(h,'defaultuicontrolfontname','Arial'); % set uicontrol default value font name as arial
set(h,'defaultuicontrolhorizontal','left'); % set uicontrol default value character horizontal as left

%% plot spectra
peakMatchIndex_merge=peakMatchIndex;
[isoIndex,~]=findIsotopePeaks(spectra,MS2tol,MS2tolUnit);

for i=1:length(isoIndex)
    if any(peakMatchIndex_merge(isoIndex(i).mono))
        peakMatchIndex_merge(isoIndex(i).iso)=1;
    end
end

width1=0.5;
bar(spectraplot,spectra(~peakMatchIndex_merge,1),spectra(~peakMatchIndex_merge,2),width1,'r','EdgeColor','r');
hold on
bar(spectraplot,spectra(peakMatchIndex_merge,1),spectra(peakMatchIndex_merge,2),width1,'g','EdgeColor','g','clipping','on');
xlabel('mz','fontsize',12,'fontweight','bold');
ylabel('Ion Current','fontsize',12,'fontweight','bold');
ylim =get(spectraplot,'ylim');
set(spectraplot,'ylim',[ylim(1) ylim(2)*1.16]);
set(spectraplot,'ClippingStyle','rectangle')
% add SGP, precursor mz, and charge information to the spectra plot
headerlocationx = double(min(spectra(:,1)));
headerlocationy1 = double(max(spectra(:,2)))*1.15;
newsgp = strrep(sgp,'{','\{');
newsgp = strrep(newsgp,'}','\}');

% zoomh = zoom;
% setAxesZoomMotion(zoomh, spectraplot, 'horizontal');

% add found ion type text in the figure

monosaclist = Glycan.gly1let;
% lastmz = 0;
hitmz = max(spectra(:,1));
for i = 1 : length(peakMatchIndex)
    if(peakMatchIndex(i)==1)
        locationx = double(spectra(i,1));
        locationy = double(spectra(i,2));
        matchedionIndexs   =  peakMatchIonIndex{i};
        
        % find best match
        bestmatchindex = 0;
        smallppm = 10000;
        for j = 1 : length(matchedionIndexs)
            ppmError = foundPeaks(matchedionIndexs(j)).ppmError;
            if(smallppm > ppmError)
                smallppm       = ppmError;
                bestmatchindex = j;
            end
        end
        
        % display best matches
        if(bestmatchindex~=0)
            charge  = foundPeaks(matchedionIndexs(bestmatchindex)).charge;
            newtype = foundPeaks(matchedionIndexs(bestmatchindex)).iontype;
            
            %             iontype = [newtype '^{+' int2str(charge) '}'];
            annotatetext = '';
            if(peakmassannotate)
                locationxstr = num2str(locationx);
                decpos = strfind(locationxstr,'.');
                if ~isempty(decpos)
                    locationxstr = locationxstr(1:decpos + 1);
                end
                annotatetext = [annotatetext,locationxstr];
                %                 text(locationx,locationy,num2str(locationx),'fontsize',8,'Clipping','on','parent',spectraplot);
            end
            %
            if(peakionannotate)
                [~,glyMat,~] = breakGlyPep(foundPeaks(matchedionIndexs(bestmatchindex)).sgp);
                if ~isempty(glyMat)
                    thisglyms = glyMat.struct;
                else
                    thisglyms = '';
                end
                thisglymslist = '';
                for j = 1:length(monosaclist)
                    tempmsnum = length(strfind(thisglyms,monosaclist{j}));
                    if tempmsnum > 0
                        thisglymslist = [thisglymslist,monosaclist{j},num2str(tempmsnum)];
                    end
                end
                if ~isempty(thisglymslist)
                    thisglymslist = [' (',thisglymslist,')'];
                end
                annotatetext = [annotatetext,' ',newtype,thisglymslist,' ',num2str(charge),'+'];
                %                 text(locationx,locationy/2,iontype,'fontsize',8,'Clipping','on','parent',spectraplot);
            end
            if ~isempty(annotatetext)
                %                 if abs(locationx - lastmz) > spacing;
                if ~any(hitmz + spacing > locationx & hitmz - spacing < locationx )
                    text(locationx,locationy*1.1,annotatetext,'fontsize',8,'Clipping','on','parent',spectraplot,'rotation',90,'Clipping','on');
                end
            end
            hitmz = [hitmz;locationx];
%             lastmz = locationx;
        end
    end
end
header1Spectra = [newsgp ' ' strtrim(fragMode) ' ' strtrim(num2str(precursorMz)) '^{+' num2str(z) '} '];
text(headerlocationx,headerlocationy1,header1Spectra,'fontsize',10,'fontweight','bold','color','b','Clipping','on','parent',spectraplot,'backgroundcolor','w');

% add score information to the spectra plot
%% locationy2 = textrow1pos(2)-25;
locationy2 = double(max(spectra(:,2)))*1.08;
header2Spectra =['Scan Number: ', num2str(scannum),', ES: ', num2str(score.enscore),...
    ' , PValue: ', num2str(score.Pvalue),' , % Ion Match: ', num2str(score.percentIonMatch), ' , Top 10: ',...
    strtrim(int2str(score.Top10)),' , Xcorr: ', num2str(score.htAvg)];
text(headerlocationx,locationy2,header2Spectra,'fontsize',9,'fontweight','bold','Clipping','on','parent',spectraplot,'backgroundcolor','w');
% output fragmention ions match map in the upper portion
if(figstruct>=2)
    [tabledata,colnames] = fragPeak2table(ionFragmentMatrix);
    columnwidth = cell(1,length(colnames));
    columnformat = cell(1,length(colnames));
    
    for i = 1:length(colnames)
        columnwidth{i}=50;
        columnformat{i}='char';
    end
    set(iontable_handle,'ColumnWidth',columnwidth)
    set(iontable_handle,'ColumnFormat',columnformat)
    
    % center each cell
    set(iontable_handle,'Data',tabledata)
    set(iontable_handle,'ColumnName',colnames);
    
    % center each cell
    jscrollpane = findjobj(iontable_handle);
    jTable      = jscrollpane.getViewport.getView;
    cellStyle   = jTable.getCellStyleAt(0,0);
    cellStyle.setHorizontalAlignment(cellStyle.CENTER);
    set(iontable_handle,'rowname',[]);
    
    % 3 panel format
    if(figstruct==3)&&(~isempty(foundPeaks))
        
        
        for i = 1 : length(foundPeaks)
            foundpeakintensity(i) = foundPeaks(i).Intensity;
        end
        [newlist,newindex] = sort(foundpeakintensity,'descend');
        
        colnames = fieldnames(foundPeaks);
        removecolindex =[];
        for i = 1 : length(colnames)
            if(strcmpi(colnames{i},'original') || strcmpi(colnames{i},'type') || ...
                    strcmpi(colnames{i},'peakIndex'))
                removecolindex=[removecolindex;i];
            end
        end
        colnames(removecolindex)=[];
        colnames =[colnames(1);'ionType1';colnames(2:length(colnames))];
        
        %add new column ion complementary sequence
        for j = 1: length(newindex)
            foundPeaks(j).ionType1 = foundPeaks(j).type;
        end
        
        for j = 1: length(newindex)
            for i = 1:length(colnames)
                scoretabledata{j,i} = foundPeaks(newindex(j)).(colnames{i});
            end
        end
        
        % set column width
        columnwidth = cell(1,length(colnames));
        columnwidth{1} = 200;
        for i = 2 : length(colnames)
            columnwidth{i} = 'auto';
        end
        columnformat = {'char','char','numeric','numeric','numeric',...
            'numeric','longg','longg','longg',...
            'longg'};
        set(foundpeaktable_handle,'data',scoretabledata,...
            'ColumnFormat',columnformat);
        % center each cell
        jscrollpane = findjobj(foundpeaktable_handle);
        jTable      = jscrollpane.getViewport.getView;
        cellStyle   = jTable.getCellStyleAt(0,0);
        cellStyle.setHorizontalAlignment(cellStyle.CENTER);
        
        colnames{length(colnames)}='ionType2';
        
        set(foundpeaktable_handle,'ColumnWidth',columnwidth);
        set(foundpeaktable_handle,'ColumnName',colnames);
    end
end

if(figdisplay)
    set(h,'Visible','on');
end

if(figexport)
    if(labindex>0)
        % export_fig(h,figfilename,'-nocrop','-transparent','-native','-a4','-m2','-painters');
        export_fig(h,figfilename,'-painters','-transparent');
        % work in ccr cluste: 12/31/14 export_fig(h,figfilename,'-painters','-transparent','-m2');
        % not WOKRING IN export_fig(h,figfilename,'-painters','-transparent','-m2','-native');
    else
        export_fig(h,figfilename,'-nocrop','-transparent');
    end
end


end

function [tabledata,colnames] = fragPeak2table(ionFragmentMatrix)
datarownum = 0;
datacolnum = 0;
iontypes = fieldnames(ionFragmentMatrix);
for i=1 : length(iontypes)
    ithion = iontypes{i};
    iontyperownum = size(ionFragmentMatrix.(ithion),1);
    if(iontyperownum~=0)
        datacolnum=datacolnum+1;
    end
    
    if(datarownum<iontyperownum)
        datarownum = iontyperownum;
    end
end
tabledata  = cell(datarownum,datacolnum);

colpos = 1;
for i=1:length(iontypes)
    ithion = iontypes{i};
    ithionfrag  = ionFragmentMatrix.(ithion);
    if(isempty(ithionfrag));
        continue;
    end
    
    tabledata(1:size(ithionfrag,1),colpos:colpos+1)=ithionfrag;
    
    %     for j=1:size(ithionfrag,1)
    %         tabledata{j,colpos}   = ithionfrag{j,1};
    %         tabledata{j,colpos+1} = ithionfrag{j,2};
    %     end
    colpos = colpos+2;
end

colnames = cell(datacolnum*2,1);
for i = 1 : length(colnames)/2
    colnames{(i-1)*2+1}='Ion type';
    colnames{(i-1)*2+2}='Found';
end

end