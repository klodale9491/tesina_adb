% Trasforma una sequenza genomica in kmero
function [kstr] = mkmerstr(seq,k)
    kstr = zeros(1,4^k);
    for x=1:(length(seq) - k + 1) % faccio scorrere la finestra di lunghezza K. 
        kmer = seq(x:x+k-1);
        kmer_index = kmer2index(kmer);
        kstr(1,kmer_index) = kstr(1,kmer_index) + 1;
    end
end

