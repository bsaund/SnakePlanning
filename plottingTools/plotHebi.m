%% Plots a Hebi Kinematics object
% Currently assumes all bodies are Fieldable Elbow Joint
function plotHebi(kin, angles)
    persistent hebiPatchHandles
    h = hebiPatchHandles;
    disp('Starting tic')
    tic

    for i=1:length(h)
        if(ishandle(h(i)))
            % delete(h(i));
        else
            hebiPatchHandles = [];
            break;
        end
    end
    
    % toc
    firstrun = length(hebiPatchHandles) == 0;
    
    fk = kin.getForwardKinematics('CoM',angles);
    
    % toc
    % lower = stlread('stl/rotary_input.stl');
    % upper = stlread('stl/rotary_output.stl');
    % toc
        
    % lower = transformSTL(lower, rotx(pi/2));
    % upper = transformSTL(upper, rotx(pi/2));
    meshes = load('FieldableKinematicsPatch');
    lower = meshes.lower;
    upper = meshes.upper;
    % toc
    % disp('stl acquired');
    if(firstrun)
        p = 1;
        for i=1:kin.getNumBodies()
            hebiPatchHandles(p) = ...
                patch(transformSTL(lower, fk(:,:,i)), ...
                      'FaceColor', [1,.1,.2],...
                      'EdgeColor', 'none',...
                      'FaceLighting', 'gouraud', ...
                      'AmbientStrength', 0.3);
            p = p+1;
            
            hebiPatchHandles(p) = ...
                patch(transformSTL(upper, fk(:,:,i)*roty(angles(i))), ...
                      'FaceColor', [1,.1,.2],...
                      'EdgeColor', 'none',...
                      'FaceLighting', 'gouraud', ...
                      'AmbientStrength', 0.3);
            p = p+1;
        end
    else
        p=1;
        for i=1:kin.getNumBodies()
            fv = transformSTL(lower, fk(:,:,i));
            set(h(p), 'Vertices', fv.vertices(:,:));
            p = p+1;
            fv = transformSTL(upper, fk(:,:,i)*roty(angles(i)));
            set(h(p), 'Vertices', fv.vertices(:,:));
            p = p+1;
        end
            
    end
    toc
    disp('all patches finished')
    
    if(firstrun)
        
        % save('FieldableKinematicsPatch','lower','upper')
        camlight('headlight');
        
        axis('image');
        view([45, 35]);
        xlabel('x');
        ylabel('y');
        zlabel('z');
    end
    
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