for i = 1:row_pixel;
    for j =  1 : coloumn_pixel;
        if(LOOK_UP_TABLE.flag(i,j) == 1)
            image(i,j)=1;
        else
            if(LOOK_UP_TABLE.Line_num(i,j)== 256 || LOOK_UP_TABLE.Sample_num(i,j) == 512)
                image(i,j)=final_image(LOOK_UP_TABLE.Sample_num(i,j),LOOK_UP_TABLE.Line_num(i,j));
            else
                Q11= final_image(LOOK_UP_TABLE.Sample_num(i,j),LOOK_UP_TABLE.Line_num(i,j)) ;
                Q12= final_image(LOOK_UP_TABLE.Sample_num(i,j)+1,LOOK_UP_TABLE.Line_num(i,j)) ;
                Q21= final_image(LOOK_UP_TABLE.Sample_num(i,j),LOOK_UP_TABLE.Line_num(i,j)+1);
                Q22= final_image(LOOK_UP_TABLE.Sample_num(i,j)+1,LOOK_UP_TABLE.Line_num(i,j)+1) ;
                image(i,j)=LOOK_UP_TABLE.coeff1(i,j)*Q11+LOOK_UP_TABLE.coeff2(i,j)*Q21+LOOK_UP_TABLE.coeff3(i,j)*Q12+LOOK_UP_TABLE.coeff4(i,j)*Q22;
            end
        end
    end
end
figure,imshow(image);