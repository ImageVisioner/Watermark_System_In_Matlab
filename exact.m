function ExactImage=exact(cover,watermark,watermarked)
%彩色秘密水印的提取
%cover为载体图像
%watermark为水印
%watermark为加了水印之后的照片
%dwt分解 离散小波分解
%分解为低频部分 垂直水平对角 这个四个部分
%其中低频部分存储这大部分的能量
%h_ll低频部分
%h_lh hl hh分别为垂直水平对角
% 联系方式：ImageVisioner@outlook.com

%嵌入和还原采用的分解必须为同一种滤波器
[h_LL,h_LH,h_HL,h_HH]=dwt2(cover,'haar');
img=h_LL;
%开分离通道
red1=img(:,:,1);
green1=img(:,:,2);
blue1=img(:,:,3);

[U_imgr1,S_imgr1,V_imgr1]= svd(red1);
[U_imgg1,S_imgg1,V_imgg1]= svd(green1);
[U_imgb1,S_imgb1,V_imgb1]= svd(blue1);


%watermark
[w_LL,w_LH,w_HL,w_HH]=dwt2(watermark,'haar');
img_wat=w_LL;
%分离通道提取
red2=img_wat(:,:,1);
green2=img_wat(:,:,2);
blue2=img_wat(:,:,3);
[U_imgr2,S_imgr2,V_imgr2]= svd(red2);
[U_imgg2,S_imgg2,V_imgg2]= svd(green2);
[U_imgb2,S_imgb2,V_imgb2]= svd(blue2);

%watermarked
[wm_LL,wm_LH,wm_HL,wm_HH]=dwt2(watermarked,'haar');
img_w=wm_LL;
red3=img_w(:,:,1);
green3=img_w(:,:,2);
blue3=img_w(:,:,3);

[U_imgr3,S_imgr3,V_imgr3]= svd(red3);
[U_imgg3,S_imgg3,V_imgg3]= svd(green3);
[U_imgb3,S_imgb3,V_imgb3]= svd(blue3);


S_ewatr=(S_imgr3-S_imgr1)/0.01;
S_ewatg=(S_imgg3-S_imgg1)/0.01;
S_ewatb=(S_imgb3-S_imgb1)/0.01;

ewatr = U_imgr2*S_ewatr*V_imgr2';
ewatg = U_imgg2*S_ewatg*V_imgg2';
ewatb = U_imgb2*S_ewatb*V_imgb2';

%cat算子融合三个矩阵rg通道
ewat=cat(3,ewatr,ewatg,ewatb);
newwatermark_LL=ewat;
rgb2=idwt2(newwatermark_LL,w_LH,w_HL,w_HH,'haar');
ExactImage=uint8(rgb2);
end
