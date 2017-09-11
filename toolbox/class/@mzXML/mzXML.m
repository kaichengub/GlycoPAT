classdef mzXML < handle
    %MZXML: An object storing the MS data in MZXML format
    %
    % Syntax:
    %          mzXMLobj = mzXML(mzxmlfilename);
    %          mzXMLobj = mzXML(mzxmlfilename,showprogress);
    %          mzXMLobj = mzXML(mzxmlfilename,showprogress,'memsave');
    %          mzXMLobj = mzXML(mzxmlfilename,showprogress,'fastload');
    %
    % Input:
    %          mzxmlfilename: mzXML file name
    %          showprogress:
    %                1:  if the progress bar will be shown
    %                0:  not shown
    %
    %          'memsave':
    % if incl. in 3rd argument: MS data are stored in the Java variables
    %                  default: MS data are stored in the Java & MATLAB varaibles
    %
    %          'fastload':
    % if incl. in 3rd argument: does not load the software instrumentation info.
    %                  default: load the software instrument & data processing info.
    %
    % Output:
    %          mzXMLobj: an mzXML object
    %
    % Example 1:
    %          mzXMLobj = mzXML('demofetuin.mzXML');
    % Example 2:
    %          mzXMLobj = mzXML('demofetuin.mzXML',1);
    % Example 3:
    %          mzXMLobj = mzXML('demofetuin.mzXML',0,'memsave');
    % Example 4:
    %          mzXMLobj = mzXML('demofetuin.mzXML',0,'fastload');
    %
    %
    %See Also retrieveMSSpectra,readmzXML
    
    % Author: Gang Liu
    % Date Lastly updated: 08/05/15
    properties
        mzxmljava;
        extmzxmljava;
        scandata;
        instrumentinfo;
        dataprocessinginfo;
    end
    
    methods
        function obj=mzXML(varargin)
            import org.systemsbiology.jrap.MSXMLParser;
            import java.io.File;
            import org.systemsbiology.jrap.extension.ExtMSXMLParser;
            
            if(nargin==1) || (nargin==2) || (nargin==3)
                fileexist = exist(varargin{1},'file')==2;
                if(~fileexist)
                    error('MATLAB:GlycoPAT:FILENOTFOUND','mzXML FILE IS NOT FOUND');
                end
                
                mzxmlfilename = varargin{1};
                [pathstr,name,ext] = fileparts(mzxmlfilename);
                if(~strcmpi(ext,'.mzxml')&& ~strcmpi(ext,'.xml'))
                    error('MATLAB:GlycoPAT:WRONGINPUTFILETYPE','WRONG INPUT FILE TYPE');
                end
                
                if(isempty(pathstr))
                    mzxmlfilename = which(mzxmlfilename);
                end
                
                if(nargin==2)||(nargin==3)
                    showpro = varargin{2};
                else
                    showpro = 0;
                end
            end
            
            if(nargin==3)
                if(strcmpi(varargin{3},'memsave'))
                    memObjsave = 1;
                    fastload   = 0;
                elseif(strcmpi(varargin{3},'fastload'))
                    memObjsave = 0;
                    fastload   = 1;
                end
            else
                memObjsave     = 0;
                fastload       = 0;
            end
            
            try
                obj.mzxmljava    = MSXMLParser(mzxmlfilename);
                obj.extmzxmljava = ExtMSXMLParser(mzxmlfilename);
            catch err
                error('MATLAB:GlycoPAT:INCORRECTFILE','INCORRECT mzXML FILE');
            end
            
            if(~memObjsave)
                if(~fastload)
                    obj.setScanData(showpro);
                    obj.setInstrumentInfo();
                    obj.setDataProcessInfo();
                else
                    obj.setScanData(showpro,1);
                end
            end
        end
    end
end

