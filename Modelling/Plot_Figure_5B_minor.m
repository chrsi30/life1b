
format long
format compact

set(0, 'DefaultFigureRenderer', 'painters');


modelName  = 'forsgren_NoBack_8C_resection'; 

if contains(modelName, '8C' )
    model_dir = './Models/8C' ; 
else
    model_dir = './Models/2C' ; 
end

load('../Data/D_MeanSEM.mat'); % importing data
load('../Data/meta_data.mat'); % importing data
load('../Data/RSX.mat'); % importing data

init %% Setting up model


%% Loading parameters

load('master_8C_prm_resec.mat');

% PATIENTS with minor resection
% Pat  8, 12
% 9 , 10, 11 ,15

% Extent of resection
% RSX.pat15 = [ 1   0 0 1   1 1 1 1 ]; % 2,3 (2014-09-23 LIFE)     
% RSX.pat8  = [ 1   1 1 1   1 1 1 1 ]; % Del av segm 6 (2016-03-22)                                                                       
% RSX.pat10 = [ 1   1 0 1   1 1 1 1 ]; % 3 (2016-08-16)                                                                                      
% RSX.pat11 = [ 1   1 1 1   1 1 1 1 ]; % Del av segm 6 (2017-02-14 LIFE + 2019-11-13)Del av segm 8 (2017-02-14 LIFE), Del av segm 7 (2019-11-13 )
% RSX.pat9  = [ 1   0 0 1   1 1 1 1 ]; % 2, 3. (2016-08-30)                                                                                    
% RSX.pat12 = [ 1   1 1 1   1 1 1 1 ]; % Del av segment 6 (2017-06-05)                                                                           %PJ55

%%% Major GROUP - STRESSOR - BASED PAT1 PRE-and Post

kstress_pat8 = exp( table2array(master_8C_prm_resec("pat8",'forsgren_NoBack_8C_resection_MiaLab_kstress')));
kstress_pat12 = exp( table2array(master_8C_prm_resec("pat12",'forsgren_NoBack_8C_resection_MiaLab_kstress')));

stressor = mean([ kstress_pat8  kstress_pat12]);

px = {'pat9','pat10','pat11','pat15'};
for k = 1:size(px,2)
    %%
    pat = px{k} ; 
    doScale     = 0;
    tmp2        = 'no_scale';
    signaltype  = 'Conc';
    type_folder = 'U2';
    exam        = 'U2';
    Volume_string ='MiaLab';
    Bound_string ='OrgBound';

    dirr_name_modelName = 'forsgren_NoBack_8C';

    LoadFolder = strcat('./Results/8C/',dirr_name_modelName,'/',signaltype,'/', tmp2, '/', Bound_string  ,'/',Volume_string ,'/');
    SaveFolder = strcat('./Figures/8C/',dirr_name_modelName,'/',signaltype,'/', tmp2, '/', Bound_string ,'/',Volume_string ,'/');

    tmp4 = strcat ( LoadFolder, type_folder, '/' , pat , '/', exam  );

    [p_dir,~] = FindBestParametersFile(tmp4, 0, '.mat');
    load(p_dir); theta = Results.xbest;

    D.(pat).U2.LiverVolume = D.(pat).U2.LiverVolume.(Volume_string) ;

    tmp7 = D.(pat);
    Mdata = meta_data.(pat);

    %% Simulation

    [theta1, scale ] = setupParam8C(theta, tmp7.U2 , Mdata);

    theta1x = [theta1(1:17)  1  theta1(18:end)  1 ];

    [simLiver1 ,  ~ , s1  ]  = wholeBodySimLiverConc_8C( theta1x, 0:0.1:3600', modelName, scale, doScale);

    allSim.(pat).simLiver1 = simLiver1;

    tmp = RSX.(pat);

    theta1x = [ theta1x( 1:(end-9))    tmp    1 ];

    theta1x( ismember( SBparameters(modelName), 'x_stress')) = 0; % stress factor

    theta1x( ismember( SBparameters(modelName), 'kstress')) = stressor; % stress factor

    [simLiver2 ,  ~ , s2  ]  = wholeBodySimLiverConc_8C( theta1x, 0:0.1:3600' , modelName, scale, doScale);

    allSim.(pat).simLiver2 = simLiver2;

    allParam.(pat) = theta1x; clear theta1x ;

end; clear  simLiver2; clear simLiver1;



%% PLOT1
f = figure();
set(gcf,'color','w')

pat = 'pat10' ;

tmp4  = D.(pat).U2.liver.segment;

set(f, 'outerposition',[0 0 500 500], 'PaperType','a4')

sim_line_width = 2;
title_size     = 16;
gca_size       = 14;

col1           = [ 0   0   0] ;
col2           = [ 0   0.5  1] ;

sgtitle( strcat( pat,'-', exam), 'FontSize', title_size);
hold on

plot( (s1.time)./60, allSim.(pat).simLiver1.sim_segment_c1(:)', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on
errorbar( D.(pat).U2.time/60 , tmp4(:,1), tmp4(:,1)*0.1 , 'O', 'color' , col1 , 'LineWidth', 1 )

plot( (s2.time)./60, allSim.(pat).simLiver2.sim_segment_c1(:)', 'color' , col2 , 'LineWidth', sim_line_width   )

set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); xlabel('Time (min) ');
ylabel('Gd-EOB-DTPA (mmol/L)');
ylim([0 0.25]); 
yticks([ 0 0.1 0.2])
legend({'Pre-op model simulation','Pre-op data', 'Post-op model simulation','Post-op data'});


