function [ img ] = flowVisualisation(img,maxiter)

    img = img;
    maxiter = maxiter;

    % img = im2double(imread('specsGuy.jpg'));
    % maxiter = 50 ; 


    [row,col,channels] = size(img) ;
    Field = zeros([row,col,2]) ; 
    T = zeros([row,col,4]) ;

    for i=1:row       
        for j=1:col
            if(j < col/2)
                Field(i,j,:) = [3;0];
            end
            if(j >= col/2)
                Field(i,j,:) = [0;3];
            end
            A = reshape(Field(i,j,:),2,1) ; 
            B = reshape((A*A')/norm(A),4,1) ;
            T(i,j,:) = B ; 
        end
    end
    
    inp = img; 

    for i = 1:maxiter
            
        img = im2double(img) ; 
        
        [gx1,gy1] = imgradientxy(img(:,:,1)) ; 
        [gx2,gy2] = imgradientxy(img(:,:,2)) ; 
        [gx3,gy3] = imgradientxy(img(:,:,3)) ; 

        [gxx1,gxy1] = imgradientxy(gx1) ; 
        [gxx2,gxy2] = imgradientxy(gx2) ; 
        [gxx3,gxy3] = imgradientxy(gx3) ; 

        [gyx1,gyy1] = imgradientxy(gy1) ; 
        [gyx2,gyy2] = imgradientxy(gy2) ; 
        [gyx3,gyy3] = imgradientxy(gy3) ; 

        H1 = cat(3,gxx1,gyx1,gxy1,gyy1) ;
        H2 = cat(3,gxx2,gyx2,gxy2,gyy2) ;
        H3 = cat(3,gxx3,gyx3,gxy3,gyy3) ;


        img(:,:,1) = img(:,:,1) + 0.01.*(T(:,:,1).*H1(:,:,1) + T(:,:,2).*H1(:,:,3) + T(:,:,3).*H1(:,:,2) + T(:,:,4).*H1(:,:,4)) ; 
        img(:,:,2) = img(:,:,2) + 0.01.*(T(:,:,1).*H2(:,:,1) + T(:,:,2).*H2(:,:,3) + T(:,:,3).*H2(:,:,2) + T(:,:,4).*H2(:,:,4)) ; 
        img(:,:,3) = img(:,:,3) + 0.01.*(T(:,:,1).*H3(:,:,1) + T(:,:,2).*H3(:,:,3) + T(:,:,3).*H3(:,:,2) + T(:,:,4).*H3(:,:,4)) ; 

    end
    
    out = img ; 
    figure ; subplot(1,2,1) ; imshow(inp) ; subplot(1,2,2) ; imshow(out,[]);
end
    