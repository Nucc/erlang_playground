-module(filereader).

-export([read_lines/1]).

read_lines(File) ->
	{ok, Device} = file:open(File, [read]),
	read_by_line(Device).


read_by_line(Device) ->
	case io:get_line(Device, "") of
		eof -> file:close(Device);
		Line -> io:format("~s", [Line]),
				read_by_line(Device)
	end.