-module(logreader).

-import(mapper, [pmapper/3]).

-export([read_from_file/1]).

read_from_file(Filename) ->
	{ok, File} = file:open(Filename, [read]),
	Writer = spawn(fun() -> writer() end),
	for_each_line(File, Writer).
	
for_each_line(Device, Writer) ->
	case io:get_line(Device, "") of
		eof -> file:close(Device);
		Line -> spawn(fun() -> mapper_process(Line, Writer) end),
				for_each_line(Device, Writer)
	end.
	

mapper_process(Line, Writer) ->
	pmapper(Line, " \n\";->", self() ),
	receive
		Result -> Writer ! {write, Result}
	end.
	
writer() ->
	receive
		{write, Message} -> 
			%io:format("AHH"),
			io:format("~p", [Message]),
			writer();
		{exit} -> exit
	end.
	