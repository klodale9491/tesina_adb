clc
clear all
% Calcolo delle distanze euclidee
load('dataset_k_5.mat');
[row,col] = size(dataset);
dists = zeros(row,row);
for i=1:row
    for j=i+1:row
        dists(i,j) = jsd_div(dataset(i,:),dataset(j,:));
        dists(j,i) = dists(i,j);
    end
end