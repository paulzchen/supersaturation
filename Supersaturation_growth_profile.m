%This script solves for the supersaturation dynamics, conversion kinetics %and growth profile for the NCs shown in Figure 3 of "Thermodynamic %framework elucidating the supersaturation dynamics of nanocrystal growth",%as described in the manuscript.clcclear allclose all%Constants for calculationsC_inf = 2.86753e-3 ; %saturation conc. (mM, which is equivalent to mol/m^3)             C0 = 0.23715415; %total monomer conc. (mM)v_c = 10.3e-6; %Molar volume of Au atom in crystal (m^3/mol)N_A = 6.022e23; %Avogadro's number (mol^-1)kB_T = 4.11e-21; %Thermodynamic temperature (J)n_NC = 2.1e11; %Number of seeds addedV_s = 12.5e-3; %Volume of synthesis vial (L)D = 9e-10; %Bulk diffusion coefficient of monomer/precursor {m^2/s}factor = V_s  / (4* pi* n_NC* D* C_inf * 1e3); %prefactor before r_conv in                                     %supersaturation calculations {s/mM}%Constants from fitting of Boltzmann absorbance kineticsA1c = [0.23887]'; %total precursor conc. {mM} A2c = [C_inf]'; %minimum precursor conc. (approximated by monomer sat. conc.) {mM}k = [0.340850217]'; %min^-1t0 = [4.68178]'; %min%Choose time range and initialize arraysn_sample = length(k); %samples in this scriptn_int = 200; %number of time intervalst_sat = 20; %saturation time for growtht_int = t_sat / n_int; %time intervalt = zeros(n_int + 1 , 1); %time vectorC_pre = zeros(n_int + 1,n_sample); %NC plasmonic growth kinetics (each column is a sample)ln_super = zeros(n_int + 1,n_sample); %supersaturation matrix (each column is a sample)                                      %calculated with the natural log                                      %formulaC_NC = zeros(n_int + 1,n_sample); %precursor conc. matrix (each column is a sample)R_conv = zeros(n_int + 1,n_sample); %conversion rate to monomer (mM/s)%Initialize vectors for growth assessmentr = zeros(n_int + 1,n_sample); %Radius vector (m)r(1,:) = 5e-9; %Initial radius (m)R_LBL = zeros(n_int + 1,n_sample); %LBL growth rate vector (m/s)%Exp values for NC sizetime_NC = [0.5, 0.75, 2, 4, 7, 15];size_NC = [18.02, 18.13, 29.63, 40.28, 50.05, 60.58];%for-loop to calculate supersaturation and growthfor i = 1 : n_int + 1    t(i+1) = i*t_int;    for j = 1 : n_sample        C_pre(i,j) = (A1c(j) - A2c(j))/(1 + exp(k(j)*...            (t(i)-t0(j)))); %{mM}        C_NC(i,j) = (A1c(j) - A2c(j) ) - (A1c(j) - A2c(j))/(1 + exp(k(j)*...            (t(i)-t0(j)))); %{mM}        R_conv(i,j) = ( (A1c(j) - A2c(j))* k(j)* exp(k(j)*(t(i)-t0(j))) ) / ...            ( 1 + exp(k(j)*(t(i)-t0(j))) )^2; %{mM/s}        ln_super(i,j) = log( factor/ r(i,j)* R_conv(i,j) + 1 );        R_LBL(i,j) = v_c* D* C_inf/r(i,j)* (exp(ln_super(i,j)) - 1 ); %{m/s}        r(i+1,j) = r(i,j) + R_LBL(i,j)*t_int; %{m}    endendsubplot(2,2,1)hold onplot(t(1:n_int+1),C_pre)title('Au precursor conc.')xlabel('time (min)')ylabel('C_p_r_e (mM)')legend('0.1 equiv. NaOH')hold offsubplot(2,2,2)plot(t(1:n_int+1),ln_super)title('supersaturation profile')xlabel('time (min)')ylabel('supersaturation')legend('0.1 equiv. NaOH')subplot(2,2,3)plot(t(1:n_int+1),C_NC)title('Au nanocrystal conc.')xlabel('time (min)')ylabel('C_N_C (mM)')legend('0.1 equiv. NaOH')subplot(2,2,4)plot(t(1:n_int+1),2*r(1:n_int+1,:)*1e9)hold onplot(time_NC,size_NC,'.k')hold offtitle('theoretical NC size (nm)')xlabel('time (min)')ylabel('NP size (nm)')legend('0.1 equiv. NaOH')