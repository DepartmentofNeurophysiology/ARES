function varargout = ARES_UI(varargin)
% ARES_UI MATLAB code for ARES_UI.fig
%      ARES_UI, by itself, creates a new ARES_UI or raises the existing
%      singleton*.
%
%      H = ARES_UI returns the handle to a new ARES_UI or the handle to
%      the existing singleton*.
%
%      ARES_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARES_UI.M with the given input arguments.
%
%      ARES_UI('Property','Value',...) creates a new ARES_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ARES_UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ARES_UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ARES_UI

% Last Modified by GUIDE v2.5 02-May-2018 12:53:57

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ARES_UI_OpeningFcn, ...
                   'gui_OutputFcn',  @ARES_UI_OutputFcn, ...
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


% --- Executes just before ARES_UI is made visible.
function ARES_UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ARES_UI (see VARARGIN)

% Choose default command line output for ARES_UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%% UIWAIT makes ARES_UI wait for user response (see UIRESUME)
uiwait(handles.ARES_UI_figure);
% uiwait(handles.ARES_UI_figure);


% --- Outputs from this function are returned to the command line.
function varargout = ARES_UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% DEFAULT OUTPUT line: varargout{1} = handles.output;



%% Set output.
options = get_options(handles);

varargout{1} = options;



%% OTHER FUNCTIONS

function process_order_input_Callback(hObject, eventdata, handles)
% hObject    handle to process_order_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of process_order_input as text
%        str2double(get(hObject,'String')) returns contents of process_order_input as a double


% --- Executes during object creation, after setting all properties.
function process_order_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to process_order_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function win_size_input_Callback(hObject, eventdata, handles)
% hObject    handle to win_size_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of win_size_input as text
%        str2double(get(hObject,'String')) returns contents of win_size_input as a double


% --- Executes during object creation, after setting all properties.
function win_size_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to win_size_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function win_step_input_Callback(hObject, eventdata, handles)
% hObject    handle to win_step_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of win_step_input as text
%        str2double(get(hObject,'String')) returns contents of win_step_input as a double


% --- Executes during object creation, after setting all properties.
function win_step_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to win_step_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in win_type_input.
function win_type_input_Callback(hObject, eventdata, handles)
% hObject    handle to win_type_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns win_type_input contents as cell array
%        contents{get(hObject,'Value')} returns selected item from win_type_input

win_type = get(hObject, 'Value');
if win_type == 2 % 2nd option is gaussian
    set(handles.gauss_std_input,'Enable','on')  % enable
else
    set(handles.gauss_std_input,'Enable','off')  % disable
end


% --- Executes during object creation, after setting all properties.
function win_type_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to win_type_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gauss_std_input_Callback(hObject, eventdata, handles)
% hObject    handle to gauss_std_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gauss_std_input as text
%        str2double(get(hObject,'String')) returns contents of gauss_std_input as a double


% --- Executes during object creation, after setting all properties.
function gauss_std_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gauss_std_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in reg_type_input.
function reg_type_input_Callback(hObject, eventdata, handles)
% hObject    handle to reg_type_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns reg_type_input contents as cell array
%        contents{get(hObject,'Value')} returns selected item from reg_type_input


% --- Executes during object creation, after setting all properties.
function reg_type_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reg_type_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function neigh_order_input_Callback(hObject, eventdata, handles)
% hObject    handle to neigh_order_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neigh_order_input as text
%        str2double(get(hObject,'String')) returns contents of neigh_order_input as a double
neigh_order = str2double(get(hObject, 'String'));
if neigh_order ~= 0
    set(handles.neigh_ignore_outside_button,'Enable','on')  % enable
else
    set(handles.neigh_ignore_outside_button,'Enable','off')  % disable
end

% --- Executes during object creation, after setting all properties.
function neigh_order_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neigh_order_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in neigh_ignore_outside_button.
function neigh_ignore_outside_button_Callback(hObject, eventdata, handles)
% hObject    handle to neigh_ignore_outside_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of neigh_ignore_outside_button


% --- Executes on button press in demean_button.
function demean_button_Callback(hObject, eventdata, handles)
% hObject    handle to demean_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of demean_button


% --- Executes on button press in abs_value_button.
function abs_value_button_Callback(hObject, eventdata, handles)
% hObject    handle to abs_value_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of abs_value_button


% --- Executes on button press in all_frames_flag_button.
function all_frames_flag_button_Callback(hObject, eventdata, handles)
% hObject    handle to all_frames_flag_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of all_frames_flag_button
FLAG_all_frames = get(hObject, 'Value');
if FLAG_all_frames == 1
    % Turn off the Selection Tools option.
    set(handles.frames_selection_flag_button, 'Value', 0);
    % Turn off all the Tools.
    set(handles.remove_ext_text, 'Enable', 'off')  % disable
    set(handles.remove_ext_input, 'Enable', 'off')  % disable
    set(handles.remove_inter_text, 'Enable', 'off')  % disable
    set(handles.remove_inter_input, 'Enable', 'off')  % disable
    set(handles.InterTrialKeep_text, 'Enable', 'off')  % disable
    set(handles.InterTrialKeep_input, 'Enable', 'off')  % disable
    set(handles.deriv_thr_mod_text, 'Enable', 'off')  % disable
    set(handles.deriv_thr_mod_input, 'Enable', 'off')  % disable
    set(handles.max_dark_text, 'Enable', 'off')  % disable
    set(handles.max_dark_input, 'Enable', 'off')  % disable
    set(handles.interpolation_cycles_text, 'Enable', 'off')  % disable
    set(handles.interpolation_cycles_input, 'Enable', 'off')  % disable
    set(handles.uipanel_automatic_selection, 'ForegroundColor', [0.5, 0.5, 0.5])  % disable
else
    % Turn on the Selection Tools option.
    set(handles.frames_selection_flag_button, 'Value', 1);
    % Turn on all the Tools.
    set(handles.remove_ext_text, 'Enable', 'on')  % enable
    set(handles.remove_ext_input, 'Enable', 'on')  % enable
    set(handles.remove_inter_text, 'Enable', 'on')  % enable
    set(handles.remove_inter_input, 'Enable', 'on')  % enable
    set(handles.InterTrialKeep_text, 'Enable', 'on')  % enable
    set(handles.InterTrialKeep_input, 'Enable', 'on')  % enable
    set(handles.deriv_thr_mod_text, 'Enable', 'on')  % enable
    set(handles.deriv_thr_mod_input, 'Enable', 'on')  % enable
    set(handles.max_dark_text, 'Enable', 'on')  % enable
    set(handles.max_dark_input, 'Enable', 'on')  % enable
    set(handles.interpolation_cycles_text, 'Enable', 'on')  % enable
    set(handles.interpolation_cycles_input, 'Enable', 'on')  % enable
    set(handles.uipanel_automatic_selection, 'ForegroundColor', [0, 0, 0])  % enable
end


% --- Executes on button press in frames_selection_flag_button.
function frames_selection_flag_button_Callback(hObject, eventdata, handles)
% hObject    handle to frames_selection_flag_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frames_selection_flag_button
FLAG_frames_selection = get(hObject, 'Value');
if FLAG_frames_selection == 1
    % Turn off the All Frames FLAG.
    set(handles.all_frames_flag_button, 'Value', 0);
    % Turn on all the Tools.
    set(handles.remove_ext_text, 'Enable', 'on')  % enable
    set(handles.remove_ext_input, 'Enable', 'on')  % enable
    set(handles.remove_inter_text, 'Enable', 'on')  % enable
    set(handles.remove_inter_input, 'Enable', 'on')  % enable
    set(handles.InterTrialKeep_text, 'Enable', 'on')  % enable
    set(handles.InterTrialKeep_input, 'Enable', 'on')  % enable
    set(handles.deriv_thr_mod_text, 'Enable', 'on')  % enable
    set(handles.deriv_thr_mod_input, 'Enable', 'on')  % enable
    set(handles.max_dark_text, 'Enable', 'on')  % enable
    set(handles.max_dark_input, 'Enable', 'on')  % enable
    set(handles.interpolation_cycles_text, 'Enable', 'on')  % enable
    set(handles.interpolation_cycles_input, 'Enable', 'on')  % enable
    set(handles.uipanel_automatic_selection, 'ForegroundColor', [0, 0, 0])  % enable
else
    % Turn on the All Frames FLAG.
    set(handles.all_frames_flag_button, 'Value', 1);
    % Turn off all the Tools.
    set(handles.remove_ext_text, 'Enable', 'off')  % disable
    set(handles.remove_ext_input, 'Enable', 'off')  % disable
    set(handles.remove_inter_text, 'Enable', 'off')  % disable
    set(handles.remove_inter_input, 'Enable', 'off')  % disable
    set(handles.InterTrialKeep_text, 'Enable', 'off')  % disable
    set(handles.InterTrialKeep_input, 'Enable', 'off')  % disable
    set(handles.deriv_thr_mod_text, 'Enable', 'off')  % disable
    set(handles.deriv_thr_mod_input, 'Enable', 'off')  % disable
    set(handles.max_dark_text, 'Enable', 'off')  % disable
    set(handles.max_dark_input, 'Enable', 'off')  % disable
    set(handles.interpolation_cycles_text, 'Enable', 'off')  % disable
    set(handles.interpolation_cycles_input, 'Enable', 'off')  % disable
    set(handles.uipanel_automatic_selection, 'ForegroundColor', [0.5, 0.5, 0.5])  % disable
end


% --- Executes on button press in normalize_flag_button.
function normalize_flag_button_Callback(hObject, eventdata, handles)
% hObject    handle to normalize_flag_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalize_flag_button


function InterTrialKeep_input_Callback(hObject, eventdata, handles)
% hObject    handle to InterTrialKeep_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InterTrialKeep_input as text
%        str2double(get(hObject,'String')) returns contents of InterTrialKeep_input as a double


% --- Executes during object creation, after setting all properties.
function InterTrialKeep_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InterTrialKeep_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function deriv_thr_mod_input_Callback(hObject, eventdata, handles)
% hObject    handle to deriv_thr_mod_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deriv_thr_mod_input as text
%        str2double(get(hObject,'String')) returns contents of deriv_thr_mod_input as a double


% --- Executes during object creation, after setting all properties.
function deriv_thr_mod_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deriv_thr_mod_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in remove_ext_input.
function remove_ext_input_Callback(hObject, eventdata, handles)
% hObject    handle to remove_ext_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns remove_ext_input contents as cell array
%        contents{get(hObject,'Value')} returns selected item from remove_ext_input


% --- Executes during object creation, after setting all properties.
function remove_ext_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove_ext_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in remove_inter_input.
function remove_inter_input_Callback(hObject, eventdata, handles)
% hObject    handle to remove_inter_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns remove_inter_input contents as cell array
%        contents{get(hObject,'Value')} returns selected item from remove_inter_input


% --- Executes during object creation, after setting all properties.
function remove_inter_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove_inter_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mult_up_down_input_Callback(hObject, eventdata, handles)
% hObject    handle to mult_up_down_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mult_up_down_input as text
%        str2double(get(hObject,'String')) returns contents of mult_up_down_input as a double


% --- Executes during object creation, after setting all properties.
function mult_up_down_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mult_up_down_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cmp_background_button.
function cmp_background_button_Callback(hObject, eventdata, handles)
% hObject    handle to cmp_background_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cmp_background_button
cmp_ARES_background = get(hObject, 'Value');

if cmp_ARES_background ~= 0
    set(handles.bg_pixels_input, 'Enable','on')  % enable
    set(handles.background_text, 'Enable','on')  % enable
else
    set(handles.bg_pixels_input, 'Enable','off')  % disable
    set(handles.background_text, 'Enable','off')  % disable
end


function bg_pixels_input_Callback(hObject, eventdata, handles)
% hObject    handle to bg_pixels_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg_pixels_input as text
%        str2double(get(hObject,'String')) returns contents of bg_pixels_input as a double


% --- Executes during object creation, after setting all properties.
function bg_pixels_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg_pixels_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function max_dark_input_Callback(hObject, eventdata, handles)
% hObject    handle to max_dark_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_dark_input as text
%        str2double(get(hObject,'String')) returns contents of max_dark_input as a double


% --- Executes during object creation, after setting all properties.
function max_dark_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_dark_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function interpolation_cycles_input_Callback(hObject, eventdata, handles)
% hObject    handle to interpolation_cycles_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interpolation_cycles_input as text
%        str2double(get(hObject,'String')) returns contents of interpolation_cycles_input as a double


% --- Executes during object creation, after setting all properties.
function interpolation_cycles_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interpolation_cycles_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_avi_button.
function save_avi_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_avi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_avi_button
FLAG_save_avi = get(hObject, 'Value');

if FLAG_save_avi ~= 0
    set(handles.normalize_avi_button, 'Enable','on')  % enable
    set(handles.static_avi_bg_button, 'Enable','on')  % enable
else
    set(handles.normalize_avi_button, 'Enable','off')  % disable
    set(handles.static_avi_bg_button, 'Enable','off')  % disable
end

% --- Executes on button press in save_mat_button.
function save_mat_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_mat_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_mat_button
FLAG_save_mat = get(hObject, 'Value');

if FLAG_save_mat ~= 0
    set(handles.normalize_mat_button, 'Enable','on')  % enable
else
    set(handles.normalize_mat_button, 'Enable','off')  % disable
end

% --- Executes on button press in save_tif_button.
function save_tif_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_tif_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_tif_button
FLAG_save_tif = get(hObject, 'Value');

if FLAG_save_tif ~= 0
    set(handles.normalize_tif_button, 'Enable','on')  % enable
else
    set(handles.normalize_tif_button, 'Enable','off')  % disable
end

% --- Executes on button press in normalize_mat_button.
function normalize_mat_button_Callback(hObject, eventdata, handles)
% hObject    handle to normalize_mat_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalize_mat_button


% --- Executes on button press in normalize_tif_button.
function normalize_tif_button_Callback(hObject, eventdata, handles)
% hObject    handle to normalize_tif_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalize_tif_button


% --- Executes on button press in normalize_avi_button.
function normalize_avi_button_Callback(hObject, eventdata, handles)
% hObject    handle to normalize_avi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalize_avi_button


% --- Executes on button press in static_avi_bg_button.
function static_avi_bg_button_Callback(hObject, eventdata, handles)
% hObject    handle to static_avi_bg_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of static_avi_bg_button


%-% ~~~~~~ Import - Export ~~~~~~ %-% 

% --- Executes on button press in export_config_button.
function export_config_button_Callback(hObject, eventdata, handles)
% hObject    handle to export_config_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% guidata(hObject, handles);

% Update handles structure.
guidata(hObject, handles);
% Save the current configuration
save_current_config(handles);
% Stop waiting for user input.
uiresume(handles.ARES_UI_figure);
% Resume the waiting.
uiwait(handles.ARES_UI_figure);


% --- Executes on button press in import_config_button.
function import_config_button_Callback(hObject, eventdata, handles)
% hObject    handle to import_config_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load configuration .mat file.
options = load_current_config(hObject, eventdata, handles);
% Update handles structure.
set_gui_values(handles, options);


% --- Executes on button press in reset_defaults_button.
function reset_defaults_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_defaults_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set defaults options.
options = set_default_options();
% Update handles structure.
set_gui_values(handles, options);
% Disable options disabled by default.
set(handles.gauss_std_input, 'Enable', 'off')  % disable
% set(handles.neigh_ignore_outside_button, 'Enable', 'off')  % disable
% set(handles.background_text, 'Enable', 'off')  % disable
% set(handles.bg_pixels_input, 'Enable', 'off')  % disable

%-% ~~~~~~ Start Analysis - Close ~~~~~~ %-% 

% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update handles structure.
guidata(hObject, handles)
% Stop waiting for user input.
uiresume(handles.ARES_UI_figure);
% Close UI.
pause(1);
fprintf('Options set correctly!\n\n')


% Close function - what to do in case the figure is closed.
function ARES_UI_figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ARES_UI_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
%     uiresume(handles.ARES_UI_figure);
    % The GUI is no longer waiting, just close it
delete(hObject);

%-% ~~~~~~ Auxiliary functions ~~~~~~ %-% 

% Saves the current configuration.
function save_current_config(handles)
% Get current config.
options = get_options(handles);
% Save.
uisave('options', 'ARES_saved_config.mat');

% Load the current configuration.
function options = load_current_config(hObject, eventdata, handles)
% Load.
[FileName_config, PathName_config, ~] = uigetfile('*.mat', 'Select configuration file.');
data_tmp_struct = load(strcat(PathName_config, FileName_config));
% Convert into standard name.
tmp_var_1 = struct2cell(data_tmp_struct);
tmp_var_2 = tmp_var_1{1, 1};
options = tmp_var_2;
% Set all options
fprintf('%s was loaded as new config.\n', FileName_config);

% Get options from GUI.
function options = get_options(handles)

% General Options.
options.deactivate_warnings = 1;
options.FLAG_less_RAM = 1;
options.FLAG_Save_Input_as_tif_stack = 0;
options.FLAG_Save_Input_as_tif_images = 0;
options.FLAG_user_custom_FileName = 1;

% AutoRegression.
options.opts_ARES_film.process_order = str2double(get(handles.process_order_input, 'String'));
options.opts_ARES_film.window_length = str2double(get(handles.win_size_input, 'String'));
options.opts_ARES_film.window_advance_step = str2double(get(handles.win_step_input, 'String'));
tmp = cellstr(get(handles.win_type_input, 'String'));
options.opts_ARES_film.window_type = tmp{get(handles.win_type_input, 'Value')};
options.opts_ARES_film.window_g_std = str2double(get(handles.gauss_std_input, 'String'));
tmp = cellstr(get(handles.reg_type_input, 'String'));
options.opts_ARES_film.reg_mode = tmp{get(handles.reg_type_input, 'Value')};
options.opts_ARES_film.absolute_value = get(handles.abs_value_button, 'Value');
options.opts_ARES_film.FLAG_demean = get(handles.demean_button, 'Value');
options.opts_ARES_film.opts_neighbourhood_ts.neighbourhood_order = str2double(get(handles.neigh_order_input, 'String'));
options.opts_ARES_film.opts_neighbourhood_ts.FLAG_ignore_outside_ROI = get(handles.neigh_ignore_outside_button, 'Value');
% Background.
options.FLAG_compute_ARES_background = get(handles.cmp_background_button, 'Value');
options.number_of_background_pixels = str2double(get(handles.bg_pixels_input, 'String'));
% Non-settable from UI.
options.opts_ARES_film.residuals_mode = 'avg';
options.opts_ARES_film.matrix_dimension = 50;
options.opts_ARES_film.FLAG_blank_tag_array = 1;

% Pre-Processing.
options.FLAG_Interpolate_Remove = get(handles.frames_selection_flag_button, 'Value');
tmp = cellstr(get(handles.remove_ext_input, 'String'));
options.FLAG_remove_external_frames = tmp{get(handles.remove_ext_input, 'Value')};
tmp = cellstr(get(handles.remove_inter_input, 'String'));
options.FLAG_Remove_Intertrial = tmp{get(handles.remove_inter_input, 'Value')}; % ATTENTION: 'User' option is not implemented yet.
options.InterTrialFrames_to_keep = str2double(get(handles.InterTrialKeep_input, 'String'));
options.tag_derivative_threshold_modifier = str2double(get(handles.deriv_thr_mod_input, 'String'));
options.tag_darkness_max_length = str2double(get(handles.max_dark_input, 'String'));
options.number_of_interpolation_cycles = str2double(get(handles.interpolation_cycles_input, 'String'));
options.FLAG_Normalize_Frames = get(handles.normalize_flag_button, 'Value');
% Non-settable from UI.
options.std_multiplier_up_down = 1; % NOTE: Change this value in case the slider in the guided version does not appear.

% ROI (Non-settable from UI).
options.ROI_StdThreshold = 0.4;

% Output.
options.FLAG_save_output = get(handles.save_mat_button, 'Value'); % .mat
options.FLAG_write_stack = get(handles.save_tif_button, 'Value'); % .tif stack
options.FLAG_save_avi = get(handles.save_avi_button, 'Value'); % .avi
options.FLAG_normalize_mat_output = get(handles.normalize_mat_button, 'Value'); 
options.FLAG_normalize_tif_output = get(handles.normalize_tif_button, 'Value'); 
options.FLAG_normalize_avi_output = get(handles.normalize_avi_button, 'Value');
options.avi_background_static_image = get(handles.static_avi_bg_button, 'Value');
% Non-settable from UI.
options.FLAG_user_ask_file_name = 1;
% Not Implemented Yet
options.FLAG_show_EPhys = 0;
options.FLAG_plot_position = 'overlay'; % option for E-Phys position: 'bottom' or 'overlay' or 'overlay minimal'

% Do not change these lines, they are control lines.
% Automatically change options in case mac is detected.
if ismac == 1, options.FLAG_Save_Input_as_tif_stack = 0; end 
% Automatically change options in case the less RAM option is selected.
if options.FLAG_less_RAM == 1, options.FLAG_Save_Input_as_tif_images = 1; end

% Set GUI values from options.
function set_gui_values(handles, options)

% AutoRegression.
set(handles.process_order_input, 'String', num2str(options.opts_ARES_film.process_order));
set(handles.win_size_input, 'String', num2str(options.opts_ARES_film.window_length));
set(handles.win_step_input, 'String', num2str(options.opts_ARES_film.window_advance_step));
switch options.opts_ARES_film.window_type
    case 'rectangular'
        tmp = 1;
    case 'gaussian'
        tmp = 2;
    case 'hanning'
        tmp = 3;
    case 'hamming'
        tmp = 4;
    case 'blackman'
        tmp = 5;
end
set(handles.win_type_input, 'Value', tmp);
set(handles.gauss_std_input, 'String', num2str(options.opts_ARES_film.window_g_std));
switch options.opts_ARES_film.reg_mode
    case 'linear'
        tmp = 1;
    case 'exponential'
        tmp = 2;
end
set(handles.reg_type_input, 'Value', tmp);

set(handles.abs_value_button, 'Value', options.opts_ARES_film.absolute_value);
set(handles.demean_button, 'Value', options.opts_ARES_film.FLAG_demean);
set(handles.neigh_order_input, 'String', num2str(options.opts_ARES_film.opts_neighbourhood_ts.neighbourhood_order));
set(handles.neigh_ignore_outside_button, 'Value', options.opts_ARES_film.opts_neighbourhood_ts.FLAG_ignore_outside_ROI);

% Background.
set(handles.cmp_background_button, 'Value', options.FLAG_compute_ARES_background);
set(handles.bg_pixels_input, 'String', num2str(options.number_of_background_pixels));

% Pre-Processing.

set(handles.frames_selection_flag_button, 'Value', options.FLAG_Interpolate_Remove);
switch options.FLAG_remove_external_frames
    case 'User'
        tmp = 1;
    case 'Auto'
        tmp = 2;
    case 'None'
        tmp = 3;
end
set(handles.remove_ext_input, 'Value', tmp);
switch options.FLAG_Remove_Intertrial % ATTENTION: 'User' option is not implemented yet.
    case 'Auto'
        tmp = 1;
    case 'None'
        tmp = 2;
    case 'User'
        warning('User option is not implemented yet. Intertrial frames removal set to None.')
        tmp = 2;
end
set(handles.remove_inter_input, 'Value', tmp);
set(handles.InterTrialKeep_input, 'String', num2str(options.InterTrialFrames_to_keep));
set(handles.deriv_thr_mod_input, 'String', num2str(options.tag_derivative_threshold_modifier));
set(handles.max_dark_input, 'String', num2str(options.tag_darkness_max_length));
set(handles.interpolation_cycles_input, 'String', num2str(options.number_of_interpolation_cycles));
set(handles.normalize_flag_button, 'Value', options.FLAG_Normalize_Frames);

% Output.
set(handles.save_mat_button, 'Value', options.FLAG_save_output); % .mat
set(handles.save_tif_button, 'Value', options.FLAG_write_stack); % .tif stack
set(handles.save_avi_button, 'Value', options.FLAG_save_avi); % .avi
set(handles.normalize_mat_button, 'Value', options.FLAG_normalize_mat_output);
set(handles.normalize_tif_button, 'Value', options.FLAG_normalize_tif_output);
set(handles.normalize_avi_button, 'Value', options.FLAG_normalize_avi_output);
set(handles.static_avi_bg_button, 'Value', options.avi_background_static_image);


% Set Defaults.
function options = set_default_options()
%% Set Default Output

% General Options.
options.deactivate_warnings = 1;
options.FLAG_less_RAM = 1;
options.FLAG_Save_Input_as_tif_stack = 0;
options.FLAG_Save_Input_as_tif_images = 0;
options.FLAG_user_custom_FileName = 1;

% AutoRegression.
options.opts_ARES_film.process_order = 3;
options.opts_ARES_film.window_length = 25;
options.opts_ARES_film.window_advance_step = 1;
options.opts_ARES_film.window_type = 'rectangular';
options.opts_ARES_film.window_g_std = 6;
options.opts_ARES_film.reg_mode = 'linear';
options.opts_ARES_film.absolute_value = 0;
options.opts_ARES_film.FLAG_demean = 0;
options.opts_ARES_film.residuals_mode = 'avg';
options.opts_ARES_film.opts_neighbourhood_ts.neighbourhood_order = 1;
options.opts_ARES_film.opts_neighbourhood_ts.FLAG_ignore_outside_ROI = 0;
% Background.
options.FLAG_compute_ARES_background = 1;
options.number_of_background_pixels = 500;
% Non-settable from UI.
options.opts_ARES_film.matrix_dimension = 50;
options.opts_ARES_film.FLAG_blank_tag_array = 1;

% Pre-Processing.
options.FLAG_Interpolate_Remove = 1;
options.FLAG_remove_external_frames = 'User';
options.FLAG_Remove_Intertrial = 'Auto'; % ATTENTION: 'User' option is not implemented yet.
options.InterTrialFrames_to_keep = 10;
options.tag_derivative_threshold_modifier = 0.3;
options.tag_darkness_max_length = 4; 
options.number_of_interpolation_cycles = 4;
options.std_multiplier_up_down = 1;
options.FLAG_Normalize_Frames = 0;

% ROI.
options.ROI_StdThreshold = 0.4;

% Output.
options.FLAG_user_ask_file_name = 1;
options.FLAG_save_output = 1;
options.FLAG_write_stack = 1; % .tif stack
options.FLAG_save_avi = 1;
options.FLAG_normalize_tif_output = 1; 
options.FLAG_normalize_avi_output = 1;
options.FLAG_normalize_mat_output = 0; 
options.avi_background_static_image = 1;
% Not Implemented Yet
options.FLAG_show_EPhys = 0;
options.FLAG_plot_position = 'overlay'; % option for E-Phys position: 'bottom' or 'overlay' or 'overlay minimal'

% Do not change these lines, they are control lines.
% Automatically change options in case mac is detected.
if ismac == 1, options.FLAG_Save_Input_as_tif_stack = 0; end 
% Automatically change options in case the less RAM option is selected.
if options.FLAG_less_RAM == 1, options.FLAG_Save_Input_as_tif_images = 1; end
