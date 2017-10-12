function varargout = G_Tune(varargin)

g_S = 1;
graf_St = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  g_S, ...
                   'gui_OpeningFcn', @G_Tune_Create, ...
                   'gui_OutputFcn',  @G_Tune_Out, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    graf_St.gui_Callback = str2func(varargin{1});%
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(graf_St, varargin{:});
else
    gui_mainfcn(graf_St, varargin{:});
end
% ����� �������������
% ����� �������������� ������
function G_Tune_Create(QQ, ~, handles, varargin)
% ��������� ����� �� ���������
handles.output = QQ;
% ���������� ��������� handless
guidata(QQ, handles);
load play_rec_ico;
set(handles.Pl_b,'CData',PlayOff);
set(handles.Record_b,'CData',RecOff);
disp('�������� �����');
% �������� ��������� ������ ������� ���������� �������� � ��������� ������
function varargout = G_Tune_Out(~, ~, handles) 
varargout{1} = handles.output;
% ����������� �� ����� �������� �������, ����� ��������� ���� �������
function freq1_CreateFcn(QQ, ~, ~)

if ispc && isequal(get(QQ,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(QQ,'BackgroundColor','white');
end

function MicFFT(Fs,update_rate,ff, handles)
df=30;
recObj = audiorecorder(Fs, 16, 2);
       recordblocking(recObj, update_rate);
    myRecording = getaudiodata(recObj);
      L = length(myRecording);
    NFFT = 2^nextpow2(L); 
    Y = fft(myRecording,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);
       plot(f,2*abs(Y(1:NFFT/2+1))) 
      
       if ff~=8
       liney=[0 1];
      freq = str2double(get(handles.freq1,'String'));
      axis([freq-df freq+df  0 0.01])
       linex = [freq freq]; 
       line(linex,liney,'Color','m');
       line(linex+2,liney,'Color','green');
       line(linex-2,liney,'Color','green');
       end
       if ff==8
           axis([0 1600  0 0.01,]);
       end;
       set(gca,'YColor','w','YTick',[])
       set(gca,'XColor','w')
    drawnow; 
    
    
% ����������� �� ����� �������� �������, ����� ��������� ���� �������
function popupmenu1_CreateFcn(QQ, ~, ~)

if ispc && isequal(get(QQ,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(QQ,'BackgroundColor','white');
end

% �������� ����, ������� ���������� ���� ����������� ���������
ah= axes('unit', 'normalized', 'position', [0 0 1 1]); 
% �������������� �������� ����������� � ��� ���������� �� ����
bg= imread('background.jpg'); imagesc(bg);
% �������������� ���������� �� ��������� ����

set(ah,'handlevisibility','off','visible','off')
% ��� ������������� ������ ���� ��������
uistack(ah, 'bottom');

% ������ ����
function Pl_b_Callback(QQ, ~, handles)

load play_rec_ico;
Fd	= 44100; 
t	= get(handles.popupmenu8,'Value');
set(QQ,'CData',PlayOn);
freq = str2double(get(handles.freq1,'String'));
t=[0:1/Fd:t];
sig= sin(2*pi*freq*t);
soundsc(sig,Fd);
pause(t);
set(QQ,'CData',PlayOff);

% ������� ��� ��������������� ����� �������� ������� �������
function freq1_Callback(QQ, ~, handles)

% ������ ������
function Record_b_Callback(QQ, eventdata, handles)

load play_rec_ico;
if get(QQ,'UserData')
	 % ���� ������� ��������� ��������, ���������:
	set(QQ,'UserData',0);
	set(QQ,'CData',RecOff)
    else
	%���� ������� ��������� ���������, ��������:
	set(QQ,'UserData',1);
	set(QQ,'CData',RecOn)
    while get(QQ,'UserData')==1
    ff=get(handles.popupmenu1,'Value');    
    MicFFT(16000, 1,ff,handles);
    end
end;

% ����
function popupmenu1_Callback(QQ, ~, handles)
tones = [82.41  110  146.83   196  246.94  329.63 ]; %����� ����
selection = get(QQ,'Value');
if selection<7,
	set(handles.freq1,'String',num2str(tones(selection),'%3.2f')); %����������� ������� � ����
	set(handles.freq1,'Enable','off'); %Dcgksdf.ott vty. ds ���������� ���������� ���� ������� ��� ����� ����� ������
else 
	set(handles.freq1,'Enable','on'); % ��������� ���������� ���� ������� ��� ����� ����� ������
end;

% ��������
function slide_Callback(hObject, ~, handles)
% hObject    handle to slide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
filename='1.wav'; %������ ����� 1
[x,fs, bits]=wavread(filename); 

filename2='2.wav'; %������ ����� 2
[y,fs, bits]=wavread(filename2); 

while get(hObject,'Value')~=0 

k=get(hObject,'Value'); % ������ ������ ��������
set(handles.bps,'String',round(get(hObject,'Value'))); % ����� BPS � ����
wavplay(y, fs); %��������������� ������� ����
pause(60/k-0.07); % ����������� BPS
%�����������
if get(hObject,'Value')==0 
break;
end;
for i=1:1:get(handles.popup,'Value')
wavplay(x, fs); %��������������� ������ ����
pause(60/k-0.07);
%�����������
if get(hObject,'Value')==0
break;
end
 end;
  % ����� BPS � ����
set(handles.bps,'String',get(hObject,'Value'));
end;

% ������� �������� ����
function off_button_Callback(~, ~, handles)
clc; % ������� ���������� ����
set(handles.slide,'Value',0); % ����� �������� �� 0
close(G_Tune);
function slide_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function bps_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popup_Callback(~, ~, ~)
function popup_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu8_Callback(hObject, eventdata, handles)


function popupmenu8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
