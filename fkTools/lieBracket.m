function t_out = lieBracket(t1, t2)
    m1 = hat(t1);
    m2 = hat(t2);
    t_out = vee(m1*m2 - m2*m1);
end
