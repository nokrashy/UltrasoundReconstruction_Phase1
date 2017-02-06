%-------------*****log transformation function*****--------------
%input of log transformation function is   
                                        %double pre_final_image[Num of samples required for each line][Num of lines];
%output of log transformation function is
                                        %double final_image[Num of samples required for each line][Num of lines];
%each pixel in the pre_final_image is converted in intenisty with positive
%log transformation to increased the lower intenisty level while decreasing
%higher intenisty level
function image = log_transformation( input )
[M,N]=size(input);
    for x = 1:M
        for y = 1:N
                    m=double(input(x,y));
                    input(x,y)=5.*log10(1+m);
        end
    end
image = input;
end

