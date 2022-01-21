function iturbo2script_3zbio_ASH(data, nocarriers, noexps, expname, TM, Observation)
%% run iTURBO2 experiments and plot results against ash observations
% use 3 different bioturbation depth depending on the observed ash-profiles

% data = matrix of required data (age, mxl, abu, iso) - explanation see below
% nocarriers = number of carriers to be measured
% noexps = number of experiments for SA
% expname = experiment name
% Observation:  1: cores with 0.5       cm kyr-1 sed-rate
%               2: cores with 2.0 - 2.5 cm kyr-1 sed-rate
% age = age of sediment layer down core
% mxl = series of mixed layer thicknesses (zbio) down core
% abu = series of abundances of carrier type 1 down core
% iso = original isotope signature of both carrier  types 1 and 2


age   = data(:,1);
abu   = data(:,3);
iso   = data(:,4);
lngth = length(data(:,1));

% distinguish between ash observation experiment
if(Observation ==1 )     % 0.5 cm kyr-1 rate
    mxl1   = data(:,2).*11;
    mxl2 = data(:,2).*13;
    mxl3 = data(:,2).*15;
    Change_rel_depth = 43;  % to align max ash concentration observed with simulated using intermediate zbio
    txt = '0.5 cm kyr^{-1}';
else                    % 2.0 - 2.5 cm kyr-1 rate
    mxl1   = data(:,2).*5;
    mxl2 = data(:,2).*7;
    mxl3 = data(:,2).*9;
    Change_rel_depth = 37;  % to align max ash concentration observed with simulated using intermediate zbio
    txt = '2.0 - 2.5 cm kyr^{-1}';
end

numb  = nocarriers;     % number of carriers to be measured
exps = noexps;          % number of different experiments

%%
for i = 1:exps
    [oriabu(i,:,:),bioabu(i,:,:),oriiso(i,:,:),bioiso(i,:,:)] = iturbo2_plus_TM(abu,iso,mxl1,numb, TM);
    [oriabu2(i,:,:),bioabu2(i,:,:),oriiso2(i,:,:),bioiso2(i,:,:)] = iturbo2_plus_TM(abu,iso,mxl2,numb, TM);
    [oriabu3(i,:,:),bioabu3(i,:,:),oriiso3(i,:,:),bioiso3(i,:,:)] = iturbo2_plus_TM(abu,iso,mxl3,numb, TM);
end
% normalize bioabu:
bioabu_norm = bioabu./nocarriers;
bioabu2_norm = bioabu2./nocarriers;
bioabu3_norm = bioabu3./nocarriers;

% variable for mean results of mxl1
mean_bioabu1_mxl1 = zeros(1,lngth);
mean_bioabu2_mxl1 = zeros(1,lngth);
mean_bioiso1_mxl1 = zeros(1,lngth);
mean_bioiso2_mxl1 = zeros(1,lngth);
% variable for mean results of mxl2
mean_bioabu1_mxl2 = zeros(1,lngth);
mean_bioabu2_mxl2 = zeros(1,lngth);
mean_bioiso1_mxl2 = zeros(1,lngth);
mean_bioiso2_mxl2 = zeros(1,lngth);
% variable for mean results of mxl3
mean_bioabu1_mxl3 = zeros(1,lngth);
mean_bioabu2_mxl3 = zeros(1,lngth);
mean_bioiso1_mxl3 = zeros(1,lngth);
mean_bioiso2_mxl3 = zeros(1,lngth);

%%
mxltext = num2str(mean(mxl1));
mxltext2 = num2str(mean(mxl2));
mxltext3 = num2str(mean(mxl3));
numbtxt = num2str(numb,2);
expstxt = num2str(exps,2);
abutxt = num2str(max(abu),2);


%%  Plot normalized abundance only and just for species 1 (no isotope change here)
set(0,'DefaultAxesFontSize',16)

% load ash observations vs relative depth:
data_V29_39=xlsread('data/iTURBO2_input_ash_experiment.xlsx','ash_data','P30:Q43');
data_V29_40=xlsread('data/iTURBO2_input_ash_experiment.xlsx','ash_data','S30:T43');
data_RC17_126=xlsread('data/iTURBO2_input_ash_experiment.xlsx','ash_data','V30:W45');
data_E48_23=xlsread('data/iTURBO2_input_ash_experiment.xlsx','ash_data','Y30:Z47');

figure
hold on
for i = 1:exps
    % mxl1
    mean_bioabu1_mxl1 = mean_bioabu1_mxl1+bioabu_norm(i,:,1);
    % mxl2
    mean_bioabu1_mxl2 = mean_bioabu1_mxl2+bioabu2_norm(i,:,1);
    % mxl3
    mean_bioabu1_mxl3 = mean_bioabu1_mxl3+bioabu3_norm(i,:,1);
end

% plot relative depths:
rel_depth = (1:lngth)-Change_rel_depth;
plot(rel_depth,oriabu(1,:,1)./nocarriers,'--k','Linewidth',2.0) % plot one of the original abu

% mxl1
mean_bioabu1_mxl1 = mean_bioabu1_mxl1/exps;
plot(rel_depth,mean_bioabu1_mxl1, '-r','Linewidth',2.0)
% mxl2
mean_bioabu1_mxl2 = mean_bioabu1_mxl2/exps;
plot(rel_depth,mean_bioabu1_mxl2, '-g','Linewidth',2.0)
% mxl3
mean_bioabu1_mxl3 = mean_bioabu1_mxl3/exps;
plot(rel_depth,mean_bioabu1_mxl3, '-b','Linewidth',2.0)
% plot observations
if(Observation == 1 )     % 0.5 cm kyr-1 rate
    plot(data_V29_39(:,1),data_V29_39(:,2),'ko','MarkerFaceColor','k')
    plot(data_V29_40(:,1),data_V29_40(:,2),'k^','MarkerFaceColor','k')
    hleg=legend('z_{bio}= 0 cm','z_{bio}= 11 cm','z_{bio}= 13 cm','z_{bio}= 15 cm');
else % 2 - 2..5cm kyr-1
    plot(data_RC17_126(:,1),data_RC17_126(:,2),'ko','MarkerFaceColor','k')
    plot(data_E48_23(:,1),data_E48_23(:,2),'k^','MarkerFaceColor','k')
    hleg=legend('z_{bio}= 0 cm','z_{bio}= 5 cm','z_{bio}= 7 cm','z_{bio}= 9 cm');
end
set(gca,'XGrid','On','YGrid','On', 'YLim',[0, 0.2],'YTick',[0.0 0.05 0.1 0.15 0.2])
set(hleg,'FontSize',8);
set(hleg,'Location','NorthEast');
xlim([-30 20])
xlabel('Core depth (cm) ');
ylabel('Normalized ash concentration');
text(0.04, 0.90, txt, 'FontSize', 14, 'Units', 'normalized');
hold off
printfilename = ['3zbio_',expname,'_',abutxt,'abu_',numbtxt,'carriers_',expstxt,'Exps'];

% check if output directory exists -- if not create it:
if ~(exist('output/mat','dir') == 7), mkdir('output/mat'); end

    
save(['output/mat/',printfilename,'.mat'],'printfilename', 'lngth','bioiso','bioiso2','bioiso3', 'oriiso', 'mean_bioiso1_mxl1', 'mean_bioiso1_mxl2', 'mean_bioiso1_mxl3','expname', 'exps', 'bioabu','bioabu2','bioabu3', 'oriabu', 'oriabu2', 'oriabu3', 'mean_bioabu1_mxl1', 'mean_bioabu1_mxl2', 'mean_bioabu1_mxl3')
print('-depsc', ['output/',printfilename]);   % save figure in extra output folder

