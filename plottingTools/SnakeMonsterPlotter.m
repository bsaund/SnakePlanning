classdef SnakeMonsterPlotter < handle

    methods(Access = public)
        function this = SnakeMonsterPlotter()
            this.lfLeg = this.getLeg();
            this.lmLeg = this.getLeg();
            this.lbLeg = this.getLeg();
            this.rfLeg = this.getLeg();
            this.rmLeg = this.getLeg();
            this.rbLeg = this.getLeg();
            
            this.lfLeg.setBaseFrame(...
                this.trans([.07,.1,0,pi/2,0,pi/2]));
            this.lmLeg.setBaseFrame(...
                this.trans([.07,0,0,pi/2,0,pi/2]));
            this.lbLeg.setBaseFrame(...
                this.trans([.07,-.1,0,pi/2,0,pi/2]));
            this.rfLeg.setBaseFrame(...
                this.trans([-.07,.1,0,-pi/2,0,pi/2]));
            this.rmLeg.setBaseFrame(...
                this.trans([-.07,0,0,-pi/2,0,pi/2]));
            this.rbLeg.setBaseFrame(...
                this.trans([-.07,-.1,0,-pi/2,0,pi/2]));
            
            c = [.7,.7,.7];
            light('Position',[0,0,100],'Color',c);
            light('Position',[-100,0,0],'Color',c);
            light('Position',[100,0,0],'Color',c);
            light('Position',[0,-100,0], 'Color',c);
            light('Position',[0,100,0],'Color',c);
            
        end
        
        function plot(this,angles)
            this.lfLeg.plot(angles(1:3));
            this.lmLeg.plot(angles(4:6));
            this.lbLeg.plot(angles(7:9));
            this.rfLeg.plot(angles(10:12));
            this.rmLeg.plot(angles(13:15));
            this.rbLeg.plot(angles(16:18));
            drawnow
        end
    end
    
    methods(Access = private, Hidden = true)
        function plt = getLeg(this)
            links = {{'FieldableElbowJoint'},
                     {'FieldableElbowJoint'},
                     {'FieldableStraightLink', 'ext1', .05, 'twist', pi/2},
                     {'FieldableElbowJoint'},
                     {'FieldableStraightLink', 'ext1', .1, 'twist', 0}};
            plt = HebiPlotter('JointTypes', links, 'lighting','off',...
                              'drawWhen','later');
        end
        
        
        function m = trans(this, xyzrpy)
            m = eye(4);
            m(1:3, 4) = xyzrpy(1:3);
            m = m*this.rotz(xyzrpy(6)) *this.roty(xyzrpy(5))*...
                this.rotx(xyzrpy(4));
        end
            
            
        function m = roty(this, theta)
        %Homogeneous transform matrix for a rotation about y
            m = [cos(theta),  0, sin(theta), 0;
                 0,           1, 0,          0;
                 -sin(theta), 0, cos(theta), 0;
                 0,           0, 0,          1];
        end
        
        function m = rotx(this, theta)
        %Homogeneous transform matrix for a rotation about y
            m = [1,  0,          0,          0;
                 0,  cos(theta),-sin(theta), 0;
                 0,  sin(theta), cos(theta), 0;
                 0,           0, 0,          1];
        end
        
        function m = rotz(this, theta)
        %Homogeneous transform matrix for a rotation about y
            m = [cos(theta), -sin(theta), 0, 0;
                 sin(theta),  cos(theta), 0, 0;
                 0          , 0, 1,          0;
                 0,           0, 0,          1];
        end
        


    end
    
    properties(Access = private, Hidden = true)
        lfLeg;
        lmLeg;
        lbLeg;
        rfLeg;
        rmLeg;
        rbLeg;
    end
end