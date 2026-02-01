x : Alice.int;
x := Alice.42;

y : Bob.int;
y := [Alice] Alice.x ~> Bob;

z : Bob.int;
z := Bob.(y + 10);

result : Alice.int;
result := [Bob] Bob.z ~> Alice;

w : Alice.int;
w := Alice.(result * 2);

final : Bob.int;
final := [Alice] Alice.w ~> Bob;