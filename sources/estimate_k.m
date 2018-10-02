clc
clear all
% calcola la lunghezza della sequenza piu piccola
[a,b] = fastaread('16S.fas');
minlen = length(b{1});
maxlen = length(b{1});
for i=2:length(b)
    if length(b{i}) < minlen
        minlen = length(b{i});
    end
    if length(b{i}) > maxlen
        maxlen = length(b{i});
    end
end
% calcola tutti i possibili valori di k, tale che 4^k < len(seq_piu_corta)
kvalues = [];
k = 1;
while 4^k < minlen
    kvalues(k) = k;
    k = k + 1;
end