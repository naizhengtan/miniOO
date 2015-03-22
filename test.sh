#echo 'var $a; $a = 1;' | ./interpreter # declaration and assign
#echo 'var $r; $r = 1; var $z; $z = $r;' | ./interpreter # dereference
#echo 'var $r; $r = proc $y: $r = $y; $r(4);' | ./interpreter  # proc define and proc execute
#echo 'var $r; $r = 2 + 1;' | ./interpreter  # plus
#echo 'var $r; $r = 2 - 1;' | ./interpreter  # plus
#echo 'var $r; var $r; $r = proc $y: $r = $y + 1;' | ./interpreter  # redefine
#echo 'var $r; $r = proc $y: $r = $y + 1; $r(4);' | ./interpreter  # modify global variable inside function
#echo 'var $r; var $h; $h = 1; var $p; $p = proc $y: $r = $y + $h; var $h; $h = 2; $p(4);' | ./interpreter # teacher exmple 1

#echo 'var $y; var $p; $y = 10; if $y < 1 then $p = 2 else $p = 1;' | ./interpreter # condition
#echo 'var $y; var $p; $y = 10; if $y == 1 then $p = 2 else $p = 1;' | ./interpreter # eqaul
#echo 'var $x; var $y; malloc($x); malloc($y); var $r; $x.c = 1; $y.c = 1; if $x == $y then $r = 1 else $r = 2;' | ./interpreter # obj equal
#echo 'var $a; malloc($a); var $b; $b = $a; $b.c = 1;' | ./interpreter # same obj
#echo 'var $p; $p = proc $y: if $y < 1 then $p = 1 else $p($y-1); $p(1);' | ./interpreter # teacher exmple 2

#echo 'var $x; malloc($x); $x.c = 0;' | ./interpreter # malloc, field
#echo 'var $x; malloc($x); $x.c = 0; var $y; $x.c = 10; $y = $x.c;' | ./interpreter # dereference the field
#echo 'var $x; malloc($x); var $y; malloc($y); $y.c = 10; $x.a = $y; var $r; $r = $x.a.c;' | ./interpreter # cascading indexing 
echo 'var $x; malloc($x); $x.c = 0; $x.f = proc $y: if $y < 1 then $x.r = $x.c else $x.f($y - 1); $x.f(2);' | ./interpreter # teacher example 3

#echo 'var $x; $x = 6; var $y; {var $x; $x = 5; $y = 3;};' | ./interpreter # scoping

#echo 'var $x; var $y; $x = 10; $y = 0; while $x > 0 { $x = $x -1; $y = $y + 2; };' | ./interpreter # loop 

#echo 'var $x; var $y; var $z; 
#$x = 10000; $y = 0; $z = 0; { 
#while $x > 0 { $x = $x -1; $y = $y + 1; } ||| 
#while $x > 0 { $x = $x -1; $z = $z + 1; } 
#};' | ./interpreter # parrallel

#echo 'var $x; var $y; var $z; 
#$x = 10000; $y = 0; $z = 0; { 
#while $x > 0 { lock($x = $x -1); $y = $y + 1; } ||| 
#	while $x > 0 { lock($x = $x -1); $z = $z + 1; } 
#};' | ./interpreter # synchronization

# Advanced topic
#echo 'var $a; var $b; malloc($a); $b = 1; $a.[$b] = 1; var $d; $d = $a.[1];' | ./interpreter # index 

