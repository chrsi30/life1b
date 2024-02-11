clear all
clc
close all


    if ~contains(path, "SBTOOLBOX")
        disp('Please install: http://www.sbtoolbox2.org/main.php?display=documentationSBT&menu=overview')
    end


msg = "What to do?";
opts = ["1. Run parameter estimation" ...
        "2. Plot article figure" ];

choice = menu(msg,opts);


%% Estimation
if     choice == 1
    if ~contains(path, "MEIGO")
        disp('Please install MEIGO toolbox : https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-15-136; https://github.com/gingproc-IIM-CSIC/MEIGO64')
    end
    cd('Modelling\');
    Estimation


    cd ..

    %%
elseif choice == 2
    addpath(genpath('./Modelling')) ;
    addpath(genpath('./Analysis')) ;

    msg = "What to do?";
    opts = ["1. Figure 2" ...
        "2. Figure 3" ...
        "3. Figure 4" ...
        "4. Figure 5" ...
        "5. Figure 6"  ];

    choice = menu(msg,opts);

    %% Figure 2
    if choice ==1
        cd('.\Modelling\')
        Plot_model_simulation_example_Fig2
        cd ..
        cd('.\Analysis\')
        Plot_Figure_2_C
        Plot_Figure_2_D
        cd ..

        %% Figure 3
    elseif choice == 2
        cd('.\Analysis\')
        Plot_Figure_3_B
        cd ..
        cd('.\Modelling\')
        Plot_Figure_3_C
        cd ..

        %% Figure 4
    elseif choice == 3
        cd('.\Modelling\')
        Plot_Figure_4_B
        Plot_Figure_4_C
        cd ..

        %% Figure 5
    elseif choice == 4
        cd('.\Modelling\')
        Plot_Figure_5_C
        Plot_Figure_5B_extended
        Plot_Figure_5B_major
        Plot_Figure_5B_minor
        cd ..
        %% Figure 6
    elseif choice == 5
        cd('.\Modelling\')
        Plot_Figure_6BCD
        Plot_Figure_6EF
        cd ..
    end

end