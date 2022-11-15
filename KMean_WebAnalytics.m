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

c = 6;
[data_cluster , w] = kMeans(data2, c);
dc = cell(1, size(w,1));
for i = 1:size(w,1)
    class = find(data_cluster == i);
    dc{i} = [dc{i}; data2(class,:)];
end
for j = 1:size(w,1)
    if size(dc{j},1) == 1
        dc{j} = [dc{j};dc{j}];
    end
    figure(j), boxplot(dc{j});ylim([0 1]);
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
    %         patch(get(h(k),'XData'),get(h(k),'YData'),[0,0,0],'FaceAlpha',0);
    end
    h = findobj(gcf,'tag','Outliers');
    set(h,'MarkerSize',8);
    for i = 1:numel(h)
        h(i).MarkerEdgeColor = [0,0,0];
    end
    lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
    set(lines, 'Color', 'k');
end


