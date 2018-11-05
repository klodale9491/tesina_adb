clc;
clear all;

%{
  Lo script permette di calcolare le distanze fra le sequenze
  usando una combinazione lineare pesata di quelle elementari.
%}

% 0) caricamento di tutte le distanze k = 2
sw_dists = load('C:\Users\alessio\Documents\MATLAB\tesina_adb\distances\sw\sw.mat');
eu_dists = load('C:\Users\alessio\Documents\MATLAB\tesina_adb\distances\euclidean\euclidean_k3.mat');
jsd_dists = load('C:\Users\alessio\Documents\MATLAB\tesina_adb\distances\jsd\jsd_k3.mat');
cb_dists = load('C:\Users\alessio\Documents\MATLAB\tesina_adb\distances\cb\cb_k3.mat');
classes = load('C:\Users\alessio\Documents\MATLAB\tesina_adb\datasets\classes.mat');
classes = string(classes.classes);
N = length(sw_dists.dists); % numero di sequenze.
M = 4; % numero di misure utilizzate.
all_dists = zeros(N,N,M); % cubo di tutte le distanze per ognuna delle misure
all_dists(:,:,1) = sw_dists.dists;
all_dists(:,:,2) = eu_dists.dists;
all_dists(:,:,3) = jsd_dists.dists;
all_dists(:,:,4) = cb_dists.dists;

% Il calcolo delle distanze combinate dipende dalla scelta del train/test
% set, quindi selezioniamo gli elementi di tali insiemi...
perc = 0.7; % percentuale di training set
part = cvpartition(classes,'HoldOut',1 - perc);
all_ind_pos = linspace(1,N,N);
trn_ind = part.training;
trn_ind_pos = all_ind_pos(trn_ind);
tst_ind = part.test;
tst_ind_pos = all_ind_pos(tst_ind);
num_trn = sum(trn_ind);
num_tst = sum(tst_ind);
unq_cls_trn = unique(classes(trn_ind));
num_cls_trn  = length(unq_cls_trn);
elm_per_cls = zeros(num_cls_trn,1); % numero elementi per ognuna delle classi del train set
log_pos_mat = logical(zeros(N,num_cls_trn));

% 1) sx_gen_means (numero_elementi_test_set X numero_misure) : per ognuna delle misure registra la media delle
% distanze di ognuno degli elementi del test-set verso gli elementi del
sx_gen_means = zeros(N,N,M);
% calcolo della matrice di medie generiche.
for j=1:M
    sx_gen_means(tst_ind,trn_ind,j) = mean(all_dists(tst_ind,trn_ind,j),2) * ones(1,sum(trn_ind));
end

% 2) sx_cls_means (numero_elementi_test_set X num_classi_train_set X numero_misure)
% mi interessa memorizzare per ognuno degli elementi del test-set la sua
% distanza media dalle classi per ognuna delle misure.
sx_cls_means = zeros(N,N,M);
% calcolo della matrice di medie per classe.
for c=1:num_cls_trn % per ognuna delle misure
    log_pos_mat(:,c) = strcmp(classes,unq_cls_trn(c)) & trn_ind;
    elm_per_cls(c) = sum(log_pos_mat(:,c));
    for j=1:M % per ognuna delle classi
        % colonna di distanze medie di ogni elemento del test 
        % con gli elementi della classe c utilizzando la misura j
        sx_cls_means(tst_ind,log_pos_mat(:,c),j) = mean(all_dists(tst_ind,log_pos_mat(:,c),j),2) * ones(1,elm_per_cls(c));
    end
end

% 3) calcolo del vettore dei pesi per ognuna delle misure utilizzate.
diff_sq1 = (sx_cls_means - sx_gen_means).^2;
diff_sq2 = (all_dists - sx_cls_means).^2;

%matrici di accumulazione delle somme (da veriicare se effettivamente devono essere dichiarate qui).
sums_1 = zeros(N,M);
sums_2 = zeros(N,M);
for j=1:M
    for c=1:num_cls_trn
        one_ind = find(log_pos_mat(:,c) == 1);% indici degli elementi di classe c appartenenti al train-set.
        sums_1(:,j) = sums_1(:,j) + (elm_per_cls(c) * diff_sq1(:,one_ind(1),j));
        sums_2(:,j) = sums_2(:,j) + sum(diff_sq2(:,one_ind(1),j));
    end
    sums_1 = sums_1 / (num_cls_trn - 1);
    sums_2 = sums_2 / (num_trn - num_cls_trn); 
end

W = sums_1 ./ sums_2; % matrice di pesi (numero_test X numero_misure).

% 4) calcolo delle distanze combinate finali
cmb_dists = zeros(N,N); % matrice delle distanze combinate finali.
for i=1:N
    dst_elm_mat = squeeze(all_dists(i,:,:))'; %  matrice di delle distanze di un elemento da tutti gli altri per ognuna delle misure (N,M)
    cmb_dists(i,:) = sum(dst_elm_mat .* W(i,:)') / sum(W(i,:));
end
cmb_dists_def = cmb_dists(tst_ind,trn_ind); % seleziono solo gli elementi di mio interesse ovvero quelli di test verso quelli di train.


