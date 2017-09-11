classdef Enz < handle
%ENZ class representing an enzyme
%
% An ENZ object is a generic representation of an enzyme.
%  It consists of a list of enzyme properties including 
%   ECNO(enzyme commission number), name, reaction, etc.
%
% ENZ properties:
%  name        - accepted name
%  systname    - systematic name
%  othernames  - alternative name(s)
%  ecno        - enzyme commission number
%  reaction    - the reaction that the enzyme catalyzes
%  organism    - the species where the enzyme is expressed 
%  compartment - the enzyme location
%
% Enz methods:
%  Enz        - create an ENZ object
%  clone      - copy an ENZ object
%
% Examples: 
%   Example 1:  % create an empty enzyme
%                  enz1 = Enz;
% 
%   Example 2:  % create a celluose synthase 
%                  a=[2;4;1;29] 
%                  enz2 = Enz(a);
%
% See also PATHWAY,RXN,COMPT,GLYCANSPECIES

% Author: Gang Liu
% Date Last Updated: 6/11/2013

    
    properties
        % NAME name of the enzyme (accepted name)
        %     NAME property is a character array.
        %
        %  See also ENZ
        name
    end
    
    properties
        % SYSTNAME systematic name of the enzyme
        %     SYSTNAME property is a character array.
        %
        %  See also ENZ
        systname
    end
    
    properties
        % OTHERNAMES alternative names of the enzyme
        %     OTHERNAME property is a  cell array storing character arrays .
        %
        %  See also ENZ
        othernames
    end
    
       properties
        % REACTION the reaction that enzyme catalyzed
        %     REACTION property is a  Matlab structure containing the 
        %      description and KEGG reaction ID 
        %
        %  See also ENZ
         reaction
    end
    
    
    properties
        % ECNO ec number of the enzyme
        %     ECNO property is a 4*1 vector.
        %
        %  See also ENZ
        ecno
    end
    
    properties
        % ORGANISM the organism where the enzyme is expressed
        %    organism property is a string 
        %    
        %  See also ENZ
        organism
    end
    
    properties
        % COMPARTMENT enzyme residence compartment
        %     COMPARTMENT  property is the reference to a
        %        COMPT object.
        %
        %  See also ENZ
        compartment
    end
    
    methods
        function obj = Enz(varargin)
            %ENZ create an ENZ object.
            %
            %  L = ENZ(ecno) creates an Enzyme object
            %
            %  See also Rxn.
            narginchk(0,1);
            
            if (nargin == 0)
                return
            end
            
            if(~isnumeric(varargin{1}) )
                error('MATLAB:GNAT:WrongInputType','Wrong Input Type');                
            end
            
            [inputrowno,inputcolno] =size(varargin{1});
                        
            if((inputrowno~=4) ||(inputcolno~=1))
                 error('MATLAB:GANT:WrongInputSize','Wrong Input Size');     
            end
            
            obj.ecno  = varargin{1};
            try
              queryEnzRes= queryIUBMBDB(obj.ecno);
              obj.name = queryEnzRes.name ;
              obj.systname = queryEnzRes.systname;
              obj.othernames = queryEnzRes.othernames;
              obj.reaction = queryEnzRes.rxn;
            catch err
               % do nothing
               % keep the field empty
               
            end
        end % end constructor
    end
    
    methods
        function new = clone(obj)
            %CLONE copy an Enz object
            %  clone(ENZobj) creates a new ENZ object
            %
            %  See also ENZ
            
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
