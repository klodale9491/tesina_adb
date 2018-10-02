clc
clear all
% caricamento del dataset e delle classi
K = 5;
[dataset,classes] = fasta_to_dataset('16S.fas','taxonomy.mat',K);
