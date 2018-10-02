function [index] = kmer2index(str)
    % Vettore mask
    mask = zeros(1,26);
    a = double(str) - 65 +1;
    mask(double('A') - 65 +1) = 0;
    mask(double('C') - 65 +1) = 1;
    mask(double('G') - 65 +1) = 2;
    mask(double('T') - 65 +1) = 3;
    
    % Aggiungere codici iupac, lettere diverse A,C,G,
    mask(double('R') - 65 +1) = convert_index([0,2],2);%R
    mask(double('Y') - 65 +1) = convert_index([1,3],2);%Y
    mask(double('S') - 65 +1) = convert_index([1,2],2);%S
    mask(double('W') - 65 +1) = convert_index([0,3],2);%W
    mask(double('K') - 65 +1) = convert_index([2,3],2);%K
    mask(double('M') - 65 +1) = convert_index([0,1],2);%M
    mask(double('B') - 65 +1) = convert_index([1,2,3],3);%B
    mask(double('D') - 65 +1) = convert_index([0,2,3],3);%D
    mask(double('H') - 65 +1) = convert_index([0,1,3],3);%H
    mask(double('V') - 65 +1) = convert_index([0,1,2],3);%V
    mask(double('N') - 65 +1) = convert_index([0,1,2,3],4);%N
    
    %a = mask(a);
    e = [length(str)-1:-1:0];
    index = (4.^e * mask(a)')+1;
end