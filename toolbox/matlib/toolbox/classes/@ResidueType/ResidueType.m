classdef ResidueType < hgsetget
    %ResidueType class representing properties for the monosaccharide type
    %
    % ResidueType properties:
    %  name                - name of the residue type
    %  desc                - detailed description of the residue
    %  synonyms            - the synonyms of the residue type
    %  superclass          - residue type superclass
    %  IUPACNAME           - IUPAC name
    %  anomericCarbon      - anomeric carbon position
    %  chirality           - the chirality
    %  ringSize            - the size of the monosaccharide ring structure
    %  isSaccharide        - the logical value if the residue is saccharide
    %  nAcetyls            - number of acetyl groups
    %  nMethyls            - number of methyl groups
    %  nlinkages           - number of linkages
    %  linkagePos          - the positions of linkages
    %  chargesPos          - charge positions
    %  compositionClass    - the composition class
    %  resMassMain         - mass used currently for the residue
    %  resMassAvg          - average mass used currently for the residue
    %  dropMthylated       - if the iron drop methylated
    %  dropAcetylated      - if the iron drop acetylated
    %  isCleavable         - if the structure cleavable
    %  isLabile            - if the structure alterable
    %  canRedend           - if the residue can be reducing end
    %  canParent           - if the residue can be parent
    %
    %
    % ResidueType  methods:
    %  ResidueType         -  create a ResidueType  object
    %  resTypetoString     -  export residue type properties to a string
    %  resTypeMat2Java     -  convert a MATLAB ResidueType object to a Java ResidueType object
    %  clone               -  copy a ResidueType object
    %
    % See also GlycanResidue,GlycanStruct.
    
    % Author: Gang Liu
    % CopyRight 2012 Neelamegham Lab
    
    properties
        %NAME the name of the residue type
        %   NAME is a character array
        %
        % See also ResidueType
        name                             %1
    end
    
    properties
        % DESC description of the residue type
        %   DESC is a character array
        %
        % See also ResidueType
        desc                               %2
    end
    
    properties
        % SYNONYMS residue name synonyms
        %     SYNONYMS is a character array
        %
        % See also ResidueType
        synonyms                     %3
    end
    
    properties
        % SUPERCLASS residue type superclass
        %     superclass is a character array
        %
        % See also ResidueType
        superclass                   %4
    end
    
    properties
        % IUPACNAME name in IUPAC format
        %     IUPACNAME is a character array
        %
        % See also ResidueType
        iupacName                 %5
    end
    
    properties
        % ANOMERICCARBON the position of anomeric carbon
        %    ANOMERICCARBON is a character array
        %
        % See also ResidueType
        anomericCarbon        %6\
    end
    
    properties
        % CHIRALITY the stereisomer property
        %   CHIRALITY  is a char
        %
        % See also ResidueType
        chirality                          %7
    end
    
    properties
        %  RINGSIZE  the size of the ring structure
        %     RINGSIZE is a numeric type (double)
        %
        % See also ResidueType
        ringSize                         %8
    end
    
    properties
        %  ISSACCHARIDE describes if the residue is a saccharide or not
        %    ISSACCHARIDE is a logic value
        %
        % See also ResidueType
        isSaccharide               %9
    end
    
    properties
        %  NACETYLS the number of the acetyles
        %     NACETYLS is a numeric type (double)
        %
        %
        % See also ResidueType
        nAcetyls                        %10
    end
    
    properties
        %  NMETHYLS the number of methyles
        %     NMETHYLS is a numeric type (double)
        %
        %
        % See also ResidueType
        nMethyls                       %11
    end
    
    properties
        %  NLINKAGES the number of linkages
        %      NLINKAGES is a numeric type
        %
        % See also ResidueType
        nlinkages                     %12
    end
    
    properties
        %  LINKAGEPOS the position of the linkage
        %     LINKAGEPOS is a character array
        %
        % See also ResidueType
        linkagePos                  %13
    end
    
    properties
        % CHARGEPOS the position of the charge in the structure
        %     CHARGEPOS is a numeric scalar (double)
        %
        % See also ResidueType
        chargesPos                %14
    end
    
    properties
        % COMPOSITIONCLASS the class of the composition
        %     COMPOSITIONCLASS  is a character array
        %
        % See also ResidueType
        compositionClass;   %15
    end
    
    properties
        %  RESMASSMAIN monoisotopic mass of the residue
        %      RESMASSMAIN is a numeric scalar (double)
        %
        % See also ResidueType
        resMassMain           %16
    end
    
    properties
        %  RESMASSAVG average  mass of the residue
        %      RESMASSAVG is a numeric scalar (double)
        %
        % See also ResidueType
        resMassAvg             %17
    end
    
    properties
        %   DROPMTHYLATED
        %       DROPMTHYLATED is a logic scalar
        %
        % See also ResidueType
        dropMthylated          %18
    end
    properties
        %   DROPACETYLATED
        %       DROPACETYLATED is a logic scalar
        %
        % See also ResidueType
        dropAcetylated         %19
    end
    
    properties
        %  ISCLEAVABLE indicate if the residue is cleavable
        %      ISCLEAVABLE is a logic scalar
        %
        % See also ResidueType
        isCleavable             %20
    end
    
    properties
        %  ISLABILE indicate if the residue is easily altered
        %      ISLABILE is a logic scalar
        %
        % See also ResidueType
        isLabile                    %21
    end
    
    properties
        % CANREDEND indicate if the residue can be reducing end
        %     CANREDEND is a logic scalar
        %
        % See also ResidueType
        canRedend             %22
    end
    
    properties
        % CANPARENT indicate if the residue can be parent residue
        %     CANPARENT is a logic scalar
        %
        %
        % See also ResidueType
        canParent               %23
    end
    
    methods  % constructor
        function obj= ResidueType(varargin)
            %ResidueType create a ResidueType object
            %
            %      RT = ResidueType() creates a default ResidueType.
            %
            %      RT = ResidueType(RTJAVA) converts a Java ResidueType object
            %      to a MATLLAB ResidueType object.
            %
            %  See also GlycanResidue,GlycanStruct.
            
            % validate the number of input arguments
%             if(~verLessThan('matlab','7.13'))
%                 narginchk(0,1);
%             else
                error(nargchk(0,1,nargin));
%             end
                       
            if(nargin==0)
                obj.name = '#empty';   %1
                obj.desc = 'Empty'; %2
                obj.synonyms ='Empty'; %3
                obj.superclass = 'special'; %4
                obj.iupacName = '-'; %5
                obj.anomericCarbon = '?'; %6
                obj.chirality = '?'; %7
                obj.ringSize = '?'; %8
                
                obj.isSaccharide = 0; %9
                obj.nAcetyls = 0; %10
                obj.nMethyls = 0; %11
                obj.nlinkages = 0;%12
                
                obj.linkagePos ='?'; %13
                obj.chargesPos ='?'; %14
                obj.compositionClass = '?'; %15
                
                obj.resMassMain = 0.0;%17
                obj.resMassAvg =0.0 ;%18
                obj.dropMthylated = 0;%19
                obj.dropAcetylated = 0;%20
                
                obj.isCleavable = 0;%21
                obj.isLabile = 0; %22
                obj.canRedend = 0;%23
                obj.canParent = 0;%24
            elseif(nargin==1)
                firstArg = varargin{1};
                import org.eurocarbdb.application.glycanbuilder.ResidueType;
                if(isa(firstArg,'org.eurocarbdb.application.glycanbuilder.ResidueType'))
                    obj.name = char(firstArg.getName); %1
                    obj.superclass =  char(firstArg.getSuperclass); %4
                    obj.compositionClass = char(firstArg.getCompositionClass);  %15
                    obj.synonyms = char(firstArg.getSynonyms); %3
                    obj.iupacName = char(firstArg.getIupacName); %5
                    obj.anomericCarbon = char(firstArg.getAnomericCarbon);%6
                    obj.chirality = char(firstArg.getChirality); %7
                    obj.ringSize =char(firstArg.getRingSize); %8
                    obj.isSaccharide = firstArg.isSaccharide; %9
                    obj.isCleavable = firstArg.isCleavable; %21
                    obj.isLabile = firstArg.isLabile; %22
                    obj.resMassMain =   firstArg.getResidueMassMain; %17
                    obj.resMassAvg   =  firstArg.getResidueMassAvg; %18
                    obj.nMethyls = firstArg.getNoMethyls; %11
                    obj.dropMthylated = firstArg.isDroppedWithMethylation;%19
                    obj.nAcetyls = firstArg.getNoAcetyls; %10
                    obj.dropAcetylated = firstArg.isDroppedWithAcetylation; %20
                    obj.nlinkages       = firstArg.getMaxLinkages;      %12
                    obj.linkagePos    = firstArg.getLinkagePositions; %13
                    obj.chargesPos   = firstArg.getChargePositions; %14
                    obj.canRedend = firstArg.canBeReducingEnd;%23
                    obj.canParent = firstArg.canHaveParent;   %24
                    obj.desc = char(firstArg.getDescription); %2
                end
            end
        end
    end
    
    methods
        resTypeJava = resTypeMat2Java(obj)
    end
    
    methods
        function toString = resTypetoString(obj)
            % resTypetoString export residue type properties to a string
            %
            %     RTSTRING = resTypeToString(obj) output residue type
            %     properties to a string.
            %
            %
            % See also RESIDUETYPE
            
%             tab = sprintf('\t');
%             toString = strcat(obj.name,tab); %1
%             toString = strcat(toString,isEmptyString(obj.superclass)); %2
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,sprintf('%s',obj.compositionClass));%3
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,isEmptyString(obj.synonyms));%4
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,sprintf('%s',obj.iupacName));%5
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,sprintf('%s',obj.anomericCarbon));%6
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,sprintf('%s',obj.chirality));%7
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,sprintf('%s',obj.ringSize));%8
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,parseBool2Str(obj.isSaccharide));%9
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,parseBool2Str(obj.isCleavable));%10
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,parseBool2Str(obj.isLabile));%11
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,sprintf('%i',0));%12
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,sprintf('%i',obj.resMassMain));%13
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,sprintf('%i',obj.resMassAvg));%14
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,sprintf('%i',obj.nMethyls));%15
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,sprintf('%i',obj.dropMthylated));%16
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,sprintf('%i',obj.nAcetyls));%17
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,parseBool2Str(obj.dropMthylated));%18
%             toString = strcat(toString,tab);
%             toString  = strcat(toString, sprintf('%i',obj.nlinkages));%19
%             toString = strcat(toString,tab);
%             toString  = strcat(toString, isEmptyString(obj.linkagePos) );%20
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,isEmptyString(obj.chargesPos) );%21
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,parseBool2Str(obj.canRedend));%22
%             toString = strcat(toString,tab);
%             toString  = strcat(toString,parseBool2Str(obj.canParent));%23
%             toString = strcat(toString,tab);
%             toString  = strcat(toString, sprintf('%s',obj.desc));%24

%           tab = sprintf('\t');
%             toString = [obj.name tab ... %]; %1 
%              isEmptyString(obj.superclass) tab...];%2
%             sprintf('%s',obj.compositionClass) tab...];%3
%             isEmptyString(obj.synonyms) tab...];%4   //not display
%             sprintf('%s',obj.iupacName) tab...];%5
%             sprintf('%s',obj.anomericCarbon) tab...];%6
%             sprintf('%s',obj.chirality) tab...]; %7
%             sprintf('%s',obj.ringSize) tab...];%8
%             parseBool2Str(obj.isSaccharide) tab...];%9
%             parseBool2Str(obj.isCleavable) tab...];%10
%             parseBool2Str(obj.isLabile) tab...];%11
%             sprintf('%i',0) tab...];      %12
%             sprintf('%i',obj.resMassMain) tab...];%13
%             sprintf('%i',obj.resMassAvg) tab...];%14
%             sprintf('%i',obj.nMethyls) tab...];%15
%             parseBool2Str(obj.dropMthylated) tab...];%16
%             sprintf('%i',obj.nAcetyls) tab...];%17
%             parseBool2Str(obj.dropMthylated) tab...]; %18
%             sprintf('%i',obj.nlinkages) tab...];%19
%             isEmptyString(obj.linkagePos) tab...];%20
%             isEmptyString(obj.chargesPos) tab...];%21
%             parseBool2Str(obj.canRedend) tab...];%22
%             parseBool2Str(obj.canParent) tab...];  %23
%             sprintf('%s',obj.desc)];%24
        
          toString = sprintf('%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%i\t%i\t%i\t%i\t%s\t%i\t%s\t%i\t%s\t%s\t%s\t%s\t%s',...
              obj.name,isEmptyString(obj.superclass),obj.compositionClass,...
              isEmptyString(obj.synonyms),obj.iupacName,obj.anomericCarbon,...];%6
              obj.chirality,obj.ringSize,parseBool2Str(obj.isSaccharide), ...];%9
              parseBool2Str(obj.isCleavable),parseBool2Str(obj.isLabile), 0,...
              obj.resMassMain,obj.resMassAvg,obj.nMethyls,...
             parseBool2Str(obj.dropMthylated),obj.nAcetyls,...
             parseBool2Str(obj.dropMthylated),obj.nlinkages,...
             isEmptyString(obj.linkagePos),isEmptyString(obj.chargesPos),...
             parseBool2Str(obj.canRedend),parseBool2Str(obj.canParent),...
             obj.desc);
           
%             tab = sprintf('\t');
%             toString = [obj.name tab]; %1
%             toString = [toString isEmptyString(obj.superclass) tab];%2
%             toString = [toString sprintf('%s',obj.compositionClass) tab];%3
%             toString = [toString isEmptyString(obj.synonyms) tab];%4   //not display
%             toString = [toString sprintf('%s',obj.iupacName) tab];%5
%             toString = [toString sprintf('%s',obj.anomericCarbon) tab];%6
%             toString = [toString sprintf('%s',obj.chirality) tab]; %7
%             toString = [toString sprintf('%s',obj.ringSize) tab];%8
%             toString = [toString parseBool2Str(obj.isSaccharide) tab];%9
%             toString = [toString parseBool2Str(obj.isCleavable) tab];%10
%             toString = [toString parseBool2Str(obj.isLabile) tab];%11
%             toString = [toString sprintf('%i',0) tab];      %12
%             toString = [toString sprintf('%i',obj.resMassMain) tab];%13
%             toString = [toString sprintf('%i',obj.resMassAvg) tab];%14
%             toString = [toString sprintf('%i',obj.nMethyls) tab];%15
%             toString = [toString parseBool2Str(obj.dropMthylated) tab];%16
%             toString = [toString sprintf('%i',obj.nAcetyls) tab];%17
%             toString = [toString parseBool2Str(obj.dropMthylated) tab]; %18
%             toString = [toString sprintf('%i',obj.nlinkages) tab];%19
%             toString = [toString isEmptyString(obj.linkagePos) tab];%20
%             toString = [toString isEmptyString(obj.chargesPos) tab];%21
%             toString = [toString parseBool2Str(obj.canRedend) tab];%22
%             toString = [toString parseBool2Str(obj.canParent) tab];  %23
%             toString = [toString sprintf('%s',obj.desc)];%23
            
            function boolStr = parseBool2Str(varBool)
                if(varBool)
                    boolStr='true';
                else
                    boolStr='false';
                end
            end
            
            function results = isEmptyString(str)
                if(isempty(str))
                    results='?';
                else
                    if(size(str,1)==1)
                        results=str(1);
                    else
                        results=str';
                        results=results(1);
                    end
                end
            end
        end
    end
    
    methods
        function new = clone(obj)
            %CLONE copy a ResidueType object
            %  CLONE(RESIDUETYPEobj) creates a new ResidueType object
            %
            %  See also ResidueType
            
            % Instantiate new object of the same class.
            new = feval(class(obj));
            
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                if(isa(obj.(p{i}),'handle'))
                    new.(p{i}) = obj.(p{i}).clone;
                else
                    new.(p{i}) = obj.(p{i});
                end
            end
        end
    end
    
    
end

