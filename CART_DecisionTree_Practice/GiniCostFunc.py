def GiniCostFunc(groups,classes):
    m = float(sum(len(group) for group in groups)) # m is the node size
    #porportion = count(class_value) / count(rows)
    #gini_index = (1.0 - sum(proportion * proportion)) * (group_size/total_samples)
    gini = 0
    for group in groups:
        m_group = len(group)
        if m_group == 0:
            continue
        score = 0
        for val in classes:
            porportion = [row[-1] for row in group].count(val) / m_group
            score += porportion * porportion
        gini += (1.0 - score) * (m_group / m)
    return gini
