function glycanString=getGlycanStringFromFile(glycanFileName,glycanFileFormat,varargin)
mFileName = 'getGlycanString';

% import glycans
import java.awt.BorderLayout;
import java.net.MalformedURLException;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
import org.eurocarbdb.application.glycanbuilder.GlycanCanvas;
import org.eurocarbdb.application.glycanbuilder.GlycanDocument;

% set up workspace
glyWorkSpace = BuilderWorkspace;
glyWorkSpace.setAutoSave(true);
% glycanFileFormat = 'glycoct_xml';

%set up glycan document store
glycanFullFileName = which(glycanFileName);
glycanDoc = glyWorkSpace.getStructures();
try
      glycanDoc.importFrom(glycanFullFileName,glycanFileFormat);
catch exception
      rethrow(exception);
      error('GlycoToolbox:glycanViewer:badFileName','bad string for xml');
end
% import all glycan structures into matlab environment
glycanString = char(glycanDoc.toGlycoCT());
if(length(varargin)==1)
     exportFormat = varargin{1,1};
     glycanString = char(glycanDoc.toString(exportFormat));       
end    

