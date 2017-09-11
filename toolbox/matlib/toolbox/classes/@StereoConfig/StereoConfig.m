classdef StereoConfig <handle
    %StereoConfig class represent the stereochemical property of the molecule
    %
    % StereoConfig properties:
    %  convention       - name convention used for stereochemical molecule
    %  symbol           - stereochemical symbol
    %
    % StereoConfig methods:
    %  StereoConfig     - create a StereoConfig object
    %  getConvention    - get "convention" property
    %  getSymbol        - get "symbol" property
    %  setConvention    - set "convention" property
    %  setSymbol        - set "symbol" property
    %  clone            - copy a StereoConfig object
    %
    % See also GlycanResidue.
    
    % Author: Gang Liu
    % CopyRight 2012 Neelamegham Lab
    
    properties
        %CONVENTION name convention used for stereochemical properties
        %  CONVENTION property is a character array
        %
        % See also StereoConfig
        convention
    end
    
    properties
        %SYMBOL name convention used for stereochemistry
        %  SYMBOL property is a character array
        %
        % See also StereoConfig
        symbol
    end
    
    methods
        function obj = StereoConfig(symbol, varargin)
            %StereoConfig create a StereoConfig object
            %
            % SC = StereoConfig(SYMBOL) creates a StereoConfig object
            %  using the fisher project convention.
            %
            % SC = StereoConfig(SYMBOL,CONVENTIONNAME) creates a StereoConfig object
            %  using the convention CONVENTIONNAME.
            %
            % See also StereoConfig
            
            % validate the number of input arguments
            
%             if(~verLessThan('matlab','7.13'))
%                 narginchk(0,2);
%             else
                error(nargchk(0,2,nargin));
%             end
            
            if(nargin>0)
                optArgIn = size(varargin,2);
                if(optArgIn==1)
                    obj.convention = varargin{1};
                    obj.symbol = symbol;
                else
                    obj.convention = 'fisher';
                    obj.symbol     = symbol;
                end
            end
        end  %constructor
        
        function projection = getConvention(obj)
            %getConvention get convention property
            %
            % See also StereoConfig
            projection = obj.convention;
        end
        
        function symbol = getSymbol(obj)
            %getSymbol get symbol property
            %
            % See also StereoConfig
            symbol = obj.symbol;
        end
        
        
        function setSymbol(obj,symbol)
            %setSymbol set symbol property
            %
            % See also StereoConfig
            obj.symbol = symbol;
        end
        
        function setConvention(obj,convention)
            %setConvention set convention property
            %
            % See also StereoConfig
            obj.convention = convention;
        end
    end
    
    methods
        function new = clone(obj)
            %CLONE copy a StereoConfig object
            %  CLONE(STEREOCONFIGOBJ) creates a new StereoConfig object
            %
            %  See also StereoConfig
            
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
    
    %      enumeration
    %           Dchiral ('fisher','D')
    %           Lchiral('fisher','L')
    %           Unknownchiral('X');
    %       end
end



