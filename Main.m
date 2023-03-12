clear;
clc;
close all;
% format short
warning off

disp('Start Particle Swarm Optimization Algorithm :');

global choice
%% Call Function And Selection Benchmark
%%
choice = SelectBenchmark;

%% Inititation Parameter
%%
prompt={ ' Maximum Number of Iterations', ' Number of Particle(Population Size)', 'W', ' C1','C2','wdamp',...
'Number of Run'};
title='Enter a Value';
nline=([1 40;1 40;1 40;1 40;1 40;1 40;1 40]); 
default={ '300', '15', '20', '1.7', '2','0.99','1'};
ev=inputdlg(prompt,title,nline,default);
aa=ev(1,:);aa=str2num(aa{:});                        max_iteration=aa;                                                                              %  Maximum Number of Iterations
bb=ev(2,:);bb=str2num(bb{:});                   pop=bb;                                                                            %  Number of Partical (Population Size)
cc=ev(3,:);cc=str2num(cc{:});                       w=cc;                                                                                      % W
dd=ev(4,:);dd=str2num(dd{:});                     c1=dd;                                                                                        % C1
ff=ev(5,:);ff=str2num(ff{:});                             c2=ff;                                                                                              % C2
ee=ev(6,:);ee=str2num(ee{:});                     wd=ee;
gg=ev(7,:);gg=str2num(gg{:});
% gg=ev(6,:);gg=str2num(gg{:});                     run=gg;

particle.position=[];
particle.velocity=[];
particle.cost=[];
particle.pbest=[];
particle.pbestcost=[];
tic


xmin=-10;
xmax=10;
dx=xmax-xmin;
vmax=0.1*dx;

particle=repmat(particle,pop,1);
for ii=1:gg
gbest=zeros(max_iteration,pop);
gbestcost=zeros(max_iteration,1);

for iteration=1:max_iteration
    r1=rand;
    r2=rand;
    if iteration==1
        gbestcost(1)=inf;
        for i=1:pop
            particle(i).velocity=zeros(1,pop);
            particle(i).position=xmin+(xmax-xmin)*rand(1,pop);
            particle(i).cost=Cost(particle(i).position);

            particle(i).pbest=particle(i).position;
            particle(i).pbestcost=particle(i).cost;

            if particle(i).pbestcost<gbestcost(iteration)
                gbest(iteration,:)=particle(i).pbest;
                gbestcost(iteration)=particle(i).pbestcost;
            end
        end
    else
        gbest(iteration,:)=gbest(iteration-1,:);
        gbestcost(iteration)=gbestcost(iteration-1);
        for i=1:pop
            particle(i).velocity=w*particle(i).velocity...
                +c1*r1*(particle(i).pbest-particle(i).position)...
                +c2*r2*(gbest(iteration,:)-particle(i).position);

            particle(i).velocity=min(max(particle(i).velocity,-vmax),vmax);

            particle(i).position=particle(i).position+particle(i).velocity;

            particle(i).position=min(max(particle(i).position,xmin),xmax);

            particle(i).cost=Cost(particle(i).position);

            if particle(i).cost<particle(i).pbestcost
                particle(i).pbest=particle(i).position;
                particle(i).pbestcost=particle(i).cost;

                if particle(i).pbestcost<gbestcost(iteration)
                    gbest(iteration,:)=particle(i).pbest;
                    gbestcost(iteration)=particle(i).pbestcost;
                end
            end
        end
    end

    disp(['Iteration ' num2str(iteration) ':   Best Cost = ' num2str(gbestcost(iteration))]);

    w=w*wd;
end

ListBestCost(ii,1)=gbestcost(iteration);
bbb=min(ListBestCost);
disp('--------------------------------------------------------------------------------------------')
disp (['Best Cost in the This Run : ', num2str(bbb)])
disp('--------------------------------------------------------------------------------------------')
figure;
plot(gbestcost);
Average1(1,ii)=mean(ListBestCost);


end
figure('name','Average')
plot(Average1);
% Xlebel('Average')
disp('--------------------------------------------------------------------------------------------')
% Average=mean(ListBestCost);
disp (['Average : ', num2str(Average1(1,:))])
disp (['Time : ', num2str(toc)])
disp ('-------------------------------------------------------------------------------------------' )


clear prompt title nline default ev aa bb cc dd ee ff i ii dx choice iteration run



