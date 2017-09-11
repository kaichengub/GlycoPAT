function varargout = fraggui(varargin)
% FRAGGUI: Start a GUI for glycopeptide fragmentation
%
% See also: GLYCOPATGUI, DIGESTGUI, SCOREGUI, BROWSEGUI, SPECTRAANNOTATIONGUI.

% Author: Gang Liu
% Date Lastly Updated: 11/29/14

format longG
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @fraggui_OpeningFcn, ...
    'gui_OutputFcn',  @fraggui_OutputFcn, ...
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


% --- Executes just before fraggui is made visible.
function fraggui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fraggui (see VARARGIN)

% Choose default command line output for fraggui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fraggui wait for user response (see UIRESUME)
% uiwait(handles.abc);


% --- Outputs from this function are returned to the command line.
function varargout = fraggui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on button press in pushbutton1.
% function pushbutton1_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
%
% % --- Executes on button press in pushbutton2.
% function pushbutton2_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_singleglycopeptide_Callback(hObject, eventdata, handles)
% hObject    handle to edit_singleglycopeptide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.singleglycopeptide=deblank(get(hObject,'String'));
guidata(hObject, handles);


% Hints: get(hObject,'String') returns contents of edit_singleglycopeptide as text
%        str2double(get(hObject,'String')) returns contents of edit_singleglycopeptide as a double

% --- Executes during object creation, after setting all properties.
function edit_singleglycopeptide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_singleglycopeptide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_savefragpep.
function pushbutton_savefragpep_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_savefragpep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isfield(handles,'tableallfrag')) || isempty(handles.tableallfrag)
    warndlg('Fragment glycopeptide first!','Save File Error')
    return
end

[fragfilename,fragpathname] = uiputfile('*.csv','Save As csv file');
fragfilefullname = fullfile(fragpathname,fragfilename);

try 
    writetable(handles.tableallfrag,fragfilefullname,'WriteRowNames',true);
catch err
    errordlg('Error during file save',err.message)
end

% --- Executes on button press in pushbutton_clearoutputwindow.
function pushbutton_clearoutputwindow_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearoutputwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_maxpfrag_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxpfrag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
maxpfrag=str2double(get(hObject,'String')) ;
if(isempty(maxpfrag) ||isnan(maxpfrag) || (maxpfrag<0))
    set(hObject,'String','1')
    warndlg('Only nonnegative number is allowed for maximum number of fragments on peptides',...
    'Incorrect input');
    handles.maxpfrag=1;
else
    handles.maxpfrag=maxpfrag;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit_maxpfrag as text
%        str2double(get(hObject,'String')) returns contents of edit_maxpfrag as a double


% --- Executes during object creation, after setting all properties.
function edit_maxpfrag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxpfrag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxgfrag_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxgfrag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
maxgfrag=str2double(get(hObject,'String')) ;
if(isempty(maxgfrag)|| isnan(maxgfrag) || maxgfrag<0)
    set(hObject,'String','0')
    warndlg('Only nonnegative number is allowed for maximum number of fragments on glycans','Incorrect input');
    handles.maxgfrag = 0;
else
    handles.maxgfrag = maxgfrag;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit_maxgfrag as text
%        str2double(get(hObject,'String')) returns contents of edit_maxgfrag as a double


% --- Executes during object creation, after setting all properties.
function edit_maxgfrag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxgfrag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxmfrag_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxmfrag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
maxmfrag=str2double(get(hObject,'String')) ;
if(isempty(maxmfrag)|| isnan(maxmfrag) || maxmfrag<0)
    set(hObject,'String','0')
    warndlg('Only nonnegative number is allowed for maximum number of fragments on modifications','Incorrect input');
    handles.maxmfrag = 0;
else
    handles.maxmfrag=maxmfrag;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit_maxmfrag as text
%        str2double(get(hObject,'String')) returns contents of edit_maxmfrag as a double


% --- Executes during object creation, after setting all properties.
function edit_maxmfrag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxmfrag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z=str2double(get(hObject,'String')) ;
if(isempty(z)||isnan(z)||z<=0)
    set(hObject,'String','1')
    warndlg('Only positive number is allowed for ion charge','Incorrect input');
    handles.z = 1; 
%     msgbox('Use "1" as default value","ErrorInput');
%     z=1;
else
    handles.z=z;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit_z as text
%        str2double(get(hObject,'String')) returns contents of edit_z as a double


% --- Executes during object creation, after setting all properties.
function edit_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_frag.
function pushbutton_frag_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_frag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% make scrolling working in display window
% enable horizontal scrolling
% jEdit = findjobj(handles.edit_allfragionstring);
% jEditbox = jEdit.getViewport().getComponent(0);
% jEditbox.setWrapping(false);                % turn off word-wrapping
% jEditbox.setEditable(false);                % non-editable
% set(jEdit,'HorizontalScrollBarPolicy',30);  % HORIZONTAL_SCROLLBAR_AS_NEEDED

% % maintain horizontal scrollbar policy which reverts back on component resize
% hjEdit = handle(jEdit,'CallbackProperties');
% set(hjEdit, 'ComponentResizedCallback',...
%     'set(gcbo,''HorizontalScrollBarPolicy'',30)')
% set(handles.edit_allfragionstring,'string','');
set(handles.uitable_fragdisp,'data',[],'ColumnName',...
         '');  

%glycopetide sequence check
% it does not have any character it does not support
if(~isfield(handles,'singleglycopeptide')) || isempty(handles.singleglycopeptide) 
    warndlg('Please enter glycopeptide sequence','Incorrect Sequence');
    return
end

glycopeptidecharregexpr = ['[^', 'ARNDCQEGHILKMFPSTWYV'];
glycopeptidecharregexpr = [glycopeptidecharregexpr,'{}nhsfxukgoicpabqe<>\d\+\-os\.'];
glycopeptidecharregexpr = [glycopeptidecharregexpr, ']'];
anynongpletterchar = regexp(handles.singleglycopeptide,glycopeptidecharregexpr,'once'); 
if(~isempty(anynongpletterchar))
    errordlg('Please enter valid glycopeptide sequence','Incorrect Sequence');
    return
end

if(~isfield(handles,'chargecalmod'))
    handles.chargecalmod = 2;
end

if(~isfield(handles,'maxmfrag'))
    handles.maxmfrag = 0;
end

if(~isfield(handles,'maxpfrag'))
    handles.maxpfrag = 1;
end

if(~isfield(handles,'maxgfrag'))
    handles.maxgfrag = 0;
end

if(~isfield(handles,'z'))
    handles.z = 1;
end

try
    if(handles.chargecalmod==2)
        % totalFragIons=[];
       totalFragIons = multiSGPFrag(handles.singleglycopeptide,handles.maxmfrag,handles.maxpfrag,handles.maxgfrag,1);

        for i=2:handles.z
           AllFragIons = multiSGPFrag(handles.singleglycopeptide,handles.maxmfrag,handles.maxpfrag,handles.maxgfrag,i);
           fragsize = length(totalFragIons);
           for j = 1 : length(AllFragIons)
             totalFragIons(j+fragsize) = AllFragIons(j);  
           end
        end       
    else
        totalFragIons  = multiSGPFrag(handles.singleglycopeptide,handles.maxmfrag,handles.maxpfrag,handles.maxgfrag,handles.z);
    end
catch
    errordlg('Please input the glycopeptide');
    return
end

tableallfrag      = struct2table(totalFragIons); 
tableallfrag.mz   = arrayfun(@(x)num2str(x,'%16.8f'),tableallfrag.mz,'UniformOutput',0);
colnames        = tableallfrag.Properties.VariableNames;
scoretabledata  = table2cell(tableallfrag);
colnames        = colnames';

% set column width
for i = 1 : length(colnames)
    columnwidth{i} = 'auto';
end

% %find maximum length of char
% maxlength= 0;
% sgplist = scoretable.sgp;
% for i = 1 : length(sgplist)
%     glystr = sgplist{i};
%     if(maxlength<length(glystr))
%         maxlength = length(glystr);
%     end
% end
% columnwidth{6} = (maxlength +2)*10;

% SET COLUMN FORMAT
for i = 1 : length(colnames)
    columnformat{i} = 'char';
end
format longG
set(handles.uitable_fragdisp,'data',scoretabledata,'ColumnName',...
    colnames,'ColumnWidth',columnwidth,'ColumnFormat',columnformat);
handles.tableallfrag = tableallfrag;
guidata(hObject,handles);

function edit_allfragionstring_Callback(hObject, eventdata, handles)
% hObject    handle to edit_allfragionstring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_allfragionstring as text
%        str2double(get(hObject,'String')) returns contents of edit_allfragionstring as a double


% --- Executes during object creation, after setting all properties.
function edit_allfragionstring_CreateFcn(hObject, ~, handles)
% hObject    handle to edit_allfragionstring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on button press in pushbutton7.
% function pushbutton7_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton7 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)



function edit_multipleglycopeptides_Callback(hObject, eventdata, handles)
% hObject    handle to edit_multipleglycopeptides (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_multipleglycopeptides as text
%        str2double(get(hObject,'String')) returns contents of edit_multipleglycopeptides as a double


% --- Executes during object creation, after setting all properties.
function edit_multipleglycopeptides_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_multipleglycopeptides (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_loadmultigpfromfile.
function pushbutton_loadmultigpfromfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadmultigpfromfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_xinput_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xinput as text
%        str2double(get(hObject,'String')) returns contents of edit_xinput as a double
chargex= str2double(get(hObject,'String'));
if(isempty(chargex))
    errordlg('Please input numeric value');
end
handles.fragchargex=chargex;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_xinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_yinput_Callback(hObject, eventdata, handles)
% hObject    handle to edit_yinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_yinput as text
%        str2double(get(hObject,'String')) returns contents of edit_yinput as a double
chargey= str2double(get(hObject,'String'));
if(isempty(chargey))
    errordlg('Please input numeric value');
end
handles.fragchargey=chargey;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_yinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_yinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function uipanel_dispoption_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel_dispoption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in pushbutton_replot.
function pushbutton_replot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_replot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_selectedRadioButton    = get(handles.uipanel_fragmod,'SelectedObject');
selectedRadioTag         = get(h_selectedRadioButton,'tag');
switch get(selectedRadioTag,'Tag') % Get Tag of selected object.
    case 'radiobutton_zequal'
        % Code for when radiobutton1 is selected.
        if(isfield(handles,'fragchargex'))&& (isfield(handles,'tableallfrag'))
           rows=(handles.tableallfrag.charge==handles.fragchargex);
           newtableallfrag = handles.tableallfrag(rows,:);
           newscoretabledata = table2cell(newtableallfrag);
           set(handles.uitable_fragdisp,'data',newscoretabledata);
        end         
    case 'radiobutton_zless'
        % Code for when radiobutton2 is selected.
        if(isfield(handles,'fragchargex'))&& (isfield(handles,'tableallfrag'))
           rows=(handles.tableallfrag.charge<handles.fragchargex);
           newtableallfrag = handles.tableallfrag(rows,:);
           newscoretabledata = table2cell(newtableallfrag);
           set(handles.uitable_fragdisp,'data',newscoretabledata);
        end 
    case 'radiobutton_zgreater'
        % Code for when togglebutton1 is selected.
        if(isfield(handles,'fragchargex'))&& (isfield(handles,'tableallfrag'))
           rows=(handles.tableallfrag.charge>handles.fragchargex);
           newtableallfrag = handles.tableallfrag(rows,:);
           newscoretabledata = table2cell(newtableallfrag);
           set(handles.uitable_fragdisp,'data',newscoretabledata);
        end 
    case 'radiobutton_zbetween'
        % Code for when togglebutton2 is selected.
        if(isfield(handles,'fragchargex'))&&...
         (isfield(handles,'tableallfrag'))&& (isfield(handles,'fragchargey'))
          if(handles.fragchargex >= handles.fragchargey)
             errordlg('Please input correct value for X & Y. Y should be greater than X'); 
          end
     
          rows =(handles.tableallfrag.charge>handles.fragchargex).*...
                 (handles.tableallfrag.charge<handles.fragchargey);
          newtableallfrag = handles.tableallfrag(rows,:);
          newscoretabledata = table2cell(newtableallfrag);
          set(handles.uitable_fragdisp,'data',newscoretabledata);
        end 
    % Continue with more cases as necessary.
    otherwise
        errodlg('Coding Error');
        % Code for when there is no match.
end


% --- Executes when selected object is changed in uipanel_charge.
function uipanel_charge_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_charge 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
h_selectedRadioButton    = get(handles.uipanel_charge,'SelectedObject');
selectedRadioTag         = get(h_selectedRadioButton,'tag');
switch  selectedRadioTag
    case 'radiobutton_chargeequalless'
        handles.chargecalmod=2;      
    case 'radiobutton_chargequal'
        handles.chargecalmod=1;           
end
%disp(handles.chargecalmod);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function uipanel_charge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel_charge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% h_selectedRadioButton    = get(hObject,'SelectedObject');
% set(h_selectedRadioButton,'selected',2);

% --- Executes during object creation, after setting all properties.
function radiobutton_chargeequalless_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton_chargeequalless (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isfield(handles,'uitable_fragdisp')&& ~isempty(handles.uitable_fragdisp))
  set(handles.uitable_fragdisp,'data',[],'ColumnName','');  
end
if(isfield(handles,'edit_maxpfrag')&& ~isempty(handles.edit_maxpfrag))
    set(handles.edit_maxpfrag,'string','1');
    if(isfield(handles,'maxpfrag'))
        handles.maxpfrag = 1;
    end
end
if(isfield(handles,'edit_maxmfrag')&& ~isempty(handles.edit_maxmfrag))
    set(handles.edit_maxmfrag,'string','0');
    if(isfield(handles,'maxmfrag'))
        handles.maxmfrag = 1;
    end
end
if(isfield(handles,'edit_maxgfrag')&& ~isempty(handles.edit_maxgfrag))
    set(handles.edit_maxgfrag,'string','0');
    if(isfield(handles,'maxgfrag'))
        handles.maxgfrag = 0;
    end
end
if(isfield(handles,'edit_singleglycopeptide')&& ~isempty(handles.edit_singleglycopeptide))
    set(handles.edit_singleglycopeptide,'string','');
    if(isfield(handles,'singleglycopeptide'))
        handles.singleglycopeptide = '';
    end
end

if(isfield(handles,'edit_z')&& ~isempty(handles.edit_z))
    set(handles.edit_z,'string','1');
end

% set fragments empty
if(isfield(handles,'tableallfrag')&&~isempty(handles.tableallfrag))
    handles.tableallfrag=[];
end

guidata(hObject, handles);
