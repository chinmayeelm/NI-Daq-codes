%------------------stimulus-GUI-Chinmayee----------------------

function varargout = stim_rec_m2014(varargin)
% STIM_REC_M2014 MATLAB code for stim_rec_m2014.fig
%      STIM_REC_M2014, by itself, creates a new STIM_REC_M2014 or raises the existing
%      singleton*.
%
%      H = STIM_REC_M2014 returns the handle to a new STIM_REC_M2014 or the handle to
%      the existing singleton*.
%
%      STIM_REC_M2014('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STIM_REC_M2014.M with the given input arguments.
%
%      STIM_REC_M2014('Property','Value',...) creates a new STIM_REC_M2014 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stim_rec_m2014_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stim_rec_m2014_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stim_rec_m2014

% Last Modified by GUIDE v2.5 12-Sep-2018 11:02:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stim_rec_m2014_OpeningFcn, ...
                   'gui_OutputFcn',  @stim_rec_m2014_OutputFcn, ...
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


% --- Executes just before stim_rec_m2014 is made visible.
function stim_rec_m2014_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stim_rec_m2014 (see VARARGIN)

% Choose default command line output for stim_rec_m2014
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stim_rec_m2014 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stim_rec_m2014_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_pushbutton.
function start_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to start_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

amp = str2double(get(handles.amplitude_input, 'string'))
freq = str2double(get(handles.frequency_input, 'string'))
dur = str2double(get(handles.duration_input, 'string'))

fs = 10000;

[A,B] = loren_wav (freq,fs,dur,amp);
%plot(B);

%devices = daq.getDevices;
s = daq.createSession('ni');
s.Rate = fs;
addAnalogOutputChannel(s,'Dev2', 'ao3' ,'Voltage'); %check device ID
addAnalogInputChannel(s,'Dev2', 'ai7', 'Voltage');
queueOutputData(s,B');
fid1 = fopen('log.bin','w'); 
lh = addlistener(s,'DataAvailable',@(src, event)logData(src, event, fid1));
% figure;
% lh = addlistener(s,'DataAvailable', @(src,event) plot(event.TimeStamps, event.Data));
s.IsContinuous = true;
s.startBackground;
pause(10);
s.stop;
delete(lh);
fclose(fid1);

% [captured_data,time] = s.startForeground();
% 
% lh2 = addlistener(s,'DataAvailable', @plotData); 
% s.IsContinuous = true;
% figure;
% plot(time,captured_data);
% ylabel('Voltage');
% xlabel('Time');
% title('Acquired Signal');

% print(fid1, captured_data);
% close(fid1);
%s.stop();
%pause();

function plotData(src,event)
    figure;
    plot(event.TimeStamps, event.Data);

function [X,Y] = loren_wav (freq, fs, dur, amplitude)
  T = 1000/freq;
  x = linspace(-T/2, T/2, fs);
  X = repmat(x, 1, freq);
  if dur>1
    X = repmat(X, 1, dur);
  end
    
  Y = 2 - amplitude./(X.^2+1);
  
  return;
  



% --- Executes on button press in stop_pushbutton.
function stop_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stop_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% s.stop;
% delete(lh);
% fclose(fid1);


% --- Executes on selection change in wave_popupmenu.
function wave_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to wave_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wave_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wave_popupmenu


% --- Executes during object creation, after setting all properties.
function wave_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wave_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duration_input_Callback(hObject, eventdata, handles)
% hObject    handle to duration_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration_input as text
%        str2double(get(hObject,'String')) returns contents of duration_input as a double


% --- Executes during object creation, after setting all properties.
function duration_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frequency_input_Callback(hObject, eventdata, handles)
% hObject    handle to frequency_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frequency_input as text
%        str2double(get(hObject,'String')) returns contents of frequency_input as a double


% --- Executes during object creation, after setting all properties.
function frequency_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function amplitude_input_Callback(hObject, eventdata, handles)
% hObject    handle to amplitude_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amplitude_input as text
%        str2double(get(hObject,'String')) returns contents of amplitude_input as a double


% --- Executes during object creation, after setting all properties.
function amplitude_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitude_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
