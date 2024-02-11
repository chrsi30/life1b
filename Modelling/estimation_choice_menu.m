
%% Model.
% Choice of model for parameter estimation. 
msg = "What model?";
opts = ["1. forsgren_NoBack_personalized" ...
        "2. forsgren_NoBack_8C" ...
        "3. forsgren_NoBack_8C_resection"  ];

choice = menu(msg,opts);
if     choice == 1 ;  modelName = 'forsgren_NoBack_personalized';
elseif choice == 2 ;  modelName = 'forsgren_NoBack_8C';
elseif choice == 3 ;  modelName = 'forsgren_NoBack_8C_resection';
end

if contains(modelName, '8C' ) 
model_dir = './Models/8C' ; 
else
model_dir = './Models/2C' ; 
end

cd(model_dir)

optModel = SBmodel([modelName '.txt']);  
SBPDmakeMEXmodel(optModel,modelName); 
ic = SBinitialconditions(modelName);
[pNames,p0] = SBparameters(modelName); %% Setting up SBtoolbox model

global p0

cd ../..


%% Choice of data normalization.
% Type of normalization for the data standard error. The (2) sample mean
% SEM.
if contains(modelName, '8C' ) 
    load_string_data = '8C_20%' ; % <- Segments data does not have a SEM. 
    load(['../Data/D_', 'meanSEM','.mat']); % importing data 'MaxSEM' for Spleen SEM. 
else
load(['../Data/D_', 'MeanSEM','.mat']); % importing data
end
load('../Data/meta_data.mat'); % importing data
save_string_data = [ 'D_', load_string_data];

%% Choice of which volume dataset to use ; 
% Sorting - patients with avilable CT volume data 
e = {'U2'}; id =[]; count =0;
if contains( modelName, 'personalized') ||   contains( modelName, '8C')   
    msg = "Which volumes to use?";
    opts = ["1. CT" ...
            "2. MiaLab" ];
    choice = menu(msg,opts);
    if choice == 1
        Volume_string = 'CT';
    else
        Volume_string = 'MiaLab';
    end   
    
    for kk = 1:size(p,2)
        pat=p{kk};
        for jj = 1:size(e,2)
            exam = e{jj};
            eval(strcat('tmp = D.',pat,'.',exam ,';'))
            if isfield(tmp, 'LiverVolume')
                eval(strcat('tmp1 = D.',pat,'.',exam ,'.LiverVolume ;'))
                if isfield(tmp1, Volume_string)
                    count = count  + 1;
                    id{count} = pat;
                end
            end
        end
        
    end
else
    id = p;
end; clear pat;

%% Sortning patient for number of examinations
% Sorting - patients for number of examinations
count =0; count1 =0;
for kk = 1:size(id,2)
    eval(strcat('tmp1 = D.',id{kk}, ';'))
    if isfield(tmp1, 'U3')
        count = count  + 1;
        id_pre_n_post{count} = id{kk};
    else
        count1 = count1  + 1;
        id_pre{count1} = id{kk};
    end
end

%% Choice of signal type and scaling 
signaltype = 'Conc'; % signaltype = 'deltaR1';
msg = "Do scale?";
opts = ["1. Yes" ...
        "2. No" ];
choice = menu(msg,opts); 
if choice == 1
    doScale = 1; scale_string = 'scale';

else
    doScale = 0;
    scale_string = 'no_scale';
end

%% Choice of what parameter bounds to use.
msg = "What bounds?";
opts = ["1. Forsgren et al. (2014) CI" ...
        "2. Forsgren, Karlsson et al. (2017) Est. Bounds" ];
choice = menu(msg,opts); 

if choice == 1
    doBounds  = 'forsgren_ci'; 
else
    doBounds  = 'OrgBound'; 
end 
