%% Cleanup
clear all
close all

filename = 'test.h5';
if exist(filename)
    delete(filename)
end


%% Setup data size
batches = 10;
imgs_per_batch = 100;
img_size = [128 128];
data_size = [batches, imgs_per_batch, img_size(1), img_size(2)];


%% Create data to be saved
data0 = rand(data_size) + 1j * rand(data_size);
data1 = rand(data_size, 'single');
date = string(datetime('now'));
scalar = 10;


%% Save data
tic
save_h5(filename, {'data0', 'data1', 'date', 'scalar'})
toc



