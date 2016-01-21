function varargout = gui_figure(varargin)
% GUI_FIGURE MATLAB code for gui_figure.fig
%      GUI_FIGURE, by itself, creates a new GUI_FIGURE or raises the existing
%      singleton*.
%
%      H = GUI_FIGURE returns the handle to a new GUI_FIGURE or the handle to
%      the existing singleton*.
%
%      GUI_FIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FIGURE.M with the given input arguments.
%
%      GUI_FIGURE('Property','Value',...) creates a new GUI_FIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI_FIGURE before gui_figure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_figure_OpeningFcn via varargin.
%
%      *See GUI_FIGURE Options on GUIDE's Tools menu.  Choose "GUI_FIGURE allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_figure

% Last Modified by GUIDE v2.5 20-Jan-2016 21:46:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_figure_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_figure_OutputFcn, ...
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


% --- Executes just before gui_figure is made visible.
function gui_figure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_figure (see VARARGIN)

% Choose default command line output for gui_figure
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_figure wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_figure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_load.
function button_load_Callback(hObject, eventdata, handles)
    global gui;
    
    gui.load_file();
    
    
% --- Executes on button press in button_start.
function button_start_Callback(hObject, eventdata, handles)
    global gui;
    
    gui.start();


% --- Executes on button press in button_stop.
function button_stop_Callback(hObject, eventdata, handles)
% hObject    handle to button_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global gui;
    
    gui.stop();
