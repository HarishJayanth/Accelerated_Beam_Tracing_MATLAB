function varargout = ABT_GUI(varargin)
% ABT_GUI MATLAB code for ABT_GUI.fig
%      ABT_GUI, by itself, creates a new ABT_GUI or raises the existing
%      singleton*.
%
%      H = ABT_GUI returns the handle to a new ABT_GUI or the handle to
%      the existing singleton*.
%
%      ABT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ABT_GUI.M with the given input arguments.
%
%      ABT_GUI('Property','Value',...) creates a new ABT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ABT_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ABT_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ABT_GUI

% Last Modified by GUIDE v2.5 23-Nov-2018 13:07:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ABT_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ABT_GUI_OutputFcn, ...
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

addpath('Classes/');
addpath('Functions/');
% End initialization code - DO NOT EDIT


% --- Executes just before ABT_GUI is made visible.
function ABT_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ABT_GUI (see VARARGIN)

% Choose default command line output for ABT_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ABT_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ABT_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function srcY_val_Callback(hObject, eventdata, handles)
% hObject    handle to srcY_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of srcY_val as text
%        str2double(get(hObject,'String')) returns contents of srcY_val as a double
getSourcePosition(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function srcY_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to srcY_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function srcZ_val_Callback(hObject, eventdata, handles)
% hObject    handle to srcZ_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of srcZ_val as text
%        str2double(get(hObject,'String')) returns contents of srcZ_val as a double
getSourcePosition(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function srcZ_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to srcZ_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function srcX_val_Callback(hObject, eventdata, handles)
% hObject    handle to srcX_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of srcX_val as text
%        str2double(get(hObject,'String')) returns contents of srcX_val as a double
getSourcePosition(hObject, eventdata, handles);

function getSourcePosition(hObject, eventdata, handles)
% This function gets the source position from the textboxes in GUI and saves it
% in the 'base' workspace
if ~evalin('base', 'exist(''src'')')
    evalin('base', 'src = Source();');
end

src = evalin('base', 'src');
x = str2double(get(handles.srcX_val, 'String'));
y = str2double(get(handles.srcY_val, 'String'));
z = str2double(get(handles.srcZ_val, 'String'));
src.setPosition([x y z]);

newString = sprintf("Source Position Updated: %.2f, %.2f, %.2f", x, y, z);
updateStatus(handles.status_text, newString);
renderSrcAndLst(handles.room_axes);
assignin('base', 'src', src);


% --- Executes during object creation, after setting all properties.
function srcX_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to srcX_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lstY_val_Callback(hObject, eventdata, handles)
% hObject    handle to lstY_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lstY_val as text
%        str2double(get(hObject,'String')) returns contents of lstY_val as a double
getListenerPosition(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function lstY_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstY_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lstZ_val_Callback(hObject, eventdata, handles)
% hObject    handle to lstZ_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lstZ_val as text
%        str2double(get(hObject,'String')) returns contents of lstZ_val as a double
getListenerPosition(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function lstZ_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstZ_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lstX_val_Callback(hObject, eventdata, handles)
% hObject    handle to lstX_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lstX_val as text
%        str2double(get(hObject,'String')) returns contents of lstX_val as a double
getListenerPosition(hObject, eventdata, handles);

function getListenerPosition(hObject, eventdata, handles)
% This function gets the listener position from the textboxes in GUI and saves it
% in the 'base' workspace
if ~evalin('base', 'exist(''lst'')')
    evalin('base', 'lst = Listener();');
end

lst = evalin('base', 'lst');
x = str2double(get(handles.lstX_val, 'String'));
y = str2double(get(handles.lstY_val, 'String'));
z = str2double(get(handles.lstZ_val, 'String'));
lst.setPosition([x y z]);

newString = sprintf("Listener Position Updated: %.2f, %.2f, %.2f", x, y, z);
updateStatus(handles.status_text, newString);
renderSrcAndLst(handles.room_axes);
assignin('base', 'lst', lst);

% --- Executes during object creation, after setting all properties.
function lstX_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstX_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function reflOrd_val_Callback(hObject, eventdata, handles)
% hObject    handle to reflOrd_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reflOrd_val as text
%        str2double(get(hObject,'String')) returns contents of reflOrd_val as a double

order = str2double(get(handles.reflOrd_val, 'String'));
assignin('base', 'order', order);
newString = sprintf("Order updated: %d", order);
updateStatus(handles.status_text, newString);


% --- Executes during object creation, after setting all properties.
function reflOrd_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reflOrd_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in roomFile_button.
function roomFile_button_Callback(hObject, eventdata, handles)
% hObject    handle to roomFile_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[roomFilename, roomFile_path] = uigetfile('../data/.room','Import Room File');
roomFile_path = [roomFile_path roomFilename];
assignin('base', 'roomFile_path', roomFile_path);

if evalin('base', 'exist(''matFile'')') ~= 1
    matFile_button_Callback(hObject, eventdata, handles);
end
matFile = evalin('base', 'matFile');

rm = Room();
rm.import(roomFile_path, matFile);
assignin('base', 'rm', rm);

evalin('base', 'clear pathSol');    % clear pathSol from base workspace

newString = sprintf("%s Imported", roomFilename);
updateStatus(handles.status_text, newString);

axes(handles.room_axes);
cla reset;
axes(handles.ir_axes);
cla reset;
renderRoom(roomFile_path, handles.room_axes);


% --- Executes on button press in matFile_button.
function matFile_button_Callback(hObject, eventdata, handles)
% hObject    handle to matFile_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[matFilename, matFilePath] = uigetfile('../data/.dat', 'Import Material File');
matFile = MaterialFile();
matFile.readFile([matFilePath matFilename]);
assignin('base', 'matFile', matFile);
updateStatus(handles.status_text, string([matFilename ' imported']));



% --- Executes on button press in pathSol_button.
function pathSol_button_Callback(hObject, eventdata, handles)
% hObject    handle to pathSol_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs = 48000;
assignin('base', 'fs', fs);
if evalin('base', 'exist(''src'')') ~= 1
    srcX_val_Callback(hObject, eventdata, handles);
end
if evalin('base', 'exist(''lst'')') ~= 1
    lstX_val_Callback(hObject, eventdata, handles);
end
if evalin('base', 'exist(''pathSol'')') ~= 1
    if evalin('base', 'exist(''rm'')') ~= 1
        newString = "Import a room file first";
        updateStatus(handles.status_text, newString);
    else
        rm = evalin('base', 'rm');
        src = evalin('base', 'src');
        lst = evalin('base', 'lst');
        order = str2double(get(handles.reflOrd_val, 'String'));

        pathSol = PathSolution(rm, src, lst, order);
        assignin('base', 'pathSol', pathSol);

        updateStatus(handles.status_text, "Computing beam tree...");
        pathSol.solve();

        updateStatus(handles.status_text, "Verifying paths to listener...");
        pathSol.update();

        newString = sprintf("Number of valid paths: %d",pathSol.numPaths);
        updateStatus(handles.status_text, newString);

        updateStatus(handles.status_text, "Computing impulse response...")
        ir = computeIR(pathSol, fs);
        updateStatus(handles.status_text, "Impulse response computed");

        axes(handles.ir_axes);
        cla reset;
        t = [0:length(ir)-1]/fs;
        plot(t, ir);
        xlabel('Time(s)');
        ylabel('Magnitude');

        renderPaths(pathSol, handles.room_axes);

        prevSrcPos = src.getPosition();
        assignin('base', 'prevSrcPos', prevSrcPos);
        assignin('base', 'prevOrder', order);
        assignin('base', 'ir', ir);

        irFilt = dsp.FrequencyDomainFIRFilter(ir');
        assignin('base', 'irFilt', irFilt);
    end
else
    prevSrcPos = evalin('base', 'prevSrcPos');
    prevOrder = evalin('base', 'prevOrder');
    rm = evalin('base', 'rm');
    src = evalin('base', 'src');
    lst = evalin('base', 'lst');
    order = str2double(get(handles.reflOrd_val, 'String'));
    pathSol = evalin('base', 'pathSol');
    changed = sum(prevSrcPos == src.getPosition())==3;  % check if source has moved
    changed = changed || (order ~= prevOrder);           % and check if order has changed

    if changed
        if order ~= prevOrder
            clear pathSol
            evalin('base', 'clear pathSol');
            pathSol = PathSolution(rm, src, lst, order);
            assignin('base', 'pathSol', pathSol);
        end
        pathSol.solve();
        newString = "Computing beam tree...";
        updateStatus(handles.status_text, newString);
    end

    pathSol.update();
    newString = "Verifying paths to listener...";
    updateStatus(handles.status_text, newString);

    newString = sprintf("Number of valid paths: %d",pathSol.numPaths);
    updateStatus(handles.status_text, newString);

    ir = computeIR(pathSol, fs);
    updateStatus(handles.status_text, "IR computed");

    axes(handles.ir_axes);
    cla reset;
    t = [0:length(ir)-1]/fs;
    plot(t, ir);
    xlabel('Time(s)');
    ylabel('Magnitude');

    renderPaths(pathSol, handles.room_axes);

    prevSrcPos = src.getPosition();
    assignin('base', 'prevSrcPos', prevSrcPos);
    assignin('base', 'prevOrder', order);
    assignin('base', 'ir', ir);

    irFilt = dsp.FrequencyDomainFIRFilter(ir');
    assignin('base', 'irFilt', irFilt);
end


% --- Executes on button press in soundFile_button.
function soundFile_button_Callback(hObject, eventdata, handles)
% hObject    handle to soundFile_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[soundFilename soundFilePath] = uigetfile('.wav', 'Open a Sound File');
[sampSound, fs_samp] = audioread([soundFilePath soundFilename]);
assignin('base', 'sampSound', sampSound);
assignin('base', 'fs_samp', fs_samp);

updateStatus(handles.status_text, string([soundFilename ' opened']));


% --- Executes on button press in playSound_button.
function playSound_button_Callback(hObject, eventdata, handles)
% hObject    handle to playSound_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if evalin('base', 'exist(''sampSound'')') ~= 1
    updateStatus(handles.status_text, "No sound to play");
else
    clear sound;
    sampSound = evalin('base', 'sampSound');
    fs_samp = evalin('base', 'fs_samp');
    sound(sampSound, fs_samp);
end


% --- Executes on button press in playIR_button.
function playIR_button_Callback(hObject, eventdata, handles)
% hObject    handle to playIR_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if evalin('base', 'exist(''ir'')') ~= 1
    updateStatus(handles.status_text, "No IR to play");
else
    clear sound;
    evalin('base', 'sound(ir, fs)');
end



% --- Executes on button press in stopSounds_button.
function stopSounds_button_Callback(hObject, eventdata, handles)
% hObject    handle to stopSounds_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound


% --- Executes on button press in saveIR_button.
function saveIR_button_Callback(hObject, eventdata, handles)
% hObject    handle to saveIR_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if evalin('base', 'exist(''ir'')') ~= 1
    updateStatus(handles.status_text, "No IR to save");
else
    [irFilename, irFilePath] = uiputfile('.wav', 'Save Impulse Response');
    ir = evalin('base', 'ir');
    fs = evalin('base', 'fs');
    audiowrite([irFilePath irFilename], ir, fs);
    updateStatus(handles.status_text, "IR saved");
end


% --- Executes on button press in playSIR_button.
function playSIR_button_Callback(hObject, eventdata, handles)
% hObject    handle to playSIR_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if evalin('base', 'exist(''ir'')') ~= 1
    updateStatus(handles.status_text, "Compute IR first");
else
    if evalin('base', 'exist(''sampSound'')') ~= 1
        updateStatus(handles.status_text, "Open a sound file");
        soundFile_button_Callback(hObject, eventdata, handles);
    end
    clear sound;
    irFilt = evalin('base', 'irFilt');
    sampSound = evalin('base', 'sampSound');
    fs_samp = evalin('base', 'fs_samp');
    filtOut = irFilt(sampSound);
    sound(filtOut/max(abs(filtOut)), fs_samp);
end


function newString = updateString(prevString, catString)
if size(prevString,1) > 7
    prevString = prevString(end-6:end,:);
end
stopInd = strfind(prevString(1,:), '  ');
if isempty(stopInd)
    stopInd = length(prevString(1,:));
end
newString = prevString(1,1:stopInd);
for i = 2:size(prevString,1)
    stopInd = strfind(prevString(i,:), '  ');
    if isempty(stopInd)
        stopInd = length(prevString(i,:));
    end
    newString = sprintf("%s\n%s", newString, prevString(i,1:stopInd));
end
newString = sprintf("%s\n%s", newString, catString);

function updateStatus(statusHandle, newString)
prevString = get(statusHandle, 'String');
newString = updateString(char(prevString), newString);
set(statusHandle, 'String', newString);
