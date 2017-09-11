function varargout = glycopatgui(varargin)
% GLYCOPATGUI: Start a GlycoPAT main GUI for Glycoproteomics Analysis
%
% See also: DIGESTGUI, SCOREGUI, BROWSEGUI, FRAGGUI, SPECTRAANNOTATIONGUI.

% Author: Gang Liu
% Date Lastly Updated: 8/5/14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @glycopatgui_OpeningFcn, ...
                   'gui_OutputFcn',  @glycopatgui_OutputFcn, ...
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


% --- Executes just before glycopatgui is made visible.
function glycopatgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to glycopatgui (see VARARGIN)

% Choose default command line output for glycopatgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes glycopatgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = glycopatgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_digestion.
function pushbutton_digestion_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_digestion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
digestgui;


% --- Executes on button press in pushbutton_ms2analysis.
function pushbutton_ms2analysis_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ms2analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scoregui;


% --- Executes on button press in pushbutton_browse.
function pushbutton_browse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
browsegui;

% --- Executes on button press in pushbutton_frag.
function pushbutton_frag_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_frag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fraggui;


% --- Executes on button press in pushbutton_singlespectraannotation.
function pushbutton_singlespectraannotation_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_singlespectraannotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spectraAnnotationgui
