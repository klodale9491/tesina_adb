function [wgv] = cmb_wgv(trn_ind,tst_ind,sx_cls_means,all_dists,elm_per_cls,j)
    % CMB_WGV Within Group Variability
    num_elm_trn = sum(trn_ind);
    num_cls_trn = length(elm_per_cls);
    wgv = sum(sum(all_dists(tst_ind,trn_ind,j) - sx_cls_means(:,:,j)).^2) / (num_elm_trn - num_cls_trn);
end

