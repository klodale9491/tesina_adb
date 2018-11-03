function [bgv] = bgv(trn_cls,trn_elm_occ,sx_cl_mean,sx_mean)
    % BGV Between Group Variability
    % trn_cls : vettore delle classi del training set
    % trn_elm_occ : vettore dei numeri di elementi per ogni classe del training
    % sx_cl_mean : vettore delle distanze medie di dell'elemento da ognuna
    % delle classi del train.
    % sx_mean : vetore della distanza media dell'elemento corrente da tutte
    % le classi, lo stesso valore e' ripetuto per ognuna delle classi.
    cl = length(trn_cls);
    bgv = sum(trn_elm_occ .* (sx_mean_cls - sx_mean_gen).^2) / (cl - 1);
end

