%% 
%% Sainty check simulations for all 8C modelling


format long
format compact

modelName = 'forsgren_NoBack_8C' ;  model_dir = './Models/8C' ; 


load_string_data = 'MeanSEM';


load(['../Data/D_', load_string_data,'.mat']); % importing data
load('../Data/meta_data.mat'); % importing data

init

%%
pat           = 'pat10'; 
doScale       =  0; 
scale_string  = 'no_scale';
signaltype    = 'Conc';
type_folder   = 'U2';
Volume_string = 'MiaLab';
Bound_string  = 'OrgBound';
exam          = 'U2';

LoadFolder = strcat('./Results/8C/',modelName,'/',signaltype,'/', scale_string , '/', Bound_string  ,'/',Volume_string ,'/');

tmp4 = strcat ( LoadFolder, type_folder, '/' , pat , '/', exam  );

[p_dir,~] = FindBestParametersFile(tmp4, 0, '.mat'); 
load(p_dir); theta = Results.xbest;

Data = D.(pat).(exam);
Mdata = meta_data.(pat);

Data.LiverVolume = D.(pat).(exam).LiverVolume.(Volume_string) ;

[theta, scale ] = setupParam8C(theta, Data , Mdata);


[simLiver ,  ~ , s  ]  = wholeBodySimLiverConc_8C( theta, 0:1:3600' , modelName, scale, doScale);       

%% Removing segments
count = 0;
theta2 = theta;
for tt = 1:2
for kk = 1:7 
count = count + 1;

if tt == 1
tmp = [ ones(1,8-kk) zeros(1,kk) ];
else
tmp = [  zeros(1,kk) ones(1,8-kk)];
end

theta2(ismember(pNames, {'px1', 'px2' , 'px3', 'px4', 'px5', 'px6', 'px7', 'px8'})) = tmp;

[~ ,  ~ , allSim.(['s', int2str(count)])  ]  = wholeBodySimLiverConc_8C( theta2, 0:1:3600' , modelName, scale, doScale);       

end
end


%% Diff function
count = 0;
for kk = 1:8

for jj = 1:10
theta3 = theta;

count = count + 1;

tmp = ['kph_' int2str(kk) ];

theta3(ismember(pNames, tmp)) = theta3( ismember(pNames, tmp))*( 0.1 + 0.1*jj);

[~ ,  ~ , allSim2.(['s', int2str(count)])  ]  = wholeBodySimLiverConc_8C( theta3, 0:10:3600' , modelName, scale, doScale);       
end

end



%% Remove segments

idx = ismember(s.states,{'Ch_1', 'Ch_2' , 'Ch_3', 'Ch_4', 'Ch_5', 'Ch_6', 'Ch_7', 'Ch_8'}) ;

f1 = figure();
f1.Position = [0 0 300 300];

tmp2 = sum (  s.statevalues(:,idx ).*D.(pat).(exam).LiverVolume.(Volume_string).segments' , 2) ;
plot( s.time./60, tmp2 , 'color' , [ 0 0 0 ] , 'LineWidth', 1 ) ;
hold on

for kk = 1:7

tmp2 = sum ( allSim.(['s', int2str(kk)]).statevalues(:,idx ).*D.(pat).(exam).LiverVolume.(Volume_string).segments' , 2) ;

plot( s.time./60, tmp2, 'color' , [ 0 + kk*0.05  0 + kk*0.05   1 - kk*0.05 ] , 'LineWidth', 1 ) ;

clear tmp2;


if kk ==1
    ylabel('Total Gd-EOB-DTPA (\mumol)');
    xlabel('Time (min)');
end

end
xticks([0 60]);
ylim([0 6.5e-4]); yticks([ 0 6.5e-4]);
set(gca, 'fontsize', 12)
set(gcf,'color','w');


%% 
f2 = figure();
f2.Position = [0 0 300 300];

tmp2 = sum (  s.statevalues(:,idx ).*D.(pat).(exam).LiverVolume.(Volume_string).segments' , 2) ;
plot( s.time./60, tmp2 , 'color' , [ 0 0 0 ] , 'LineWidth', 1 ) ;
hold on

for kk = 8:14

tmp2 = sum ( allSim.(['s', int2str(kk)]).statevalues(:,idx ).*D.(pat).(exam).LiverVolume.(Volume_string).segments' , 2) ;

plot( s.time./60, tmp2, 'color' , [ 0 + kk*0.05  0 + kk*0.05   1 - kk*0.05 ] , 'LineWidth', 1 ) ;

clear tmp2;


if kk ==8
    ylabel('Total Gd-EOB-DTPA (\mumol)');
    xlabel('Time (min)');
end

end
xticks([0 60]);
ylim([0 6.5e-4]); yticks([ 0 6.5e-4]);
set(gca, 'fontsize', 12)
set(gcf,'color','w');



%%

%% Changing function
f3 = figure();
f3.Position = [0 0 600 350];

count = 0;
for kk = 1:8

subplot(2,4,kk)
for jj = 1:10
count = count + 1;

C = allSim2.(['s', int2str(count)]).statevalues(:, ismember(s.states,['Ch_' int2str(kk)]) ) ;

plot( (0:10:3600')./60, C, 'color' , [ 1 - jj*0.1   0 + jj*0.1  0 ] , 'LineWidth', 1 ) ;
hold on

end

if kk ==1
    ylabel(' Gd-EOB-DTPA (mM;)');
    xlabel('Time (min)');
end

xticks([0 60]);
ylim([0 4e-4]); yticks([ 0 4e-4]);
set(gca, 'fontsize', 12)



end
set(gcf,'color','w');


%%
f4 = figure();
f4.Position = [0 0 600 350];
count = 0; count2 = 0;

for kk = [ 1 8 ] 
count2 = count2 + 1;
subplot(1,2,count2)
for jj = 1:10
count = count + 1;

tmp2 = sum ( allSim2.(['s', int2str(count)]).statevalues(:,idx ).*D.(pat).(exam).LiverVolume.(Volume_string).segments' , 2) ;

plot( (0:10:3600')./60, tmp2, 'color' , [ 1 - jj*0.1   0 + jj*0.1  0 ] , 'LineWidth', 1 ) ;
hold on

end

if kk ==1
    ylabel('Total Gd-EOB-DTPA (\mumol)');
    xlabel('Time (min)');
end

xticks([0 60]);
ylim([0 6.5e-4]); yticks([ 0 6.5e-4]);
set(gca, 'fontsize', 12)


end
set(gcf,'color','w');











