function d = dist(point1, point2)

%point1 = [a1, b1], point2 = [a2, b2]
v = point1 - point2;
d = sqrt(v * v');
