%% Cleanup
clear all
close all

filename = 'test.h5';
if exist(filename)
    delete(filename)
end


%% Setup data size
chunks = 10;
imgs_per_chunk = 1000;
img_size = [256 256];
data_size = [chunks, imgs_per_chunk, img_size];


%% Create data to be saved
data0 = rand(data_size, 'single');
data1 = rand(data_size, 'single');
date = string(datetime('now'));
scalar = 10;


%% Save data
tic
save_h5(filename, {'data0', 'data1', 'date', 'scalar'})
toc



