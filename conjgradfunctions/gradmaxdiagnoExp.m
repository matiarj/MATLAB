function gf=gradmaxdiagnoExp(x,varargin)
% Maximizaton of the diagonality of hte matrix. 
covmat = varargin{1};   % #pix X #pix X #taus 
% sizevec = varargin{2};
sizevec = [size(covmat,1), length(x)/size(covmat,1)];
W = pinv(exp(reshape(x, sizevec(1), sizevec(2))))';
ntau = size(covmat,3); % #taus (different time delays)
gftmp = zeros(ntau,prod(sizevec));
for tau=1:ntau
    C = covmat(:,:,tau);
    P = W'*C*W;
    Q = diag(1./diag(P));
    R = inv(P);
%     gfr = (Q'*W' - (W*R)')*0.5*(C+C');
    gfr = Q'*W'*0.5*(C+C') - 0.5*((C*W*R)'+R*W'*C);
    gftmp(tau,:) = reshape(gfr',1,prod(sizevec));
end

% gf1 = sum(gftmp,1).*exp(x);
gf1 = sum(gftmp,1);
gf1r = reshape(gf1,sizevec(1), sizevec(2));


% gf2 = -gf1r.*(pinv(W)*exp(reshape(x, sizevec(1)*sizevec(2), sizevec(3)))*pinv(W))';
% gf2 = -(W'*pinv(gf1r)*W');
% gf2 = -(W*pinv(gf1r)*W);
% gf2 = -gf1r.*W;
gf2 = -gf1r.*1./W;

gf=reshape(gf2,1,prod(sizevec));