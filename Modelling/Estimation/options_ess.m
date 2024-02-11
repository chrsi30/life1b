function [problem, opts]= options_ess(modelName, doBounds )


if strcmp(doBounds, 'OrgBound') % Using the param-space defined in forsgren et al.

x0_kef     = 3.8e-4   ;% Hep -> Bile [1/s]
x0_kdiff   = 1.7e-3   ;% EES/blood plasma diffusion [1/s]
x0_ki      = 4.7e-3   ;% Plasma -> Hepatocyte [1/s]
x0_kback   = 2.8e-4   ;% Hepatocyte -> Plasma [1/s]
x0_kstress = 0.5      ;% Global stress factor after resecton [dim]
x0_scale   = 1.6      ;% Scaling factor   [dim]

ub_kef     = 5e-4;   lb_kef     = 1e-5;
ub_kdiff   = 0.05;   lb_kdiff   = 1e-4;
ub_ki      = 0.1;    lb_ki      = 1e-5;
ub_kback   = 5e-4;   lb_kback   = 1e-7;
ub_kstress = 1.9;    lb_kstress = 0.05;
ub_scale   = 10;     lb_scale   = 0.1;

elseif strcmp(doBounds, 'forsgren_ci')
    
x0_kef     = 3.8e-4   ;% Hep -> Bile [1/s]
x0_kdiff   = 1.7e-3   ;% EES/blood plasma diffusion [1/s]
x0_ki      = 4.7e-3   ;% Plasma -> Hepatocyte [1/s]
x0_kback   = 2.8e-4   ;% Hepatocyte -> Plasma [1/s]
x0_kstress = 0.5      ;% Global stress factor after resecton [dim]
x0_scale   = 1.6      ;% Scaling factor   [dim]

ub_kef = 6.657e-4   ; lb_kef     = 2.108e-4 ; 

ub_kdiff = 2.915e-3 ; lb_kdiff   = 9.626e-4 ;

ub_ki =6.682e-3     ; lb_ki      = 3.265e-3 ;

ub_kback = 6.754e-4 ; lb_kback   = 4.593e-6 ; 

ub_kstress = 1.9    ; lb_kstress = 0.05;

ub_scale =1.801     ; lb_scale   = 1.431    ;

    
else
    disp('Check doBounds input string');
end

if  strcmp( modelName, 'forsgren_NoBack_personalized')

x0    = log([x0_kef   x0_kdiff   x0_ki       x0_scale]);
lb =  log([lb_kef, lb_kdiff,  lb_ki,   lb_scale]); ub =  log([ub_kef, ub_kdiff,  ub_ki,   ub_scale]);

else
    
x0    = log([x0_kef   x0_kdiff   x0_ki   x0_kback    x0_scale]);
lb =  log([lb_kef, lb_kdiff,  lb_ki, lb_kback,  lb_scale]); ub =  log([ub_kef, ub_kdiff,  ub_ki, ub_kback,  ub_scale]);  

end
    

%% MEIGO OPTIONS I (COMMON TO ALL SOLVERS):
opts.ndiverse     = 'auto'; %100; %500; %5; %
opts.maxtime      = 10; % In cess this option will be overwritten
opts.maxeval      = 1e9;
opts.log_var      = [];

opts.local.solver = 'dhc'; %'dhc'; %'fmincon'; %'nl2sol'; %'mix'; %
opts.local.finish = opts.local.solver;
opts.local.bestx = 0;

problem.x_L       = lb;
problem.x_U       = ub;

problem.f         = 'meigoDummy';
problem.x_0       = x0;

% %% MEIGO OPTIONS II (FOR ESS AND MULTISTART):
opts.local.iterprint = 1;

%% MEIGO OPTIONS III (FOR ESS ONLY):
opts.dim_refset   = 'auto'; %

%% OPTIONS AUTOMATICALLY SET AS A RESULT OF PREVIOUS OPTIONS:
if(strcmp(opts.local.solver,'fmincon'))
    opts.local.use_gradient_for_finish = 1; %DW: provide gradient to fmincon
else
    opts.local.use_gradient_for_finish = 0; %DW: provide gradient to fmincon
end
opts.local.check_gradient_for_finish = 0; %DW: gradient checker



end


