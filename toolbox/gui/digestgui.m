function varargout = digestgui(varargin)
% DIGESTGUI Start a GUI for glycopeptide digestion
%
% See also: GLYCOPATGUI, SCOREGUI, BROWSEGUI, FRAGGUI, SPECTRAANNOTATIONGUI.

% Author: Gang Liu
% Date Lastly Updated: 11/29/14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @digestgui_OpeningFcn, ...
    'gui_OutputFcn',  @digestgui_OutputFcn, ...
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


% --- Executes just before digestgui is made visible.
function digestgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to digestgui (see VARARGIN)

% Choose default command line output for digestgui
handles.output = hObject;
% handles.peptideseqpathname='';
% handles.peptideseqfilename='';
% handles.fixmodfileame='';
% handles.varmodfilename='';
% handles.enzname='';
% handles.peptideseq='';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes digestgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = digestgui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_digest.
function pushbutton_digest_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_digest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_displayenzname_Callback(hObject, eventdata, handles)
% hObject    handle to edit_displayenzname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_displayenzname as text
%        str2double(get(hObject,'String')) returns contents of edit_displayenzname as a double


% --- Executes during object creation, after setting all properties.
function edit_displayenzname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_displayenzname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_enz.
function popupmenu_enz_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_enz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents          = cellstr(get(hObject,'String')) ;
handles.enzname   = contents{get(hObject,'Value')};
set(handles.edit_displayenzname,'string',handles.enzname);
handles.enzname = regexp(handles.enzname,'\&','split');
if(length(handles.enzname)==1)
    handles.enzname = strtrim(handles.enzname{1});
elseif(length(handles.enzname)>1)
    for i = 1: length(handles.enzname)
        handles.enzname{i} = strtrim(handles.enzname{i});
    end
end
handles.enzname
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_enz contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_enz


% --- Executes during object creation, after setting all properties.
function popupmenu_enz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_enz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    handles.enzname ='Trypsin';
    set(handles.edit_displayenzname,'string',handles.enzname);
end


function edit_peptideseq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_peptideseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pepseq  =  get(hObject,'String');
guidata(hObject, handles);


% Hints: get(hObject,'String') returns contents of edit_peptideseq as text
%        str2double(get(hObject,'String')) returns contents of edit_peptideseq as a double


% --- Executes during object creation, after setting all properties.
function edit_peptideseq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_peptideseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    set(hObject,'Max',5);
end

% --- Executes on button press in pushbutton_selectpeptideseqfile.
function pushbutton_selectpeptideseqfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectpeptideseqfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname,filterindex] = uigetfile({'*.txt';'*.fasta'},'Pick a file storing peptide sequence');
if(isequal(filename,0) || isequal(pathname,0))
    msgbox('File NOT Selected');
else
    try
        handles.pepseq = peptideread(pathname,filename);
        pepdata = handles.pepseq;
        numprot=length(pepdata);
        handles.pepfilename = fullfile(pathname,filename);
        % enable horizontal scrolling
        set(handles.edit_disppepseq,'string',handles.pepfilename);
        jEdit = findjobj(handles.edit_disppepseq);
        jEditbox = jEdit.getViewport().getComponent(0);
        jEditbox.setWrapping(false);                % turn off word-wrapping
        jEditbox.setEditable(false);                % non-editable
        set(jEdit,'HorizontalScrollBarPolicy',30);  % HORIZONTAL_SCROLLBAR_AS_NEEDED
    catch error
        errordlg(error.message,'Please select file again');
        return
    end
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_savefileas.
function pushbutton_savefileas_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_savefileas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit_fixedvariable_mwchange_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fixedvariable_mwchange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fixedvariable_mwchange as text
%        str2double(get(hObject,'String')) returns contents of edit_fixedvariable_mwchange as a double


% --- Executes during object creation, after setting all properties.
function edit_fixedvariable_mwchange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fixedvariable_mwchange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_selectaminoacids.
function popupmenu_selectaminoacids_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_selectaminoacids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_selectaminoacids contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_selectaminoacids

% Hint: get(hObject,'Value') returns toggle state of radiobutton16


% --- Executes on button press in pushbutton_fixmodsaveas.
function pushbutton_fixmodsaveas_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fixmodsaveas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fixedmodfilename, fixedmodfilepathname] = uiputfile('*.txt', 'Save fixed modification configuration as');
if(isequal(fixedmodfilename,0) || isequal(fixedmodfilepathname,0))
    msgbox('NO file is saved');
else
    outputfilefullname = [fixedmodfilepathname fixedmodfilename];
    fid=fopen(outputfilefullname,'w');
    fprintf(fid,'%s \n',handles.fixedmodtext);
    fclose(fid);
end

% --- Executes on button press in radiobutton_varmodoxidationchoice.
function radiobutton_varmodoxidationchoice_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_varmodoxidationchoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choicevarmodoxidation=get(hObject,'Value') ;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_varmodoxidationchoice


% --- Executes on button press in radiobutton_varmodsulfchoice.
function radiobutton_varmodsulfchoice_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_varmodsulfchoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choicevarmodsulf=get(hObject,'Value') ;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_varmodsulfchoice


% --- Executes on button press in radiobutton_varmodcarbchoice.
function radiobutton_varmodcarbchoice_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_varmodcarbchoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choicevarmodcarbamidomethyl=get(hObject,'Value') ;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_varmodcarbchoice


% --- Executes on button press in radiobutton_varmodphoschoice.
function radiobutton_varmodphoschoice_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_varmodphoschoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choicevarmodphos=get(hObject,'Value') ;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_varmodphoschoice


% --- Executes on button press in radiobutton_varmodcusttomchoice.
function radiobutton_varmodcusttomchoice_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_varmodcusttomchoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choicevarmodcustom=get(hObject,'Value') ;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_varmodcusttomchoice

% --- Executes on selection change in popupmenu_varmodaa_custom.
function popupmenu_varmodaa_custom_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_varmodaa_custom contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_varmodaa_custom
handles.varmodaacust = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_varmodaa_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_varmodpos_oxidation_Callback(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_oxidation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.varmodposoxidation = get(hObject,'String');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_varmodpos_oxidation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_oxidation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_varmodpos_sulf_Callback(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_sulf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.varmodpossulf = get(hObject,'String');
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_varmodpos_sulf as text
%        str2double(get(hObject,'String')) returns contents of edit_varmodpos_sulf as a double


% --- Executes during object creation, after setting all properties.
function edit_varmodpos_sulf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_sulf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_varmodpos_carba_Callback(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_carba (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.varmodposcarba = get(hObject,'String');
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_varmodpos_carba as text
%        str2double(get(hObject,'String')) returns contents of edit_varmodpos_carba as a double


% --- Executes during object creation, after setting all properties.
function edit_varmodpos_carba_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_carba (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_varmodpos_phos_Callback(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_phos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.varmodposphos = get(hObject,'String');
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_varmodpos_phos as text
%        str2double(get(hObject,'String')) returns contents of edit_varmodpos_phos as a double


% --- Executes during object creation, after setting all properties.
function edit_varmodpos_phos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_phos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_varmodpos_custom_Callback(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.varmodposcustom = get(hObject,'String');
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_varmodpos_custom as text
%        str2double(get(hObject,'String')) returns contents of edit_varmodpos_custom as a double


% --- Executes during object creation, after setting all properties.
function edit_varmodpos_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_enzdigest.
function pushbutton_enzdigest_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_enzdigest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset display window
set(handles.edit_disppepfraglibrary,'string','');








%% check peptide sequence
% string manipulation
% covert small letter to capital letter if exist
if(~isfield(handles,'pepseq'))
    errordlg('NO INPUT FOR PEPTIDE SEQUENCE','PLEASE INPUT PEPTIDE SEQUENCE');
    return
end

if(length(handles.pepseq)>1)
    for i = 1: length(handles.pepseq)
        pepseqonly{i} = handles.pepseq(i).sequence;
        pepseqonly{i} = upper(pepseqonly{i});
        pepseqonly{i} = (pepseqonly{i})';
        pepseqonly{i} = reshape(pepseqonly{i},1,...
            size(pepseqonly{i},1)*size(pepseqonly{i},2));
        pepseqonly{i} = strtrim(pepseqonly{i});
        pepseqheader{i} = handles.pepseq(i).header;
    end
else
    pepseqonly = handles.pepseq.sequence;
    pepseqonly = upper(pepseqonly);
    pepseqonly = (pepseqonly)';
    pepseqonly = reshape(pepseqonly,1,...
        size(pepseqonly,1)*size(pepseqonly,2));
    pepseqonly = strtrim(pepseqonly);
    pepseqheader = handles.pepseq.header;
end

% pepseqonly = (upper(pepseqonly))';

% reshape character matrix to vector if exist
% and remove any white space char


% PEPTIDE SEQUENCE CHARACTER CHECK
if(iscell(pepseqonly))
    for i = 1 : length(pepseqheader)
        singlepepseqonly = pepseqonly{i};
        anynonletterchar = regexp(singlepepseqonly,Aminoacid.getaacharexpr,'once');
        if(~isempty(anynonletterchar))
            errordlg('INCORRECT PEPTIDE SEQUENCE CHARACTER','PLEASE INPUT CORRECT PEPTIDE SEQUENCE');
            return
        end
    end
elseif(ischar(pepseqonly))
    singlepepseqonly = pepseqonly;
    anynonletterchar = regexp(singlepepseqonly,Aminoacid.getaacharexpr,'once');
    if(~isempty(anynonletterchar))
        errordlg('INCORRECT PEPTIDE SEQUENCE CHARACTER','PLEASE INPUT CORRECT PEPTIDE SEQUENCE');
        return
    end
end

%% check enzyme input
if(~isfield(handles,'enzname'))
    errordlg('NO INPUT FOR ENZYME','PLEASE SELECT ENZYME');
    return
end

digestoptions          = digestoptionset;

% set maxpeplength
if(isfield(handles,'maxpeplength'))
    digestoptions    = digestoptionset(digestoptions,'maxpeplen',handles.maxpeplength);
else
    handles.maxpeplength = digestoptions.maxpeplen;
end

% set minpeplength
if(isfield(handles,'minpeplength'))
    digestoptions    = digestoptionset(digestoptions,'minpeplen',handles.minpeplength);
else
    handles.minpeplength = digestoptions.minpeplen;
end

% set maxnummod
if(isfield(handles,'maxnummod'))
    digestoptions    = digestoptionset(digestoptions,'maxptm',handles.maxnummod);
else
    handles.maxnummod = digestoptions.maxptm;
end

% set minnummod
if(isfield(handles,'minnummod'))
    digestoptions    = digestoptionset(digestoptions,'minptm',handles.minnummod);
else
    handles.minnummod = digestoptions.minptm;
end

% set maxmissingcleaveage
if(isfield(handles,'maxmissingcleavage'))
    digestoptions    = digestoptionset(digestoptions,'missedmax',handles.maxmissingcleavage);
else
    handles.maxmissingcleavage = digestoptions.missedmax;
end

disp(['Missedmax=',num2str(digestoptions.missedmax)]);
disp(['Minpeplen=',num2str(digestoptions.minpeplen)]);
disp(['Maxpeplen=',num2str(digestoptions.maxpeplen)]);
disp(['Maxptm=',num2str(digestoptions.maxptm)]);
disp(['Minptm=',num2str(digestoptions.minptm)]);

%% check variable ptm input
if(~isfield(handles,'varptmopt'))
    errordlg('NO INPUT FOR VARIABLE PTM','PLEASE SET VARIABLE PTM OPTION');
    return
end


%% check fixed ptm input
if(~isfield(handles,'fptmopt'))
    errordlg('NO INPUT FOR FIXED PTM','PLEASE SET FIXED PTM OPTION');
    return
end

% set up fixed and variable ptm
digestoptions    = digestoptionset(digestoptions,'fixedptm',...
    handles.fptmopt,'varptm', handles.varptmopt);
digestoptions.dispprog=1;
[handles.output,handles.outputstring] = digestSGP(handles.pepfilename, handles.enzname, digestoptions);

if(isempty(handles.output))
    msgbox('Can not Find Qualified Fragments','NOTFound');
end

set(handles.edit_disppepfraglibrary,'string',handles.outputstring);
% enable horizontal scrolling

jEdit = findjobj(handles.edit_disppepfraglibrary);
jEditbox = jEdit.getViewport().getComponent(0);
jEditbox.setWrapping(false);                % turn off word-wrapping
jEditbox.setEditable(false);                % non-editable
set(jEdit,'HorizontalScrollBarPolicy',30);  % HORIZONTAL_SCROLLBAR_AS_NEEDED
% maintain horizontal scrollbar policy which reverts back on component resize
hjEdit = handle(jEdit,'CallbackProperties');
set(hjEdit, 'ComponentResizedCallback',...
    'set(gcbo,''HorizontalScrollBarPolicy'',30)')
guidata(hObject,handles);

function edit_disppepfraglibrary_Callback(hObject, eventdata, handles)
% hObject    handle to edit_disppepfraglibrary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_disppepfraglibrary as text
%        str2double(get(hObject,'String')) returns contents of edit_disppepfraglibrary as a double


% --- Executes during object creation, after setting all properties.
function edit_disppepfraglibrary_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_disppepfraglibrary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_outputfilesave.
function pushbutton_outputfilesave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_outputfilesave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[outputfilename, outputpathname] = uiputfile('*.txt', 'Save output as');
outputfilefullname = [outputpathname outputfilename];
if(isequal(outputfilename,0) || isequal(outputpathname,0))
    msgbox('NO file is saved');
    return
else
    fileID=fopen(outputfilefullname,'w');
    % add header and parameter set information to final output
    fprintf(fileID,'%s',handles.outputstring);    
    fclose(fileID);
    msgbox('Digested peptide fragments were saved');
% [outputfilename, outputpathname] = uiputfile('*.txt', 'Save output as');
% outputfilefullname = [outputpathname outputfilename];
% if(isequal(outputfilename,0) || isequal(outputpathname,0))
%     msgbox('NO file is saved');
%     return
% else
%     fileID=fopen(outputfilefullname,'w');
%     % add header and parameter set information to final output
%     
%     nProt = length(handles.pepseq);
%     % print complete protein sequence
%     if (nProt>1)
%         for i = 1 : nProt
%             fprintf(fileID,'sequence %i : %s\n',i,handles.pepseq(i).sequence);
%         end
%     else
%         fprintf(fileID,'sequence 1: %s\n',handles.pepseq.sequence);
%     end
%     
%     % print enzyme name
%     proteasedb    =  Protease.mklocaldb;
%     enzname = handles.enzname;
%     if(iscell(enzname))
%         for k=1:length(enzname)
%             if(proteasedb.isKey(upper(enzname{k})))
%                 ezncleaveexpr =  proteasedb(upper(enzname{k}));
%                 fprintf(fileID,'Enzyme %i:  %s (name) %s (cleavage pattern)\n', k, ...
%                     enzname{k},ezncleaveexpr);
%             else
%                 error('MATLAB:GPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
%             end
%         end
%     else
%         if(proteasedb.isKey(upper(enzname)))
%             ezncleaveexpr =  proteasedb(upper(enzname));
%             fprintf(fileID,'Enzyme:  %s (name) %s (cleavage pattern)\n', ...
%                 enzname,ezncleaveexpr);
%         else
%             error('MATLAB:GPAT:UNSUPPORTEDENZYME','UNSUPPORTED ENZYME TYPE');
%         end
%     end
%     
%     % print fixed ptm parameter
%     fixedptmopt = handles.fptmopt;
%     for i = 1 : length(fixedptmopt)
%         fprintf(fileID,'Fixed ptm: %s %s \n',fixedptmopt.aaresidue{i,1},fixedptmopt.mod{i,1});
%     end
%     
%     % print variable ptm parameter
%     varptmopt = handles.varptmopt;
%     for i = 1 : length(varptmopt.aaresidue)
%         fprintf(fileID,'Variable ptm: %s %s %s\n',varptmopt.aaresidue{i,1},...
%             varptmopt.mod{i,1},num2str(varptmopt.pos{i,1}));
%     end
%     
%     minPTM   =  handles.minnummod;
%     maxPTM    = handles.maxnummod;
%     MinPepLen = handles.minpeplength;
%     MaxPepLen = handles.maxpeplength;
%     MissedMax = handles.maxmissingcleavage;
%     
%     % printf minPTM,maxPTM,missedMax,minPepLen,maxPeplen
%     fprintf(fileID,'minPTM : %i\n',minPTM);
%     fprintf(fileID,'maxPTM : %i\n',maxPTM);
%     fprintf(fileID,'minPepLen : %i\n',MinPepLen);
%     fprintf(fileID,'maxPepLen : %i\n',MaxPepLen);
%     fprintf(fileID,'MissedMax : %i\n',MissedMax);
%     
%     % print protein header
%     FASTAhead = handles.pepseq.header;
%     fprintf(fileID,'>%s \n',FASTAhead);
%     
%     % print final products
%     for i = 1 : length(handles.output)
%         fprintf(fileID,'%s \n',handles.output{i});
%     end
%     
%     fclose(fileID);
%     msgbox('Digested peptide fragments were saved');
    
end



% --- Executes on button press in pushbutton_varmodsaveas.
function pushbutton_varmodsaveas_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_varmodsaveas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[varmodfilename, varmodfilepathname] = uiputfile('*.txt', 'Save fixed modification configuration as');
outputfilefullname = [varmodfilepathname varmodfilename];
fid=fopen(outputfilefullname,'w');
if(isequal(varmodfilename,0) || isequal(varmodfilepathname,0))
    msgbox('NO file is saved');
else
    fprintf(fid,'%s \n',handles.varptmstring);
end
fclose(fid);

function edit_dispvarmod_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dispvarmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dispvarmod as text
% str2double(get(hObject,'String')) returns contents of edit_dispvarmod as a double


% --- Executes during object creation, after setting all properties.
function edit_dispvarmod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dispvarmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_dispfixedmod_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dispfixedmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dispfixedmod as text
%        str2double(get(hObject,'String')) returns contents of edit_dispfixedmod as a double


% --- Executes during object creation, after setting all properties.
function edit_dispfixedmod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dispfixedmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_fixedmodload.
function pushbutton_fixedmodload_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fixedmodload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname,filterindex] = uigetfile({'*.txt'},'Pick a file storing fixed modification configuration');
if(isequal(filename,0) || isequal(pathname,0))
    errordlg('File NOT Selected','Please select file again');
else
    try
        [fptmopt,fptmoptstring] = fixedptmread(pathname,filename);
        fptmfilename = fullfile(pathname,filename);
        set(handles.edit_dispfixptmfile,'string',fptmfilename);
        % enable horizontal scrolling
        jEdit = findjobj(handles.edit_dispfixptmfile);
        jEditbox = jEdit.getViewport().getComponent(0);
        jEditbox.setWrapping(false);                % turn off word-wrapping
        jEditbox.setEditable(false);                % non-editable
        set(jEdit,'HorizontalScrollBarPolicy',30);  % HORIZONTAL_SCROLLBAR_AS_NEEDED
        
    catch filereaderr
        errordlg(filereaderr.message,'Please select correct file again');
        return
    end
    
    %    set(handles.edit_dispfixedmod,'string',fptmoptstring);
    handles.fptmopt = fptmopt;
    handles.fixedmodtext = fptmoptstring;
    guidata(hObject, handles);
end

% --- Executes on button press in radiobutton_carbamidomethyl.
function radiobutton_carbamidomethyl_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_carbamidomethyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choicecarbamidomethyl=get(hObject,'Value');
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_carbamidomethyl


% --- Executes on button press in radiobutton_custom1.
function radiobutton_custom1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_custom1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choicecustom1=get(hObject,'Value');
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_custom1



function edit_custom1molmass_Callback(hObject, eventdata, handles)
% hObject    handle to edit_custom1molmass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.custom1molmass = str2double(get(hObject,'String'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_custom1molmass as text
%        str2double(get(hObject,'String')) returns contents of edit_custom1molmass as a double


% --- Executes during object creation, after setting all properties.
function edit_custom1molmass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_custom1molmass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_cust1aa.
function popupmenu_cust1aa_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_cust1aa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.custom1aa = get(hObject,'Value');
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_cust1aa contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_cust1aa


% --- Executes during object creation, after setting all properties.
function popupmenu_cust1aa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_cust1aa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_custom2.
function radiobutton_custom2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_custom2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choicecustom2=get(hObject,'Value');
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_custom2



function edit_custom2molmass_Callback(hObject, eventdata, handles)
% hObject    handle to edit_custom2molmass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.custom2molmass = str2double(get(hObject,'String'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_custom2molmass as text
%        str2double(get(hObject,'String')) returns contents of edit_custom2molmass as a double


% --- Executes during object creation, after setting all properties.
function edit_custom2molmass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_custom2molmass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_cust2aa.
function popupmenu_cust2aa_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_cust2aa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.custom2aa = get(hObject,'Value');
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_cust2aa contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_cust2aa


% --- Executes during object creation, after setting all properties.
function popupmenu_cust2aa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_cust2aa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_carboxymethyl.
function radiobutton_carboxymethyl_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_carboxymethyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choicecarboxymethyl=get(hObject,'Value');
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_carboxymethyl


% --- Executes on button press in pushbutton_varmodload.
function pushbutton_varmodload_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_varmodload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname,filterindex] = uigetfile({'*.txt'},'Pick a file sotring variable modification configuration');
if(isequal(filename,0) || isequal(pathname,0))
    msgbox('File NOT Selected');
else
    try
        [varptmopt,varptmstring]=varptmread(pathname,filename);
        
        handles.varptmopt      = varptmopt;
        handles.varptmstring   = varptmstring;
        
        varptmfilename = fullfile(pathname,filename);
        set(handles.edit_dispvarptmfile,'string',varptmfilename);
        % enable horizontal scrolling
        jEdit = findjobj(handles.edit_dispvarptmfile);
        jEditbox = jEdit.getViewport().getComponent(0);
        jEditbox.setWrapping(false);                % turn off word-wrapping
        jEditbox.setEditable(false);                % non-editable
        set(jEdit,'HorizontalScrollBarPolicy',30);  % HORIZONTAL_SCROLLBAR_AS_NEEDED
        
        %   varmodfilefullname   = strcat(pathname, filename);
        %   handles.vardata      = textread(varmodfilefullname,'%s','whitespace','');
        % set(handles.edit_dispvarmod,'string',handles.varptmstring);
        guidata(hObject, handles);
    catch vptmerror
        errordlg('Incorrect Variable PTM File','Select correct variable ptm option file');
    end
    %     handles.varmodfilename    = filename;
    %     handles.varmodpathname = pathname;
end

% --- Executes on button press in radiobutton_varmodglycanchoice.
function radiobutton_varmodglycanchoice_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_varmodglycanchoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choicevarmodglycan=get(hObject,'Value') ;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_varmodglycanchoice


% --- Executes on button press in pushbutton_glycanselection.
function pushbutton_glycanselection_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_glycanselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[a,handles.glycanmod] = glycanmod;
set(handles.edit_dispglycanmod,'string',handles.glycanmod);
guidata(hObject,handles);


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton_varmodcarboxymethylchoice.
function radiobutton_varmodcarboxymethylchoice_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_varmodcarboxymethylchoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choicevarmodcarboxymethyl=get(hObject,'Value') ;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_varmodcarboxymethylchoice



function edit_varmodpos_carbo_Callback(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_carbo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.varmodposcarbo = get(hObject,'String');
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_varmodpos_carbo as text
%        str2double(get(hObject,'String')) returns contents of edit_varmodpos_carbo as a double


% --- Executes during object creation, after setting all properties.
function edit_varmodpos_carbo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_varmodpos_carbo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_varmodaa_oxidation.
function popupmenu_varmodaa_oxidation_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_oxidation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.varmodaaoxidation = get(hObject,'Value');
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_varmodaa_oxidation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_varmodaa_oxidation


% --- Executes during object creation, after setting all properties.
function popupmenu_varmodaa_oxidation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_oxidation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_varmodaa_sulf.
function popupmenu_varmodaa_sulf_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_sulf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.varmodaasulf = get(hObject,'Value');
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_varmodaa_sulf contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_varmodaa_sulf


% --- Executes during object creation, after setting all properties.
function popupmenu_varmodaa_sulf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_sulf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_varmodaa_carbamidomethyl.
function popupmenu_varmodaa_carbamidomethyl_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_carbamidomethyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.varmodaacarba = get(hObject,'Value');
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_varmodaa_carbamidomethyl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_varmodaa_carbamidomethyl


% --- Executes during object creation, after setting all properties.
function popupmenu_varmodaa_carbamidomethyl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_carbamidomethyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_varmodaa_carboxymethyl.
function popupmenu_varmodaa_carboxymethyl_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_carboxymethyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.varmodaacarbo = get(hObject,'Value');
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_varmodaa_carboxymethyl contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_varmodaa_carboxymethyl


% --- Executes during object creation, after setting all properties.
function popupmenu_varmodaa_carboxymethyl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_carboxymethyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_varmodaa_phos.
function popupmenu_varmodaa_phos_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_phos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.varmodaaphos = get(hObject,'Value');
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_varmodaa_phos contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_varmodaa_phos


% --- Executes during object creation, after setting all properties.
function popupmenu_varmodaa_phos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_varmodaa_phos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uipanel16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_maxnummod_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxnummod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.maxnummod=str2double(get(hObject,'String'));
if(isempty(handles.maxnummod)||isnan(handles.maxnummod)...
        ||handles.maxnummod<=0)
    msgbox('Use default value "2" for digestion','Wrong input');
    handles.maxnummod = 2;
    set(handles.edit_maxnummod,'string',2);
end

guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_maxnummod as text
%        str2double(get(hObject,'String')) returns contents of edit_maxnummod as a double


% --- Executes during object creation, after setting all properties.
function edit_maxnummod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxnummod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_minpeplength_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minpeplength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.minpeplength = str2double(get(hObject,'String'));
if(isempty(handles.minpeplength)||isnan(handles.minpeplength)...
        || handles.minpeplength<0)
    msgbox('Use default value "4" for digestion','Wrong input');
    handles.minpeplength = 4;
    set(handles.edit_minpeplength,'string','4');
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_minpeplength as text
%        str2double(get(hObject,'String')) returns contents of edit_minpeplength as a double


% --- Executes during object creation, after setting all properties.
function edit_minpeplength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minpeplength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_maxmisscleavages_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxmisscleavages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.maxmissingcleavage= str2double(get(hObject,'String'));
if(isempty(handles.maxmissingcleavage)||isnan(handles.maxmissingcleavage)...
        ||handles.maxmissingcleavage<0 )
    handles.maxmissingcleavage =0;
    msgbox('Use default value "0" for digestion','Wrong input');
    set(handles.edit_maxmisscleavages,'string','0');
end
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of edit_maxmisscleavages as text
%        str2double(get(hObject,'String')) returns contents of edit_maxmisscleavages as a double


% --- Executes during object creation, after setting all properties.
function edit_maxmisscleavages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxmisscleavages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text_fixedmodconfigdisp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_fixedmodconfigdisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton_createfixedmod.
function pushbutton_createfixedmod_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_createfixedmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fixedmodtext ='';
if(isfield(handles,'choicecarbamidomethyl') && handles.choicecarbamidomethyl)
    addtxt = sprintf('%s \n','C C<i>  57.0214');
    fixedmodtext =[fixedmodtext addtxt];
end

if(isfield(handles,'choicecarboxymethyl') && handles.choicecarboxymethyl)
    addtxt = sprintf('%s \n','C C<c>  58.00548');
    fixedmodtext =[fixedmodtext addtxt];
end

if(isfield(handles,'choicecustom1')&& handles.choicecustom1)
    if(isfield(handles,'custom1molmass'))
        if(~isfield(handles,'custom1aa'))
            handles.custom1aa =1;
        end
        addaminacid = Aminoacid.aa1let{handles.custom1aa};
        addmasstxt    = sprintf('%s \n',num2str(handles.custom1molmass));
        fixedmodtext =[fixedmodtext addaminacid ' ' ...
            addaminacid '<x> '  addmasstxt];
    end
end

if(isfield(handles,'choicecustom2')&& handles.choicecustom2)
    if(isfield(handles,'custom2molmass'))
        if(~isfield(handles,'custom2aa'))
            handles.custom2aa =1;
        end
        addaminacid = Aminoacid.aa1let{handles.custom2aa};
        addmasstxt = sprintf('%s \n',num2str(handles.custom2molmass));
        fixedmodtext =[fixedmodtext addaminacid ' ' ...
            addaminacid '<x> '  addmasstxt];
    end
end

handles.fixedmodtext = fixedmodtext;
guidata(hObject,handles);
if(isempty(fixedmodtext))
    msgbox('Please provide input to create configuration');
else
    set(handles.edit_dispfixedmod,'string',fixedmodtext);
end

% --- Executes on button press in pushbutton_createvarmodconfig.
function pushbutton_createvarmodconfig_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_createvarmodconfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varmodtext ='';
if(isfield(handles,'choicevarmodcarbamidomethyl') &&handles.choicevarmodcarbamidomethyl  ...
        && isfield(handles,'varmodposcarba'))
    if(~isfield(handles,'varmodaacarba'))
        handles.varmodaacarba =1;
    end
    
    addaminacid = Aminoacid.aa1let{handles.varmodaacarba};
    addpostxt    = sprintf('%s \n',handles.varmodposcarba);
    varmodtext =[varmodtext '<i> ' ...
        addaminacid ' ', addpostxt];
end

if(isfield(handles,'choicevarmodcarboxymethyl') &&handles.choicevarmodcarboxymethyl &&...
        isfield(handles,'varmodposcarbo') )
    if(~isfield(handles,'varmodaacarbo'))
        handles.varmodaacarbo =1;
    end
    
    addaminacid = Aminoacid.aa1let{handles.varmodaacarbo};
    addpostxt    = sprintf('%s \n',handles.varmodposcarbo);
    varmodtext =[varmodtext '<ic> ' ...
        addaminacid ' ', addpostxt];
end

if(isfield(handles,'choicevarmodoxidation')  && handles.choicevarmodoxidation...
        && isfield(handles,'varmodposoxidation') )
    if(~isfield(handles,'varmodaaoxidation'))
        handles.varmodaaoxidation =1;
    end
    
    addaminacid = Aminoacid.aa1let{handles.varmodaaoxidation};
    addpostxt    = sprintf('%s \n',handles.varmodposoxidation);
    varmodtext =[varmodtext '<o> ' ...
        addaminacid ' ', addpostxt];
end

if(isfield(handles,'choicevarmodsulf') && handles.choicevarmodsulf &&...
        isfield(handles,'varmodpossulf') )
    if(~isfield(handles,'varmodaasulf'))
        handles.varmodaasulf =1;
    end
    
    addaminacid = Aminoacid.aa1let{handles.varmodaasulf};
    addpostxt    = sprintf('%s \n',handles.varmodpossulf);
    varmodtext =[varmodtext '<s> ' ...
        addaminacid ' ', addpostxt];
end

if(isfield(handles,'choicevarmodphos') &&handles.choicevarmodphos&&....
        isfield(handles,'varmodposphos') )
    if(~isfield(handles,'varmodaaphos'))
        handles.varmodaaphos =1;
    end
    
    addaminacid = Aminoacid.aa1let{handles.varmodaaphos};
    addpostxt    = sprintf('%s \n',handles.varmodposphos);
    varmodtext =[varmodtext '<p> ' ...
        addaminacid ' ', addpostxt];
end

if(isfield(handles,'choicevarmodglycan') && handles.choicevarmodglycan)
    if(isfield(handles,'glycanmod'))
        addpostxt    = sprintf('%s \n',handles.glycanmod);
        varmodtext  = [varmodtext addpostxt];
    end
end

handles.varmodtext = varmodtext;
guidata(hObject,handles);

if(isempty(varmodtext))
    msgbox('Please provide input to create configuration');
else
    set(handles.edit_dispvarmod,'string',varmodtext);
end


% --- Executes on key press with focus on radiobutton_varmodsulfchoice and none of its controls.
function radiobutton_varmodsulfchoice_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton_varmodsulfchoice (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function edit_dispglycanmod_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dispglycanmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dispglycanmod as text
%        str2double(get(hObject,'String')) returns contents of edit_dispglycanmod as a double


% --- Executes during object creation, after setting all properties.
function edit_dispglycanmod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dispglycanmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_minnummod_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minnummod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.minnummod=str2double(get(hObject,'String'));
if(isempty(handles.minnummod)||isnan(handles.minnummod)...
        ||handles.minnummod<0)
    msgbox('Use default value "0" for digestion','Wrong input');
    handles.minnummod = 0;
    set(handles.edit_minnummod,'string',2);
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_minnummod as text
%        str2double(get(hObject,'String')) returns contents of edit_minnummod as a double


% --- Executes during object creation, after setting all properties.
function edit_minnummod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minnummod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_maxpeplength_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxpeplength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.maxpeplength= str2double(get(hObject,'String'));
if(isempty(handles.maxpeplength)||isnan(handles.maxpeplength)...
        ||handles.maxpeplength<=0)
    msgbox('Use default value "12" for digestion','Wrong input');
    handles.maxpeplength = 12;
    set(handles.edit_maxpeplength,'string','12');
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit_maxpeplength as text
%        str2double(get(hObject,'String')) returns contents of edit_maxpeplength as a double


% --- Executes during object creation, after setting all properties.
function edit_maxpeplength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxpeplength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%
% function edit_maxpeplength_Callback(hObject, eventdata, handles)
% % hObject    handle to edit_maxpeplength (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% % Hints: get(hObject,'String') returns contents of edit_maxpeplength as text
% %        str2double(get(hObject,'String')) returns contents of edit_maxpeplength as a double


% % --- Executes during object creation, after setting all properties.
% function edit_maxpeplength_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to edit_maxpeplength (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
%
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


% --- Executes on button press in pushbutton_clear.
function pushbutton_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_disppepfraglibrary,'string','');


% --- Executes on button press in pushbutton_clearvarmod.
function pushbutton_clearvarmod_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearvarmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_dispvarmod,'string','');
if(isfield(handles,'varptmopt'))
    handles.varptmopt      = [];
end
if(isfield(handles,'varptmstring'))
    handles.varptmstring   = '';
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_clearfixedmod.
function pushbutton_clearfixedmod_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearfixedmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_dispfixedmod,'string','');
if(isfield(handles,'fptmopt'))
    handles.fptmopt = [];
end
if(isfield(handles,'fixedmodtxt'))
    handles.fixedmodtext = '';
end
guidata(hObject, handles);



function edit_disppepseq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_disppepseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_disppepseq as text
%        str2double(get(hObject,'String')) returns contents of edit_disppepseq as a double


% --- Executes during object creation, after setting all properties.
function edit_disppepseq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_disppepseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dispvarptmfile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dispvarptmfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dispvarptmfile as text
%        str2double(get(hObject,'String')) returns contents of edit_dispvarptmfile as a double


% --- Executes during object creation, after setting all properties.
function edit_dispvarptmfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dispvarptmfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dispfixptmfile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dispfixptmfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dispfixptmfile as text
%        str2double(get(hObject,'String')) returns contents of edit_dispfixptmfile as a double


% --- Executes during object creation, after setting all properties.
function edit_dispfixptmfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dispfixptmfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on pushbutton_selectpeptideseqfile and none of its controls.
function pushbutton_selectpeptideseqfile_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectpeptideseqfile (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton_selectpeptideseqfile.
function pushbutton_selectpeptideseqfile_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_selectpeptideseqfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu_enz.
function popupmenu_enz_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_enz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on popupmenu_enz and none of its controls.
function popupmenu_enz_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_enz (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
