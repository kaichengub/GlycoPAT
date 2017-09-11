function varargout = scoregui(varargin)
% SCOREGUI: Start a GUI for spectra scoring
%
% See also: GLYCOPATGUI, DIGESTGUI, BROWSEGUI, FRAGGUI,
% SPECTRAANNOTATIONGUI.

% Author: Gang Liu
% Date Lastly Updated: 11/29/14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @scoreall_OpeningFcn, ...
    'gui_OutputFcn',  @scoreall_OutputFcn, ...
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


% --- Executes just before scoreall is made visible.
function scoreall_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scoreall (see VARARGIN)

% Choose default command line output for scoreall
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes scoreall wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = scoreall_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_selectpepfile.
function pushbutton_selectpepfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectpepfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname,filterindex] = uigetfile({'*.txt'},'Pick a file storing digested peptide sequence');
if(isequal(filename,0) || isequal(pathname,0))
    msgbox('File NOT Selected');
else
    try
        digpepfilename = fullfile(pathname,filename);
        set(handles.edit_loadedpepfile,'string',digpepfilename);
        handles.digpepfilename = digpepfilename;
    catch error
        errordlg(error.message,'Please select file again');
        return
    end
end
guidata(hObject, handles);


% --- Executes on selection change in popupmenu_tolms1unit.
function popupmenu_tolms1unit_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_tolms1unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_tolms1unit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_tolms1unit
contents = cellstr(get(hObject,'String'));
handles.ms1tolunit=contents{get(hObject,'Value')};
if(isempty(handles.ms1tolunit))
    errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_tolms1unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_tolms1unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_tolms2unit.
function popupmenu_tolms2unit_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_tolms2unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_tolms2unit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_tolms2unit
contents = cellstr(get(hObject,'String'));
handles.ms2tolunit=contents{get(hObject,'Value')};
if(isempty(handles.ms2tolunit))
    errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_tolms2unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_tolms2unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ms1tol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ms1tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ms1tol as text
%        str2double(get(hObject,'String')) returns contents of edit_ms1tol as a double
handles.ms1tol= str2double(get(hObject,'String'));

if( isempty(handles.ms1tol) || (handles.ms1tol<0) || isnan(handles.ms1tol))
    handles.ms1tol = 20;
    set(handles.edit_ms1tol,'String','20');
    % errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
end
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function edit_ms1tol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ms1tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_ms2tol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ms2tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ms2tol as text
%        str2double(get(hObject,'String')) returns contents of edit_ms2tol as a double
handles.ms2tol= str2double(get(hObject,'String'));
if(isempty(handles.ms2tol) || handles.ms2tol < 0 || isnan(handles.ms2tol))
    handles.ms2tol = 1;
    set(handles.edit_ms2tol, 'string', '1');
    %     errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_ms2tol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ms2tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_loadedpepfile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_loadedpepfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_loadedpepfile as text
%        str2double(get(hObject,'String')) returns contents of edit_loadedpepfile as a double


% --- Executes during object creation, after setting all properties.
function edit_loadedpepfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_loadedpepfile (see GCBO)
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


% --- Executes on button press in radiobutton_mzxml.
function radiobutton_mzxml_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_mzxml (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_mzxml


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in pushbutton_selectmzxmlfile.
function pushbutton_selectmzxmlfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectmzxmlfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[mzxmlfilename, mzxmlpathname,filterindex] = uigetfile({'*.mzXML'},'Pick a mzXML file');
if(isequal(mzxmlfilename,0) || isequal(mzxmlpathname,0))
    msgbox('File NOT Selected');
else
    try
        mzxmlfullfilename = fullfile(mzxmlpathname,mzxmlfilename);
        set(handles.edit_loadmzxmlstatus,'string',mzxmlfullfilename);
        handles.mzxmlfilename = mzxmlfilename;
        handles.mzxmlpathname = mzxmlpathname;
    catch error
        errordlg(error.message,'Please select file again');
        return
    end
end
set(handles.radiobutton_mzxml,'Value',1);
set(handles.radiobutton_dta,'Value',0);
handles.msdatatype = 'mzXML';
guidata(hObject, handles);

% --- Executes on button press in pushbutton_selectdir.
function pushbutton_selectdir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% edit_selectdir
h_selectedRadioButton = get(handles.uipanel_msdataload,'SelectedObject');
selectedRadioTag = get(h_selectedRadioButton,'tag');
if(strcmpi(selectedRadioTag,'radiobutton_mzxml'))
    msgbox('Select correct radiobutton');
    return
elseif(strcmpi(selectedRadioTag,'radiobutton_dta'))
    % do nothing
else
    errdlg('Code Error');
end

selectpath = uigetdir;
if(isequal(selectpath,0))
    msgbox('PATH NOT Selected');
else
    try
        set(handles.edit_selectdir,'string',selectpath);
        handles.selectpath = selectpath;
    catch error
        errordlg(error.message,'Please select PATH again');
        return
    end
end
set(handles.radiobutton_dta,'Value',1);
set(handles.radiobutton_mzxml,'Value',0);
handles.msdatatype = 'dta';
guidata(hObject, handles);


% --- Executes on button press in pushbutton_scoreallfiles.
function pushbutton_scoreallfiles_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_scoreallfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set display message
set(handles.edit_statusreport,'string','');
statusstr1stline = sprintf(' %s \n','Start to read the inputs');
statusstr2ndline = sprintf(' %s \n','Please wait.................');
statusstr = [statusstr1stline,statusstr2ndline];
set(handles.edit_statusreport,'string',statusstr);

% set input parameters
if(~isfield(handles,'msdatatype'))
    handles.msdatatype='dta';
end

if(isfield(handles,'digpepfilename'))
    pepfilename   = handles.digpepfilename;
else
    errordlg('Please select digested peptide file');
    return;
end

% if(isfield(handles,'fragmod'))
%     fragMode   = handles.fragmod;
%     if(strcmpi(fragMode,'custom'))
%          if(isfield(handles,'fragmodespecial'))
%             fragMode = handles.fragmodespecial;
%          end
%
%          handles.nmFrag=0;
%          handles.npFrag=1;
%          handles.ngFrag=0;
%          if(isfield(handles,'nmFragcustom'))
%             handles.nmFrag  = handles.nmFragcustom;
%          end
%
%          if(isfield(handles,'npFragcustom'))
%             handles.npFrag  = handles.npFragcustom;
%          end
%
%          if(isfield(handles,'ngFragcustom'))
%             handles.ngFrag  = handles.ngFragcustom;
%          end
%     end
% else
%     fragMode   = 'ETD';
%     handles.nmFrag=0;
%     handles.npFrag=1;
%     handles.ngFrag=0;
% end
isetdfrag = handles.radiobutton_etd.Value;
iscidfrag = handles.radiobutton_cidhcd.Value;
ishcdfrag = handles.radiobutton_hcd.Value;
iscustomfrag = handles.radiobutton_custom.Value;
isautofrag = handles.radiobutton_autofrag.Value;
if isetdfrag
    fragMode = 'ETD';
    handles.nmFrag = 0;
    handles.ngFrag = 0;
    handles.npFrag = 1;
elseif iscidfrag
    fragMode = 'CID';
    handles.nmFrag = 0;
    handles.ngFrag = 0;
    handles.npFrag = 1;
elseif ishcdfrag
    fragMode = 'HCD';
    handles.nmFrag = 0;
    handles.ngFrag = 1;
    handles.npFrag = 1;
elseif isautofrag
    fragMode = 'auto';
    handles.nmFrag = 0;
    handles.ngFrag = 0;
    handles.npFrag = 1;
elseif iscustomfrag
    switch handles.popupmenu_fragmod.Value
        case 1
            fragMode = 'ETDSpecial';
        case 2
            fragMode = 'CIDSpecial';
        case 3
            fragMode = 'HCDSpecial';
    end
    handles.nmFrag = str2num(handles.edit_nmFragcustom.String);
    handles.ngFrag = str2num(handles.edit_ngFragcustom.String);
    handles.npFrag = str2num(handles.edit_npFragcustom.String);
end
if(isfield(handles,'ms1tol'))
    ms1tol        = handles.ms1tol;
else
    ms1tol        = 20;
end

if(isfield(handles,'ms1tolunit'))
    ms1tolUnit    = handles.ms1tolunit;
else
    ms1tolUnit     = 'ppm';
end

if(isfield(handles,'ms2tol'))
    ms2tol        = handles.ms2tol;
else
    ms2tol        = 1;
end

if(isfield(handles,'ms2tolunit'))
    ms2tolUnit    = handles.ms2tolunit;
else
    ms2tolUnit    = 'Da';
end

if(isfield(handles,'outputdir'))
    OutputDir     = handles.outputdir;
else
    errordlg('Please select output file');
    return;
end

if(isfield(handles,'outputfilename'))
    Outfname      = handles.outputfilename;
else
    errordlg('Please select output file');
    return;
end

if(isfield(handles,'maxlag'))
    maxlag          = handles.maxlag;
else
    maxlag  = 50;
end

if(isfield(handles,'cutoffmed'))
    CutOffMed       = handles.cutoffmed;
else
    CutOffMed  = 2;
end

if(isfield(handles,'cutoffval'))
    FracMax         = handles.cutoffval;
else
    FracMax = 0.02;
end

if(isfield(handles,'ngFrag'))
    ngFrag          = handles.ngFrag;
else
    errordlg('Please reselect Fragmentation mode');
    return;
end
%
if(isfield(handles,'nmFrag'))
    nmFrag          = handles.nmFrag;
else
    errordlg('Please reselect Fragmentation mode');
    return;
end

if(isfield(handles,'npFrag'))
    npFrag          = handles.npFrag;
else
    errordlg('Please reselect Fragmentation mode');
    return;
end

if(isfield(handles,'selectPeak'))
    selectPeak      = handles.selectPeak;
else
    selectPeak     = {};
end

if(isfield(handles,'varyLabilePTM'))
    veryLabilePTM   = handles.veryLabilePTM;
else
    veryLabilePTM   = {};
end

pseudoLabilePTM = {};
if(strcmpi(handles.msdatatype,'dta'))
    if(isfield(handles,'selectpath'))
        dataDirectory = handles.selectpath;
    else
        errordlg('Please select directory for ms data');
        return;
    end
    
    if(strcmpi(fragMode,'auto'))
        errordlg('Deselect "Auto" option and specify another fragmentation option');
        return
    end
    
    % display message
    statusstr1stline = sprintf(' %s \n','Start to calculate the scores');
    statusstr2ndline = sprintf(' %s \n','Please wait.................');
    statusnewstr = [statusstr1stline,statusstr2ndline];
    statusstr = [statusstr,statusnewstr];
    set(handles.edit_statusreport,'string',statusstr);
    %     fragMode = upper(fragMode);
    scoreAllSpectra(pepfilename,dataDirectory,fragMode,ms1tol,ms1tolUnit,ms2tol,ms2tolUnit,...
        OutputDir,Outfname,maxlag,CutOffMed,FracMax,nmFrag,npFrag,ngFrag,selectPeak,true);
elseif(strcmpi(handles.msdatatype,'mzxml'))
    if(~isfield(handles,'mzxmlfilename') || ~isfield(handles,'mzxmlfilename'))
        errordlg('Please select mzXML file for ms data');
        return;
    end
    mzxmlfilename = handles.mzxmlfilename;
    mzxmlpathname = handles.mzxmlpathname;
    
    % display message
    statusstr1stline = sprintf(' %s \n','Start to calculate the scores');
    statusstr2ndline = sprintf(' %s \n','Please wait.................');
    statusnewstr = [statusstr1stline,statusstr2ndline];
    statusstr = [statusstr,statusnewstr];
    set(handles.edit_statusreport,'string',statusstr);
    
    
    %     fragMode = upper(fragMode);
    handles = scoreAllSpectra(pepfilename,mzxmlpathname,fragMode,ms1tol,ms1tolUnit,ms2tol,ms2tolUnit,...
        OutputDir,Outfname,maxlag,CutOffMed,FracMax,nmFrag,npFrag,ngFrag,selectPeak,...
        true,mzxmlfilename,handles);
end

statusstr3rdline = sprintf(' %s \n','The calculation is completed');
statusstr = [statusstr,statusstr3rdline];
set(handles.edit_statusreport,'string',statusstr);

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton_etd.
function radiobutton_etd_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_etd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_etd


% --- Executes on button press in radiobutton_cidhcd.
function radiobutton_cidhcd_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cidhcd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cidhcd


% --- Executes on button press in radiobutton_custom.
function radiobutton_custom_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_custom



function edit_statusreport_Callback(hObject, eventdata, handles)
% hObject    handle to edit_statusreport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_statusreport as text
%        str2double(get(hObject,'String')) returns contents of edit_statusreport as a double


% --- Executes during object creation, after setting all properties.
function edit_statusreport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_statusreport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_loadmzxmlstatus_Callback(hObject, eventdata, handles)
% hObject    handle to edit_loadmzxmlstatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_loadmzxmlstatus as text
%        str2double(get(hObject,'String')) returns contents of edit_loadmzxmlstatus as a double


% --- Executes during object creation, after setting all properties.
function edit_loadmzxmlstatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_loadmzxmlstatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_selectdir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_selectdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_selectdir as text
%        str2double(get(hObject,'String')) returns contents of edit_selectdir as a double


% --- Executes during object creation, after setting all properties.
function edit_selectdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_selectdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_nmFragcustom_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nmFragcustom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nmFragcustom as text
%        str2double(get(hObject,'String')) returns contents of edit_nmFragcustom as a double
h_selectedRadioButton    = get(handles.uipanel_fragmod,'SelectedObject');
selectedRadioTag         = get(h_selectedRadioButton,'tag');
if(strcmpi(selectedRadioTag,'radiobutton_custom'))
    handles.nmFragcustom.Value =  str2double(get(hObject,'String'));
    if(isempty(handles.nmFragcustom) || handles.nmFragcustom.Value < 0 ||...
            isnan(handles.nmFragcustom.Value))
        handles.nmFragcustom.Value = 0;
        set(handles.edit_nmFragcustom,'string', '0');
    end
    guidata(hObject, handles);
else
    msgbox('Please select custom radiobutton');
end

% --- Executes during object creation, after setting all properties.
function edit_nmFragcustom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nmFragcustom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ngFragcustom_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ngFragcustom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ngFragcustom as text
%        str2double(get(hObject,'String')) returns contents of edit_ngFragcustom as a double
h_selectedRadioButton    = get(handles.uipanel_fragmod,'SelectedObject');
selectedRadioTag         = get(h_selectedRadioButton,'tag');
if(strcmpi(selectedRadioTag,'radiobutton_custom'))
    handles.ngFragcustom.Value =  str2double(get(hObject,'String'));
    if(isempty(handles.ngFragcustom.Value) || handles.ngFragcustom.Value < 0 || isnan(handles.ngFragcustom.Value))
        handles.ngFragcustom.Value = 0;
        set(handles.edit_ngFragcustom,'string', '0');
    end
    guidata(hObject, handles);
else
    msgbox('Please select custom radiobutton');
end

% --- Executes during object creation, after setting all properties.
function edit_ngFragcustom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ngFragcustom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_npFragcustom_Callback(hObject, eventdata, handles)
% hObject    handle to edit_npFragcustom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_npFragcustom as text
%        str2double(get(hObject,'String')) returns contents of edit_npFragcustom as a double
h_selectedRadioButton    = get(handles.uipanel_fragmod,'SelectedObject');
selectedRadioTag         = get(h_selectedRadioButton,'tag');
if(strcmpi(selectedRadioTag,'radiobutton_custom'))
    handles.npFragcustom.Value =  str2double(get(hObject,'String'));
    if(isempty(handles.npFragcustom.Value) || handles.npFragcustom.Value < 0 || isnan(handles.npFragcustom.Value))
        handles.npFragcustom.Value = 1;
        set(handles.edit_npFragcustom,'string', '1');
    end
    guidata(hObject, handles);
else
    msgbox('Please select custom radiobutton');
end

% --- Executes during object creation, after setting all properties.
function edit_npFragcustom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_npFragcustom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_fragmod.
function popupmenu_fragmod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_fragmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_fragmod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_fragmod
h_selectedRadioButton    = get(handles.uipanel_fragmod,'SelectedObject');
selectedRadioTag         = get(h_selectedRadioButton,'tag');
if(strcmpi(selectedRadioTag,'radiobutton_custom'))
    contents = cellstr(get(hObject,'String'));
    selectedfrag = contents{get(hObject,'Value')};
    handles.fragmodespecial = strcat(selectedfrag,'special');
    guidata(hObject, handles);
else
    msgbox('Please select custom radiobutton');
end


% --- Executes during object creation, after setting all properties.
function popupmenu_fragmod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_fragmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxlag_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxlag as text
%        str2double(get(hObject,'String')) returns contents of edit_maxlag as a double
handles.maxlag= str2double(get(hObject,'String'));
if(isempty(handles.maxlag) || handles.maxlag <0 || isnan(handles.maxlag))
    handles.maxlag = 50;
    set(handles.edit_maxlag,'String','50');
    %     errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_maxlag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cutoffmedian_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cutoffmedian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cutoffmedian as text
%        str2double(get(hObject,'String')) returns contents of edit_cutoffmedian as a double
handles.cutoffmed= str2double(get(hObject,'String'));
if(isempty(handles.cutoffmed) || handles.cutoffmed < 0 || isnan(handles.cutoffmed))
    handles.cutoffmed = 2;
    set(handles.edit_cutoffmedian, 'string', '2');
    %     errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_cutoffmedian_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cutoffmedian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cutoffvalue_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cutoffvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cutoffvalue as text
%        str2double(get(hObject,'String')) returns contents of edit_cutoffvalue as a double
handles.cutoffval= str2double(get(hObject,'String'));
if(isempty(handles.cutoffval) || handles.cutoffval < 0 || isnan(handles.cutoffval))
    handles.cutoffval = .02;
    set(handles.edit_cutoffvalue, 'string', '0.02');
    %     errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_cutoffvalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cutoffvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_peakselect_Callback(hObject, eventdata, handles)
% hObject    handle to edit_peakselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_peakselect as text
%        str2double(get(hObject,'String')) returns contents of edit_peakselect as a double
handles.selectPeak = str2num(get(hObject,'String'));
if(isempty(handles.selectPeak))
    errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
end

peaklist = handles.selectPeak;
for i =1 : length(peaklist)
    if( peaklist(i)<=0 || isnan(peaklist(i)) )
        errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_peakselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_peakselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_labileptm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_labileptm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_labileptm as text
%        str2double(get(hObject,'String')) returns contents of edit_labileptm as a double
handles.labileptm= get(hObject,'String');
if(isempty(handles.labileptm))
    errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_labileptm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_labileptm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_outputfilename.
function pushbutton_outputfilename_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_outputfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[outputfilename, pathname,filterindex] = uiputfile({'*.csv'},'Save the output to a file');
if(isequal(outputfilename,0) || isequal(pathname,0))
    msgbox('File NOT Selected');
else
    try
        outputfullfilename = fullfile(pathname,outputfilename);
        set(handles.edit_outputfilename,'string',outputfullfilename);
        handles.outputfilename = outputfilename;
        handles.outputdir      = pathname;
    catch error
        errordlg(error.message,'Please select file again');
        return
    end
end
guidata(hObject, handles);


function edit_outputfilename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputfilename as text
%        str2double(get(hObject,'String')) returns contents of edit_outputfilename as a double


% --- Executes during object creation, after setting all properties.
function edit_outputfilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel_msdataload.
function uipanel_msdataload_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_msdataload
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
h_selectedRadioButton    = get(handles.uipanel_msdataload,'SelectedObject');
selectedRadioTag         = get(h_selectedRadioButton,'tag');
switch  selectedRadioTag
    case 'radiobutton_mzxml'
        handles.msdatatype = 'mzXML';
    case 'radiobutton_dta'
        handles.msdatatype = 'dta';
end
guidata(hObject, handles);

% --- Executes when selected object is changed in uipanel_fragmod.
function uipanel_fragmod_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_fragmod
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
h_selectedRadioButton    = get(handles.uipanel_fragmod,'SelectedObject');
selectedRadioTag         = get(h_selectedRadioButton,'tag');
switch  selectedRadioTag
    case 'radiobutton_etd'
        handles.fragmod='ETD';
        handles.nmFrag = 0;
        handles.ngFrag = 0;
        handles.npFrag = 1;
    case 'radiobutton_cidhcd'
        handles.fragmod='CID';
        handles.nmFrag = 0;
        handles.ngFrag = 2;
        handles.npFrag = 1;
    case 'radiobutton_custom'
        handles.fragmod='custom';
    case 'radiobutton_autofrag'
        handles.fragmod='AUTO';
        handles.nmFrag = 0;
        handles.ngFrag = 0;
        handles.npFrag = 1;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function uipanel_fragmod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel_fragmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% selObj=get(hObject,'selectedobject'); % Find which one is selected
% set(selObj,'selected',[]);

% --- Executes on button press in pushbutton_clearstatus.
function pushbutton_clearstatus_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearstatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_statusreport,'string','');


% --- Executes during object creation, after setting all properties.
function radiobutton_cidhcd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton_cidhcd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on radiobutton_cidhcd and none of its controls.
function radiobutton_cidhcd_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton_cidhcd (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over radiobutton_custom.
function radiobutton_custom_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton_hcd.
function radiobutton_hcd_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_hcd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_hcd
