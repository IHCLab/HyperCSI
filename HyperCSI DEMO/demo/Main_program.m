clear all; close all; clc;

%% Setting
N = 9;

band1=[5:106];band2=[115:151];band3=[171:214]; banduse = [band1 band2 band3];
load Cuprite_1997_150_150_3
X = X / 10000;
Xo = X;
[M,L] = size(X);
[C d O_index] = RASF(X,N, 10/225);
X(: , O_index) = [] ;
disp('*********************')

plot_flag = 1;

%% HyperCSI
[A_HyperCSI, S_HyperCSI, time_HyperCSI] = HyperCSI(X,N);
A_est =  A_HyperCSI; time_HyperCSI

%% Plot
if plot_flag ==1;
    load ALLINALL;load wavelength_1997;
    sn_est  = zeros(N,22500); sn_est(:,setdiff( [1:22500], O_index )) = S_HyperCSI;
    L = 22500;
    
    % Plotting of Endmember Signatures
    [SADDD A_scale indexx index] =rd_compare(A_est,ALLINALL,banduse);
    A_scale=A_scale(:,N:-1:1);
    % %
    range1=1:length(band1);
    range2=(range1(end)+1):(range1(end)+length(band2));
    range3=(range2(end)+1):(range2(end)+length(band3));
    step=0; figure;
    for i=1: N
        L_min=min(A_scale(:,i))-0.1;
        L_max=max(A_scale(:,i))-L_min;
        A_test=A_scale(:,i)-ones(M,1)*L_min+step;
        step=step+L_max+0.1;
        plot(wavelength(range1),A_test(range1),wavelength(range2),A_test(range2),wavelength(range3),A_test(range3));hold on;
    end
    
    axis([0.4 2.5 0 step+0.4]);
    
    % Plotting the Abundance fractions
    sn_est_rmves_l = sn_est;
    sn_est_scale = sn_est_rmves_l./(max(sn_est_rmves_l')'*ones(1,L)); % Normaization
    for i=1:N
        image1=reshape(sn_est_scale(i,:),sqrt(L),sqrt(L));
        figure;imshow(image1);title(i);
    end
end