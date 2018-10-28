clc
clear all
% Calcolo delle distanze cb

load('dataset_k_3.mat');
[rows,cols] = size(dataset);

% calcolo taglie delle singole sequenze compresse

%cx = zeros(1,rows); 
%for i=1:rows
%    cx(i) = size(dzip(dataset(i,:)),1);
%end



% calcolo taglie delle combinate sequenze compresse

%cxy = zeros(rows,rows); % taglia di ogni singola coppia di sequenze compresse
%for i=1:rows
%    disp(i);
%    for j=1:rows
%        % calcolo della matrice di compressione
%        xy = horzcat(dataset(i,:),dataset(j,:));
%        cxy(i,j) = size(dzip(xy),1);
%    end
%end



% calcolo effettivo delle distanze cb
% normalizzate.

load('cx_k3.mat');
load('cxy_k3.mat');
dists = zeros(rows,rows);
for i=1:rows
    disp(i);
    for j=1:rows
        dists(i,j) = (cxy(i,j) - min(cx(i),cx(j)))/max(cx(i),cx(j));
    end
end
