-module(counter).

-export([start/1]).

start(Processes, To) ->
	
	Counter = spawn(fun() -> counter(0) end),
	create_processes(Processes, To, Counter),
	

create_processes(0, To, Counter) ->
	receive
		exit -> 

create_processes(N, To, Counter, Top) ->
	spawn(fun() -> process(To, Counter) end),
	create_processes(N-1, To, Counter).
	

process(0, _) -> exit('end');
process(N, Counter) ->
	Counter ! N,
	process(N-1, Counter).

counter(N) ->
	receive
		exit -> io:format("~c", [N]);
		_    -> counter(N+1)
	end.