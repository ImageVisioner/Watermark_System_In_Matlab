function [MSE,PSNR,NcValue] =ImageEvaluation(cover,EmbedImage)
% 图像评价算法
% 参数一：cover为原本的载体图像
% 参数二：EmbedImage为嵌入图像后的图像
% 返回值 : MSE PSNR NcValue
% 作用：对嵌入前后图像进行标准化评价
% 联系方式：ImageVisioner@outlook.com


cover=double(cover);
EmbedImage=double(EmbedImage);
cover_red=cover(:,:,1);
cover_blue=cover(:,:,2);
cover_green=cover(:,:,3);
%每个通道下计算
Embed_red=EmbedImage(:,:,1);
Embed_blue=EmbedImage(:,:,2);
Embed_green=EmbedImage(:,:,3);

if any(size(cover)~=size(EmbedImage))  %pnsr计算时候必须两个图像的尺寸相同
    error('Please keep the size of both images the same!');
    
    
else
    %由于pnsr是mse计算出来的
    %首先计算mse
    Sub_red=cover_red-Embed_red;  %红色通道相减
    MSE_RED=sum(Sub_red(:).*Sub_red(:))/numel(Sub_red);
    
    %绿色通道相减
    Sub_green=cover_green-Embed_green;
    MSE_Green=sum( Sub_green(:).* Sub_green(:))/numel( Sub_green);
    
    
    %红色通道相减
    Sub_blue=cover_blue-Embed_blue;
    MSE_Blue=sum(  Sub_blue(:).*  Sub_blue(:))/numel( Sub_blue);
    
    %求平均
    %--------------------psnr----------------------
    psnr_red=10*log10(255^2/MSE_RED);  %红色通道的psnr
    psnr_green=10*log10(255^2/MSE_Green); %绿色通道的psnr
    psnr_blue=10*log10(255^2/MSE_Blue);
    
    MSE=(MSE_Blue+MSE_Green+MSE_RED)/3;
    PSNR=(psnr_blue+psnr_red+psnr_green)/3;
    
    %如果变成灰度图 那么两幅图相等 得到的Ncvalue为NAN
    %必须为二维数组
    cover_gray=rgb2gray(cover);
    EmbedImage_gray=rgb2gray(EmbedImage);
    NcValue1=corr2(cover_gray,EmbedImage_gray);
    disp(NcValue1)  %内部进行打印
    
    %将其转换到各个通道计算
    NcValue_Red=corr2(cover_red,Embed_red);
    
    NcValue_Blue=corr2(cover_blue,Embed_blue);
    NcValue_green=corr2(cover_green,Embed_green);
    
    NcValue=(NcValue_Red+NcValue_Blue+NcValue_green)/3;
end
end