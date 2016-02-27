%% Plots a Hebi Kinematics object
% Currently assumes all bodies are Fieldable Elbow Joint
% @kin: A HebiKinematics object describing the robot to be plotted
% @angles: A vector of joint angles of the object
function plotHebi(kin, angles)
    persistent PATCH_HANDLES IS_LOW_RES PREV_TIME_TAKEN
    t0 = tic;
    firstrun = isFirstrun(PATCH_HANDLES);
    if(firstrun)
        IS_LOW_RES = false;
        PATCH_HANDLES = plotInitial(kin, angles, true, ...
                                      PATCH_HANDLES)
        PREV_TIME_TAKEN = 0;
    else
        updatePlot(kin, angles, IS_LOW_RES, PATCH_HANDLES)
    end
    drawnow
    PREV_TIME_TAKEN = .9*PREV_TIME_TAKEN + .1*toc(t0);
    IS_LOW_RES = adjustResolution(PREV_TIME_TAKEN, IS_LOW_RES)
end

function low_res = adjustResolution(time_taken, currently_low_res)
    time_taken
    if(currently_low_res)
        low_res = time_taken > 0.05;
    else
        low_res = time_taken > 0.1;
    end
end

function firstrun = isFirstrun(handles)
    for i=1:length(handles)
        if(~ishandle(handles(i)))
            firstrun = true;
            return;
        end
    end
    
    firstrun = length(handles) == 0;
end

function h = plotInitial(kin, angles, low_res, h)

    fk = kin.getForwardKinematics('CoM',angles);
    [upper, lower] = loadMeshes(low_res);

    p = 1;
    for i=1:kin.getNumBodies()
        h(p) = patch(transformSTL(lower, fk(:,:,i)), ...
                     'FaceColor', [1,.1,.2],...
                     'EdgeColor', 'none',...
                     'FaceLighting', 'gouraud', ...
                     'AmbientStrength', 0.3);
        p = p+1;
        
        h(p) = patch(transformSTL(upper, fk(:,:,i)*roty(angles(i))), ...
                     'FaceColor', [1,.1,.2],...
                     'EdgeColor', 'none',...
                     'FaceLighting', 'gouraud', ...
                     'AmbientStrength', 0.3);
        p = p+1;
    end

    % save('FieldableKinematicsPatch_low_res','lower','upper')
    camlight('headlight');
    axis('image');
    view([45, 35]);
    xlabel('x');
    ylabel('y');
    zlabel('z');
end

function updatePlot(kin, angles, low_res, h)
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
    fv.vertices = (trans * [fv.vertices, ones(size(fv.vertices,1), ...
                                              1)]')';
    fv.vertices = fv.vertices(:,1:3);

end
    
%Homogeneous transform matrix for a rotation about x
function m = rotx(theta)
    m = [1, 0,          0,          0;
         0, cos(theta), -sin(theta),0;
         0, sin(theta), cos(theta), 0;
         0, 0,          0,          1];
end

%Homogeneous transform matrix for a rotation about y
function m = roty(theta)
    m = [cos(theta),  0, sin(theta), 0;
         0,           1, 0,          0;
         -sin(theta), 0, cos(theta), 0;
         0,           0, 0,          1];
end


%Homogeneous transform matrix for a rotation about z
function m = rotz(theta)
    m = [cos(theta), -sin(theta), 0, 0;
         sin(theta),  cos(theta), 0, 0;
         0,          0,           1, 0;
         0,          0,           0, 1];
end