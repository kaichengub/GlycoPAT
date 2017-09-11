function varargout = spectraAnnotationgui(varargin)
% SPECTRAANNOTATIONGUI: Start a GUI to annotate single spectra 
%
% See also: GLYCOPATGUI, DIGESTGUI, BROWSEGUI, FRAGGUI, 
% SPECTRAANNOTATIONGUI.

% Authro: Gang Liu
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
if(isempty(handles.ms1tol))
    errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
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
% if(isempty(handles.ms2tol) || handles.ms2tol<0 || isnan(handles.ms2tol))
%     handles.ms2tol = 1;
%     set(handles.edit_ms2tol, 'string', '1');
% %     errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
% end
handles.ms2tol= str2double(get(hObject,'String'));
if(isempty(handles.ms2tol))
    errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
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



function edit_glypepseq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_glypepseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_glypepseq as text
%        str2double(get(hObject,'String')) returns contents of edit_glypepseq as a double
handles.glypepseq =  get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_glypepseq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_glypepseq (see GCBO)
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
guidata(hObject, handles);


% --- Executes on button press in pushbutton_annotatespectra.
function pushbutton_annotatespectra_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_annotatespectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set display message
fprintf(1,' %s \n','Please wait.................');

% set input parameters
if(~isfield(handles,'msdatatype'))
    handles.msdatatype='dta';
end

if(isfield(handles,'fragmod'))
    fragMode   = handles.fragmod;
else
    fragMode = 'custom';
    handles.nmFrag=0;
    handles.npFrag=0;
    handles.ngFrag=2;
end

if(strcmpi(fragMode,'custom'))
     if(isfield(handles,'fragmodespecial'))
        fragMode = handles.fragmodespecial;         
     else 
        fragMode = 'CIDSpecial';
     end

     handles.nmFrag=0;
     handles.npFrag=0;
     handles.ngFrag=2;

     if(isfield(handles,'nmFragcustom'))
        handles.nmFrag  = handles.nmFragcustom;     
     end

     if(isfield(handles,'npFragcustom'))
        handles.npFrag  = handles.npFragcustom;         
     end

     if(isfield(handles,'ngFragcustom'))
        handles.ngFrag  = handles.ngFragcustom;
     end
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
    outputdir     = handles.outputdir;
else
    errordlg('Please select output file');
    return;
end

if(isfield(handles,'outputfilename'))
    outputname      = handles.outputfilename;
else
    errordlg('Please select output file');
    return;
end

outputfullfilename = fullfile(outputdir,outputname);

if(isfield(handles,'maxlag'))
    maxlag          = handles.maxlag;
else
    maxlag  = 50;
end

if(isfield(handles,'cutoffmed'))
    cutOffMed       = handles.cutoffmed;
else
    cutOffMed  = 2;
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
  
  if(isfield(handles,'scannum'))
      scannum  = handles.scannum;      
  else
      scannum  = 1;
  end
  
  if(isfield(handles,'zcharge'))
      zcharge          = handles.zcharge;
  else
      zcharge  = 1;
  end
  
  %handles.glypepseq 
  if(isfield(handles,'glypepseq'))
      glypepseq          = handles.glypepseq;
  else
      errordlg('Please input peptide sequence');
      return;
  end
  
if(strcmpi(handles.msdatatype,'dta'))
    if(isfield(handles,'selectpath'))
        dtadir = handles.selectpath;
    else
        errordlg('Please select directory for ms data');
        return;
    end    
    
    if(strcmpi(fragMode,'auto'))
        errordlg('Deselect "Auto" option and specify another fragmentation option');
        return
    end
    
    fragMode = upper(fragMode);
    
    filename = dir(dtadir);               % reads directory and puts it in a matlab structure
    cat      = strcat('.',num2str(scannum),'.',num2str(zcharge),'.dta');
    tempfname=[];
    ith=-1;
    for i=1:length(filename)                    % includes only files that contain the text 'dta'
        [pathstr,name,ext] = fileparts(char(filename(i).name));
        if regexp(ext,'dta')
            tempfname=[tempfname;cellstr(filename(i).name)];
            if ~isempty(findstr(filename(i).name,cat))
                ith=i;
                continue;
            end
        end
    end    
    
    if(ith==-1)
       errordlg('MATLAB:GlycoPAT:SPECTRANOTFOUND','THE SPECTRA IS NOT FOUND');
       return;
    end 
    
    param      = [maxlag,cutOffMed,FracMax];
    nFrag      = [nmFrag,ngFrag,npFrag];
    selectPeak = [];  
    save      =  true;
    
%     if(strcmpi(fragMode,'CID/HCD'))
%        fragMode ='CID';
%     end
    
    try     
%         annotate1spectradta(dtadir,glypepseq,fragMode,ms2tol,ms2tolUnit,...
annotate1spectrum(dtadir,glypepseq,fragMode,ms2tol,ms2tolUnit,...
            param,nFrag,selectPeak,...
            save,scannum,zcharge,outputfullfilename);
    catch err
        errordlg(err.message);
        return
    end
    
elseif(strcmpi(handles.msdatatype,'mzxml'))
    if(~isfield(handles,'mzxmlfilename') )
        errordlg('Please select mzXML file for ms data');
        return;
    end
    mzxmlfilename = handles.mzxmlfilename;
    mzxmlpathname = handles.mzxmlpathname;
    mzxmlfullfilename = fullfile(mzxmlpathname,mzxmlfilename);
    param      = [maxlag,cutOffMed,FracMax];
    nFrag      = [nmFrag,ngFrag,npFrag];
    selectPeak = [];  
    save=true;
       
    try 
%         annotate1spectramzxml(mzxmlfullfilename,glypepseq,fragMode,ms2tol,ms2tolUnit,...
annotate1spectrum(mzxmlfullfilename,glypepseq,fragMode,ms2tol,ms2tolUnit,...
      	  param,nFrag,selectPeak,...
          save,scannum,zcharge,outputfullfilename); 
    catch err
       errordlg(err.message); 
       return;
    end
end


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
    handles.nmFragcustom =  str2double(get(hObject,'String'));
    if(isempty(handles.nmFragcustom) || handles.nmFragcustom < 0 ||...
            isnan(handles.nmFragcustom))
        handles.nmFragcustom = 0;
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
    handles.ngFragcustom =  str2double(get(hObject,'String'));
    if(isempty(handles.ngFragcustom) || handles.ngFragcustom < 0 || isnan(handles.ngFragcustom))
        handles.ngFragcustom = 2;
        set(handles.edit_ngFragcustom,'string', '2');
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
    handles.npFragcustom =  str2double(get(hObject,'String'));
    if(isempty(handles.npFragcustom) || handles.npFragcustom < 0 || isnan(handles.npFragcustom))
        handles.npFragcustom = 0;
        set(handles.edit_npFragcustom,'string', '0');
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
    contents                = cellstr(get(hObject,'String'));
    selectedfrag            = contents{get(hObject,'Value')};
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
if(isempty(handles.maxlag) || handles.maxlag < 0 || isnan(handles.maxlag))
    handles.maxlag = 50;
    set(handles.edit_maxlag, 'string', '50');
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
    handles.cutoffval = 0.02;
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
handles.peakselect= str2double(get(hObject,'String'));
if(isempty(handles.peakselect))
    errordlg('INPUT ERROR','PLEASE INPUT A Valid NUMERIC VALUE');
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
    case 'radiobutton_hcd'
        handles.fragmod='HCD';
        handles.nmFrag = 0;
        handles.ngFrag = 1;
        handles.npFrag = 1;
    case 'radiobutton_custom'
        handles.fragmod='custom';
    case 'radiobutton_autofrag'
        handles.fragmod='AUTO';
        handles.nmFrag = 0;
        handles.ngFrag = 0;
        handles.npFrag = 1;
    otherwise
        handles.fragmod='custom';
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

function edit_scannum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scannum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scannum as text
%   str2double(get(hObject,'String')) returns contents of edit_scannum as a double
handles.scannum = str2double(get(hObject,'String'));
if mod(handles.scannum,1)==0 && (handles.scannum>0)
else
    msgbox('Input Value is not Positive or not Integer Value','Use default value 1');
    handles.scannum = 1;
    set(handles.edit_scannum,'String','1');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_scannum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scannum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_zcharge_Callback(hObject, eventdata, handles)
% hObject    handle to edit_zcharge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_zcharge as text
%        str2double(get(hObject,'String')) returns contents of edit_zcharge as a double
handles.zcharge=str2double(get(hObject,'String'));
if mod(handles.zcharge,1)==0 && (handles.zcharge>0)
else
    msgbox('Input Value is not Positive or not Integer Value','Use default value 1');
    handles.zcharge = 1;
    set(handles.edit_zcharge,'String','1');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_zcharge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_zcharge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_savefileas.
function pushbutton_savefileas_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_savefileas (see GCBO)
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


function edit_filesaveasstatus_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputfilename as text
%        str2double(get(hObject,'String')) returns contents of edit_outputfilename as a double


% --- Executes during object creation, after setting all properties.
function edit_filesaveasstatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pushbutton_annotatespectra_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_annotatespectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton_autofrag.
function radiobutton_autofrag_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_autofrag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_autofrag
