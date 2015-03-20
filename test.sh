echo 'var $a; $a = 1;' | ./mini
#echo 'var $r; var $h; $h = 1; var $p; $p = proc $y: $r = $y + $h; var $h; $h = 2; $p(4);' | ./mini
#echo 'var $p; $p = proc $y: if $y < 1 then $p = 1 else $p($y-1); $p(1);' | ./mini
#echo 'var $x; malloc($x); $x.c = 0; $x.f = proc $y: if $y < 1 then $x.r = $x.c else $x.f($y - 1); $x.f(2);' | ./mini
#echo 'var $x; malloc($x); var $y; $y = $x;' | ./mini
