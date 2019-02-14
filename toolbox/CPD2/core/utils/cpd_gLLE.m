function M=cpd_gLLE(X,neighborhood)

    [n, d] = size(X);

    % Compute pairwise distances and find nearest neighbors (vectorized implementation)
    %disp('Finding nearest neighbors...');    
    %[distance, neighborhood] = find_nn(X, k);
     
    X = X';
    neighborhood = neighborhood';
    max_k = size(neighborhood, 1);
    
    [k,mtp] = size(neighborhood);
    % Find reconstruction weights for all points by solving the MSE problem 
    % of reconstructing a point from each neighbours. A used constraint is 
    % that the sum of the reconstruction weights for a point should be 1.
    disp('Compute reconstruction weights...');
    if k > d 
        tol = 1e-5;
    else
        tol = 0;
    end

    % Construct reconstruction weight matrix
    W = zeros(max_k, n);
    for i=1:n
        nbhd = neighborhood(:,i);
        nbhd = nbhd(nbhd ~= 0);
        kt = numel(nbhd);
        z = bsxfun(@minus, X(:,nbhd), X(:,i));                  % Shift point to origin
        C = z' * z;												% Compute local covariance
        C = C + eye(kt, kt) * tol * trace(C);					% Regularization of covariance (if K > D)
        wi = C \ ones(kt, 1);                                   % Solve linear system
        wi = wi / sum(wi);                                      % Make sure that sum is 1
        W(:,i) = [wi; nan(max_k - kt, 1)];
    end

    % Now that we have the reconstruction weights matrix, we define the 
    % sparse cost matrix M = (I-W)'*(I-W).
    M = sparse(1:n, 1:n, ones(1, n), n, n, 4 * max_k * n);
    for i=1:n
       w = W(:,i);
       j = neighborhood(:,i);
       indices = find(j ~= 0 & ~isnan(w));
       j = j(indices);
       w = w(indices);
       M(i, j) = M(i, j) - w';
       M(j, i) = M(j, i) - w;
       M(j, j) = M(j, j) + w * w';
    end