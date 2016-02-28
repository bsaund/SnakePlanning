function ad = Adjoint(m);
R = m(1:3, 1:3);
p = m(1:3, 4);

ad = [R, hat(p)*R;
      zeros(3), R];
end