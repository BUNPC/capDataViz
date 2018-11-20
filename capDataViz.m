function varargout = capDataViz(varargin)
% CAPDATAVIZ MATLAB code for capDataViz.fig
%      CAPDATAVIZ, by itself, creates a new CAPDATAVIZ or raises the existing
%      singleton*.
%
%      H = CAPDATAVIZ returns the handle to a new CAPDATAVIZ or the handle to
%      the existing singleton*.
%
%      CAPDATAVIZ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAPDATAVIZ.M with the given input arguments.
%
%      CAPDATAVIZ('Property','Value',...) creates a new CAPDATAVIZ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before capDataViz_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to capDataViz_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help capDataViz

% Last Modified by GUIDE v2.5 20-Nov-2018 09:50:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @capDataViz_OpeningFcn, ...
                   'gui_OutputFcn',  @capDataViz_OutputFcn, ...
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


% --- Executes just before capDataViz is made visible.
function capDataViz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to capDataViz (see VARARGIN)

% Choose default command line output for capDataViz
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes capDataViz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = capDataViz_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function File_loadData_Callback(hObject, eventdata, handles)
% hObject    handle to File_loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Data_longStall

% [filename,pathname] = uigetfile({'*.mat;*.tiff;*.tif'},'Please select OCT angiogram');
% [pathstr,name,ext] = fileparts(filename);
% if strcmp(ext,'.mat')
%     temp = load([pathname filename]);
%     fn = fieldnames(temp);
%     OCT = temp.(fn{1});
% elseif strcmp(ext,'.tiff') || strcmp(ext,'.tif')
%     info = imfinfo([pathname filename]);
%     for u = 1:length(info)
%         if u == 1
%             temp = imread([pathname filename],1);
%             angio = zeros([length(info) size(temp)]);
%             angio(u,:,:) = temp;
%         else
%             angio(u,:,:) = imread([pathname filename],u);
%         end
%     end
%     OCT = angio; 
%     maxValue = max(OCT(:));
%     minValue = min(OCT(:));
% %     set(handles.edit_OCTmin,'String',num2str(minValue));
% %     set(handles.edit_OCTmax,'String',num2str(maxValue));
% end
% 
% Data_longStall.OCT = OCT;

[filename,pathname] = uigetfile({'*.mat;*.tiff;*.tif'},'Please select transformed TPM angiogram');
[pathstr,name,ext] = fileparts(filename);
if strcmp(ext,'.mat')
    temp = load([pathname filename]);
    fn = fieldnames(temp);
    TPM = temp.(fn{1});
elseif strcmp(ext,'.tiff') || strcmp(ext,'.tif')
    info = imfinfo([pathname filename]);
    for u = 1:length(info)
        if u == 1
            temp = imread([pathname filename],1);
            angio = zeros([length(info) size(temp)]);
            angio(u,:,:) = temp;
        else
            angio(u,:,:) = imread([pathname filename],u);
        end
    end
    TPM = angio; 
    maxValue = max(TPM(:));
    minValue = min(TPM(:));
    set(handles.edit_min,'String',num2str(minValue));
    set(handles.edit_max,'String',num2str(maxValue));
end

Data_longStall.TPM = TPM;

% [Oz,Ox,Oy] = size(Data_longStall.OCT);
[nz,nx,ny] = size(Data_longStall.TPM);

set(handles.text_TPMx,'String',['x -> x(1' '-' num2str(nx) ')']);
set(handles.text_TPMy,'String',['y -> y(1' '-' num2str(ny) ')']);
set(handles.text_TPMz,'String',['z -> z(1' '-' num2str(nz) ')']);

set(handles.edit_TPMMIPx,'string',num2str(nx));
set(handles.edit_TPMMIPy,'string',num2str(ny));

set(handles.slider_TPM,'max',nz);
set(handles.slider_TPM,'min',1);
set(handles.slider_TPM,'Value',nz);
set(handles.slider_TPM,'SliderStep',[1/(nz-1), 10/(nz-1)]);
% set(handles.text_TPMx,'String',['x -> x(1' '-' num2str(Ox) ')']);
% set(handles.text_TPMy,'String',['y -> y(1' '-' num2str(Oy) ')']);
% set(handles.text_TPMz,'String',['z -> z(1' '-' num2str(Oz) ')']);

draw(hObject, eventdata, handles);

function draw(hObject, eventdata, handles)

global Data_longStall

% [Oz,Ox,Oy] = size(Data_longStall.OCT);
[nz,nx,ny] = size(Data_longStall.TPM);

TPMxs = round(str2double(get(handles.edit_TPMxs,'string')));
TPMxs = min(max(TPMxs,1),nx);
TPMMIPx = round(str2double(get(handles.edit_TPMMIPx,'string')));
TPMxe = TPMxs+TPMMIPx-1;
TPMxe = min(max(TPMxe,TPMxs),nx);

TPMys = round(str2double(get(handles.edit_TPMys,'string')));
TPMys = min(max(TPMxs,1),ny);
TPMMIPy = round(str2double(get(handles.edit_TPMMIPy,'string')));
TPMye = TPMxs+TPMMIPy-1;
TPMye = min(max(TPMye,TPMys),ny);

TPMzs = round(str2double(get(handles.edit_TPMzs,'string')));
TPMzs = min(max(TPMzs,1),nz);
TPMMIPz = round(str2double(get(handles.edit_TPMMIPz,'string')));
TPMze = TPMzs+TPMMIPz-1;
TPMze = min(max(TPMze,TPMzs),nz);

minTPM = str2double(get(handles.edit_min,'String'));
maxTPM = minTPM+str2double(get(handles.edit_max,'String'));

Zmin = str2double(get(handles.edit_TPMzs,'String'));
Zmax = Zmin+str2double(get(handles.edit_TPMMIPz,'String'));

img = squeeze(max(Data_longStall.TPM(TPMzs:TPMze,TPMxs:TPMxe,TPMys:TPMye),[],1));
axes(handles.axes1)
colormap('gray');
if get(handles.radiobutton_logscaleTPM,'Value')
    imagesc(log(img),[log(minTPM) log(maxTPM)]);
else
    imagesc(img,[minTPM maxTPM]);
end
axis image;

hold on
% if 1
if isfield(Data_longStall,'stallogram') & get(handles.radiobutton_stalls,'Value')
%     jj = str2double(get(handles.edit_segno,'string'));
    c = ['r','c','y','k'];
    for kk = 1:length(Data_longStall.stallogram)
        for jj = 1:length(Data_longStall.stallogram(kk).seg)
            minidx = min(Data_longStall.stallogram(kk).seg(jj).pos(:,1));
            maxidx = max(Data_longStall.stallogram(kk).seg(jj).pos(:,1));
            if (minidx >= Zmin && minidx <= Zmax) || (maxidx >= Zmin && maxidx <= Zmax)
    %             plot(Data_longStall.stallogram.seg(jj).pos(:,3),Data_longStall.stallogram.seg(jj).pos(:,2),'r.','markersize',16);
                s = scatter(Data_longStall.stallogram(kk).seg(jj).pos(:,3),Data_longStall.stallogram(kk).seg(jj).pos(:,2),c(kk),'filled','SizeData',10);
                alpha(s,.1)
            end
        end
    end
end
% end
hold off


function edit_TPMxs_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TPMxs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TPMxs as text
%        str2double(get(hObject,'String')) returns contents of edit_TPMxs as a double
draw(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_TPMxs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TPMxs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TPMMIPx_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TPMMIPx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TPMMIPx as text
%        str2double(get(hObject,'String')) returns contents of edit_TPMMIPx as a double
draw(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_TPMMIPx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TPMMIPx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TPMys_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TPMys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TPMys as text
%        str2double(get(hObject,'String')) returns contents of edit_TPMys as a double
draw(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_TPMys_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TPMys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TPMMIPy_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TPMMIPy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TPMMIPy as text
%        str2double(get(hObject,'String')) returns contents of edit_TPMMIPy as a double
draw(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_TPMMIPy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TPMMIPy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_TPMzs_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TPMzs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TPMzs as text
%        str2double(get(hObject,'String')) returns contents of edit_TPMzs as a double

global Data_longStall

Tz = size(Data_longStall.TPM,1);
ii = round(str2double(get(handles.edit_TPMzs,'String')));
jj = Tz-ii+1;
jj = min(max(jj,1),Tz);
set(handles.slider_TPM,'Value',jj);

draw(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function edit_TPMzs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TPMzs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TPMMIPz_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TPMMIPz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TPMMIPz as text
%        str2double(get(hObject,'String')) returns contents of edit_TPMMIPz as a double
draw(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function edit_TPMMIPz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TPMMIPz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function File_loadstallogram_Callback(hObject, eventdata, handles)
% hObject    handle to File_loadstallogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Data_longStal

[filename,pathname] = uigetfile('*.mat','Please select transformed stall-O-gram');
[pathstr,name,ext] = fileparts(filename);
% temp = load([pathname filename]);
% fn = fieldnames(temp);
if isfield(Data_longStall,'stallogram')
    s = length(Data_longStall.stallogram);
    load([pathname filename]);
    Data_longStall.stallogram(s+1).seg = seg;
else
    load([pathname filename]);
    Data_longStall.stallogram.seg = seg;
end
draw(hObject, eventdata, handles);


function edit_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_min as text
%        str2double(get(hObject,'String')) returns contents of edit_min as a double
draw(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_max as text
%        str2double(get(hObject,'String')) returns contents of edit_max as a double

draw(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function edit_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in radiobutton_logscaleTPM.
function radiobutton_logscaleTPM_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_logscaleTPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_logscaleTPM
draw(hObject, eventdata, handles);

% --- Executes on slider movement.
function slider_TPM_Callback(hObject, eventdata, handles)
% hObject    handle to slider_TPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Data_longStall

Tz = size(Data_longStall.TPM,1);
jj = round(get(handles.slider_TPM,'Value'));
jj = min(max(jj,1),Tz);
ii = Tz-jj+1;
set(handles.edit_TPMzs,'String',num2str(ii));
draw(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider_TPM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_TPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton_stalls.
function radiobutton_stalls_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_stalls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_stalls

draw(hObject, eventdata, handles);
