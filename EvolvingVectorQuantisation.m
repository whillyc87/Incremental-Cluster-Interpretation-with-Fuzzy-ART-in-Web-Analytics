function [M,K] = EvolvingVectorQuantisation(x, p)


% p = 0.7; % data variant within a cluster indicating the cluster size.
alpa = 0.02;
% Algorithm 3 page 100: Evolving Vector Quantization (Basic)
M.w = x(1,:); % prototype weight vector
M.b{1} = []; % mapped x
M.D = 0;% cluster size
winner = 1;
iter = 0;
while iter < 200
    iter = iter +1;
    for i = 1:size(x,1)
        c = size(M.w,1);
        commit = 0;
% Step 1: fetch a data sample.
        A = x(i,:);        
% Step 2: fetch a model M
        Mk = M;
        winner_old = winner;
% Step 3: Evaluate Euclidean similarity of A and mj.
        ED = ((ones(c,1) * A) - M.w) * ((ones(c,1) * A) - M.w)';
        ED = sqrt(sum(eye(size(ED)) .* ED, 2));
% Step 4: determine a winner node mJ.
        [a,J] = sort(ED, "ASC");
        for win = 1:size(J,1)
% Step 5: evaluate fitness of mJ.
            pwJ = M.w(J(win),:) + alpa * (A - M.w(J(win),:)); % learning equation
            TM.w = pwJ; % updated prototype weight vector.
            TM.b{1} = [M.b{J(win)}, i]; % updated set elements.
            TM.b{1} = unique(TM.b{1}); % remove repeated elements.
            TM.D = M.D(J(win)); % get previous cluster size.
            TM.D = clusterSize(TM, x(TM.b{1},:)); % updated cluster size.
            if TM.D <= p % if cluster size is smaller than p
                M.w(J(win),:) = pwJ; % set prototype weight at winner node
                M.b{J(win)} = TM.b{1}; % record i index in winner node
                M.D(J(win)) = TM.D; % set the updated cluster size
                commit = 1; % existing node accepted.
                winner = J(win); % winner J index
                break;
            end
        end
        if commit == 0 % create new node.            
            M.w(c+1,:) = A;
            M.b{c+1} = i;
            M.D(c+1) = 0;
            winner = c+1;
            Mk.w(winner,:) = M.w(winner,:);
        end
        if winner_old ~= winner
            M.b{winner_old}( M.b{winner_old}==i ) = [];
        end        
    end    
    if i>1 && abs(sum( M.w(winner,:) - Mk.w(winner,:))) < 0.002
%             wT = testData(M, i, alpa, x, p);
%             M.b{wT} = [M.b{wT}, i];
%             if wT ~= winner
%                 []
%             end
%         break;
    end
    ind = strcat('Incremental-iter(',num2str(iter), ').mat');
    save(ind,'M','x','alpa','p');
    if stopping(M, Mk) <=0.000194
        iter
        stopping(M, Mk)
        break;
    end
end 

K = TestData(ind);
end  



function MD = clusterSize(M, X)
ED = (ones(size(M.b{1},2),1) * M.w - X) * (ones(size(M.b{1},2),1) * M.w - X)';
ED = sqrt(sum(eye(size(ED)) .* ED,2));

MD = max(ED);
end

function s = stopping(M,Mk)
s = sum( sum(abs(M.w - Mk.w),2) / size(M.w,2) ,1) / size(M.w,1);
end


