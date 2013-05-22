-module(logger).
-export([debug/1, debug/2]).

debug(Message) ->
	debug(Message, []).
	
debug(Message, Params) ->
	io:format(Message, Params).