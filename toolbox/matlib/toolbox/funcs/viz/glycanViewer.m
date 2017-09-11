function glycanViewer(varargin)
%glycanViewer read a GlycanStruct object and return a graphical 
% representation of its 2D structure.
% 
% glycanViewer(GLYCANSTRUCTOBJ,OPTIONS) reads a GlycanStruct object 
%  GLYCANSTRUCTOBJ,and the display options defined in the input argument
%  OPTIONS. The function returns a graphics showing the glycan structure. 
%  OPTIONS is a MATLAB structure variable and can be created using the 
%  DISPLAYSET function. See displayset for more detail. Two options 
%  commonly used are "showMass" (true or false) and "showLinkage"
%  (true or false).
%
% glycanViewer(GLYCANSTRUCTOBJ) uses the default display options to show 
%  the glycan's structure.
%
% glycanViewer(GLYCANJAVAOBJ,...) uses a Glycan Java Object GLYCANJAVAOBJ  
%  defined in GlycanBuilder library as the input format.
%   
% Example 1:
%  glycanStructObj = glycanMLread('highmannose.glycoct_xml');
%  glycanViewer(glycanStructObj);
%
% Example 2:
%  gDispOption1    = displayset('showmass',true,'showLinkage',true,...
%      'showRedEnd',true);
%  gDispOption2    = displayset(gDispOption1,'Isotope','AVG',...
%      'Derivatization','perDMe','IonCloudCharge','K');
%  glycanStructObj = glycanMLread('highmannose.glycoct_xml');
%  glycanViewer(glycanStructObj,gDispOption1);
%  glycanViewer(glycanStructObj,gDispOption2);
%  
% Example 3:
%  gDispOption1    = displayset('showmass',true,'showLinkage',true,...
%       'showRedEnd',true);
%  glycanStructObj = glycanMLread('highmannose.glycoct_xml');
%  glycanJavaObj   = glycanStructObj.structMat2Java;
%  glycanViewer(glycanJavaObj)
%  glycanViewer(glycanJavaObj,gDispOption1);
%
% See also glycanFileViewer,glycanMLread,glycanMLwrite,glycanStrread,
%  glycanStrwrite,glycanNetViewer,glycanNetFileViewer,displayset,
%  displayget.

% Author: Gang Liu
% Date Lastly Updated: 8/11/13

import java.awt.BorderLayout;
import java.net.MalformedURLException;

import javax.swing.JFrame;
import javax.swing.JScrollPane;

import org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
import org.eurocarbdb.application.glycanbuilder.GlycanCanvas;
import org.eurocarbdb.application.glycanbuilder.GlycanDocument;

% input check
error(nargchk(1,2,nargin));
    
% input number check
if (nargin==1)
    glycanObj = varargin{1};
    options = displayset; %getDefaultDispoptions();
elseif(nargin==2)
    glycanObj = varargin{1};
    options =  varargin{2};
end

% input variable type check
isGlycanMat = isa(glycanObj,'GlycanStruct');
isGlycanSpecies = isa(glycanObj,'GlycanSpecies');
isGlycanJava = isa(glycanObj,'org.eurocarbdb.application.glycanbuilder.Glycan');

if ~(isGlycanMat||isGlycanJava||isGlycanSpecies)
    errorReport(mfilename,'WrongInputType');
end;

%   convert to glycan java structure
if(isGlycanMat)
    glycanStruct = structMat2Java(glycanObj);
elseif(isGlycanSpecies)
    glycanStruct = glycanObj.glycanStruct;
else
    glycanStruct = glycanObj;
end

% set up workspace
glycanWorkSpace = BuilderWorkspace;
glycanWorkSpace.setAutoSave(true);

%set up glycan document store
glycanDoc = glycanWorkSpace.getStructures();
try
    glycanDoc.addStructure(glycanStruct);
catch exception
    rethrow(exception);
    errorReport(mfilename,'IncorrectGlycanStructure');
end

%set up display options for workspace
if(~isempty(options))
    theGraphicOptions = glycanWorkSpace.getGraphicOptions();
    
    % first options: display molecular weight
     theGraphicOptions.SHOW_MASSES_CANVAS=displayget(options,'showMass');
        
    % second option: display reducing end
     theGraphicOptions.SHOW_REDEND_CANVAS=displayget(options,'showRedEnd');
        
    % show linkage
    if(displayget(options,'showLinkage'))
        glycanWorkSpace.setDisplay('linkage');
    else
        glycanWorkSpace.setDisplay('compact');
    end
    
    % if showMass option is true, set up details of showMass
    theMassOptions=glycanWorkSpace.getDefaultMassOptions();
    theMassOptions.setIsotope(java.lang.String(displayget(options,'Isotope')));
    theMassOptions.setDerivatization(java.lang.String(displayget(options,'Derivatization')));
    
    theMassOptions.ION_CLOUD.clear;
    theMassOptions.ION_CLOUD.initFromString(java.lang.String(displayget(options,'IonCloudCharge')));
end

%set up display options for glycan
theGlycan=glycanDoc.getFirstStructure();

theGlycan.setMassOptions(theMassOptions);

%set the layout
%glycangraph = get(gcf,'JavaFrame');
glycangraph = JFrame;
glycangraph.getContentPane().setLayout(BorderLayout);

% show structure in the canvas
glycanCanvas = GlycanCanvas(glycangraph,glycanWorkSpace);
sp = JScrollPane(glycanCanvas);
glycanCanvas.setScrollPane(sp);
glycangraph.getContentPane.add(sp,BorderLayout.CENTER);

% setIconImage(FileUtils.defaultThemeManager.getImageIcon("logo").getImage());
glycangraph.setVisible(true);
glycangraph.setSize(400, 300);
glycangraph.setLocationRelativeTo([]);
end