clc
clear all

load('C:\Users\alessio\Documents\MATLAB\tesina_adb\distances\euclidean\euclidean_k_2.mat'); % carico le distanze 'dists'
load('C:\Users\alessio\Documents\MATLAB\tesina_adb\datasets\classes.mat'); % carico le classi 'classes'

% 10-Fold cross validation
n = length(dists);
kfolds = 10;
kneigh = 7;
unq_cls = unique(classes); % in tutto vi saranno 6 classi uniche.
all_indices = linspace(1,n,n);

% kfolds test di classificazione
err = zeros(1,kfolds); % percentuale di errore del classificatore, per ognuna delle iterazioni
perc = 0.9;
for i=1:kfolds
    part = cvpartition(n,'HoldOut',1 - perc);
    test_indices  = all_indices(part.test); % vettore LOGICAL : il test e' 1/kfolds di tutto il dataset
    train_indices = all_indices(part.training);% vettore LOGICAL : il train e' (kfolds - 1) / kfolds di tutto il dataset
    % dato he le classi sono 7, selezionando i primi 7 vicino una classe
    % avrà la maggioranza di vicini(almeno 2)
    tst_cls = myknnclassify(test_indices,dists,classes,kneigh);
    real_cls = string(classes(test_indices));
    % verifico quante classificazioni ha sbagliato il mio classificatore
    num_err = 0;
    for j=1:length(tst_cls)
        if(strcmp(tst_cls(j),real_cls(j)) == 0)
            num_err = num_err + 1;
        end
    end
    err(i) = num_err / length(tst_cls);
end