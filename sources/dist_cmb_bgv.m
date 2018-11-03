function [bgv] = bgv(trn_ind,tst_ind,sx_gen_means,sx_cls_means,elm_per_cls,j)
    % BGV Between Group Variability
    num_cls_trn = length(elm_per_cls); % numero di classi del train-set
    bgv = sum(sum(elm_per_cls .* ((sx_cls_means(:,:,j)' - sx_gen_means(:,j)).^2)' )) / (num_cls_trn - 1);
end

