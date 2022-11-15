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
    
    
[M,K] = EvolvingVectorQuantisation(data2, 0.7);
for dc = 1:size(K.w,1)
    if size(K.b{dc},1) == 1
        K.b{dc} = [K.b{dc},K.b{dc}];
    end
    figure(dc+1), boxplot(data2(K.b{dc},:));ylim([0 1]);
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
