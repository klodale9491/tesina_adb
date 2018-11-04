clc
clear all

%{
  Lo script permette di calcolare le distanze fra le sequenze
  usando una combinazione lineare pesata di quelle elementari.
%}

% 0) caricamento di tutte le distanze k = 2
sw_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\sw\sw.mat');
eu_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\euclidean\euclidean_k2.mat');
jsd_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\jsd\jsd_k2.mat');
cb_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\cb\cb_k2.mat');
classes = load('C:\Users\aless\Documents\MATLAB\tesina_adb\datasets\classes.mat');
classes = string(classes.classes);
N = length(sw_dists.dists); % numero di sequenze.
M = 4; % numero di misure utilizzate.
all_dists = zeros(N,N,M); % cubo di tutte le distanze per ognuna delle misure
all_dists(:,:,1) = sw_dists.dists;
all_dists(:,:,2) = eu_dists.dists;
all_dists(:,:,3) = jsd_dists.dists;
all_dists(:,:,4) = cb_dists.dists;

% caricamento di tutte le distanze k = 3
%{
sw_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\sw\sw.mat');
eu_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\euclidean\euclidean_k3.mat');
jsd_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\jsd\jsd_k3.mat');
cb_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\cb\cb_k3.mat');
classes = load('C:\Users\aless\Documents\MATLAB\tesina_adb\datasets\classes.mat');
all_dists = zeros(N,N,M); % cubo di tutte le distanze per ognuna delle misure
N = length(sw_dists.dists); % numero di sequenze.
M = 4; % numero di misure utilizzate.
%}

% caricamento di tutte le distanze k = 4
%{
sw_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\sw\sw.mat');
eu_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\euclidean\euclidean_k4.mat');
jsd_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\jsd\jsd_k4.mat');
cb_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\cb\cb_k4.mat');
classes = load('C:\Users\aless\Documents\MATLAB\tesina_adb\datasets\classes.mat');
all_dists = zeros(N,N,M); % cubo di tutte le distanze per ognuna delle misure
N = length(sw_dists.dists); % numero di sequenze.
M = 4; % numero di misure utilizzate.
%}

% caricamento di tutte le distanze k = 5
%{
sw_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\sw\sw.mat');
eu_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\euclidean\euclidean_k5.mat');
jsd_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\jsd\jsd_k5.mat');
cb_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\cb\cb_k5.mat');
classes = load('C:\Users\aless\Documents\MATLAB\tesina_adb\datasets\classes.mat');
all_dists = zeros(N,N,M); % cubo di tutte le distanze per ognuna delle misure
N = length(sw_dists.dists); % numero di sequenze.
M = 4; % numero di misure utilizzate.
%}

% Il calcolo delle distanze combinate dipende dalla scelta del train/test
% set, quindi selezioniamo gli elementi di tali insiemi...
perc = 0.7; % percentuale di training set
part = cvpartition(N,'HoldOut',1 - perc);
all_ind_pos = linspace(1,N,N);
trn_ind = part.training;
trn_ind_pos = all_ind_pos(trn_ind);
tst_ind = part.test;
tst_ind_pos = all_ind_pos(tst_ind);
num_trn = sum(trn_ind);
num_tst = sum(tst_ind);
cmb_dists = zeros(sum(tst_ind),sum(trn_ind)); % matrice delle distanze combinate finali.

% 1) sx_gen_means (numero_elementi_test_set X numero_misure) : per ognuna delle misure registra la media delle
% distanze di ognuno degli elementi del test-set verso gli elementi del
% train set.
sx_gen_means = zeros(num_tst,M);
for j=1:M
    sx_gen_means(:,j) = mean(all_dists(tst_ind,trn_ind,j),2);
end

% 2) sx_cls_means (numero_elementi_test_set X num_classi_train_set X numero_misure)
% mi interessa memorizzare per ognuno degli elementi del test-set la sua
% distanza media dalle classi per ognuna delle misure.
unq_cls_trn = unique(classes(trn_ind));
num_cls_trn  = length(unq_cls_trn);
sx_cls_means = zeros(num_cls_trn,num_tst,M);
sx_cls_means2 = zeros(num_tst,num_trn,M);
% mi interessa sapere quali sono gli indici degli elementi del train-set 
% per ognuna delle classi. 
% trn_cls_elm_own : memorizza per ogni elemento del train-set la sua classe di appartenenza 
% fra le num_trn_cls disponibili.
cls_elm_own = logical(zeros(num_trn,num_cls_trn));
elm_per_cls = zeros(num_cls_trn,1); % numero elementi per ognuna delle classi del train set
log_pos_mat = logical(zeros(sum(trn_ind),num_cls_trn));
for c=1:num_cls_trn
    log_pos_mat(:,c) = not(cellfun('isempty', strfind(classes(trn_ind), unq_cls_trn(c)))); % posizioni logiche 
    ind_pos = find(log_pos_mat(:,c)); % posizione numeriche 
    cls_elm_own(ind_pos,c) = 1; % indici delle classe-iesima nel train set
    elm_per_cls(c) = sum(log_pos_mat(:,c));
end
for j=1:M % per ognuna delle misure
    for c=1:num_cls_trn % per ognuna delle classi
        trn_cls_ind = trn_ind_pos(cls_elm_own(:,c));% indici del train della classe corrente c-sima
        % colonna di distanze medie di ogni elemento del test 
        % con gli elementi della classe c utilizzando la misura j
        sx_cls_means(c,:,j) = mean(all_dists(tst_ind_pos,trn_cls_ind,j),2);
        sx_cls_means2(:,log_pos_mat(:,c),j) = repmat(sx_cls_means(c,:,j)',1,sum(log_pos_mat(:,c))); % spiaccico la colonna sugli indici di log_pos
    end
end

% 3) calcolo del vettore dei pesi per ognuna delle misure utilizzate.
W = zeros(1,M);
for j=1:M
    btw_grp_var = dist_cmb_bgv(trn_ind,tst_ind,sx_gen_means,sx_cls_means,elm_per_cls,j);
    wht_grp_var = dist_cmb_wgv(trn_ind,tst_ind,sx_cls_means2,all_dists,elm_per_cls,j);
    W(j) = btw_grp_var/wht_grp_var;
end

% 4) calcolo delle distanze combinate finali (da sistemare utilizzando il reshape(), piu' veloce.)
for i=1:num_tst
    elm_ind = tst_ind_pos(i);
    for j = 1: M
        cmb_dists(i,:) = cmb_dists(i,:) + (W(j) * all_dists(elm_ind,trn_ind,j));
    end
    cmb_dists(i,:) = cmb_dists(i,:) / sum(W);
end