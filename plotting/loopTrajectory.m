
function loopTrajectory(plottingFunc, angle_traj, varargin)
    angle_traj = angle_traj';
    while true
        for i= 1:size(angle_traj, 1)
            plottingFunc(angle_traj(i,:), varargin{:});
            if(i==1)
                pause(1)
            end
        end
        pause(1)
    end
end


% function loopTrajectory(snake, world, spring, angle_traj, useRealistic)
% %% Repeat trajectory
%     angle_traj = angle_traj';
%     if(nargin < 5)
%         useRealistic = false;
%     end
%     plt = HebiPlotter('resolution','high', 'drawWhen', 'later', ...
%                       'figureHandle', gcf);
%     plt.setBaseFrame(snake.frame);
%     while true
%         for i= 1:size(angle_traj, 1)
%             if useRealistic
%                 plt.plot(angle_traj(i,:));
%             else
%                 snake.plotTorques(angle_traj(i,:), world, spring);
%             end
%             axis([-1,1,-1,1,-1,1])
%             % axis(.5*[-1,1,-1,1,-1,1])
%             drawnow
%             if(i==1)
%                 pause(3)
%             end
%         end
%         pause(3)
% %         useRealistic = ~useRealistic;
%     end

% end
