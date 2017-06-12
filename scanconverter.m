function scan_out = scanconverter( R,pitch,depth,lens,nLines)

%scan converter           
%nLines = 256;
nSamples = 512;
npixel=512;
nsample=512;
fSample=1;
row_pixel=512;
coloumn_pixel=512;
% R = 61;     %probe radius in mm
%lens = 0.7; %lens thickness in mm
% pitch = 0.2;
% depth = 180.0;  % mm
dAngle = pitch/R;  %delta angle in radians
halfAngle = ((nLines - 1)*dAngle)/2;
d1=R*cos(halfAngle);
d2=R-d1;
angleVector = -halfAngle:dAngle:halfAngle;  %the angle of each line in radians measured from the center line 
dr = depth/nsample;    %distance between samples in mm
midSamples = ((R+lens+dr):dr:(lens+depth+R))';
Lin_n_x = midSamples*sin(angleVector);    % matrix containing the horizontal position of each pixel
Lin_n_y = midSamples*cos(angleVector);    % matrix containing the vertical position of each pixel
pixel_mm= (depth+d2)/npixel;
for i = 1:nSamples
    for n_line =  1 : nLines
        STheta(i,n_line) = -halfAngle-dAngle+n_line*dAngle;
    end
end
for n_sample = 1:nSamples
    for j =  1 : nLines
        SRadius(n_sample,j) = R+lens+n_sample*dr;
    end
end

%new cartesian coordinates for image (512 * 512) in mm
ypixel_step=d1+lens+pixel_mm : pixel_mm : d1+lens+row_pixel*pixel_mm ;
for i = 1:row_pixel
    for j =  1 : coloumn_pixel
        y_pixel(i,j) = ypixel_step(i);
    end
end

xpixel_step = -(coloumn_pixel/2)*pixel_mm : pixel_mm : (coloumn_pixel/2)*pixel_mm;
for i = 1:row_pixel;
    for j =  1 : coloumn_pixel
       x_pixel(i,j)= xpixel_step(j);
    end
end

%new radious and theta for image (512 * 512) pixels 
for i = 1:row_pixel;
    for j =  1 : coloumn_pixel
       ImRadius(i,j)= sqrt(x_pixel(i,j).^2 + y_pixel(i,j).^2);
       ImTheta(i,j) = atan(x_pixel(i,j)./y_pixel(i,j));
    end 
end
%  ?final_image=mat2gray(final_image);
final_image=[zeros(512,32) ones(512,32) zeros(512,32) ones(512,32) zeros(512,32) ones(512,32) zeros(512,32) ones(512,32)];
%interpolation
for i = 1:row_pixel;
    for j =  1 : coloumn_pixel;
        if(ImTheta(i,j) < STheta(i,1) || ImTheta(i,j) > STheta(i,256) || ImRadius(i,j) < SRadius(fSample) || ImRadius(i,j) > SRadius(nSamples) )
            line_index(i,j)=0;
            sample_index(i,j)=0;
            flag(i,j)=1;
        else
            line_index(i,j)= int16((ImTheta(i,j)+ halfAngle+dAngle)/dAngle);
            sample_index(i,j) = int16((ImRadius(i,j)-lens-R)/dr);
            if(line_index(i,j)== 256 || sample_index(i,j) == 512)
               image(i,j)=final_image(sample_index(i,j),line_index(i,j));
            else
               x1=Lin_n_x(sample_index(i,j),line_index(i,j));
               x2=Lin_n_x(sample_index(i,j),line_index(i,j)+1);
               x=x_pixel(i,j);
               y1=Lin_n_y(sample_index(i,j),line_index(i,j));
               y2=Lin_n_y(sample_index(i,j) +1 ,line_index(i,j));
               y=y_pixel(i,j);
               
               dist1(i,j) = sqrt((x-x1).^2+(y-y1)^2);
               dist3(i,j) = sqrt((x-x1).^2+(y-y2).^2);
               dist2(i,j) = sqrt((x-x2).^2+(y-y1).^2);
               dist4(i,j) = sqrt((x-x2).^2+(y-y2).^2);
               dist_tot(i,j) = dist1(i,j) + dist2(i,j) + dist3(i,j) + dist4(i,j);
               
               coeff1(i,j) = (1-(dist1(i,j)./ dist_tot(i,j)))./3 ; 
               coeff2(i,j) = (1-(dist2(i,j)./ dist_tot(i,j) ))./3;
               coeff3(i,j) = (1-(dist3(i,j)./ dist_tot(i,j) ))./3;
               coeff4(i,j) = (1-(dist4(i,j)./ dist_tot(i,j) ))./3;
             end
        end
    end
end
LOOK_UP_TABLE=struct('flag',flag,'Line_num',line_index,'Sample_num',sample_index,'coeff1',coeff1,'coeff2',coeff2,'coeff3',coeff3,'coeff4',coeff4); 
scan_out=LOOK_UP_TABLE;
end