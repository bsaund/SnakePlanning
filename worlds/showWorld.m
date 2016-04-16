function fig = showWorld(world)
    fig = figure('Name', 'World');
    cad.faces = world.faces;
    cad.vertices = world.vertices;
    patch(cad,...
          'FaceColor', [0,1,0],...
          'EdgeColor', 'none');
    axis('equal');
    
    pos = get(fig, 'position');
    set(fig, 'position', [pos(1:2)/4 pos(3:4)*2]);
    
    hold on
end
