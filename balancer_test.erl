-module(balancer_test).
-import(balancer, [start/0]).

-import(logger, [debug/1, debug/2]).

-export([test_registration/0]).


test_registration() -> 
	Writers = spawn(balancer, start, []),
	Readers = spawn(balancer, start, []),
	
	create_readers(10, Readers),
	create_writers(10, Writers, Readers).


create_writers(0, _, _) -> {ok};
create_writers(N, Group, Readers) ->
	Pid = spawn(fun() -> writer(Readers) end),
	Group ! {reg, Pid},
	
	create_writers(N-1, Group, Readers).


create_readers(0, _) -> {ok};
create_readers(N, Group) ->
	Pid = spawn(fun() -> reader() end),
	io:format("~s", [erlang:process_info(Pid)]),
	Group ! {reg, Pid},
	create_readers(N-1, Group).
	
	
writer(Readers) ->
	Readers ! {get, self()},
	receive
		{ok, Pid} -> Pid ! {write, "Writer pid: ~p", self()},
					 debug("Initialize writer with reader ~p ~n", [Pid])
	after 2000 -> 
		void,
	
	debug("writer closed ~p ~n", [self()])
end.

reader() ->
	debug("Initialize reader ~n"),
	receive
		{write, Message, Pid} -> io:format(Message, [Pid])
	after 5000 -> 
		debug("Exit reader ~p", [self()]),
		{exit}
end.