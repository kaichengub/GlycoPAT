function glycanFileViewer(glycanFileName, varargin )
%glycanFileViewer read the sequence file of a glycan and return a graphical 
% represenation of its 2D structure.
%
% glycanFileViewer(FILENAME, FILEFORMAT,OPTIONS) reads a file name
%  in the string input argument FILENAME using a sequence format specified 
%  with the input argument FILEFORMAT, and the display options defined in 
%  the input argument OPTIONS. The function returns a graphics showing the
%  glycan structure. Options is a MATLAB structure variable and can be 
%  created with display function. see DISPLAYSET for details. Commonly used 
%  options are "showMass" (true or false) and "showLinkage"(true or false).
%
% glycanFileViewer(FILENAME, FILEFORMAT) returns a graphics showing the
%  glycan structure using default display options as an input.
%
% glycanFileViewer(FILENAME) returns a graphics showing the
%  glycan structure using default display options. The glycan
%  file format is Glycoct. "glycoct_xml" as the inputs.
% 
% Example 1:
%  glycanFileViewer('highmannose.glycoct_xml');
%
% Example 2:
%  glycanFileViewer('highmannose.glycoct_xml','glycoct_xml');
%  glycanFileViewer('highmannose.linucs','linucs')
%
% Example 3:
%  gDispOption1 = displayset('showmass',true,'showLinkage',true,'showRedEnd',true);
%  gDispOption2 = displayset(gDispOption1, 'Isotope','AVG','Derivatization','perDMe','IonCloudCharge','K');
%  glycanFileViewer('highmannose.glycoct_xml','glycoct_xml',gDispOption2);
%  glycanFileViewer('highmannose.glycoct_xml','glycoct_xml',gDispOption1);
%
% See also glycanViewer, glycanMLread, glycanMLwrite,glycanStrread,glycanStrwrite,
% glycanNetViewer,glycanNetFileViewer,displayset,displayget.

% Author: Gang Liu
% Date Lastly Updated: 8/2/13

import java.awt.BorderLayout;
import java.net.MalformedURLException;

import javax.swing.JFrame;
import javax.swing.JScrollPane;

import org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
import org.eurocarbdb.application.glycanbuilder.GlycanCanvas;
import org.eurocarbdb.application.glycanbuilder.GlycanDocument;

% check the number of the inputs
if(~verLessThan('matlab','7.13'))
    narginchk(1,3);
else
    error(nargchk(1,3,nargin));
end

if (nargin == 1)
    glyFileFormat = 'glycoct_xml';
    options =displayset;
elseif(nargin == 2)
    glyFileFormat  = varargin{1};
    options = displayset;
elseif(nargin == 3)
    glyFileFormat  = varargin{1};
    options =  varargin{2};
end

% check input variable
isCharArg = ischar(glycanFileName)&&ischar(glyFileFormat) ;
if(~isCharArg)
    errorReport(mfilename,'NonStringInput');
end

% check if file exists
glycanFullFileName = which(glycanFileName);
isFileExist = exist(glycanFullFileName,'file');
if(~isFileExist)
    errorReport(mfilename,'FileNotFound');
end

%check if viewer option has been set up properly
% To Be Written

% set up workspace
glycanWorkSpace = BuilderWorkspace;
glycanWorkSpace.setAutoSave(true);

%set up display options %default option---with molecular weight and linkage
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
   % if showMass option is true, set up details of showMass
    theMassOptions=glycanWorkSpace.getDefaultMassOptions();
    theMassOptions.setIsotope(java.lang.String(displayget(options,'Isotope')));
    theMassOptions.setDerivatization(java.lang.String(displayget(options,'Derivatization')));
    
    theMassOptions.ION_CLOUD.clear;
    theMassOptions.ION_CLOUD.initFromString(java.lang.String(displayget(options,'IonCloudCharge')));
end

%set up glycan document store
glyDoc = glycanWorkSpace.getStructures();
try
    glyDoc.importFrom(glycanFullFileName,glyFileFormat);
catch exception
    rethrow(exception);
    errorReport(mfilename,'IncorrectGlycanFile');
end

%set the layout
glycangraph = JFrame;
glycangraph.getContentPane().setLayout(BorderLayout);

%set canvas and scroopane
glycanCanvas = GlycanCanvas(glycangraph,glycanWorkSpace);
sp = JScrollPane(glycanCanvas);
glycanCanvas.setScrollPane(sp);

% set up the image
glycangraph.getContentPane.add(sp,BorderLayout.CENTER);
glycangraph.setVisible(true);
glycangraph.setSize(400, 300);
glycangraph.setLocationRelativeTo([]);

end



 

