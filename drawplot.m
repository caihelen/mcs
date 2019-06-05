% Draw a plot of 2D position
function drawplot(nests)
    clf
    hold on
    plot(nests(:,2), nests(:,3), 'bo')
    refreshdata
    drawnow
end
