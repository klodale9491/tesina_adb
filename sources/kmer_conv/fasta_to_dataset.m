function [dataset,classes] = fasta_to_dataset(fasta_fn,tax_fn,k)
    [head,seqs] = fastaread(fasta_fn);% h : ID delle sequenze, s : sequanze 
    load(tax_fn);% Carico la tassonomia divisa per classi, famiglia, genere, ordine
    classes = categorical(length(head),1);% creo una struttura, categorical per salavre gli ID di classe
    dataset = zeros(length(head),4^k);
    for j=1:length(head)
        seq_id = strtok(head{j});% estrazione identificativo
        [bool,pos] = ismember(seq_id,Sequence); 
        classes(j,1) = CLASS(pos); % classe della sequenza
        dataset(j,:) = mkmerstr(upper(seqs{j}),k); % conversione in kmeri
    end
end