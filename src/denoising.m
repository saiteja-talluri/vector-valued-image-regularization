function [ img ] = denoising( myinp,t,locality,maxiter)

    q = locality;
    img = myinp;
    [row,col,channels] = size(myinp) ;
    out =  img;

    for k=1:maxiter
        
        grad_x = zeros(size(img));
        grad_y = zeros(size(img)); 
        [grad_x(:,:,1),grad_y(:,:,1)] = imgradientxy(img(:,:,1)) ;
        [grad_x(:,:,2),grad_y(:,:,2)] = imgradientxy(img(:,:,2)) ;
        [grad_x(:,:,3),grad_y(:,:,3)] = imgradientxy(img(:,:,3)) ;
        [x,y] = meshgrid(-1*q:q,-1*q:q);
            
        for i=q+1:row-q
            
            for j=q+1:col-q
            
                if (mod(i+1,4)==0 && mod(j+1,4)==0) 
                    continue 
                end
                
                Gr = [grad_x(i,j,1) ^ 2 , grad_x(i,j,1) * grad_y(i,j,1)  ; grad_x(i,j,1) * grad_y(i,j,1) , grad_y(i,j,1) ^ 2 ];
                Gg = [grad_x(i,j,2) ^ 2 , grad_x(i,j,2) * grad_y(i,j,2)  ; grad_x(i,j,2) * grad_y(i,j,2) , grad_y(i,j,2) ^ 2 ];
                Gb = [grad_x(i,j,3) ^ 2 , grad_x(i,j,3) * grad_y(i,j,3)  ; grad_x(i,j,3) * grad_y(i,j,3) , grad_y(i,j,3) ^ 2 ];
                
                G_sigma = Gr + Gg + Gb;
                filter = fspecial('gaussian',3,1);
                G = imfilter(G_sigma,filter);
            
                [V1,D1] = eig(G);
                [D,perm] = sort(diag(D1), 'ascend') ;
                V = V1(:, perm) ;
                l1 = D(1) ;
                l2 = D(2) ;
                T = 1/sqrt(1+l1+l2) * (V(:,1) * V(:,1)')  + 1/(1+l1+l2) * (V(:,2) * V(:,2)') ;
                T_inv = inv(T) ;
            
                gauss = guassCalc(x,y,T_inv,t);
                gauss = gauss/sum(sum(gauss));
                local_img = img(i-q:i+q,j-q:j+q,:);
                for p = 1:3
                    co = conv2(local_img(:,:,p),gauss,'same');
                    img(i,j,p) =  co(q+1,q+1);
                end
                
            end
        end
        
        ssim(img,out)
        out = img;

    end
    
    figure ; subplot(1,2,1) ; imshow(myinp) ; subplot(1,2,2) ; imshow(img,[]);
        
end
