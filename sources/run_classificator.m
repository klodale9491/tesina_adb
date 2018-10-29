clc;
clear all;

load('C:\Users\alessio\Documents\MATLAB\tesina_adb\distances\sw\sw.mat'); % carico le distanze 'dists'
load('C:\Users\alessio\Documents\MATLAB\tesina_adb\datasets\classes.mat'); % carico le classi 'classes'

% inizializzazione variabili modello di classificazione.
n = length(dists);
unq_cls = unique(classes); % in tutto vi saranno 6 classi uniche.
all_indices = linspace(1,n,n);

% 9 livelli di perc di training set, 7 livelli di vicini.
%{
data = zeros(9,7); 
for kneigh=1:7 % proviamo su un differente numero di vicini
    for j=1:9 
        perc = 0.1 * j; % proviamo su differenti percentuali di training set

        % suddivisione del dataset
        part = cvpartition(n,'HoldOut',1 - perc);
        test_indices  = all_indices(part.test);% vettore LOGICAL : il test e' 1/kfolds di tutto il dataset
        train_indices = all_indices(part.training);% vettore LOGICAL : il train e' (kfolds - 1) / kfolds di tutto il dataset

        % confronto fra le classi corrette e calcolate dal classificatore.
        test_cls = myknnclassify(test_indices,dists,classes,kneigh);
        real_cls = string(classes(test_indices));

        % verifico quante classificazioni ha sbagliato il mio classificatore
        conf_mat = confusionmat(test_cls,real_cls);
        err = 1 - sum(diag(conf_mat))/sum(sum(conf_mat));
        data(j,kneigh) = err;
    end 
end
%}

% validazione del modello con cross-validation
kfolds = 10;
kneigh = 7;
cross_indices = crossvalind('KFold',all_indices,kfolds);
err_vec = zeros(1,kfolds);

for k=1:kfolds
    test_indices  = all_indices(cross_indices == k);% vettore LOGICAL : il test e' 1/kfolds di tutto il dataset
    train_indices = all_indices(~test_indices);% vettore LOGICAL : il train e' (kfolds - 1) / kfolds di tutto il dataset

    % confronto fra le classi corrette e predette dal classificatore.
    pred_cls = myknnclassify(test_indices,dists,classes,kneigh);
    real_cls = string(classes(test_indices));

    % verifico quante classificazioni ha sbagliato il mio classificatore
    conf_mat = confusionmat(real_cls,pred_cls);
    err = 1 - sum(diag(conf_mat))/sum(sum(conf_mat));
    err_vec(1,k) = err;
end