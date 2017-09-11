classdef Anomer <handle
%Anomer class representing the orientation of anomeric hydroxyl group
%
% Anomer properties:
%  symbol           - anomer symbol
%  carbonPos    - the position for anomeric carbon
%
% Anomer methods:
%  Anomer       - create an ANOMER object
%  getSymbol    - retrieve the "symbol" property
%  getCarbonPos - retrieve the 'carbonPos' property
%  setSymbol    - set the "symbol" property
%  setCarbonPos - set the "carbonPos" property
%  clone        - copy an Anomer object
%
% See also GlycanResidue,GlycanStruct.

% Author: Gang Liu
% CopyRight 2012 Neelamegham Lab

    properties
        % SYMBOL descirbe two types of stereoisomers
        %    SYMBOL property is a character
        %
        % See also ANOMER
        symbol;
    end
    
    properties
        % CARBONPOS describe the anomeric carbon position
        %   CARBONPOS property is character
        %
        % See also ANOMER
        carbonPos;
    end
    
    methods  % constructor
        function obj = Anomer(symbol,varargin)
            % ANOMER create an Anomer object
            %
            %   A = ANOMER(SYMBOL,CARBOSPOS) constructs an ANOMER object
            %    with its symbol and its anomeric position.
            %
            %   A = ANOMER(SYMBOL) constructs an ANOMERs object  with its symbol .
            %
            % See also ANOMER
            
            % validate the number of input arguments
%             if(~verLessThan('matlab','7.13'))
%                 narginchk(0,2);
%             else
                error(nargchk(0,2,nargin));
%             end    
            
            if(nargin>0)
                if ~(isa(symbol,'char'))
                    errorReport(mfilename,'IncorrectInputType');
                end
                obj.symbol = symbol;
                
                if(length(varargin)==1)
                    if (~isa( varargin{1},'char'))
                        errorReport(mfilename,'IncorrectInputType');
                    end
                    obj.carbonPos = varargin{1};
                end
            end
        end
    end
    
    methods
        
        function symbol = getSymbol(obj)
            % GETSYMBOL get the anomer symbol
            %
            % See also ANOMER
            symbol = obj.symbol;
        end
        
        
        function carbonPos = getCarbonPos(obj)
            % GETCARBONPOS get the carbon position
            %
            % See also ANOMER
            carbonPos = obj.carbonPos;
        end
        
        function setsymbol(obj,symbol)
            % SETSYMBOL set the anomer symbol
            %
            % See also ANOMER
            obj.fullsymbol = symbol;
        end
        
        function setCarbonPos(obj,carbonPos)
            % SETCARBONPOS set the anomeric carbon position
            %
            % See also ANOMER
            obj.carbonPos = carbonPos;
        end
        
        
    end
    
    methods
        function new = clone(obj)
            %CLONE copy a Anomer object
            %  CLONE(ANOMERobj) copies an Anomer object to a new object
            %
            %  See also ANOMER
            
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

