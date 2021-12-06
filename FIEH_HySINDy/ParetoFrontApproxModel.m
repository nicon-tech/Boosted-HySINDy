%% Further validation
% Run regress FIEH Model
% Run this code after the main code

% function[ ] = ApproxModel( );
% variables in data are: time, t, vertical position, y, vertical velocity, yp and
% acceleration

yoverFcn = @(t, y) events_FIEH2(t,y,stroke,Yi);
options = odeset('RelTol',1e-12,'AbsTol',1e-12, 'Events', yoverFcn);
% tspan_in = p.tspan;
% plottag = p.plottag;
% yinitvec = p.yinitvec;
% options = p.options;
jj=3;% impactTop model number
uu=2;% impactDown model number

for kk=3 % model combination number
    clear yinit z_outm t_outm y1 t1 tspan current_t tend
    yinit = z_out(1,:);
    
    tspan = t_out./dt;
    
    dt = tspan(2)-tspan(1);
    tend = tspan(end);
    
    % current_t = 0; % starting value of the current time
    t_outm = []; z_outm = []; zdot_outm = [];
    
    % for mm = 1:size(yinitvec,1) %data creation(/<=>measurements) for each initial conditions
    %     mm
    %     yinit  = yinitvec(mm,:)
    current_t = 0; % starting value of the current time
    t_outm = [t_outm; 0];
    z_outm = [z_outm; yinit]; % y_out contain both vertical position and velocity
    %     a_out = [a_out; hopperspring(0,yinit',kappa)']; % a_out contain both vertical acceleration and velocity
    %NOTE_NN: a_out = [a_out; hopperspring(0,yinit',kappa)'] implica che si
    %parta in regime di spring
    t1= 0;
    
    % m*xpp = -m*g - k(x-x0), x<=x0
    % m*xpp = -m*g,            x>x0
    while current_t < tend
        if length(tspan)>1 % check that we haven't reached the end within error
            if abs(yinit(1)+(stroke/2))<1e-12 % if we are within error of transition
                if yinit(2)<0 % springing if velocity is negative
                    yinit(1) =  -(stroke/2)-1e-12;
                    clear Xicomb
                    Xicomb = Cluster_impactDown.Xistruct.Xicomb;
                    for ii = uu %:length(Xicomb)
                        disp('Cluster down impact')
                        disp(['Model num:' num2str(ii) ' of ' num2str(length(Xicomb)) ' for this cluster'])
                        Xi_impact_down = [Xicomb{ii}(:,1), Xicomb{ii}(:,2)]
                        model_complexity_impact_down = nnz(Xi_impact_down);
                        [t1,y1] = ode45(@(t,y)sparseGalerkin(t,y,Xi_impact_down,polyorder_impactDown,polyorder_impactDown_x,polyorder_impactDown_y,usesine_impactDown),tspan,yinit,options);  % approximate
                        %                         a_mod_impactDown = diff(x_mod_impactDown(:,2));
                        %     a_mod_springDown = sparseGalerkin(t_mod_spring,x_mod_spring',Xi_spring,polyorder_spring,polyorder_spring_x,polyorder_spring_y,usesine_spring);  % approximate
                    end
                    
                    figure(1)
                    plot(t1,y1(:,1))
                    hold on
                    drawnow
                else % free
                    yinit(1) =  -(stroke/2)+1e-12;
                    clear Xicomb
                    Xicomb = Cluster_free.Xistruct.Xicomb;
                    for ii = kk %:length(Xicomb)
                        disp('Cluster free')
                        disp(['Model num:' num2str(ii) ' of ' num2str(length(Xicomb)) ' for this cluster'])
                        Xi_free = [Xicomb{ii}(:,1), Xicomb{ii}(:,2)]
                        model_complexity_free = nnz(Xi_free);
                        [t1,y1] = ode45(@(t,y)sparseGalerkin(t,y,Xi_free,polyorder_free,polyorder_free_x,polyorder_free_y,usesine_free),tspan,yinit,options);  % approximate
                        %                         a_mod_free1 = diff(x_mod_free1(:,2));
                        %     a_mod_flight = sparseGalerkin(t_mod_flight,x_mod_flight',Xi_flight,polyorder_flight,polyorder_flight_x,polyorder_flight_y,usesine_flight);  % approximate
                    end
                    
                    plot(t1,y1(:,1))
                    hold on
                    drawnow
                end
            elseif abs(yinit(1)-(stroke/2))<1e-12 % if we are within error of transition
                if yinit(2)>0
                    yinit(1) =  (stroke/2)+1e-12;
                    clear Xicomb
                    Xicomb = Cluster_impactTop.Xistruct.Xicomb;
                    for ii = jj %:length(Xicomb)
                        disp('Cluster top impact')
                        disp(['Model num:' num2str(ii) ' of ' num2str(length(Xicomb)) ' for this cluster'])
                        Xi_impact_top = [Xicomb{ii}(:,1), Xicomb{ii}(:,2)]
                        model_complexity_impact_top = nnz(Xi_impact_top);
                        [t1,y1] = ode45(@(t,y)sparseGalerkin(t,y,Xi_impact_top,polyorder_impactTop,polyorder_impactTop_x,polyorder_impactTop_y,usesine_impactTop),tspan,yinit,options);  % approximate
                        %                     a_mod_impactTop = diff(x_mod_impactTop(:,2));
                        %     a_mod_spring = sparseGalerkin(t_mod_spring,x_mod_spring',Xi_spring,polyorder_spring,polyorder_spring_x,polyorder_spring_y,usesine_spring);  % approximate
                    end
                    plot(t1,y1(:,1))
                    hold on
                    drawnow
                else %free
                    yinit(1) =  (stroke/2)-1e-12;
                    clear Xicomb
                    Xicomb = Cluster_free.Xistruct.Xicomb;
                    for ii = kk%:length(Xicomb)
                        disp('Cluster free')
                        disp(['Model num:' num2str(ii) ' of ' num2str(length(Xicomb)) ' for this cluster'])
                        Xi_free = [Xicomb{ii}(:,1), Xicomb{ii}(:,2)]
                        model_complexity_free = nnz(Xi_free);
                        [t1,y1] = ode45(@(t,y)sparseGalerkin(t,y,Xi_free,polyorder_free,polyorder_free_x,polyorder_free_y,usesine_free),tspan,yinit,options);  % approximate
                        %                         a_mod_free1 = diff(x_mod_free1(:,2));
                        %     a_mod_flight = sparseGalerkin(t_mod_flight,x_mod_flight',Xi_flight,polyorder_flight,polyorder_flight_x,polyorder_flight_y,usesine_flight);  % approximate
                    end
                    
                    plot(t1,y1(:,1))
                    hold on
                    drawnow
                end
                
            elseif (yinit(1)+(stroke/2))<0
                clear Xicomb
                Xicomb = Cluster_impactDown.Xistruct.Xicomb;
                for ii = uu %:length(Xicomb)
                    disp('Cluster down impact')
                    disp(['Model num:' num2str(ii) ' of ' num2str(length(Xicomb)) ' for this cluster'])
                    Xi_impact_down = [Xicomb{ii}(:,1), Xicomb{ii}(:,2)]
                    model_complexity_impact_down = nnz(Xi_impact_down);
                    [t1,y1] = ode45(@(t,y)sparseGalerkin(t,y,Xi_impact_down,polyorder_impactDown,polyorder_impactDown_x,polyorder_impactDown_y,usesine_impactDown),tspan,yinit,options);  % approximate
                    %                         a_mod_impactDown = diff(x_mod_impactDown(:,2));
                    %     a_mod_springDown = sparseGalerkin(t_mod_spring,x_mod_spring',Xi_spring,polyorder_spring,polyorder_spring_x,polyorder_spring_y,usesine_spring);  % approximate
                end
                plot(t1,y1(:,1))
                hold on
                drawnow
            elseif (yinit(1)-(stroke/2))>0
                yinit(1) =  (stroke/2)+1e-12;
                clear Xicomb
                Xicomb = Cluster_impactTop.Xistruct.Xicomb;
                for ii = jj %:length(Xicomb)
                    disp('Cluster top impact')
                    disp(['Model num:' num2str(ii) ' of ' num2str(length(Xicomb)) ' for this cluster'])
                    Xi_impact_top = [Xicomb{ii}(:,1), Xicomb{ii}(:,2)]
                    model_complexity_impact_top = nnz(Xi_impact_top);
                    [t1,y1] = ode45(@(t,y)sparseGalerkin(t,y,Xi_impact_top,polyorder_impactTop,polyorder_impactTop_x,polyorder_impactTop_y,usesine_impactTop),tspan,yinit,options);  % approximate
                    %                     a_mod_impactTop = diff(x_mod_impactTop(:,2));
                    %     a_mod_spring = sparseGalerkin(t_mod_spring,x_mod_spring',Xi_spring,polyorder_spring,polyorder_spring_x,polyorder_spring_y,usesine_spring);  % approximate
                end
                plot(t1,y1(:,1))
                hold on
                drawnow
            else %free
                clear Xicomb
                Xicomb = Cluster_free.Xistruct.Xicomb;
                for ii = kk%:length(Xicomb)
                    disp('Cluster free')
                    disp(['Model num:' num2str(ii) ' of ' num2str(length(Xicomb)) ' for this cluster'])
                    Xi_free = [Xicomb{ii}(:,1), Xicomb{ii}(:,2)]
                    model_complexity_free = nnz(Xi_free);
                    [t1,y1] = ode45(@(t,y)sparseGalerkin(t,y,Xi_free,polyorder_free,polyorder_free_x,polyorder_free_y,usesine_free),tspan,yinit,options);  % approximate
                    %                         a_mod_free1 = diff(x_mod_free1(:,2));
                    %     a_mod_flight = sparseGalerkin(t_mod_flight,x_mod_flight',Xi_flight,polyorder_flight,polyorder_flight_x,polyorder_flight_y,usesine_flight);  % approximate
                end
                
                plot(t1,y1(:,1))
                hold on
                drawnow
            end
            t_outm = [t_outm; t1(2:end)];
            z_outm = [z_outm; y1(2:end,:)];
            %                 a_out = [a_out; a(2:end,:)];
            yinit = y1(end,:);
            tspan = t1(end):dt:tend+1;
            current_t = t_outm(end);
            
        end
        
    end
    % end
    %
    clear zdot_outm
    zdot_outm = diff(z_outm);
    t_outm = t_outm(1:end-1,:);
    z_outm = z_outm(1:end-1,:);
    %
    zdot_outm = zdot_outm(2:end,:);
    t_outm = t_outm(2:end,:);
    z_outm = z_outm(2:end,:);
%     % save data
%     data.zoutm = z_outm;
%     data.zdotoutm = zdot_outm;
%     data.toutm = t_outm;
    %
    zswitch_median_down = -0.015; %switch position 1
    zswitch_median_top = 0.015; %switch position 2
    
    % We find switch position by use xswitch_max because the algorithm
    % findchangepts find the switch prematurely. Then we use mean to add
    % statistic
    
    switch_index_impactDown = find(z_outm(:,1)<=zswitch_median_down);
    t_outm_impactDown = t_outm(switch_index_impactDown);
    z_outm_impactDown = z_outm(switch_index_impactDown,:);
    zdot_outm_impactDown = zdot_outm(switch_index_impactDown,:);
    %
    switch_index_impactTop = find(z_outm(:,1)>=zswitch_median_top);
    t_outm_impactTop = t_outm(switch_index_impactTop);
    z_outm_impactTop = z_outm(switch_index_impactTop,:);
    zdot_outm_impactTop = zdot_outm(switch_index_impactTop,:);
    %
    switch_index_free = find(z_outm(:,1)>zswitch_median_down & z_outm(:,1)<zswitch_median_top);
    t_outm_free = t_outm(switch_index_free);
    z_outm_free = z_outm(switch_index_free,:);
    zdot_outm_free = zdot_outm(switch_index_free,:);
    % plot dynamics
    figure
    plot(t_outm_impactDown.*dt./10^4,zdot_outm_impactDown(:,2),'r.','LineWidth',0.9) % approx model
    hold on
    plot(t_outm_free.*dt./10^4,zdot_outm_free(:,2),'b.','LineWidth',0.9) % approx model
    plot(t_outm_impactTop.*dt./10^4,zdot_outm_impactTop(:,2),'r.','LineWidth',0.9) % approx model
    plot(t_out,zdot_out(:,2),'k--','LineWidth',0.9) % measurements
    xlabel('$t [ ]$','interpreter','latex')
    ylabel('$\stackrel{..}{x} [ ]$','interpreter','latex');
    title('HySINDy - Acceleration','interpreter','latex')
    legend('impact','free','interpreter','latex')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure
    subplot(2,2,1)
    plot(t_out,z_out(:,1),'k--','LineWidth',0.9) % measurements
    hold on
    plot(t_outm_impactDown.*dt./10^4,z_outm_impactDown(:,1),'r.','LineWidth',0.9) % approx model
    plot(t_outm_free.*dt./10^4,z_outm_free(:,1),'b.','LineWidth',0.9) % approx model
    plot(t_outm_impactTop.*dt./10^4,z_outm_impactTop(:,1),'r.','LineWidth',0.9) % approx model
    xlabel('$t [ ]$','interpreter','latex')
    ylabel('$x [ ]$','interpreter','latex');
    title('HySINDy - Position','interpreter','latex')
    legend('training data','impact','free','interpreter','latex')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,2,2)
    plot(t_out,z_out(:,2),'k--','LineWidth',0.9) % measurements
    hold on
    plot(t_outm_impactDown.*dt./10^4,z_outm_impactDown(:,2),'r.','LineWidth',0.9) % approx model
    plot(t_outm_free.*dt./10^4,z_outm_free(:,2),'b.','LineWidth',0.9) % approx model
    plot(t_outm_impactTop.*dt./10^4,z_outm_impactTop(:,2),'r.','LineWidth',0.9) % approx model
    xlabel('$t [ ]$','interpreter','latex')
    ylabel('$\dot{x} [ ]$','interpreter','latex');
    title('HySINDy - velocity','interpreter','latex')
    legend('training data','impact','free','interpreter','latex')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,2,[3,4]);
    plot(z_out(:,1),z_out(:,2),'ko','LineWidth',0.9) % measurements
    hold on
    plot(z_outm_impactDown(:,1),z_outm_impactDown(:,2),'r.','LineWidth',0.9) % approx model
    plot(z_outm_free(:,1),z_outm_free(:,2),'b.','LineWidth',0.9) % approx model
    plot([zswitch_median_down zswitch_median_down], [1.3*min(z_out(:,2)) 1.3*max(z_out(:,2))],'k--','LineWidth',0.9)
    plot([zswitch_median_top zswitch_median_top], [1.3*min(z_out(:,2)) 1.3*max(z_out(:,2))],'k--','LineWidth',0.9)
    plot(z_outm_impactTop(:,1),z_outm_impactTop(:,2),'r.','LineWidth',0.9) % approx model
    xlabel('$x [ ]$','interpreter','latex')
    ylabel('$\dot{x} [ ]$','interpreter','latex')
    title('HySINDy - Phase space','interpreter','latex')
    legend('training data','impact','free','$x{switch}$','interpreter','latex')
    % plot Pareto front
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %t_Out = t span for validation
    t_Out = t_out./dt.*10^4;
    t_Outm = t_outm(t_outm<t_Out(end));
    z_Outm = z_outm(1:size(t_Outm,1),:);
    z_val1 = interp1(t_Outm,z_Outm(:,1),t_Out);
    z_val2 = interp1(t_Outm,z_Outm(:,2),t_Out);
    z_mod_val = [z_val1, z_val2];
    % z_out = z_measure_val
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [tlength, nterms] = size(z_mod_val);
    % calculate error B = A(~isnan(A))
    error1 = z_out(2:end-1,:)-z_mod_val(2:end-1,:); %error
    Error1 = [];
    for bb=1:2
        Error1 = [Error1, error1(~isnan(error1(:,bb)),bb)];
    end
    abserror = abs(Error1); %absolute error
    
    for bb=1:nterms % for each term
        abserror_avg_val(bb) = sum(abserror(:,bb))./(size(Error1,1)); %average abs error
        RMSE_val(bb) = sqrt(sum(abserror(:,bb).^2)./(size(Error1,1))); %root mean square error
    end
    
    abserror_val = [abserror_avg_val(:,1); abserror_avg_val(:,2)];
end
%%
%sequenze testate:
%impactTop = 28, 28, 28, 26, 24, 22, 20, 18, 7, 9, 11, 13, 15, 16, 16, 1, 3, 3, 5, 7, 9, 9, 11, 13, 15, 15, 15, 16, 16, 18,
% 20, 22, 24, 26, 28, 30
%impactDown = 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 7, 1, 3, 3, 3, 3, 3, 5, 5, 5, 5, 6, 7, 7, 7, 7, 7, 7, ...
%free = 2, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 3, 3, ...
%%
mean_e_val = []; RMSE = []; model_complexity = []; aic_c_val = [];
%%
mean_e_val = [mean_e_val; mean(abserror_avg_val)];
RMSE = [RMSE; sum(RMSE_val)./(size(error1,2))];
%evaluate the complexity of intere system of model
model_complexity = [model_complexity; model_complexity_free+model_complexity_impact_down+model_complexity_impact_top]; %intere system complexity

%Information criteria
IC_val{ee} = ICcalculations(abserror_val, model_complexity(ee,:), size(z_mod_val,1));
aic_c_val = [aic_c_val; IC_val{ee}.aic_c];
%     valsims_val{kk}.t_val = t_Out;
%     valsims_val{kk}.z_measure_val = z_out;
%%
minIC_val = min(aic_c_val);
relative_aic_c = abs(aic_c_val-minIC_val); %relative AIC_c
    
Cluster.abserror_avg = mean_e_val;
% Cluster_impact1.Xi_ind = Xi_select_val;
Cluster.RMSE = RMSE;
Cluster.IC = IC_val;
Cluster.aic_c = aic_c_val;
Cluster.numterms = model_complexity;
% Cluster_impactTop.valsims = valsims_val;
save Cluster_test2

%%
figure
plot(model_complexity,RMSE,'b*','LineWidth',0.9) % approx model
hold on
xlabel('$model complexity [ ]$','interpreter','latex')
ylabel('$RMSE [ ]$','interpreter','latex');
title('Pareto front','interpreter','latex')
legend('training','validation','interpreter','latex')
%%



