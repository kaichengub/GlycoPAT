function varargout = browsegui(varargin)
% BROWSEGUI: Start a GUI for browsing scoring result in CSV format
%
% See also: GLYCOPATGUI, DIGESTGUI, SCOREGUI, FRAGGUI, SPECTRAANNOTATIONGUI

% Author: Gang Liu
% Date Lastly Updated: 7/30/14

% Edit the above text to modify the response to help browsegui

% Last Modified by GUIDE v2.5 08-Dec-2016 16:08:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @browsegui_OpeningFcn, ...
    'gui_OutputFcn',  @browsegui_OutputFcn, ...
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


% --- Executes just before browsegui is made visible.
function browsegui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to browsegui (see VARARGIN)

% Choose default command line output for browsegui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes browsegui wait for user response (see UIRESUME)
% uiwait(handles.main);


% --- Outputs from this function are returned to the command line.
function varargout = browsegui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_loadscoreresult.
function pushbutton_loadscoreresult_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadscoreresult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mzxmlobj finaltable
mzxmlobj =[];
[dirallfilename, pathname,filterindex] = uigetfile({'*.csv'},'Pick a file storing scoring result');
if(isequal(dirallfilename,0) || isequal(pathname,0))
    msgbox('File NOT Selected');
else
    try
        set(handles.edit_dispheader,'string','');
        set(handles.edit_loadfilestatus,'string','');
        set(handles.edit_dispheader,'string','');
        set(handles.uitable_scoredisplay,'data',[],'ColumnName',...
            '');
        
        handles.scorefilename = fullfile(pathname,dirallfilename);
        % enable horizontal scrolling
        set(handles.edit_loadfilestatus,'string',handles.scorefilename);
        jEdit = findjobj(handles.edit_loadfilestatus);
        jEditbox = jEdit.getViewport().getComponent(0);
        jEditbox.setWrapping(false);                % turn off word-wrapping
        jEditbox.setEditable(false);                % non-editable
        set(jEdit,'HorizontalScrollBarPolicy',30);  % HORIZONTAL_SCROLLBAR_AS_NEEDED
        
        % read header from file
        [handles.headerpar,handles.msdatatype,headerstr,scoredata] = scoreCSVread(handles.scorefilename);
        
        % display header information and enable horizontal scrolling
        jEdit    = findjobj(handles.edit_dispheader);
        jEditbox = jEdit.getViewport().getComponent(0);
        jEditbox.setWrapping(false);                % turn off word-wrapping
        jEditbox.setEditable(false);                % non-editable
        set(jEdit,'HorizontalScrollBarPolicy',30);  % HORIZONTAL_SCROLLBAR_AS_NEEDED
        headerstr = strrep(headerstr,',',' ');
        set(handles.edit_dispheader,'string',headerstr);
        
        %load scoring data
        scoretable              = struct2table(scoredata);
        colnames                = scoretable.Properties.VariableNames;
        
        handles.scoretable      = sortrows(scoretable,'enscore','descend');
        scoretabledata          = table2cell(handles.scoretable);
        colnames                = colnames';
        
        % set column width
        for i = 1 : length(colnames)
            columnwidth{i} = 'auto';
        end
        
        %find maximum length of char
        maxlength= 0;
        sgplist = scoretable.peptide;
        for i = 1 : length(sgplist)
            glystr = sgplist{i};
            if(maxlength<length(glystr))
                maxlength = length(glystr);
            end
        end
        columnwidth{7} = (maxlength +2)*10;
        % SET COLUMN FORMAT
        for i = 1 : length(colnames)
            columnformat{i} = 'numeric';
        end
        columnformat{7} = 'char';
        % columnformat{length(colnames)} = 'char';
        
        for i = 1 : length(colnames)
            if(strcmpi(colnames{i},'htavg'))
                colnames{i} = 'Xcorr';
            elseif(strcmpi(colnames{i},'htcenter'))
                colnames{i}='Xcorr_norm';
            elseif(strcmpi(colnames{i},'enscore'))
                colnames{i}='ES';
            end
        end
        
        finaltable = handles.scoretable;
        set(handles.uitable_scoredisplay,'data',scoretabledata,'ColumnName',...
            colnames,'ColumnWidth',columnwidth,'ColumnFormat',columnformat);
        handles.colnames     = colnames;
        handles.columnwidth  = columnwidth;
        handles.columnformat = columnformat;
        
        %  jScroll = findjobj(handles.uitable_scoredisplay);
        %  jTable = jScroll.getViewport.getView;
        %  jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
        hJScroll = findjobj(handles.uitable_scoredisplay); % findjobj is from file exchange
        hJTable  = hJScroll.getViewport.getView; % get the table component within the scroll object
        hJTable.setNonContiguousCellSelection(false);
        hJTable.setColumnSelectionAllowed(false);
        hJTable.setRowSelectionAllowed(true);
        
        handles.isglycanonly = false;
        
        hJTable = handle(hJTable,'CallbackProperties');
        %set(hJTable,'MousePressedCallback',{@myCellSelectionCallback,gcf});
        set(hJTable,'MousePressedCallback',{@uitable_scoredisplay_CellSelectionCallback,handles});
        guidata(hObject,handles);
    catch error
        errordlg(error.message,'Please select file again');
        return
    end
end

function uitable_scoredisplay_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_scoredisplay (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global mzxmlobj finaltable
hJScroll         = findjobj(handles.uitable_scoredisplay); % findjobj is from file exchange
hJTable          = hJScroll.getViewport.getView;            % get the table component within the scroll object
selectedrow      = hJTable.getSelectedRow + 1;

datastruct = table2struct(finaltable);
%% new version
try
    if(strcmpi(handles.msdatatype,'dta'))
        browse1file(selectedrow,handles.headerpar,datastruct);
    elseif(strcmpi(handles.msdatatype,'mzxml'))
        if(isempty(mzxmlobj))
            mzxmlobj    = mzXML(handles.headerpar.xmlfilename,0,'memsave');
            % msscandata  = mzxmlobj.scandata;
        end
        browse1file(selectedrow,handles.headerpar,datastruct,mzxmlobj);
    end
catch err
    msgbox(err.message);
    return
end

%% new version end, previous version start
% try
%     if(strcmpi(handles.msdatatype,'dta'))
%         foundpeaks     = browse1dtafile(selectedrow,handles.headerpar,datastruct);
%     elseif(strcmpi(handles.msdatatype,'mzxml'))
%         if(isempty(mzxmlobj))
%            mzxmlobj    = mzXML(handles.headerpar.xmlfilename,0,'memsave');
%           % msscandata  = mzxmlobj.scandata;
%         end
%         foundpeaks     = browse1mzXMLfile(selectedrow,handles.headerpar,datastruct,mzxmlobj);
%     end
% catch err
%     msgbox(err.message);
%     return
% end
%% previous version end


% if(~isempty(fieldnames(foundpeaks)))
% foundpeaktable = struct2table(foundpeaks);
% foundpeaktable = sortrows(foundpeaktable,'Intensity','descend');
% colnames       = foundpeaktable.Properties.VariableNames;
% scoretabledata = table2cell(foundpeaktable);
% colnames       = colnames';
% % set column width
% for i = 1 : length(colnames)
%     columnwidth{i} = 'auto';
% end
% columnformat{i} = {'char','char','numeric','numeric','numeric',...
%                    'char','numeric','long','long','long','long',...
%                    'long'};
%
% h=annotate1filegui;
% htable=findobj(h,'Tag','uitable_matchpeaklist');
% % set(htable,'data',scoretabledata,'ColumnName',...
% %     colnames,'ColumnWidth',columnwidth,'ColumnFormat',columnformat);
% end

function edit_loadfilestatus_Callback(hObject, eventdata, handles)
% hObject    handle to edit_loadfilestatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_loadfilestatus as text
%        str2double(get(hObject,'String')) returns contents of edit_loadfilestatus as a double


% --- Executes during object creation, after setting all properties.
function edit_loadfilestatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_loadfilestatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_clear.
function pushbutton_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mzxmlobj finaltable
mzxmlobj =[];
finaltable = [];
set(handles.edit_dispheader,'string','');
set(handles.edit_loadfilestatus,'string','');
set(handles.edit_dispheader,'string','');
set(handles.uitable_scoredisplay,'data',[],'ColumnName',...
    '');
set(handles.checkbox_glycanonly,'value',0);
handles.scoretable=[];
guidata(hObject,handles);

function edit_dispheader_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dispheader (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dispheader as text
%        str2double(get(hObject,'String')) returns contents of edit_dispheader as a double


% --- Executes during object creation, after setting all properties.
function edit_dispheader_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dispheader (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uitable_scoredisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable_scoredisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when annotation is resized.
function annotation_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to annotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton_loadscoreresult.
function pushbutton_loadscoreresult_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadscoreresult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in uitable_scoredisplay.
function uitable_scoredisplay_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_scoredisplay (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_glycanonly.
function checkbox_glycanonly_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_glycanonly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global finaltable
handles.isglycanonly = get(hObject,'Value');

if(handles.isglycanonly)
    glycanonlyrows          =  cellfun('isempty',strfind(...
        handles.scoretable.peptide,'{'));
    displaytable            =  handles.scoretable(~glycanonlyrows,:);
else
    displaytable            =  handles.scoretable;
end

if(isfield(handles,'selectbysenscore')&&handles.selectbysenscore)
    displaytable = displaytable(displaytable.enscore>handles.enscorethreshold,:);
end

if(isfield(handles,'selectbyfragmode'))
    switch upper(handles.selectbyfragmode)
        case 'ALL MODES'
            % do nothing
        case 'ETD ONLY'
            etdonlyrows =  ~cellfun('isempty',strfind(upper(...
                displaytable.fragMode),'ETD'));
            displaytable = displaytable(etdonlyrows,:);
        case 'CID ONLY'
            CIDdonlyrows =  ~cellfun('isempty',strfind(...
                upper(displaytable.fragMode),'CID'));
            displaytable = displaytable(CIDdonlyrows,:);
        case 'HCD ONLY'
            HCDonlyrows =  ~cellfun('isempty',strfind(...
                upper(displaytable.fragMode),'HCD'));
            displaytable = displaytable(HCDonlyrows,:);
        otherwise
            error('MATLAB:GLYCOPAT:ERROR','ABNORMAL ERROR, CHECK CODE');
    end
end

displaydata = table2cell(displaytable);
set(handles.uitable_scoredisplay,'data',displaydata,'ColumnName',...
    handles.colnames,'ColumnWidth',handles.columnwidth,...
    'ColumnFormat',handles.columnformat);
handles.displaytable=displaytable;
finaltable = displaytable;
guidata(hObject,handles);

% --- Executes on button press in selectspectrabyescore.
function selectspectrabyescore_Callback(hObject, eventdata, handles)
% hObject    handle to selectspectrabyescore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global finaltable
handles.selectbysenscore = get(hObject,'Value');

if(isfield(handles,'isglycanonly')&& handles.isglycanonly)
    glycanonlyrows          =  cellfun('isempty',strfind(...
        handles.scoretable.peptide,'{'));
    displaytable            =  handles.scoretable(~glycanonlyrows,:);
else
    displaytable            =  handles.scoretable;
end

if(handles.selectbysenscore)
    displaytable = displaytable(displaytable.enscore>handles.enscorethreshold,:);
end

if(isfield(handles,'selectbyfragmode'))
    switch upper(handles.selectbyfragmode)
        case 'ALL MODES'
            % do nothing
        case 'ETD ONLY'
            etdonlyrows =  ~cellfun('isempty',strfind(upper(...
                displaytable.fragMode),'ETD'));
            displaytable = displaytable(etdonlyrows,:);
        case 'CID ONLY'
            CIDdonlyrows =  ~cellfun('isempty',strfind(...
                upper(displaytable.fragMode),'CID'));
            displaytable = displaytable(CIDdonlyrows,:);
        case 'HCD ONLY'
            HCDonlyrows =  ~cellfun('isempty',strfind(...
                upper(displaytable.fragMode),'HCD'));
            displaytable = displaytable(HCDonlyrows,:);
        otherwise
            error('MATLAB:GLYCOPAT:ERROR','ABNORMAL ERROR, CHECK CODE');
    end
end

displaydata = table2cell(displaytable);
set(handles.uitable_scoredisplay,'data',displaydata,'ColumnName',...
    handles.colnames,'ColumnWidth',handles.columnwidth,...
    'ColumnFormat',handles.columnformat);
handles.displaytable=displaytable;
finaltable = displaytable;
guidata(hObject,handles);

function enscorethreshold_Callback(hObject, eventdata, handles)
% hObject    handle to enscorethreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enscorethreshold as text
%        str2double(get(hObject,'String')) returns contents of enscorethreshold as a double
handles.enscorethreshold = str2double(get(hObject,'String'));
if(isnan(handles.enscorethreshold))
    handles.enscorethreshold = 0;
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function enscorethreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enscorethreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in select_fragmode.
function select_fragmode_Callback(hObject, eventdata, handles)
% hObject    handle to select_fragmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_fragmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_fragmode
global finaltable
contents     = cellstr(get(hObject,'String'));
handles.selectbyfragmode = contents{get(hObject,'Value')};

if(isfield(handles,'isglycanonly')&& handles.isglycanonly)
    glycanonlyrows          =  cellfun('isempty',strfind(...
        handles.scoretable.peptide,'{'));
    displaytable            =  handles.scoretable(~glycanonlyrows,:);
else
    displaytable            =  handles.scoretable;
end

if(isfield(handles,'selectbysenscore')&&handles.selectbysenscore)
    displaytable = displaytable(displaytable.enscore>handles.enscorethreshold,:);
end

if(isfield(handles,'selectbyfragmode'))
    switch upper(handles.selectbyfragmode)
        case 'ALL MODES'
            % do nothing
        case 'ETD ONLY'
            etdonlyrows =  ~cellfun('isempty',strfind(upper(...
                displaytable.fragMode),'ETD'));
            displaytable = displaytable(etdonlyrows,:);
        case 'CID ONLY'
            CIDdonlyrows =  ~cellfun('isempty',strfind(...
                upper(displaytable.fragMode),'CID'));
            displaytable = displaytable(CIDdonlyrows,:);
        case 'HCD ONLY'
            HCDonlyrows =  ~cellfun('isempty',strfind(...
                upper(displaytable.fragMode),'HCD'));
            displaytable = displaytable(HCDonlyrows,:);
        otherwise
            error('MATLAB:GLYCOPAT:ERROR','ABNORMAL ERROR, CHECK CODE');
    end
end

displaydata = table2cell(displaytable);
set(handles.uitable_scoredisplay,'data',displaydata,'ColumnName',...
    handles.colnames,'ColumnWidth',handles.columnwidth,...
    'ColumnFormat',handles.columnformat);
handles.displaytable=displaytable;
finaltable = displaytable;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function select_fragmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_fragmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in export_spectra.
function export_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to export_spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mzxmlobj finaltable
diname = uigetdir(pwd,'Pick a folder to store annotated spectra');
if(isequal(diname,0))
    msgbox('Folder NOT Selected');
else
    try
        datastruct = table2struct(finaltable);
        if(strcmpi(handles.msdatatype,'dta'))
            %%
        elseif(strcmpi(handles.msdatatype,'mzxml'))
            tic
            waitbarstring =['Exporting annotated spectra to the folder (' diname  ')....Please wait...'];
            waitbarstring=regexprep(waitbarstring,'\\','\\\\');
            waitbarstring=regexprep(waitbarstring,'//','////');
            waitbarstring=regexprep(waitbarstring,'\_','\\\_');
            h = waitbar(0,sprintf('%s',waitbarstring));
            for i = 1:height(finaltable)
                if(isempty(mzxmlobj))
                    mzxmlobj    = mzXML(handles.headerpar.xmlfilename,0,'memsave');
                    % msscandata  = mzxmlobj.scandata;
                end
                figopt.exportfolder = diname;
                figopt.export       = 1;
                figopt.display      = 0;
                browse1mzXMLfile(i,handles.headerpar,datastruct,mzxmlobj,figopt);
                waitbar(i/height(finaltable),h);
            end
            close(h);
            toc
        end
    catch err
        errordlg(err.message);
    end
end

% --- Executes on button press in fdrfilter.
function fdrfilter_Callback(hObject, eventdata, handles)
% hObject    handle to fdrfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global finaltable;

if(isfield(handles,'fdrratechoice'))
    if(handles.fdrratechoice==1)
        fdrfiltervalue = 0.005;
    elseif(handles.fdrratechoice==2)
        fdrfiltervalue = 0.01;
    elseif(handles.fdrratechoice==3)
        fdrfiltervalue = 0.02;
    elseif(handles.fdrratechoice==4)
        fdrfiltervalue = 0.04;
    elseif(handles.fdrratechoice==5)
        fdrfiltervalue = 0.05;
    elseif(handles.fdrratechoice==6)
        fdrfiltervalue = 0.1;
    elseif(handles.fdrratechoice==7)
        fdrfiltervalue = 0.2;
    end
else
    fdrfiltervalue = 0.005;
end

if(isfield(handles,'fdrfragmode'))
    if(strcmp(handles.fdrfragmode,'HCD'))
        singlemode = 1;
        fragmode ='HCD';
    elseif(strcmp(handles.fdrfragmode,'ETD'))
        singlemode = 1;
        fragmode ='ETD';
    elseif(strcmp(handles.fdrfragmode,'CID'))
        singlemode = 1;
        fragmode ='CID';
    elseif(strcmp(handles.fdrfragmode,'All Modes'))
        singlemode = 0;
        fragmode ='CID';
    end
else
    singlemode = 0;
    fragmode ='CID';
end

%check selection of fragmentation types
modetypes = unique(handles.scoretable.fragMode);
if(singlemode==1) % select single mode
    % check selected mode is in modetypes
    if((sum(strcmp(fragmode,modetypes)))==0)
        errordlg('Selected fragmentation mode does not exist in the table, Please select antoher one');
        return
    end
else % select mixed mode but there is only one fragmentation type
    if(length(modetypes)==1)
        singlemode = 1;
        fragmode   = modetypes{1};
    end
end

if(isfield(handles,'peptype'))
    if(handles.peptype==1)
        glycopep = 2;
    elseif(handles.peptype==2)
        glycopep = 0;
    elseif(handles.peptype==3)
        glycopep = 1;
    end
else
    glycopep =2;
end

option   = struct('fdrfilter',fdrfiltervalue,'glycopep',glycopep,'singlemode',singlemode,'fragmode',fragmode);
[handles.escutoffvalue,displaytable] = fdrfilter(handles.scoretable,option);
% display ES cut off value
handles.escutoffvalue
set(handles.escutoff,'string',num2str(handles.escutoffvalue));
% display table
displaydata = table2cell(displaytable);
set(handles.uitable_scoredisplay,'data',displaydata,'ColumnName',...
    handles.colnames,'ColumnWidth',handles.columnwidth,...
    'ColumnFormat',handles.columnformat);
handles.displaytable=displaytable;
finaltable = displaytable;
guidata(hObject,handles);

% --- Executes on button press in resetoriginal.
function resetoriginal_Callback(hObject, eventdata, handles)
% hObject    handle to resetoriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isfield(handles,'scoretable'))&& (~isempty(handles.scoretable))
    displaydata = table2cell(handles.scoretable);
    set(handles.uitable_scoredisplay,'data',displaydata,'ColumnName',...
        handles.colnames,'ColumnWidth',handles.columnwidth,...
        'ColumnFormat',handles.columnformat);
end

% --- Executes on selection change in fdr_rate.
function fdr_rate_Callback(hObject, eventdata, handles)
% hObject    handle to fdr_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fdrratechoice = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function fdr_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdr_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fdr_fragmode.
function fdr_fragmode_Callback(hObject, eventdata, handles)
% hObject    handle to fdr_fragmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fdr_fragmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fdr_fragmode
contents = cellstr(get(hObject,'String'));
handles.fdrfragmode = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function fdr_fragmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdr_fragmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fdr_peptidetype.
function fdr_peptidetype_Callback(hObject, eventdata, handles)
% hObject    handle to fdr_peptidetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fdr_peptidetype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fdr_peptidetype
handles.fdrpeptype = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function fdr_peptidetype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdr_peptidetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function escutoff_Callback(hObject, eventdata, handles)
% hObject    handle to escutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of escutoff as text
%        str2double(get(hObject,'String')) returns contents of escutoff as a double


% --- Executes during object creation, after setting all properties.
function escutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to escutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in export_csv.
function export_csv_Callback(hObject, eventdata, handles)
% hObject    handle to export_csv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname,filterindex] = uiputfile({'*.csv'},'Save a file storing scoring result');
if(isequal(filename,0) || isequal(pathname,0))
    msgbox('File NOT Selected');
else
    try
        fullfilename = fullfile(pathname,filename);
        if(isfield(handles,'displaytable'))
            writetable(handles.displaytable,fullfilename);
        else
            writetable(handles.scoretable,fullfilename);
        end
    catch err
        errordlg(err.message);
    end
end

% --- Executes on button press in fdrfilter.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to fdrfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in fdr_rate.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to fdr_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fdr_rate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fdr_rate


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdr_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fdr_fragmode.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to fdr_fragmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fdr_fragmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fdr_fragmode


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdr_fragmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fdr_peptype.
function fdr_peptype_Callback(hObject, eventdata, handles)
% hObject    handle to fdr_peptype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.peptype = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function fdr_peptype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdr_peptype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on uitable_scoredisplay and none of its controls.
function uitable_scoredisplay_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uitable_scoredisplay (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton_loadscoreresult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadscoreresult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
