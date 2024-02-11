

format long
format compact

set(0, 'DefaultFigureRenderer', 'painters');

modelName = 'forsgren_NoBack_8C_resection';

if contains(modelName, '8C' )
    model_dir = './Models/8C' ; 
else
    model_dir = './Models/2C' ; 
end

load('../DATA/D_MeanSEM.mat'); % importing data
load('../DATA/meta_data.mat'); % importing data

init 

%%
pat = 'pat1'; %% Changed to pat 2
doScale     = 0; 
tmp2        = 'no_scale';
signaltype  = 'Conc';
type_folder = 'U2_U3';
exam        = 'U2';
Volume_string ='CT';
Bound_string ='OrgBound';


LoadFolder = strcat('./Results/8C/',modelName,'/',signaltype,'/', tmp2, '/', Bound_string  ,'/',Volume_string ,'/');
SaveFolder = strcat('./Figures/8C/',modelName,'/',signaltype,'/', tmp2, '/', Bound_string ,'/',Volume_string ,'/');

tmp4 = strcat ( LoadFolder, type_folder, '/' , pat , '/', exam  );

[p_dir,~] = FindBestParametersFile(tmp4, 0 ,'.mat'); 
load(p_dir); theta = Results.xbest;

eval( strcat('tmp3 = D.', pat ))

D.(pat).U2.LiverVolume = D.(pat).U2.LiverVolume.(Volume_string);
D.(pat).U3.LiverVolume = D.(pat).U3.LiverVolume.(Volume_string);

eval(strcat('Mdata = meta_data.', pat,';') );

%% simulation 1 
[theta1, scale ] = setupParam8C(theta, D.(pat).U2 , Mdata);
theta1 = [ theta1 1];
[simLiver1 ,  ~ , s1  ]  = wholeBodySimLiverConc_8C( theta1, 0:0.1:3600', modelName, scale, doScale);   
[theta2, scale ] = setupParam8C(theta, D.(pat).U3 , Mdata);
theta2 = [ theta2 1];

theta2( ismember( SBparameters(modelName), 'x_stress')) = 0; % stress factor

[simLiver2 ,  ~ , s2  ]  = wholeBodySimLiverConc_8C( theta2, 0:0.1:3600' , modelName, scale, doScale);   
%%
tmp4  = D.(pat).U2.liver.segment;
tmp5  = D.(pat).U3.liver.segment;
%% PLOT1
f = figure() ;
set(gcf,'color','w')
set(f, 'outerposition',[0 0 500 500], 'PaperType','a4')

sim_line_width = 2;
title_size     = 16;
gca_size       = 14;

col1           = [ 0   0   0] ;
col2           = [ 0   0   0] ;

hold on

plot( (s1.time)./60, simLiver1.sim_segment_c1(:)', 'color' , col1 , 'LineWidth', sim_line_width   )
hold on
errorbar( D.(pat).U2.time/60 , tmp4(:,1), tmp4(:,1)*0.1 , 'O', 'color' , col1 , 'LineWidth', 1 )

plot( (s2.time)./60, simLiver2.sim_segment_c1(:)', '--', 'color' , col2 , 'LineWidth', sim_line_width   )
errorbar( D.(pat).U3.time./60, tmp5(:,1), tmp5(:,1)*0.1 , '*', 'color' , col2 , 'LineWidth', 1 )

set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); xlabel('Time (min) ');
ylabel('Gd-EOB-DTPA (mmol/L)');
ylim([0 0.25]); 
yticks([ 0 0.1 0.2])
legend({'Pre-op model simulation','Pre-op data', 'Post-op model simulation','Post-op data'},'Location','southoutside');




