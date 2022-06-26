function BrightnesImage=EqualBrightness(cover,EmbedImage)
% 名字：亮度规格化算法
% 参数一：cover为载体图像
% 参数二：EmbedImage为嵌入水印的照片
% 作用：将嵌入水印前后的两个图像均衡其亮度
% 联系方式：ImageVisioner@outlook.com
  aa=mean2(rgb2gray(cover));
  bb=mean2(rgb2gray(EmbedImage));
  BrightnesImage=EmbedImage+abs((aa-bb));
end