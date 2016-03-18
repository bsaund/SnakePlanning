function showWorld(worldName)
    S = stlread(worldName);
    patch(S,...
          'FaceColor', [1,1,1],...
          'EdgeColor', [0,0,0]);
    axis('equal');
end
