/*REXX program verifies if a   horizontal ray   from   point P   intersects  a polygon. */
call points 5 5,       5 8,       -10  5,       0  5,       10  5,       8  5,       10 10
A=2.5;    B=7.5                            /* ◄───── used for shorter arguments (below).*/
call poly 0 0, 10 0,  10 10,  0 10                             ;   call test 'square'
call poly 0 0, 10 0,  10 10,  0 10,  A  A,   B  A,   B  B, A B ;   call test 'square hole'
call poly 0 0,  A A,   0 10,  A  B,  B  B,  10 10,  10  0      ;   call test 'irregular'
call poly 3 0,  7 0,  10  5,  7 10,  3 10,   0  5              ;   call test 'hexagon'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
in$out: procedure expose point. poly.;      parse arg p;            #=0
                      do side=1  to poly.0  by 2;    #=#+intersect(p,side);  end  /*side*/
        return # // 2                            /*ODD  is inside.     EVEN  is outside.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
intersect: procedure expose point. poly.;         parse arg ?,s;      sp=s+1
           epsilon='1e' || (-digits()%2);         infinity="1e" || (digits() *2)
           Px=point.?.x;      Ax=poly.s.x;        Ay=poly.s.y
           Py=point.?.y;      Bx=poly.sp.x;       By=poly.sp.y        /* [↓]  do a swap.*/
           if Ay>By           then parse  value   Ax Ay Bx By    with    Bx By Ax Ay
           if Py=Ay | Py=By   then Py=Py + epsilon
           if Py<Ay | Py>By | Px>max(Ax,Bx)  then return 0
           if Px<min(Ax,Bx)                  then return 1
           if Ax\=Bx          then m_red =(By-Ay) / (Bx-Ax)
                              else m_red =infinity
           if Ax\=Px          then m_blue=(Py-Ay) / (Px-Ax)
                              else return 1
           return m_blue >= m_red
/*──────────────────────────────────────────────────────────────────────────────────────*/
points: wx=0;  wy=0;     do j=1  for arg();         parse value  arg(j)  with  xx  yy
                         wx=max(wx, length(xx) );   call  value  'POINT.'j".X",  xx
                         wy=max(wy, length(yy) );   call  value  'POINT.'j".Y",  yy
                         end   /*j*/
        call value point.0,  j-1                         /*define the number of points. */
        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
poly:   @='POLY.';       parse arg Fx Fy                 /* [↓]  process the X,Y points.*/
        n=0
                 do j=1  for arg();     n=n+1;      parse value arg(j)   with   xx yy
                 call value @ || n'.X', xx ;        call value  @ || n".Y", yy
                 if n//2  then iterate; n=n+1
                 call value @ || n'.X', xx ;        call value  @ || n".Y", yy
                 end   /*j*/
        n=n+1
        call value @ || n'.X', Fx;      call value @ || n".Y", Fy;       call value @'0',n
        return                                           /*POLY.0  is # segments(sides).*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
test:   say;     do k=1  for point.0;     w=wx+wy+2
                 say right('  ['arg(1)"]  point:", 30),
                     right( right(point.k.x, wx)', 'right(point.k.y, wy), w)     "  is  ",
                     right( word('outside inside',  in$out(k)+1), 7)
                 end   /*k*/
        return
