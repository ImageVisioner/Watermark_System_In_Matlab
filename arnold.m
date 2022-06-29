function arnoldImg = arnold(massage,a,b,n)
% %灰度图置乱函数 猫脸置乱算法
% 作用：给水印图像进一步加密，保证破解的稳定性
% 参数一：massage:灰度图像
% a,b为参数 n为变换次数
% 联系方式：ImageVisioner@outlook.com
[height,weight] = size(massage);
N=height;
arnoldImg = zeros(height,weight);
for i=1:n
    for y=1:height
        for x=1:weight
            %防止取余过程中出现错误，先把坐标系变换成从0 到 N-1
            xx=mod((x-1)+b*(y-1),N)+1;
            yy=mod(a*(x-1)+(a*b+1)*(y-1),N)+1;
            arnoldImg(yy,xx)=massage(y,x);
        end
    end
    massage=arnoldImg;
end
arnoldImg = uint8(arnoldImg);
end