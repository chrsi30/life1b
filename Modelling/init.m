global p0 

set(0, 'DefaultFigureRenderer', 'painters');

%% Generating paths to folders
%linklr

%% Generating pateints ids
%generate_id

%% Setting up SBtoolbox model
cd(model_dir)

optModel = SBmodel([modelName '.txt']);
SBPDmakeMEXmodel(optModel,modelName);
ic = SBinitialconditions(modelName);
[pNames,p0] = SBparameters(modelName);

cd ../..



