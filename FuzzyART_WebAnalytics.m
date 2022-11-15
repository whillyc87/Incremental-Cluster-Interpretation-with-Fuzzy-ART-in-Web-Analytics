fileName = 'data.xlsx';
data = fmeaDataExtraction(inputFolder, fileName, 'Sheet1', 'A2:N853');
data(:,1) = 1:size(data,1);
data2 = data./max(data);
figure(101),boxplot(data2);
set(findobj(gca,'type','line'),'linew',2)
box off;
ylim([0,1]);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
xlabel('Feature space', 'FontSize', 30);
ylabel('Data attribution', 'FontSize', 30);
h = findobj(gca,'Tag','Box');
for k=1:length(h)
    set(h(k), 'Color', 'k');
end
h = findobj(gcf,'tag','Outliers');
set(h,'MarkerSize',8);
for i = 1:numel(h)
    h(i).MarkerEdgeColor = [0,0,0];
end
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k');

% for vig = [0.75, 0.80, 0.85, 0.90]
for vig = 0.80
    art = fuzzyARTClustering(data2, vig);
    [I, w, BI] = FuzzyARTAnalysis(art.w);
    for j = 1:size(art.w,1)
        figure(j), boxplot(BI{j}');
        set(findobj(gca,'type','line'),'linew',2)
        box off;
        ylim([0,1]);
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
        xlabel('Feature space', 'FontSize', 30);
        ylabel('Data attribution', 'FontSize', 30);
        h = findobj(gca,'Tag','Box');        
        for k=1:length(h)
            set(h(k), 'Color', 'k');
        end
        h = findobj(gcf,'tag','Outliers');
        set(h,'MarkerSize',8);
        for i = 1:numel(h)
            h(i).MarkerEdgeColor = [1,1,1];
        end
        lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
        set(lines, 'Color', 'none');
    end   
    
    figure(size(art.w,1)+1), boxplot(w);ylim([0 1]);
    set(findobj(gca,'type','line'),'linew',2);
    box off;
    ylim([0,1]);
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
    xlabel('Feature space', 'FontSize', 30);
    ylabel('Data attribution', 'FontSize', 30);
    h = findobj(gca,'Tag','Box');
    for k=1:length(h)
        set(h(k), 'Color', 'k');
    end
    h = findobj(gcf,'tag','Outliers');
    set(h,'MarkerSize',8);
    for i = 1:numel(h)
        h(i).MarkerEdgeColor = [0,0,0];
    end
    lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
    set(lines, 'Color', 'k');
    
    for dc = 1:size(art.w,1)
        if size(art.data{dc},1) == 1
            art.data{dc} = [art.data{dc};art.data{dc}];
        end
        figure(100+dc), boxplot(art.data{dc});ylim([0 1]);
        set(findobj(gca,'type','line'),'linew',2)
        box off;
        ylim([0,1]);
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',20);
        xlabel('Feature space', 'FontSize', 30);
        ylabel('Data attribution', 'FontSize', 30);
        h = findobj(gca,'Tag','Box');
        for k=1:length(h)
            set(h(k), 'Color', 'k');
        end
        h = findobj(gcf,'tag','Outliers');
        set(h,'MarkerSize',8);
        for i = 1:numel(h)
            h(i).MarkerEdgeColor = [0,0,0];
        end
        lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
        set(lines, 'Color', 'k');
    end
end

