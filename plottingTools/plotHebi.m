function plotHebi(kin, angles, low_res)
% Plots a Hebi Kinematics object
% Currently assumes all bodies are Fieldable Elbow Joint
% @kin: A HebiKinematics object describing the robot to be plotted
% @angles: A vector of joint angles of the object
% @low_res: Optional parameter to use low resolution meshes for
% faster plotting    

    persistent PATCH_HANDLES 
    if(nargin < 3)
        low_res = false;
    end

    if(isFirstrun(PATCH_HANDLES))
        PATCH_HANDLES = plotInitial(kin, angles, low_res, ...
                                      PATCH_HANDLES);
    else
        updatePlot(kin, angles, low_res, PATCH_HANDLES)
    end
    
    drawnow
end

function firstrun = isFirstrun(handles)
%Returns if this is the first run of the program
%Exists if the window has been closed
% This is determined by checking if the handles already exist
    persistent TIME_SINCE_LAST_CALL
    
    for i=1:length(handles)
        if(~ishandle(handles(i))) 
            if( isa(TIME_SINCE_LAST_CALL, 'numeric') && ...
                toc(TIME_SINCE_LAST_CALL) < .5)
            
                error('Window closed, quitting');
            else
                firstrun = true;
                return
            end
        end
    end
    TIME_SINCE_LAST_CALL = tic;
    firstrun = length(handles) == 0;
end

function h = plotInitial(kin, angles, low_res, h)
%Plots the links using patch
%Returns a list of handles to all of the patch objects

    fk = kin.getForwardKinematics('CoM',angles);
    [upper, lower] = loadMeshes(low_res);

    p = 1;
    for i=1:kin.getNumBodies()
        h(p) = patch(transformSTL(lower, fk(:,:,i)), ...
                     'FaceColor', [.5,.1,.2],...
                     'EdgeColor', 'none',...
                     'FaceLighting', 'gouraud', ...
                     'AmbientStrength', 0.3);
        p = p+1;
        
        h(p) = patch(transformSTL(upper, fk(:,:,i)*roty(angles(i))), ...
                     'FaceColor', [.5,.1,.2],...
                     'EdgeColor', 'none',...
                     'FaceLighting', 'gouraud', ...
                     'AmbientStrength', 0.3);
        p = p+1;
    end

    % This is how I saved the meshes (orinally loaded from an stl file)
    % save('FieldableKinematicsPatch_low_res','lower','upper')
    
    %Initialize lights, camera, axes
    % camlight('headlight');
    % camlight()
    light('Position',[0,0,10]);
    light('Position',[5,0,10]);
    light('Position',[-5,0,10]);

    % light('Position',[0,0,10]);
    axis('image');
    view([45, 35]);
    % camlight()
    xlabel('x');
    ylabel('y');
    zlabel('z');
end

function updatePlot(kin, angles, low_res, h)
%Updates the link patches that were previously plotted
    fk = kin.getForwardKinematics('CoM',angles);
    [upper, lower] = loadMeshes(low_res);

    p=1;
    for i=1:kin.getNumBodies()
        fv = transformSTL(lower, fk(:,:,i));
        set(h(p), 'Vertices', fv.vertices(:,:));
        set(h(p), 'Faces', fv.faces);
        p = p+1;
        fv = transformSTL(upper, fk(:,:,i)*roty(angles(i)));
        set(h(p), 'Vertices', fv.vertices(:,:));
        set(h(p), 'Faces', fv.faces);
        p = p+1;
    end
end


function [upper, lower] = loadMeshes(low_res)
%Returns the relevent meshes
%Based on low_res different resolution meshes will be loaded
    
    %This was how I originally transformed from the .stl files 
    %  to matlabe files, which I saved
    % lower = stlread('stl/rotary_input_low_res.stl');
    % upper = stlread('stl/rotary_output_low_res.stl');
    % lower = transformSTL(lower, rotx(pi/2));
    % upper = transformSTL(upper, rotx(pi/2));
        
    if(low_res)
        meshes = load('FieldableKinematicsPatchLowRes');
    else
        meshes = load('FieldableKinematicsPatch');
    end
    lower = meshes.lower;
    upper = meshes.upper;

end

function fv = transformSTL(fv, trans)
%Transforms from the base frame of the mesh to the correctly
%location in space
    fv.vertices = (trans * [fv.vertices, ones(size(fv.vertices,1), ...
                                              1)]')';
    fv.vertices = fv.vertices(:,1:3);

end
    
function m = rotx(theta)
%Homogeneous transform matrix for a rotation about x
    m = [1, 0,          0,          0;
         0, cos(theta), -sin(theta),0;
         0, sin(theta), cos(theta), 0;
         0, 0,          0,          1];
end

function m = roty(theta)
%Homogeneous transform matrix for a rotation about y
    m = [cos(theta),  0, sin(theta), 0;
         0,           1, 0,          0;
         -sin(theta), 0, cos(theta), 0;
         0,           0, 0,          1];
end

function m = rotz(theta)
%Homogeneous transform matrix for a rotation about z
    m = [cos(theta), -sin(theta), 0, 0;
         sin(theta),  cos(theta), 0, 0;
         0,          0,           1, 0;
         0,          0,           0, 1];
end