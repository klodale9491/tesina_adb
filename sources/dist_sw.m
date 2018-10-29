clc
clear all

load('C:\Users\alessio\Documents\MATLAB\tesina_adb\datasets\dataset_seq.mat'); % sequenze genomiche
load('C:\Users\alessio\Documents\MATLAB\tesina_adb\datasets\classes.mat'); % classi

num_sqn = length(dataset);
dists = zeros(num_sqn,num_sqn);

% lut per cachare gli allineamenti con se stessi.
disp('creating lut...');
lut_align = zeros(1,num_sqn);
for i=1:num_sqn
    seq = char(dataset(i));
    lut_align(i) = swalign(seq,seq);
end

disp('computing alignments...');
for i=1:num_sqn
    seq1 = char(dataset(i));
    score11 = lut_align(i);
    disp(i);
    for j=i+1:num_sqn
        seq2 = char(dataset(j));
        score12 = swalign(seq1,seq2);
        score22 = lut_align(j);
        dists(i,j) = (1-score12/score11)* (1-score12/score22);
        dists(j,i) = dists(i,j);
    end
end