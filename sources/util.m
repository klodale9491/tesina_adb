% caricamento del dataset e delle classi
%{
    K = 5;
    [dataset,classes] = fasta_to_dataset('16S.fas','taxonomy.mat',K);
    % caricamento delle sequenza, senza la codifica a k-meri
    [sequences,classes] = fasta_to_dataset_seq('16S.fas','taxonomy.mat');
%}

% stima il valore di K da utilizzare per l'esperimento
%{
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
%}