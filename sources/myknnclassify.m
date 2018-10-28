function [tst_cls] = myknnclassify(tst_idx,dists,classes,K)    
    % per ognuno degli elementi del test set calcolo le distanze
    % con gli elementi preclassificati del training set.
    tst_cls = strings(1,length(tst_idx));
    classes = cellstr(classes);
    for i=1:length(tst_idx)
        % mappa associativa delle occorrenze, classes(cellArray)
        occ_map = containers.Map(classes,zeros(1,length(classes)));
        
        % fra le distanze pre-computate prendo le prime k
        % e verifico dove stanno la maggiornaza dei vicini.
        curr_dist = dists(tst_idx(:,i),:);
        [out,ind] = sort(curr_dist);
        for j=1:K
            near_elem_ind = ind(j);
            near_elem_cls = classes{near_elem_ind}; % classe dell'elemento più vicino
            occ_map(near_elem_cls) = occ_map(near_elem_cls) + 1; % aumento il numero di vicini per la classe near_elem_cls
        end
        [cls,val] = max_map(occ_map);
        tst_cls(i) = cls;
    end
    
    % funzione che calcola il massimo e torna chiave e valore di questo
    function [max_key,max_val] = max_map(map)
        max_val = -1;
        max_key = "";
        keys = map.keys();
        vals = map.values();
        for k=1:length(keys)
           if vals{k} > max_val
               max_val = vals{k};
               max_key = keys{k};
           end
        end
    end

end

