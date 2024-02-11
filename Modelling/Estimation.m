
clear
clc
close all

format long
format compact

linklr

estimation_choice_menu

%%
    
tmp1 = {'id_pre_n_post', 'id_pre'};

if contains(modelName,'resection')
    tmp1 = {'id_pre_n_post'};
end

for ii = 1:size(tmp1,2)
    id_data_type =  tmp1{ii}  ;

    if strcmp( id_data_type, 'id_pre_n_post') %% TO IDENTIFY AND RUN PATIENTS WITH BOTH OR ONLY A SINGLE EXAMINATION
        e={'U2','U3'};  type_folder = 'U2_U3';
    else
        e={'U2'};  type_folder = 'U2';
    end

    for kk = 1:size(e,2) %% LOOPING OVER EXAMINATIONS U2, U3
        exam = e{kk};

        for iii = 1:size(id,2) %% LOOPING OVER PATIENTS

            if contains( modelName, 'personalized') || contains( modelName, '8C') %% 1) CHECKING TYPE OF MODEL. PERSONLIZED 2C or 8C

                pat = id{iii}; disp(strcat('Estimating:,', pat,'-', exam ))
                if isfield( D.(pat).(exam) , 'LiverVolume' ) %% Checking if the data struct contain the field LiverVolume

                    % The field LiverVolume contatins two fields: MiaLab and CT data for livervolume.
                    if isfield( D.(pat).(exam).LiverVolume, Volume_string ) %% Checking for CT/Mialab data for the specific patient and examuination

                        if contains( modelName, 'resection') %% Checking are we running a resection model?
                            % Extract both the U2 (pre) and U3 (post) resection volume data
                            D.(pat).U2.LiverVolume = D.(pat).U2.LiverVolume.(Volume_string);
                            D.(pat).U3.LiverVolume = D.(pat).U3.LiverVolume.(Volume_string);
                        else
                            D.(pat).(exam).LiverVolume = D.(pat).(exam).LiverVolume.(Volume_string);
                        end
                        [anonymous, problem, opts ] = setupEstimation(modelName, signaltype, pat, exam, D ,meta_data, doScale,doBounds); %% <-- Setting up estimation, parameter bounds etc..

                        problem.x_0 = problem.x_0.*rand(1,length(problem.x_0));
                        Results = run_opt(problem,opts,anonymous ); % call to estimation function
                    else
                        pat = id{iii}; disp(strcat('No volume - :,', pat,'-', exam ))
                        continue
                    end
                end
            else %%  No personlization.
                pat = id{iii}; disp(strcat('Estimating:,', pat,'-', exam ))

                [anonymous, problem, opts ] = setupEstimation(modelName, signaltype, pat, exam, D ,meta_data, doScale,doBounds);

                problem.x_0 = problem.x_0.*rand(1,length(problem.x_0));
                Results = run_opt(problem,opts,anonymous );
            end
            %% Saving Results and figures
            tmp2 = strcat( SaveFolder ,type_folder,'/',pat, '/', exam ); % Creating the path and name of the same folder

            if ~exist(tmp2,'dir')
                mkdir(tmp2)
            end

            [fig] =save_model_estimation( Results, D, Mdata, modelName, signaltype,doScale, pat, exam  , SaveFolder ) ;

            %%% Saving estimation results
            save(sprintf('%s/optESS(%.2f), %s.mat',tmp2, Results.fbest,  datestr(now,'yymmdd-HHMM'))  ,'Results')
            %%% Saving figures
            saveas(fig, sprintf('%s/optESS(%.2f), %s.png',tmp2, Results.fbest,  datestr(now,'yymmdd-HHMM')) )
            saveas(fig, sprintf('%s/optESS(%.2f), %s.fig',tmp2, Results.fbest,  datestr(now,'yymmdd-HHMM')) )
            close all
        end
    end
end



%%
function [fig] =save_model_estimation( Results, D, Mdata, modelName, signaltype, doScale, pat, exam, SaveFolder )

if strcmp( modelName, 'forsgren_NoBack_personalized') % Setting up to be able to plot.
    eval(strcat('Data = D.', pat, '.' ,exam,';') );
    eval(strcat('Mdata = meta_data.', pat,';') );

    thetax = [exp(Results.xbest) Data.LiverVolume.total Mdata.BloodVolume Mdata.BW ]  ;
    fig = plot_model_fit(D, modelName, signaltype,doScale, pat, exam, thetax ); % Plotting figure

elseif strcmp( modelName, 'forsgren_NoBack_8C')
    eval(strcat('Mdata = meta_data.', pat,';') );
    thetax =  Results.xbest; % OBS no exp... the parameter vector for simulation is built in the plot function.

    fig = plot_model_fit_8C(D, modelName, signaltype,doScale, pat, exam, thetax, Mdata) ;

elseif strcmp( modelName, 'forsgren_NoBack_8C_resection')
    eval(strcat('Mdata = meta_data.', pat,';') );
    thetax =  Results.xbest; % OBS no exp... the parameter vector for simulation is built in the plot function.

    fig = figure(1);
    plot_model_fit_8C_resection(D, modelName, signaltype,doScale, pat, exam, thetax, Mdata) ;

end

    tmp2 = strcat( SaveFolder ,type_folder,'/',pat, '/', exam ); % Creating the path and name of the same folder

    if ~exist(tmp2,'dir')
        mkdir(tmp2)
    end

end

%%
function [anonymous, problem, opts ] = setupEstimation(modelName, signaltype, pat, exam, D ,meta_data, doScale,doBounds)
global p0

if contains(modelName, 'resection')
    eval(strcat('Data = D.', pat,';') );
    eval(strcat('Mdata = meta_data.', pat,';') );
else
    eval(strcat('Data = D.', pat, '.' ,exam,';') );
    eval(strcat('Mdata = meta_data.', pat,';') );
end

if  strcmp(modelName, 'forsgren_NoBack_personalized' )
    
    anonymous = @(theta)  CostFunction_global(theta,modelName, Data,Mdata , signaltype, doScale);
    [problem, opts]=options_ess(modelName,doBounds);
    
    
elseif strcmp(modelName, 'forsgren_NoBack_8C' )
    
    anonymous = @(theta)  CostFunction_8C(theta,modelName, Data, Mdata,  doScale);
    [problem, opts]=options_ess_8C(p0,modelName,doBounds);
    
elseif   strcmp(modelName, 'forsgren_NoBack_8C_resection' )   
    
    if  ~strcmp(exam, 'U3' )
        
        anonymous = @(theta)  CostFunction_8C_resection(theta,modelName, Data,Mdata, doScale);
        [problem, opts]=options_ess_8C(p0,modelName,doBounds);
    end
  
end

end

%%
function [ Results] = run_opt(problem,opts,anonymous)

    %%% optimization
    warning('off','all')
    optim_algorithm = 'ess'; % 'multistart'; %  'cess'; %
    Results = MEIGO(problem,opts,optim_algorithm,anonymous);
    
    fitting_speed     = Results.time(end);
    best_fs           = Results.fbest;
    parameters_ess    = Results.xbest';
    X=parameters_ess;
    w = warning ('on','all');
       

end







