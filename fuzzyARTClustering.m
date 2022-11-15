function art = fuzzyARTClustering(x, vig)
% x is the input data.

art.w  = ones(1, size(x,2)*2);
art.Vigilance = vig;
art.LearningRate = 1;
art.ChoiceParameter = 0.002;
for i = 1:size(x,1)
    
    A = ComplementCoding(x(i,:));
    if size(art.w,1) == 0
        art = Initialisation(A, art);
    end
    
    T = CategoryMatch(A, art);
    J = VigilanceTest(A, art, T);
    if J > 0
        art = UpdatePrototypeWeight(A, art, J);
        art.data{J} = [];
    else        
        art = ExpandClusterStructrue(A, art);
        J = size(art.w,1);
        art.data{J} = [];
    end
    
end
% Testing data
for i = 1:size(x,1)
    A = ComplementCoding(x(i,:));
    T = CategoryMatch(A, art);
    J = VigilanceTest(A, art, T);
    Data_cluster(i) = J;
    art.data{J} = [art.data{J}; x(i,:)];
end
% Graphical interpretaion
close all;
figure (1), hold on;
plot(x(:,1), x(:,2), 'kx', 'MarkerSize', 20);
for i = 1:size(art.w,1)
    plot(x(logical(Data_cluster == i), 1), x(logical(Data_cluster == i), 2), 'o', 'MarkerSize', 20);
    text(x(logical(Data_cluster == i), 1), x(logical(Data_cluster == i), 2), num2str(i), 'FontSize', 20);
end
close all;
end

function A = ComplementCoding(x)
A = [x,1-x];
end

function art = Initialisation(x, art)
art.w = x;
art.Vigilance = 0.9;
art.LearningRate = 1;
art.ChoiceParameter = 0.002;
end

function T = CategoryMatch(x, art)
T = sum(min(ones(size(art.w,1),1) * x , art.w) , 2) ./ (art.ChoiceParameter + sum(art.w,2));
% we interpret the typical category match (shown above) in term of type II fuzzy sets.

end

function J = VigilanceTest(x, art, T)
[Tsort, Tind] = sort(T, 'DESC');
J = 0;
for i = 1:size(Tind,1)
    if sum(min(art.w(Tind(i),:) , x) , 2) / sum(x,2) > art.Vigilance
        J = Tind(i);
    end
end
end

function art = UpdatePrototypeWeight(x, art, J)
art.w(J,:) = (art.LearningRate) * min(x, art.w(J,:)) + (1-art.LearningRate) * art.w(J,:);
end

function art = ExpandClusterStructrue(x, art)
art.w( size(art.w,1)+1, : ) = x;
end
