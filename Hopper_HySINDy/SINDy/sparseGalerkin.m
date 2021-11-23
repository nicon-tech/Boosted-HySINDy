function dy = sparseGalerkin(t,y,ahat,polyorder,polyorderx,polyordery,usesine)
% Copyright 2015, All Rights Reserved
% Code by Steven L. Brunton
% For Paper, "Discovering Governing Equations from Data: 
%        Sparse Identification of Nonlinear Dynamical Systems"
% by S. L. Brunton, J. L. Proctor, and J. N. Kutz

yPool = poolDatady(y',length(y),polyorder,polyorderx,polyordery,usesine,0, 0, 0);
dy = (yPool*ahat)';