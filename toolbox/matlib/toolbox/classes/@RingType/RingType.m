classdef RingType <handle
    %RingType class representing ring type structure of monosaccharide residue
    %
    % RingType properties:
    %  rSize          - the number of the ring structure
    %  name           - short name of the ring structure
    %  fullName       - full name of the ring structure
    %
    % RingType methods:
    %   RingType       - RingType constructor
    %  getRingSize    - retrieve "rSize" property
    %  getName        - retrieve "Name" property
    %  getFullName    - retrieve "FULLNAME" property
    %  setRingSize    - set "RingSize" property
    %  setName        - set "Name" property
    %  setFullName    - set "FullName" property
    %  clone          - copy a RINGTYPE object
    %
    % See also GlycanResidue,GlycanLinkage.
    
    % Author: Gang Liu
    % CopyRight 2012 Neelamegham Lab.
    
    properties
        % RSIZE the size of ring structure
        %    RSIZE property is a numeric double
        %
        % See also RingType
        rSize;
    end
    
    properties
        % NAME the short name of the ring structure
        %    NAME property is a character array
        %
        % See also RingType
        name;
    end
    
    properties
        % FULLNAME the full name of the ring structure
        %    FULLNAME property is a character array
        %
        % See also RingType
        fullName;
    end
    
    methods
        function obj=RingType(rSize_in,varargin)
        % RingType create a RingType object
        %
        % R = RingType(NRINGSIZE) creates a ring-type structure and the
        % size of ring structure is NRINGSIZE
        %
        % R = RingType(NRINGSIZE, RINGSHORTNAME) creates a ring-type structure and
        % size of ring structure is NRINGSIZE and the short name is RINGSHORTNAME
        %
        % R = RingType(NRINGSIZE, RINGSHORTNAME,RINGFULLNAME) creates a ring-type structure.
        %  The size of ring structure is NRINGSIZE, the short name is
        %  RINGSHORTNAME and the full name is RINGFULLNAME.
        %
        %
        %  See also RingType
            
            % validate the number of input arguments
%              if(~verLessThan('matlab','7.13'))
%                 narginchk(0,3);
%             else
                error(nargchk(0,3,nargin));
%             end
            if(nargin>0)
                obj.rSize = rSize_in;
                if size(varargin,1)==1
                    obj.name = varargin{1};
                end
                
                if size(varargin,1)==2
                    obj.fullName = varargin{2};
                end
            end
            
        end  % constructor
        
        function name=getName(obj)
        % getName get the short name of the ring-type structure
        %
        % See also RingType
            name = obj.name  ;
        end
        
        function fullName=getFullName(obj)
            % getFullName get the full name of the ring-type structure
            %
            % See also RingType
            fullName = obj.fullName  ;
        end
        
        function ringSize=getRingSize(obj)
            %getRingSize get the size of ring structure in the ring skeleton
            %
            %  See also RingType
            ringSize= obj.rSize;
        end
        
        function obj=setName(obj,name)
            % setName set the short name of the ring-type structure
            %
            %  See also RingType
            obj.name = name;
        end
        
        
        function obj=setFullName(obj,fullName)
            % setFullName set the full name of the ring-type structure
            %
            %  See also RingType
            obj.fullName = fullName;
        end
        
        function obj=setRingSize(obj,size)
            % setRingSize set the size of the ring-type structure
            %
            %  See also RingType
            obj.rSize = size;
        end
    end
    
    methods
        function new = clone(obj)
            %clone copy a RINGTYPE object
            %  clone(RINGTYPEobj) creates a new RINGTYPE object
            %
            %  See also RingType.
            
            % Instantiate new object of the same class
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
    
    %     enumeration
    %         pyr('p',6);
    %         fur('f',5);
    %         unknownRingType('Unknown');
    %         openRingType('Open');
    %     end
end

