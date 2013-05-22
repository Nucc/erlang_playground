-module(balancer).

-import(logger, [debug/1, debug/2]).

-export([start/0, observer/1, observer/0]).

% Start a new balancer
start() ->
	spawn(balancer, observer, []).


% Controlling the requests
observer() -> observer([]).
observer(Targets) ->
	debug("next"),
	receive
		
		{reg, Pid} ->
			NewTargets = lists:append([Pid], Targets),
			debug("Add new process; process: ~p", [Pid]),
			observer(NewTargets);
			
		{reg, Pid, From} ->
			NewTargets = lists:append([Pid], Targets),
			From ! {ok, Targets}, 
			debug("Add new process; process: ~p", [Pid]),
			observer(NewTargets);
				
		{get, From} ->
			[Pid|Remains] = Targets,
			From ! {ok, Pid},
			debug("Get next process ~p ~n", From),
			observer( lists:append(Remains, [Pid]) );

		{stop} ->
			% TODO: send exit signal to processes
			
			debug("Shut down observer, ~p", [self()]),
			exit("Stopped")
end.
