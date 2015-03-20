#echo 'var $a; $a = 1;' | ./mini # declaration and assign
#echo 'var $r; $r = 1; var $z; $z = $r;' | ./mini # dereference
#echo 'var $r; $r = proc $y: $r = $y; $r(4);' | ./mini  # proc define and proc execute
#echo 'var $r; $r = 2 + 1;' | ./mini  # plus
#echo 'var $r; $r = 2 - 1;' | ./mini  # plus
#echo 'var $r; var $r; $r = proc $y: $r = $y + 1;' | ./mini  # redefine
#echo 'var $r; $r = proc $y: $r = $y + 1; $r(4);' | ./mini  # modify global variable inside function
#echo 'var $r; var $h; $h = 1; var $p; $p = proc $y: $r = $y + $h; var $h; $h = 2; $p(4);' | ./mini # teacher exmple 1

#echo 'var $y; var $p; $y = 10; if $y < 1 then $p = 2 else $p = 1;' | ./mini # condition
#echo 'var $p; $p = proc $y: if $y < 1 then $p = 1 else $p($y-1); $p(1);' | ./mini # teacher exmple 2

#echo 'var $x; malloc($x); $x.c = 0;' | ./mini # malloc, field
#echo 'var $x; malloc($x); $x.c = 0; var $y; $x.c = 10; $y = $x.c;' | ./mini # dereference the field
#echo 'var $x; malloc($x); var $y; malloc($y); $y.c = 10; $x.a = $y; var $r; $r = $x.a.c;' | ./mini # cascading indexing 
#echo 'var $x; malloc($x); $x.c = 0; $x.f = proc $y: if $y < 1 then $x.r = $x.c else $x.f($y - 1); $x.f(2);' | ./mini # teacher example 3
