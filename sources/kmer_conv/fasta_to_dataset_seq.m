function [sequences,classes] = fasta_to_dataset_seq(fasta_fn,tax_fn)
    [head,seqs] = fastaread(fasta_fn);% h : ID delle sequenze, s : sequanze 
    load(tax_fn);% Carico la tassonomia divisa per classi, famiglia, genere, ordine
    sequences = categorical(length(head),1); % sequenze nucleotidiche
    classes = categorical(length(head),1);% creo una struttura, categorical per salavre gli ID di classe
    for j=1:length(head)
        seq_id = strtok(head{j});% estrazione identificativo
        [bool,pos] = ismember(seq_id,Sequence);
        sequences(j,1) = seqs{j};
        classes(j,1) = CLASS(pos); % classe della sequenza
    end
end