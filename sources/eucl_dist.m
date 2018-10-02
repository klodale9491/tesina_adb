clc
clear all
% Calcolo delle distanze euclidee
load('dataset_k_2.mat');
[row,col] = size(dataset);
dists = zeros(row,row);
for i=1:row
    for j=i+1:row
        dists(i,j) = norm(dataset(i,:) - dataset(j,:));
        dists(j,i) = dists(i,j);
    end
end