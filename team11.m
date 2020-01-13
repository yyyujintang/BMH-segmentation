function varargout = team11(varargin)
% TEAM11 MATLAB code for team11.fig
%      TEAM11, by itself, creates a new TEAM11 or raises the existing
%      singleton*.
%
%      H = TEAM11 returns the handle to a new TEAM11 or the handle to
%      the existing singleton*.
%
%      TEAM11('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEAM11.M with the given input arguments.
%
%      TEAM11('Property','Value',...) creates a new TEAM11 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before team11_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to team11_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help team11

% Last Modified by GUIDE v2.5 12-Jan-2020 16:28:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @team11_OpeningFcn, ...
                   'gui_OutputFcn',  @team11_OutputFcn, ...
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


% --- Executes just before team11 is made visible.
function team11_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to team11 (see VARARGIN)

% Choose default command line output for team11
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes team11 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = team11_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in NO59.
function NO59_Callback(hObject, eventdata, handles)
% hObject    handle to NO59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('C:\wyw\DIP\WMH')
% load编号59
data1 = load_untouch_nii('T159.nii.gz');
data2 = load_untouch_nii('FLAIR59.nii.gz');
data3 = load_untouch_nii('wmh59.nii.gz');
global image1 image2 image3 vs2
image1 = data1.img;% 232*256*48 unit16
image2 = data2.img;% single
image3 = data3.img;% single
vs2=get(handles.slider2,'value');%通过slider元件选择一幅slide显示（处理是针对全图处理
vs2=round(vs2*48+1);
set(handles.edit6,'string',vs2);
axes(handles.axes1)
imshow(image3(:,:,vs2),[]);
axes(handles.axes2)
imshow(image2(:,:,vs2),[]);

% --- Executes on button press in Pretreatment.
function Pretreatment_Callback(hObject, eventdata, handles)
% hObject    handle to Pretreatment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image1 image2 image3 resultsemi fc2 vs2
set(handles.edit7,'string',3);
set(handles.edit8,'string',100);
image11=mat2gray(image1);
image22=mat2gray(image2);
image4=mat2gray(image3);%all double
image4=(image4<1);
image3=image3.*image4;%去除掉image3中非WMH的信号，便于作比较
window0=zeros(232,256);%double
%选择有效的slice（20-40）
for i=1:48
    if i<20     
        image22(:,:,i)=image22(:,:,i).*window0;
        image11(:,:,i)=image11(:,:,i).*window0;
    end
    if i>40
       image22(:,:,i)=image22(:,:,i).*window0; 
       image11(:,:,i)=image11(:,:,i).*window0;
   end
end
level1 =graythresh(image11); 
level2 =graythresh(image22);
BW1=image11;
BW2=image22;
for i=1:48
BW1(:,:,i)=im2bw(image11(:,:,i),level1);
end
for i=1:48
BW2(:,:,i)=im2bw(image22(:,:,i),level2);
end
%形态学去头骨
se1=strel('disk',19);%需要足够大，将脑组织内部的空洞都给填充上
se2=strel('disk',24);%由于脑组织的外边缘不包含白质高信号，可以适当的多腐蚀掉一点
f1=imopen(~BW1,se1);%闭运算填充空洞，提取出外边缘
f2=imerode(~f1,se2);%腐蚀掉闭运算带来的边缘膨胀
f3=f2.*BW2;%去除头骨
fc1=f3.*image22;%去除头骨的结果
se3=strel('square',3);
se4=strel('square',5);
f4=imopen(~f3,se3);%闭运算填充空洞，保护离散的白质高信号，但是保证 中间的脊部分保留
f5=imerode(~f4,se4);%腐蚀脊
f6=imdilate(f5,se3);%膨胀回一部分
fc2=f6.*fc1;
vs2=get(handles.slider2,'value');
vs2=round(vs2*48+1);
set(handles.edit6,'string',vs2);
axes(handles.axes1)
imshow(image3(:,:,vs2),[]);
axes(handles.axes2)
imshow(image2(:,:,vs2),[]);
resultsemi=fc2;

% --- Executes on button press in NO60.
function NO60_Callback(hObject, eventdata, handles)
% hObject    handle to NO60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('C:\wyw\DIP\WMH')
%编号60
data1 = load_untouch_nii('T160.nii.gz');
data2 = load_untouch_nii('FLAIR60.nii.gz');
data3 = load_untouch_nii('wmh60.nii.gz');
global image1 image2 image3 vs2
image1 = data1.img;% 232*256*48 unit16
image2 = data2.img;% single
image3 = data3.img;% single
vs2=get(handles.slider2,'value');%通过slider元件选择一幅slide显示（处理是针对全图处理
vs2=round(vs2*48+1);
set(handles.edit6,'string',vs2);
axes(handles.axes1)
imshow(image3(:,:,vs2),[]);
axes(handles.axes2)
imshow(image2(:,:,vs2),[]);


% --- Executes on button press in NO61.
function NO61_Callback(hObject, eventdata, handles)
% hObject    handle to NO61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('C:\wyw\DIP\WMH')
%编号61
data1 = load_untouch_nii('T161.nii.gz');
data2 = load_untouch_nii('FLAIR61.nii.gz');
data3 = load_untouch_nii('wmh61.nii.gz');
global image1 image2 image3 vs2
image1 = data1.img;% 232*256*48 unit16
image2 = data2.img;% single
image3 = data3.img;% single
vs2=get(handles.slider2,'value');%通过slider元件选择一幅slide显示（处理是针对全图处理
vs2=round(vs2*48+1);
set(handles.edit6,'string',vs2);
axes(handles.axes1)
imshow(image3(:,:,vs2),[]);
axes(handles.axes2)
imshow(image2(:,:,vs2),[]);

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Method1.
function Method1_Callback(hObject, eventdata, handles)
% hObject    handle to Method1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%大津阈值法找阈值
global fc2 result vs2 image3
k=get(handles.edit7,'string');
k=str2num(k);
vs2=get(handles.slider2,'value');
vs2=round(vs2*48+1);
set(handles.edit6,'string',vs2);
axes(handles.axes2)
imshow(fc2(:,:,vs2),[]);
axes(handles.axes1)
imshow(image3(:,:,vs2),[]);
result=fc2;
for w=1:k %循环次数
  I=im2uint8(result);%3维
  II=(I>0);
  [M,N,O]=size(I);%用于遍历
  realsize=sum(sum(sum(II)));%用于求均值
%预定义划分的两组，分别为C1、C2。预定义level，用于存放不同划分时的类间方差
min_value =min(min(min(I)));
max_value =max(max(max(I)));%定义C1、C2、level的下标，同时起统计个数的作用
level =zeros(1,max_value);%求出原图像灰度最大、最小值
columns1 = 1;columns2 = 1;columns3 = 1;%开始遍历
for k = (min_value+1):(max_value-1)
C1 = zeros(1,max_value);
C2 = zeros(1,max_value);
for o = 1:O
for i = 1:M
for j = 1:N 
 if I(i,j,o)>0 && I(i,j,o)<=k
     C1(I(i,j,o))=C1(I(i,j,o))+1 ;%得分组C1
     columns1= columns1 + 1;
 end
 if I(i,j,o)>0 && I(i,j,o)>k
   C2(I(i,j,o))= C2(I(i,j,o))+1; %得到分组C2
   columns2 = columns2 + 1;
 end
 end
end
end%得到C1、C2的概率
 posibility1 = (columns1-1) / realsize;
 posibility2 = 1 - posibility1;
%得到C1、C2的均值
%由于预定义个数大于实际个数，因而求均值时不记录多余的零
C111 = zeros(1,max_value);
C222 = zeros(1,max_value);
for i=(min_value+1):k
  C111(1,i)=double(i)*C1(i)/realsize;
end
C11=sum(C111);
ave1=C11/posibility1;
for n=(k+1):(max_value-1)
  C222(1,n)=double(n)*C2(n)/realsize;
end
C22=sum(C222);
ave2=C22/posibility2;
 %得到类间方差，存放在level中
 std = posibility1*posibility2*(ave1 -ave2)^2;
 level(columns3) = std;
columns3 = columns3 + 1;
columns1 = 1;
columns2 = 1;
C1 = zeros(1,max_value);
C2 = zeros(1,max_value);
end
%找到当前最大阈值
[a,maxx] =max(level);
levelopti= min_value+maxx-1;
levell = double(levelopti)/255
for o=1:48
for i=1:232
    for j=1:256
        if (result(i,j,o)<levell)
            result(i,j,o)=0;        
        end
    end
end
end
% se1=strel('square',2);
% result=imopen(result,se1);
end
% dicom_write_volume(result,'segment_result');
result=result>0;
axes(handles.axes2)
imshow(result(:,:,vs2),[]);

% --- Executes on button press in Method2.
function Method2_Callback(hObject, eventdata, handles)
% hObject    handle to Method2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 读取操作
global image2 image3 result vs2
ans1=image3;
img=image2;
ans1_24=ans1(:,:,24)==1;
ans11=ans1==1;
image_1_24=img(:,:,24);
imshow (image_1_24,[]);
imshow (ans1_24,[]);

%去除周围偏小的值太多的点
lows=img<100;
fltrlow=ones(10,10,10);
convlow=convn(lows,fltrlow,'same');
reasonablethings=convlow<=400;
% imshow3D(reasonablethings,[]);

%三维假的增强子
fltr3d2=zeros(5,5,5);

fltr3d2(:,:,1)=[-1 -1 -1 -1 -1; -1 -1 -1 -1 -1; -1 -1 -1 -1 -1;-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;];
fltr3d2(:,:,2)=[-1 -1 -1 -1 -1; -1 -1 -1 -1 -1; -1 -1 -1 -1 -1;-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;];
fltr3d2(:,:,3)=[-1 -1 -1 -1 -1; -1 -1 -1 -1 -1; -1 -1 1500 -1 -1;-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;];
fltr3d2(:,:,4)=[-1 -1 -1 -1 -1; -1 -1 -1 -1 -1; -1 -1 -1 -1 -1;-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;];
fltr3d2(:,:,5)=[-1 -1 -1 -1 -1; -1 -1 -1 -1 -1; -1 -1 -1 -1 -1;-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;];

conv3d_1_2=convn(img,fltr3d2,'same');

conv3d_1_2=conv3d_1_2.*reasonablethings;
result_1_21=conv3d_1_2>=430000;
result_1_22=conv3d_1_2<=570000;
result_1_2=result_1_21.*result_1_22;
alltested=sum(sum(sum(result_1_2)));

temp=ans11==result_1_2;
temp=temp.*ans11;

all3D_2=sum(sum(sum(temp)));

%三维真增强子
fltr3drl=zeros(5,5,5);

fltr3drl(:,:,1)=[-1 -1 -1 -1 -1; -1 -1 -1 -1 -1; -1 -1 -1 -1 -1;-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;];
fltr3drl(:,:,2)=[-1 -1 -1 -1 -1; -1 -1 -1 -1 -1; -1 -1 -1 -1 -1;-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;];
fltr3drl(:,:,3)=[-1 -1 -1 -1 -1; -1 -1 -1 -1 -1; -1 -1 125 -1 -1;-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;];
fltr3drl(:,:,4)=[-1 -1 -1 -1 -1; -1 -1 -1 -1 -1; -1 -1 -1 -1 -1;-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;];
fltr3drl(:,:,5)=[-1 -1 -1 -1 -1; -1 -1 -1 -1 -1; -1 -1 -1 -1 -1;-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;];


%船新的答案和考察项
imgtest=img(:,:,20:40);
anstest=ans11(:,:,23:39);
%把0填上！
meansh=zeros(17,1);
imgfilled=imgtest;
for k=1:21
    thing=imgtest(:,:,k);
    meansh(k,1)=mean(mean(thing));
end

for i=1:232
    for j=1:256
        for k= 1:21
            if imgtest(i,j,k)<290
                imgfilled(i,j,k)=290;
            end
        end
    end
end

%三维卷积
last3d=convn(imgfilled,fltr3drl,'same');
last3dreal=last3d(:,:,3:19);
rsnbrew=reasonablethings(:,:,22:38);
conv3dlast=last3dreal.*rsnbrew;

imgfilledrl=imgfilled(:,:,3:19);
result_rl1=conv3dlast>=800;
result_rl2=imgfilledrl>=300;
result_rl=result_rl1.*result_rl2;
% imshow3D(result_rl,[]);

alllast=sum(sum(sum(result_rl)));
allrl=sum(sum(sum(anstest)));

temp=anstest==result_rl;
temp=temp.*anstest;

all3D_rl=sum(sum(sum(temp)));

%对result_rl进行开和闭
SE=ones(2,2);
SE2=ones(3,3);
tempp=zeros(232,256,17);
for j=1:17
    
    temppp=imerode(result_rl(:,:,j),SE);
    temppp=1-temppp;
    temppp=imerode(temppp,SE);
    temppp=1-temppp;
    
    temppp=1-temppp;
    temppp=imerode(temppp,SE);
    temppp=1-temppp;
    temppp=imerode(temppp,SE);
    
%     temppp=imerode(temppp,SE2);
%     temppp=1-temppp;
%     temppp=imerode(temppp,SE2);
%     temppp=1-temppp;
    
    tempp(:,:,j)=temppp;
end


%把结果都填好
resultfnl=zeros(232,256,48);
resultfnl(:,:,22:38)=tempp;

result=resultfnl;
vs2=get(handles.slider2,'value');%通过slider元件选择一幅slide显示（处理是针对全图处理
vs2=round(vs2*48+1);
set(handles.edit6,'string',vs2);
axes(handles.axes2)
imshow(result(:,:,vs2),[]);
% dicom_write_volume(result,'laplacian_result');

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in Evaluation.
function Evaluation_Callback(hObject, eventdata, handles)
% hObject    handle to Evaluation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global result image3
%%计算acc 
    TP=0;
    FP=0;
    TN=0;
    FN=0;
 for m=1:48
    for i=1:232
        for j=1:256
    if result(i,j,m)>0
        if image3(i,j,m)==0
            FP=FP+1;
        else
            TP=TP+1;
        end
    end
     if result(i,j,m)==0
         if image3(i,j,m)>0
             FN=FN+1;
         else
             TN=TN+1;
         end
    end
        end
    end
 end
acc=(TP+TN)/(TP+FN+TN+FP);
stv=TP/(TP+FN);
DSI=2*TP/(2*TP+FN+FP);
VOE=2*(FN+FP)/(2*TP+FP+FN)
set(handles.edit5,'string',num2str(stv));
set(handles.edit1,'string',num2str(acc));  
set(handles.edit2,'string',num2str(DSI));
set(handles.edit3,'string',num2str(VOE));


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in edit2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of edit2


% --- Executes on button press in edit4.
function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of edit4


% --- Executes on button press in edit5.
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of edit5


% --- Executes on button press in edit3.
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of edit3


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image2 result vs2 image3;
img=image2(:,:,32);
I0=img;
[m,n]=size(I0);
result=zeros(m,n,48);
% threshold=get(handles.slider5,'value');
% threshold=round(threshold*150+40);
% set(handles.edit8,'string',threshold);
threshold=get(handles.edit8,'string');
threshold=str2num(threshold);
for r=20:40    
I=image2(:,:,r);
if isinteger(I)
    I=im2double(I);
end
[M,N]=size(I);
copy1=zeros(M,N);
for i=1:M/2 %遍历整幅图像
    for j=1:N/2
        copy1(i,j)=I(i,j);       
    end
end
S=max(max(copy1));
[x,y]=find(S==copy1);
x1=round(x);
y1=round(y);
seed=copy1(x1,y1);
J1=zeros(M,N);
J1(x1,y1)=1;
count=1; %待处理点个数
while count>0
    count=0;
    for i=1:M %遍历整幅图像
    for j=1:N
        if J1(i,j)==1 %点在“栈”内
        if (i-1)>1&&(i+1)<M&&(j-1)>1&&(j+1)<N %3*3邻域在图像范围内
            for u=-1:1 %8-邻域生长
            for v=-1:1
                if J1(i+u,j+v)==0&&abs(I(i+u,j+v)-seed)<=threshold
                    J1(i+u,j+v)=1;
                    count=count+1;  %记录此次新生长的点个数
                end
            end
            end
        end
        end
    end
    end
end

I2=image2(:,:,r);
if isinteger(I2)
    I2=im2double(I2);
end

[M,N]=size(I2);
copy2=zeros(M,N);
for i=M/2:M %遍历整幅图像
    for j=1:N/2
        copy2(i,j)=I2(i,j);
        
    end
end
P=max(max(copy2));
[x2,y2]=find(P==copy2);
x2=round(x2);
y2=round(y2);
seed=I2(x2,y2);
J2=zeros(M,N);
J2(x2,y2)=1;

count=1; %待处理点个数

while count>0
    count=0;
    for i=1:M %遍历整幅图像
    for j=1:N
        if J2(i,j)==1 %点在“栈”内
        if (i-1)>1&&(i+1)<M&&(j-1)>1&&(j+1)<N %3*3邻域在图像范围内
            for u=-1:1 %8-邻域生长
            for v=-1:1
                if J2(i+u,j+v)==0&&abs(I2(i+u,j+v)-seed)<=threshold
                    J2(i+u,j+v)=1;
                    count=count+1;  %记录此次新生长的点个数
                end
            end
            end
        end
        end
    end
    end
end

I3=image2(:,:,r);
if isinteger(I3)
    I3=im2double(I3);
end

[M,N]=size(I3);
copy3=zeros(M,N);
for i=1:M %遍历整幅图像
    for j=N/2:N
        copy3(i,j)=I3(i,j);
        
    end
end
P=max(max(copy3));
[x2,y2]=find(P==copy3);
x2=round(x2);
y2=round(y2);
seed=I3(x2,y2);
J3=zeros(M,N);
J3(x2,y2)=1;
count=1; %待处理点个数
while count>0
    count=0;
    for i=1:M %遍历整幅图像
    for j=1:N
        if J3(i,j)==1 %点在“栈”内
        if (i-1)>1&&(i+1)<M&&(j-1)>1&&(j+1)<N %3*3邻域在图像范围内
            for u=-1:1 %8-邻域生长
            for v=-1:1
                if J3(i+u,j+v)==0&&abs(I3(i+u,j+v)-seed)<=threshold
                    J3(i+u,j+v)=1;
                    count=count+1;  %记录此次新生长的点个数
                end
            end
            end
        end
        end
    end
    end
end
I4=image2(:,:,r);
if isinteger(I4)
    I4=im2double(I4);
end
[M,N]=size(I4);
copy4=zeros(M,N);
for i=M/2:M %遍历整幅图像
    for j=N/2:N
        copy4(i,j)=I4(i,j);
        
    end
end
P=max(max(copy4));
[x2,y2]=find(P==copy4);
x2=round(x2);
y2=round(y2);
seed=I4(x2,y2);
J4=zeros(M,N);
J4(x2,y2)=1;

count=1; %待处理点个数

while count>0
    count=0;
    for i=1:M %遍历整幅图像
    for j=1:N
        if J4(i,j)==1 %点在“栈”内
        if (i-1)>1&&(i+1)<M&&(j-1)>1&&(j+1)<N %3*3邻域在图像范围内
            for u=-1:1 %8-邻域生长
            for v=-1:1
                if J4(i+u,j+v)==0&&abs(I4(i+u,j+v)-seed)<=threshold
                    J4(i+u,j+v)=1;
                    count=count+1;  %记录此次新生长的点个数
                end
            end
            end
        end
        end
    end
    end
end
J=J1+J2+J3+J4;
K=imbinarize(J);
result(:,:,r)=K;
end
vs2=get(handles.slider2,'value');%通过slider元件选择一幅slide显示（处理是针对全图处理
vs2=round(vs2*48+1);
set(handles.edit6,'string',vs2);
axes(handles.axes2)
imshow(result(:,:,vs2),[]);
axes(handles.axes1)
imshow(image3(:,:,vs2),[]);


% --- Executes on button press in show.
function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image2 image3;
figure
imshow3D(image2,[min(image2(:)),max(image2(:))])
figure
imshow3D(image3,[min(image3(:)),max(image3(:))])


% --- Executes on button press in semiauto1.
function semiauto1_Callback(hObject, eventdata, handles)
% hObject    handle to semiauto1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resultsemi vs2 result
  I=im2uint8(resultsemi);%3维
  II=(I>0);
  [M,N,O]=size(I);%用于遍历
  realsize=sum(sum(sum(II)));%用于求均值
%预定义划分的两组，分别为C1、C2。预定义level，用于存放不同划分时的类间方差
min_value =min(min(min(I)));
max_value =max(max(max(I)));%定义C1、C2、level的下标，同时起统计个数的作用
level =zeros(1,max_value);%求出原图像灰度最大、最小值
columns1 = 1;columns2 = 1;columns3 = 1;%开始遍历
for k = (min_value+1):(max_value-1)
C1 = zeros(1,max_value);
C2 = zeros(1,max_value);
for o = 1:O
for i = 1:M
for j = 1:N 
 if I(i,j,o)>0 && I(i,j,o)<=k
     C1(I(i,j,o))=C1(I(i,j,o))+1 ;%得分组C1
     columns1= columns1 + 1;
 end
 if I(i,j,o)>0 && I(i,j,o)>k
   C2(I(i,j,o))= C2(I(i,j,o))+1; %得到分组C2
   columns2 = columns2 + 1;
 end
 end
end
end%得到C1、C2的概率
 posibility1 = (columns1-1) / realsize;
 posibility2 = 1 - posibility1;
%得到C1、C2的均值
%由于预定义个数大于实际个数，因而求均值时不记录多余的零
C111 = zeros(1,max_value);
C222 = zeros(1,max_value);
for i=(min_value+1):k
  C111(1,i)=double(i)*C1(i)/realsize;
end
C11=sum(C111);
ave1=C11/posibility1;
for n=(k+1):(max_value-1)
  C222(1,n)=double(n)*C2(n)/realsize;
end
C22=sum(C222);
ave2=C22/posibility2;
 %得到类间方差，存放在level中
 std = posibility1*posibility2*(ave1 -ave2)^2;
 level(columns3) = std;
columns3 = columns3 + 1;
columns1 = 1;
columns2 = 1;
C1 = zeros(1,max_value);
C2 = zeros(1,max_value);
end
%找到当前最大阈值
[a,maxx] =max(level);
levelopti= min_value+maxx-1;
levell = double(levelopti)/255
for o=1:48
for i=1:232
    for j=1:256
        if (resultsemi(i,j,o)<levell)
            resultsemi(i,j,o)=0;        
        end
    end
end
end
se1=strel('square',2);
resultsemi=imopen(resultsemi,se1);
result=resultsemi;
vs2=get(handles.slider2,'value');%通过slider元件选择一幅slide显示（处理是针对全图处理
vs2=round(vs2*48+1);
set(handles.edit6,'string',vs2);
axes(handles.axes2)
imshow(result(:,:,vs2),[]);



% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global result
figure
imshow3D(result,[min(result(:)),max(result(:))])



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global result;
result=single(result);
nii = make_nii(result);
save_nii (nii,'C:\wyw\DIP\wmh\result.nii');
%dicom_write_volume(result,'result');
