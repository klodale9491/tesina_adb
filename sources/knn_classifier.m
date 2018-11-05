function [tst_cls] = knn_classifier(dists,classes,K)    
    % per ognuno degli elementi del test set calcolo le distanze
    % con gli elementi preclassificati del training set.
    num_tst = size(dists,1);
    tst_cls = strings(1,num_tst);
    for i=1:num_tst        
        % fra le distanze pre-computate prendo le prime k
        % e verifico in quale classe stanno la maggiornaza dei vicini.
        curr_dist = dists(i,:);
        [~,ind] = sort(curr_dist);
        bst_k_cls = classes(ind(1,1:K)); % le classi dei primi K vicini
        tst_cls(i) = mode(bst_k_cls); % torna la classe con il maggiorn numero di frequenze(la moda)
    end
end

