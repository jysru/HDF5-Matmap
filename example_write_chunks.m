%% Cleanup
clear all
close all

filename = 'test.h5';
if exist(filename)
    delete(filename)
end


%% Setup data size = 10;
chunks = 10;
imgs_per_chunk = 1000;
img_size = [256 256];
data_size = [chunks, imgs_per_chunk, img_size];


%% Create data to be saved
data0 = rand(data_size, 'single');
data1 = rand(data_size, 'single');
date = string(datetime('now'));
scalar = 10;


%% Save data using the high-level API
tic
h5create(filename, '/data0', data_size)
h5create(filename, '/data1', data_size)

for i=1:chunks
    h5write(filename, '/data0', data0(i, :, :, :), [i, 1, 1, 1], [1, data_size(2:end)])
    h5write(filename, '/data1', data1(i, :, :, :), [i, 1, 1, 1], [1, data_size(2:end)])
end

h5writeatt(filename, '/', 'date', string(date))
h5writeatt(filename, '/', 'scalar', scalar)
toc



