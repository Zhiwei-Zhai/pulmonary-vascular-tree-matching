%CPD_GRBF The non-rigid CPD point-set registration. It is recommended to use
%   and umbrella function rcpd_register with an option opt.method='nonrigid'
%   instead of direct use of the current funciton.
%
%   [C, W, sigma2, iter, T] =cpd_GLTC(X, Y, beta, lambda, max_it, tol, viz, outliers, fgt, corresp,sigma2);
%
%   Input
%   ------------------
%   X, Y       real, double, full 2-D matrices of point-set locations. We want to
%              align Y onto X. [N,D]=size(X), where N number of points in X,
%              and D is the dimension of point-sets. Similarly [M,D]=size(Y).
%   beta       (try 1..5 ) std of Gaussian filter (Green's funciton) 
%   lambda     (try 1..5) regularization weight
%   max_it     (try 150) maximum number of iterations allowed
%   tol        (try 1e-5) tolerance criterium
%   viz=[0 or 1]    Visualize every iteration         
%   outliers=[0..1] The weight of noise and outliers, try 0.1
%   fgt=[0 or 1]    (default 0) Use a Fast Gauss transform (FGT). (use only for the large data problems)
%   corresp=[0 or 1](default 0) estimate the correspondence vector.
%
%
%   Output
%   ------------------
%   C      Correspondance vector, such that Y corresponds to X(C,:).
%   W      Non-rigid transformation cooeficients.
%   sigma2 Final sigma^2
%   iter   Final number or iterations
%   T      Registered Y point set
%
% Programed by Zhiwei Zhai according to the reference of 'Ge, S., Fan, G., & Ding, M. (2014, June). Non-rigid point set registration with global-local topology preservation. In Computer Vision and Pattern Recognition Workshops (CVPRW), 2014 IEEE Conference on (pp. 245-251). IEEE.'


function  [C, W, sigma2, iter, T] =cpd_GLTC(X, Y, beta, lambda, max_it, tol, viz, outliers, fgt, corresp,sigma2);

[N, D]=size(X); [M, D]=size(Y);

% Initialization
T=Y; iter=0;  ntol=tol+10; W=zeros(M,D);
if ~exist('sigma2','var') || isempty(sigma2) || (sigma2==0), 
    sigma2=(M*trace(X'*X)+N*trace(Y'*Y)-2*sum(X)*sum(Y)')/(M*N*D);
end
sigma2_init=sigma2;


% Construct affinity matrix G
G=cpd_G(Y,Y,beta);

%Zhiwei Construct local linear embeding matrix
k=5;
alpha = 100;
MLLE = cpd_LLE(Y, k);

iter=0; ntol=tol+10; L=1;
while (iter<max_it) && (ntol > tol) && (sigma2 > 1e-8) %(sigma2 > 1e-8)
%while (iter<max_it)  && (sigma2 > 1e-8) %(sigma2 > 1e-8)

    L_old=L;
    % Check wheather we want to use the Fast Gauss Transform
    if (fgt==0)  % no FGT
        [P1,Pt1, PX, L]=cpd_P(X, T, sigma2 ,outliers); st='';
    else         % FGT
        [P1, Pt1, PX, L, sigma2, st]=cpd_Pfast(X, T, sigma2, outliers, sigma2_init, fgt);
    end
    
    L=L+lambda/2*trace(W'*G*W);
    ntol=abs((L-L_old)/L);
%     disp([' CPD nonrigid ' st ' : dL= ' num2str(ntol) ', iter= ' num2str(iter) ' sigma2= ' num2str(sigma2)]);


    % M-step. Solve linear system for W.

    dP=spdiags(P1,0,M,M); % precompute diag(P)
%     W=(dP*G+lambda*sigma2*eye(M))\(PX-dP*Y);
    W=(dP*G+lambda*sigma2*eye(M)+alpha*sigma2*MLLE*G)\(PX-(dP+alpha*sigma2*MLLE)*Y); %Zhiwei, Global-local Tophology constraints
    
    % % same, but solve symmetric system, this can be a bit faster
    % % but can have roundoff errors on idP step. If you want to speed up
    % % use rather a lowrank version: opt.method='nonrigid_lowrank'.
    %
    % idP=spdiags(1./P1,0,M,M); 
    % W=(G+lambda*sigma2*idP)\(idP*PX-Y)

    % update Y postions
    T=Y+G*W;

    Np=sum(P1);sigma2save=sigma2;
    sigma2=abs((sum(sum(X.^2.*repmat(Pt1,1,D)))+sum(sum(T.^2.*repmat(P1,1,D))) -2*trace(PX'*T)) /(Np*D));

    % Plot the result on current iteration
    if viz, cpd_plot_iter(X, T); end;
    iter=iter+1;

end


% disp('CPD registration succesfully completed.');

%Find the correspondence, such that Y corresponds to X(C,:)
if corresp, C=cpd_Pcorrespondence(X,T,sigma2save,outliers); else C=0; end;
