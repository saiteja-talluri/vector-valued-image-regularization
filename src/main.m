%% Denoising
image = im2double(imread('child.png'));
img = denoising(image,3,1,5);

filter = fspecial('gaussian',5,3);
guass = imfilter(image,filter);

figure ; subplot(1,3,1) ; imshow(image) ;subplot(1,3,2) ; imshow(guass,[]); subplot(1,3,3) ; imshow(img,[]);

%% Inpainting
image = im2double(imread('specsGuy.jpg'));
mask = im2double(imread('specsmask.png'));

inpainting(image,mask,5,10,10);


%% Restoration
image = im2double(imread('obama.bmp'));
image = image(1:2:end,1:2:end,:);
[row,col,channels] = size(image);
out = zeros(size(image));
mask = ones(row,col);
bilinearLenna = zeros(size(image));

%% Creating a mask and Removing Pixels
for i = 1:row
    for j = 1:col
        if(mod(i,2) == 1 && mod(j,2) == 0)
            continue;
        end
        
        if(mod(i,2) == 0 && mod(j,2) == 1)
            continue;
        end
        mask(i,j) = 0;
        out(i,j,:) = image(i,j,:);
    end
end

img = inpainting(out,mask,3,1,10);

figure ; subplot(1,3,1) ; imshow(image) ; subplot(1,3,2) ; imshow(out); subplot(1,3,3) ; imshow(img);








