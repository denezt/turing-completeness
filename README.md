# Turing Complete Language Examples
## Building a Turing Complete Language

### Requirements
<ol>
	<li>Ruby 1.8+</li>
	<li>Python 3+</li>
</ol>

### What make a programming language for a Turing Complete Language?
1. Basic Math Operations: Add, Subtracting, Multiplying and Division
2. Conditional Logic: if, case, or when
3. Looping: while, for, until, do
4. Memory (Abitrarily Large: [...],[...]

### Testing for Turing Completeness

``` shell
# simulate a turing machine
# [0] == current_state
# [1] == head position
# [2] == number of symbols this machine recognizes
# [3] == current state + read value offset
# [state*[2]*3+10] == write at the current head position(nil or any number)
# [state*[2]*3+11] == move head amount (-1, 0, 1)
# [state*[2]*3+12] == next-state (state starting from 0)
# [10000+] == tape - pick a enough constant that the turing machine doesn't corrupt your states
# -1 is the stop-state
# Assumes you initialized your turing program for all your states.
[0]=-1
[1]=10000
while [0]>=0 do
	[3] = 10 + ([0]*[2]+[[1]]) * 3;
	[[1]] = [[3]];
	[1] = [1] + [[3]+1];
	[0] = [[3]+2];
end
```
