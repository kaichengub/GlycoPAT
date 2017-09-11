function varargout = enzViewer(varargin)
%enzViewer read an object of Enz class or its subclass and return a GUI 
% displaying its properties .
%
% enzViewer(ENZOBJ) reads an Enz (or its subclass) object. The function 
%   returns a graphics showing its various types of names (e.g. systematic 
%   name, recommended name) and other  properties related to enzyme 
%   specificities (e.g., functional group, target branch in substrate).
%  
% Example 1:
%       enz1 = Enz([2;4;1;29] );
%       enzViewer(enz1);
%
% See also Enz.

% Author: Gang Liu
% Date Lastly Modified: 8/2/13 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',    mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @enzview_OpeningFcn, ...
                   'gui_OutputFcn',  @enzview_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before enzview is made visible.
function enzview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to enzview (see VARARGIN)

% Choose default command line output for enzview
handles.output = hObject;

if(length(varargin)==1)
    if(isa(varargin{1},'Enz'))
        enz = varargin{1};
        handles.enz = enz;
    else
        error('MATLAB:GNAT:WrongInputType', 'Input type is not correct');
    end
    
    set(handles.edit_dispenzname,'String',enz.name);
    set(handles.edit_systname,'String',enz.systname);
    set(handles.edit_alternames,'String',enz.othernames);
    set(handles.edit_rxn,'String',enz.reaction);
    
    if(isa(varargin{1},'GTEnz'))
         set(handles.edit_funcgroupresiduelinkage,'String',enz.dispFuncResLink);
         set(handles.edit_resattach,'String',enz.dispAttachResLink);
         
          if(isprop(enz,'substMinStruct')&&~ isempty(enz.substMinStruct))  
             set(handles.edit_substMinStruct,'String',enz.substMinStruct.toLinucs);
          end
          
         if(isprop(enz,'substMaxStruct')&&~ isempty(enz.substMaxStruct))
            set(handles.edit_substMaxStruct,'String',enz.substMaxStruct.toLinucs);
         end
          
          if(isprop(enz,'prodMinStruct')&&~ isempty(enz.prodMinStruct))  
             set(handles.edit_prodMinStruct,'String',enz.prodMinStruct.toLinucs);
          end
          
         if(isprop(enz,'prodMaxStruct')&&~ isempty(enz.prodMaxStruct))
            set(handles.edit_prodMaxStruct,'String',enz.prodMaxStruct.toLinucs);
          end
         
         if(isprop(enz,'substNABranch')&&~ isempty(enz.substNABranch))
              if(isa(enz.substNABranch,'GlycanStruct'))
                 set(handles.edit_substNABranch,'String',enz.substNABranch.toLinucs);
              elseif(isa(enz.substNABranch,'CellArrayList'))
                  substNABranchString='';
                  for i =1 : enz.substNABranch.length
                        substNABranchString = strcat(substNABranchString,'__');
                        substNABranchString = strcat(substNABranchString,enz.substNABranch.get(i).toLinucs);
                  end
                  set(handles.edit_substNABranch,'String',substNABranchString);
              end
         end
         
          if(isprop(enz,'substNAStruct')&&~ isempty(enz.substNAStruct))
            set(handles.edit_substNAStruct,'String',enz.substNAStruct.toLinucs);
          end
         
         if(isprop(enz,'substNAResidue')&&~ isempty(enz.substNAResidue))
             set(handles.edit_substNAResidue,'String',enz.substNAResidue.name);
         end
         
          if(isprop(enz,'targetBranch')&&~ isempty(enz.targetBranch))
                set(handles.edit_targetBranch,'String',enz.targetBranch.toLinucs);
          end
         
         if(isprop(enz,'targetNABranch') &&~isempty(enz.targetNABranch))
               set(handles.edit_targetNABranch,'String',enz.targetNABranch.toLinucs);
         end
         
         if(isprop(enz,'targetbranchcontain') &&~ isempty(enz.targetbranchcontain))
               set(handles.edit_targetbranchcontain,'String',enz.targetbranchcontain.toLinucs);
         end
                 
         if(isprop(enz,'isTerminalTarget')&&~ isempty(enz.isTerminalTarget))
             if(enz.isTerminalTarget)
                 set(handles.edit_isterminaltarget,'String','true');
             else
                 set(handles.edit_isterminaltarget,'String','false');
             end
         end
         
         if(isprop(enz,'glycanTypeSpec'))
             if(ischar(enz.glycanTypeSpec))
                 set(handles.edit_glycanTypeSpec,'String',enz.glycanTypeSpec);
             end
         end
         
    elseif(isa(varargin{1},'GHEnz'))
        acceptorterminal = enz.dispFuncResLink;
        fgresiduelinkagestring='';
        for i =1 : length(acceptorterminal)
            fgresiduelinkagestring = [fgresiduelinkagestring acceptorterminal{1,i}];
            if(i==length(acceptorterminal))
                continue;
            end
            fgresiduelinkagestring = [fgresiduelinkagestring,'  or  '];                     
        end
        
        set(handles.edit_funcgroupresiduelinkage,'String',fgresiduelinkagestring);
        set(handles.edit_resattach,'String',enz.dispAttachResLink);
            
         if(isprop(enz,'substMinStruct')&&~ isempty(enz.substMinStruct))  
             set(handles.edit_substMinStruct,'String',enz.substMinStruct.toLinucs);
          end
          
         if(isprop(enz,'substMaxStruct')&&~ isempty(enz.substMaxStruct))
            set(handles.edit_substMaxStruct,'String',enz.substMaxStruct.toLinucs);
         end
          
          if(isprop(enz,'prodMinStruct')&&~ isempty(enz.prodMinStruct))  
             set(handles.edit_prodMinStruct,'String',enz.prodMinStruct.toLinucs);
          end
          
         if(isprop(enz,'prodMaxStruct')&&~ isempty(enz.prodMaxStruct))
            set(handles.edit_prodMaxStruct,'String',enz.prodMaxStruct.toLinucs);
          end
         
         if(isprop(enz,'substNABranch')&&~ isempty(enz.substNABranch))
               set(handles.edit_substNABranch,'String',enz.substNABranch.toLinucs);
         end
         
          if(isprop(enz,'substNAStruct')&&~ isempty(enz.substNAStruct))
            set(handles.edit_substrNAStruct,'String',enz.substNAStruct.toLinucs);
          end
         
         if(isprop(enz,'substNAResidue')&&~ isempty(enz.substNAResidue))
             set(handles.edit_substNAResidue,'String',enz.substNAResidue.name);
         end
         
          if(isprop(enz,'targetBranch')&&~ isempty(enz.targetBranch))
                set(handles.edit_targetNABranch,'String',enz.targetBranch.toLinucs);
          end
         
         if(isprop(enz,'targetNABranch') &&~ isempty(enz.targetNABranch))
               set(handles.edit_targetNABranch,'String',enz.targetNABranch.toLinucs);
         end
         
         if(isprop(enz,'targetbranchcontain') &&~ isempty(enz.targetbranchcontain))
               set(handles.edit_targetbranchcontain,'String',enz.targetbranchcontain.toLinucs);
         end
                 
         if(isprop(enz,'isTerminalTarget')&&~ isempty(enz.isTerminalTarget))
             if(enz.isTerminalTarget)
                 set(handles.edit_isterminaltarget,'String','true');
             else
                 set(handles.edit_isterminaltarget,'String','false');
             end
         end
         
         if(isprop(enz,'glycanTypeSpec'))
             if(ischar(enz.glycanTypeSpec))
                 set(handles.edit_glycanTypeSpec,'String',enz.glycanTypeSpec);
             end
         end         
    end
    
end
   
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes enzview wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = enzview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%
% 1st row: recommended name
function edit_dispenzname_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dispenzname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dispenzname as text
%        str2double(get(hObject,'String')) returns contents of edit_dispenzname as a double

% --- Executes during object creation, after setting all properties.
function edit_dispenzname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dispenzname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%
% 2nd row: systematic name
function edit_systname_Callback(hObject, eventdata, handles)
% hObject    handle to edit_systname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_systname as text
%        str2double(get(hObject,'String')) returns contents of edit_systname as a double


% --- Executes during object creation, after setting all properties.
function edit_systname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_systname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
% 3rd row: alternative names
function edit_alternames_Callback(hObject, eventdata, handles)
% hObject    handle to edit_alternames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_alternames as text
%        str2double(get(hObject,'String')) returns contents of edit_alternames as a double


% --- Executes during object creation, after setting all properties.
function edit_alternames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_alternames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
% 4th row: rxn
function edit_rxn_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rxn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rxn as text
%        str2double(get(hObject,'String')) returns contents of edit_rxn as a double


% --- Executes during object creation, after setting all properties.
function edit_rxn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rxn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
% 5th row: functional group
function edit_funcgroupresiduelinkage_Callback(hObject, eventdata, handles)
% hObject    handle to edit_funcgroupresiduelinkage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_funcgroupresiduelinkage as text
%        str2double(get(hObject,'String')) returns contents of edit_funcgroupresiduelinkage as a double


% --- Executes during object creation, after setting all properties.
function edit_funcgroupresiduelinkage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_funcgroupresiduelinkage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
% 6th row: residue linking to functional group
function edit_resattach_Callback(hObject, eventdata, handles)
% hObject    handle to edit_resattach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_resattach as text
%   str2double(get(hObject,'String')) returns contents of edit_resattach as a double


% --- Executes during object creation, after setting all properties.
function edit_resattach_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_resattach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7th row: substrate minimal structure
function edit_substMinStruct_Callback(hObject, eventdata, handles)
% hObject    handle to edit_substMinStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_substMinStruct as text
%        str2double(get(hObject,'String')) returns contents of edit_substMinStruct as a double


% --- Executes during object creation, after setting all properties.
function edit_substMinStruct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_substMinStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_substMinStruct.
function pushbutton_substMinStruct_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_substMinStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isprop(handles.enz,'substMinStruct') && ~isempty(handles.enz.substMinStruct))
    enzObjtoview = handles.enz.substMinStruct;
    options=displayset('showmass',true,'showLinkage',true,...
                            'showRedEnd',true);
% mgat2.substMaxStruct= m3gn;
    glycanViewer(enzObjtoview,options);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8th row: substrate maximal structure
function edit_substMaxStruct_Callback(hObject, eventdata, handles)
% hObject    handle to edit_substMaxStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_substMaxStruct as text
%        str2double(get(hObject,'String')) returns contents of edit_substMaxStruct as a double


% --- Executes during object creation, after setting all properties.
function edit_substMaxStruct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_substMaxStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_substMaxStruct.
function pushbutton_substMaxStruct_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_substMaxStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isprop(handles.enz,'substMaxStruct') && ~isempty(handles.enz.substMaxStruct))
    enzObjtoview = handles.enz.substMaxStruct;
    options=displayset('showmass',true,'showLinkage',true,...
                            'showRedEnd',true);
% mgat2.substMaxStruct= m3gn;
    glycanViewer(enzObjtoview,options);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 9th row: product minimal structure
function edit_prodMinStruct_Callback(hObject, eventdata, handles)
% hObject    handle to edit_prodMinStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_prodMinStruct as text
%        str2double(get(hObject,'String')) returns contents of edit_prodMinStruct as a double


% --- Executes during object creation, after setting all properties.
function edit_prodMinStruct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_prodMinStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_substMaxStruct.
function pushbutton_prodMinStruct_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_substMaxStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isprop(handles.enz,'prodMinStruct') && ~isempty(handles.enz.prodMinStruct))
    enzObjtoview = handles.enz.prodMinStruct;
    options=displayset('showmass',true,'showLinkage',true,...
                            'showRedEnd',true);
% mgat2.substMaxStruct= m3gn;
    glycanViewer(enzObjtoview,options);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 9th row: product maximal structure
function edit_prodMaxStruct_Callback(hObject, eventdata, handles)
% hObject    handle to edit_prodMinStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_prodMinStruct as text
%        str2double(get(hObject,'String')) returns contents of edit_prodMinStruct as a double


% --- Executes during object creation, after setting all properties.
function edit_prodMaxStruct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_prodMinStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_substMaxStruct.
function pushbutton_prodMaxStruct_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_substMaxStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isprop(handles.enz,'prodMinStruct') && ~isempty(handles.enz.prodMaxStruct))
    enzObjtoview = handles.enz.prodMaxStruct;
    options=displayset('showmass',true,'showLinkage',true,...
                            'showRedEnd',true);
% mgat2.substMaxStruct= m3gn;
    glycanViewer(enzObjtoview,options);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10th row: substNABranch
function edit_substNABranch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_substNABranch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_substNABranch as text
%        str2double(get(hObject,'String')) returns contents of edit_substNABranch as a double


% --- Executes during object creation, after setting all properties.
function edit_substNABranch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_substNABranch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_substNABranch.
function pushbutton_substNABranch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_substNABranch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isprop(handles.enz,'substNABranch') && ~isempty(handles.enz.substNABranch))
    options=displayset('showmass',true,'showLinkage',true,...
                            'showRedEnd',true);
    if(isa(handles.enz.substNABranch,'GlycanStruct'))
        enzObjtoview = handles.enz.substNABranch;
% mgat2.substMaxStruct= m3gn;
        glycanViewer(enzObjtoview,options);
    elseif(isa(handles.enz.substNABranch,'CellArrayList'))
        for i = 1 : handles.enz.substNABranch.length
                glycanViewer(handles.enz.substNABranch.get(i),options);         
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 11th row: substNAStruct
function edit_substNAStruct_Callback(hObject, eventdata, handles)
% hObject    handle to edit_substNAStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_substNAStruct as text
%        str2double(get(hObject,'String')) returns contents of edit_substNAStruct as a double


% --- Executes during object creation, after setting all properties.
function edit_substNAStruct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_substNAStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_subststNAStruct.
function pushbutton_substNAStruct_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_subststNAStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isprop(handles.enz,'substNAStruct') && ~isempty(handles.enz.substNAStruct))
    enzObjtoview = handles.enz.substNAStruct;
    options=displayset('showmass',true,'showLinkage',true,...
                            'showRedEnd',true);
% mgat2.substMaxStruct= m3gn;
    glycanViewer(enzObjtoview,options);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 12th row: substNAResidue
function edit_substNAResidue_Callback(hObject, eventdata, handles)
% hObject    handle to edit_substNAResidue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_substNAResidue as text
%        str2double(get(hObject,'String')) returns contents of edit_substNAResidue as a double


% --- Executes during object creation, after setting all properties.
function edit_substNAResidue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_substNAResidue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_substNAResidue.
function pushbutton_substNAResidue_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_substNAResidue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isprop(handles.enz,'substNAResidue') && ~isempty(handles.enz.substNAResidue))
    enzObjtoviewResidue = GlycanResidue(handles.enz.substNAResidue);
    enzObjtoview=GlycanStruct(enzObjtoviewResidue);
    glycanViewer(enzObjtoview);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 13th row: targetBranch
function edit_targetBranch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_substNAResidue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_substNAResidue as text
%        str2double(get(hObject,'String')) returns contents of edit_substNAResidue as a double


% --- Executes during object creation, after setting all properties.
function edit_targetBranch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_substNAResidue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_targetBranch.
function pushbutton_targetBranch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_targetBranch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isprop(handles.enz,'targetBranch') && ~isempty(handles.enz.targetBranch))
    enzObjtoview = handles.enz.targetBranch;
    options=displayset('showmass',true,'showLinkage',true,...
                            'showRedEnd',true);
% mgat2.substMaxStruct= m3gn;
    glycanViewer(enzObjtoview,options);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 14th row: targetNABranch
function edit_targetNABranch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_substNAResidue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_substNAResidue as text
%        str2double(get(hObject,'String')) returns contents of edit_substNAResidue as a double

% --- Executes during object creation, after setting all properties.
function edit_targetNABranch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_substNAResidue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_targetBranch.
function pushbutton_targetNABranch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_targetBranch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isprop(handles.enz,'targetNABranch') && ~isempty(handles.enz.targetNABranch))
    enzObjtoview = handles.enz.targetNABranch;
    options=displayset('showmass',true,'showLinkage',true,...
                            'showRedEnd',true);
% mgat2.substMaxStruct= m3gn;
    glycanViewer(enzObjtoview,options);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 15th row: targetbranchcontain
function edit_targetbranchcontain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_substNAResidue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_substNAResidue as text
%        str2double(get(hObject,'String')) returns contents of edit_substNAResidue as a double

% --- Executes during object creation, after setting all properties.
function edit_targetbranchcontain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_substNAResidue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_targetbranchcontain.
function pushbutton_targetbranchcontain_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_targetBranch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isprop(handles.enz,'targetbranchcontain') && ~isempty(handles.enz.targetbranchcontain))
    enzObjtoview = handles.enz.targetbranchcontain;
    options=displayset('showmass',true,'showLinkage',true,...
                            'showRedEnd',true);
% mgat2.substMaxStruct= m3gn;
    glycanViewer(enzObjtoview,options);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 
% % --- Executes on button press in pushbutton_targetNABranch.
% function pushbutton_substnaTargetBranch_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton_targetNABranch (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% if(isprop(handles.enz,'targetBranch') && ~isempty(handles.enz.targetBranch))
%     enzObjtoview = handles.enz.targetBranch;
%     options=displayset('showmass',true,'showLinkage',true,...
%                             'showRedEnd',true);
% % mgat2.substMaxStruct= m3gn;
%     glycanViewer(enzObjtoview,options);
% end
% 
% 
% 
% % --- Executes on button press in pushbutton1.
% function pushbutton1_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 













% 
% 
% 
% 
% 
% 
% function edit_targetbranchNAsubstr_Callback(hObject, eventdata, handles)
% % hObject    handle to edit_targetNABranch (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of edit_targetNABranch as text
% %        str2double(get(hObject,'String')) returns contents of edit_targetNABranch as a double
% 
% 
% % --- Executes during object creation, after setting all properties.
% function edit_targetbranchNAsubstr_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to edit_targetNABranch (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 16th row: isterminaltarget
function edit_isterminaltarget_Callback(hObject, eventdata, handles)
% hObject    handle to edit_isterminaltarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_isterminaltarget as text
%   str2double(get(hObject,'String')) returns contents of edit_isterminaltarget as a double

% --- Executes during object creation, after setting all properties.
function edit_isterminaltarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_isterminaltarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 17th row: isterminaltarget
 function edit_glycanTypeSpec_Callback(hObject, eventdata, handles)
 % hObject    handle to edit_glycanTypeSpec (see GCBO)
 % eventdata  reserved - to be defined in a future version of MATLAB
 % handles    structure with handles and user data (see GUIDATA)
 
 % Hints: get(hObject,'String') returns contents of edit_glycanTypeSpec as text
 %        str2double(get(hObject,'String')) returns contents of edit_glycanTypeSpec as a double
% 
% 
% % --- Executes during object creation, after setting all properties.
 function edit_glycanTypeSpec_CreateFcn(hObject, eventdata, handles)
 % hObject  handle to edit_glycanTypeSpec (see GCBO)
 % eventdata  reserved - to be defined in a future version of MATLAB
 % handles    empty - handles not created until after all CreateFcns called
 
 % Hint: edit controls usually have a white background on Windows.
 %       See ISPC and COMPUTER.
 if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes when uipanel1 is resized.
function uipanel1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
