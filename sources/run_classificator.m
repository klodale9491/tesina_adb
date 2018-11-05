clc;
clear all;

% caricamento di tutto il dataset
sw_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\sw\sw.mat');
eu_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\euclidean\euclidean_k3.mat');
jsd_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\jsd\jsd_k3.mat');
cb_dists = load('C:\Users\aless\Documents\MATLAB\tesina_adb\distances\cb\cb_k3.mat');
classes = load('C:\Users\aless\Documents\MATLAB\tesina_adb\datasets\classes.mat');
classes = string(classes.classes);
N = length(sw_dists.dists); % numero di sequenze.
M = 4; % numero di misure utilizzate.
all_dists = zeros(N,N,M+1); % cubo di tutte le distanze per ognuna delle misure
all_dists(:,:,1) = sw_dists.dists;
all_dists(:,:,2) = eu_dists.dists;
all_dists(:,:,3) = jsd_dists.dists;
all_dists(:,:,4) = cb_dists.dists;

% inizializzazione variabili modello di classificazione.
n = length(all_dists);
unq_cls = unique(classes); % in tutto vi saranno 6 classi uniche.
all_indices = linspace(1,n,n);

kfolds = 10; % numero di partizioni train vs test
kneigh = 10; % numero di vicini
err_kfold_measure = zeros(kfolds, M+1);

% validazione del modello con cross-validation
cross_indices = crossvalind('KFold',all_indices,kfolds);

for k=1:kfolds
    test_indices  = cross_indices == k;% vettore LOGICAL : il test e' 1/kfolds di tutto il dataset
    train_indices = ~test_indices;% vettore LOGICAL : il train e' (kfolds - 1) / kfolds di tutto il dataset
    
    % calcolo le distanze combinate
    all_dists(:,:,M+1) = dist_cmb_fnc(train_indices,test_indices,all_dists(:,:,1:M),classes); % caricamento del dataset delle distanze combinate.
     
    % eseguo il calcolo per tutte le misure 
    for j=1:M+1
        % confronto fra le classi corrette e predette dal classificatore.
        pred_cls = knn_classifier(all_dists(test_indices,train_indices,j),classes,kneigh);
        real_cls = string(classes(test_indices));

        % verifico quante classificazioni ha sbagliato il mio classificatore
        conf_mat = confusionmat(real_cls,pred_cls);
        err = 1 - sum(diag(conf_mat))/sum(sum(conf_mat));
        err_kfold_measure(k,j) = err;
    end
    disp(k);
end

