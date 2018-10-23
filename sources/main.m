clc
clear all
% caricamento del dataset e delle classi
K = 5;
%[dataset,classes] = fasta_to_dataset('16S.fas','taxonomy.mat',K);

% caricamento delle sequenza, senza la codifica a k-meri
[sequences,classes] = fasta_to_dataset_seq('16S.fas','taxonomy.mat');
