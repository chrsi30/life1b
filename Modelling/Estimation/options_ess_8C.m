function [problem, opts]= options_ess_8C(p0, modelName , doBounds)

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

elseif strcmp(doBounds, 'NewBound')
    
x0_kef     = 3.8e-4   ;% Hep -> Bile [1/s]
x0_kdiff   = 1.7e-3   ;% EES/blood plasma diffusion [1/s]
x0_ki      = 4.7e-3   ;% Plasma -> Hepatocyte [1/s]
x0_kback   = 2.8e-4   ;% Hepatocyte -> Plasma [1/s]
x0_kstress = 0.5      ;% Global stress factor after resecton [dim]
x0_scale   = 1.6      ;% Scaling factor   [dim]

ub_kef     = 1e3;   lb_kef     = 1e-6;
ub_kdiff   = 1e3;   lb_kdiff   = 1e-6;
ub_ki      = 1e3;    lb_ki     = 1e-6;
ub_kback   = 1e3;   lb_kback   = 1e-7;
ub_kstress = 1.9;    lb_kstress = 0.05;
ub_scale   = 10;     lb_scale   = 0.1;    
    
else
    disp('Check doBounds input string');
end



if strcmp ( modelName, 'forsgren_NoBack_8C') 
% lb =  log([1e-5*ones(1,8),... % kef         
%            1e-5*ones(1,8),... % ki
%            1e-4,...
%            0.1]);
       
lb =  log([lb_kef*ones(1,8),...           
           lb_ki*ones(1,8) ,...
           lb_kdiff,...
           lb_scale]);
       
       

ub =  log([ub_kef*ones(1,8),...           
           ub_ki*ones(1,8) ,...
           ub_kdiff,...
           ub_scale]);
       
problem.x_0             = [ p0(1:17)' 1 ];       
    
elseif strcmp ( modelName, 'forsgren_NoBack_8C_resection') 
% lb =  log([1e-5*ones(1,8),... % kef         
%            1e-5*ones(1,8),... % ki
%            1e-4,...
%            1e-1,...
%            0.1]);
% 
% 
% ub =  log([5e-4*ones(1,8),...           
%            0.1*ones(1,8) ,...
%            0.05,...
%            1e1,...
%            10]);      

lb =  log([lb_kef*ones(1,8),...           
           lb_ki*ones(1,8) ,...
           lb_kdiff,...
           lb_kstress,...
           lb_scale]);
       
       

ub =  log([ub_kef*ones(1,8),...           
           ub_ki*ones(1,8) ,...
           ub_kdiff,...
           ub_kstress,...
           ub_scale]);



%        
problem.x_0             = [ p0(1:18)' 1 ];       

 
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


