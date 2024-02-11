
format long
format compact

modelName = 'forsgren_NoBack_personalized' ;  model_dir = './Models/2C' ; 

init

linklr

%%
pat           = 'pat1'; 
doScale       =  0; 
scale_string  = 'no_scale';
signaltype    = 'Conc';
type_folder   = 'U2_U3';
Volume_string = 'CT';
Bound_string  = 'OrgBound';
data_string   = 'D_MeanSEM';
%%
f = figure();
set(gcf,'color' , 'w')

sim_line_width = 1.5;
title_size = 16;
gca_size =14;
col1 = [ 0 0 0];
col2 = [ 0.7 0.7 0.7];


nexttile
exam        = 'U2';
LoadFolder = strcat('./Results/', data_string ,'/2C/',modelName,'/',signaltype,'/', scale_string, '/', Bound_string  ,'/',Volume_string ,'/');

Tchi2 = D.(pat).(exam).Tchi2;

tmp4 = strcat ( LoadFolder, type_folder, '/' , pat , '/', exam ,'- Tchi2 =', int2str(Tchi2) );

[p_dir,~] = FindBestParametersFile(tmp4, 0, '.mat'); 
load(p_dir); theta = Results.xbest;

eval(strcat('Data = D.', pat, '.' ,exam,';') );
eval(strcat('Mdata = meta_data.', pat,';') );

thetax = [exp(Results.xbest) Data.LiverVolume.(Volume_string).total Mdata.BloodVolume Mdata.BW ]  ;

[simLiver ,  simSpleen , s  ]  = wholeBodySimLiverConc(thetax,  0:0.1:3600'  , modelName, doScale);

title( strcat( pat,'-', exam), 'FontSize', title_size);
hold on
plot( (s.time)./60, simLiver', 'color' , col1 , 'LineWidth', sim_line_width   )
errorbar( (Data.time)./60, Data.liver.mean , Data.liver.SEM, 'O', 'color' , col1 , 'LineWidth', 1 )
plot( (s.time)./60, simSpleen', 'color' , col2 , 'LineWidth', sim_line_width)
errorbar( (Data.time)./60, Data.spleen.mean , Data.spleen.SEM, '^', 'color' , col2 , 'LineWidth', 1 )
set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); xlabel('Time (min) ');
ylabel('Gd-EOB-DTPA (mmol/L)');
ylim([0 0.25]); 

nexttile
exam        = 'U3';
LoadFolder = strcat('./Results/', data_string ,'/2C/',modelName,'/',signaltype,'/', scale_string, '/', Bound_string  ,'/',Volume_string ,'/');
Tchi2 = D.(pat).(exam).Tchi2;
tmp4 = strcat ( LoadFolder, type_folder, '/' , pat , '/', exam ,'- Tchi2 =', int2str(Tchi2) );

[p_dir,~] = FindBestParametersFile(tmp4, 0, '.mat'); 
load(p_dir); theta = Results.xbest;

eval(strcat('Data = D.', pat, '.' ,exam,';') );
eval(strcat('Mdata = meta_data.', pat,';') );

thetax = [exp(Results.xbest) Data.LiverVolume.(Volume_string).total Mdata.BloodVolume Mdata.BW ]  ;
[simLiver ,  simSpleen , s  ]  = wholeBodySimLiverConc(thetax,  0:0.1:3600'  , modelName, doScale);

title( strcat( pat,'-', exam), 'FontSize', title_size);
hold on
plot( (s.time)./60, simLiver', 'color' , col1 , 'LineWidth', sim_line_width   )
errorbar( (Data.time)./60, Data.liver.mean , Data.liver.SEM, 'O', 'color' , col1, 'LineWidth', 1 )
plot( (s.time)./60, simSpleen', 'color' , col2 , 'LineWidth', sim_line_width)
errorbar( (Data.time)./60, Data.spleen.mean , Data.spleen.SEM, '^', 'color' , col2, 'LineWidth', 1 )
set(gca,'FontSize',gca_size, 'Fontweight' ,'bold')
xlim([0 60]); xlabel('Time (min) ');
ylabel('Gd-EOB-DTPA (mmol/L)');
ylim([0 0.25]); 
legend({'Liver simulation', 'Liver data', 'Spleen simulation', 'Spleen data'});
set(gcf,'color' , 'w')






