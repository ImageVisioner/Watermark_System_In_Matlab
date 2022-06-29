function   EmbedImage=embed(cover,watermark)
% 彩色图像嵌入算法
% cover为载体彩色图像 m*n*3矩阵
% watermark为秘密图片（s水印）
% dwt分解 离散小波分解
% 分解为低频部分 垂直水平对角 这个四个部分
% 其中低频部分存储这大部分的能量
% h_ll低频部分
% h_lh hl hh分别为垂直水平对角
%% 联系方式：ImageVisioner@outlook.com

%只有double精度的矩阵才能分解
%unit格式的矩阵请转换为double
[h_LL,h_LH,h_HL,h_HH]=dwt2(cover,'haar');
img_cover=h_LL;
%分离各个通道
Red_cover=img_cover(:,:,1);
% Red_cover=int8(Red_cover)
% imshow(Red_cover),title("Red_cover")
Green_cover=img_cover(:,:,2);
Blue_cover=img_cover(:,:,3);

%svd分解
%分解出幺正矩阵
[U_imgr1,S_imgr1,V_imgr1]= svd(Red_cover);
[U_imgg1,S_imgg1,V_imgg1]= svd(Green_cover);
[U_imgb1,S_imgb1,V_imgb1]= svd(Blue_cover);

%------------------------水印分解部分---------------------------

[w_LL,w_LH,w_HL,w_HH]=dwt2(watermark,'haar');
img_water=w_LL;
Red_water=img_water(:,:,1);
Green_water=img_water(:,:,2);
Blue_water=img_water(:,:,3);
%svd分解
%分解出幺正矩阵
[U_imgr2,S_imgr2,V_imgr2]= svd(Red_water);
[U_imgg2,S_imgg2,V_imgg2]= svd(Green_water);
[U_imgb2,S_imgb2,V_imgb2]= svd(Blue_water);

%-------------------------结束分解过程---------------------------
%-------------------------开始嵌入过程---------------------------
%其中0.01为融合因子,越小融合程度越高

S_wimgr=S_imgr1+(0.01*S_imgr2);
S_wimgg=S_imgg1+(0.01*S_imgg2);
S_wimgb=S_imgb1+(0.01*S_imgb2);


wimgr = U_imgr1*S_wimgr*V_imgr1';
wimgg = U_imgg1*S_wimgg*V_imgg1';
wimgb = U_imgb1*S_wimgb*V_imgb1';

wimg=cat(3,wimgr,wimgg,wimgb);
newhost_LL=wimg;
%反变换
EmbedImage=idwt2(newhost_LL,h_LH,h_HL,h_HH,'haar');
EmbedImage=uint8(EmbedImage);
end