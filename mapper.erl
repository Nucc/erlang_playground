-module(mapper).

-export([mapper/2, pmapper/3]).


pmapper( Text, Delimiters, From ) ->
	Result = mapper( Text, Delimiters ),
	From ! Result.

% @Text = string
% @Delimiters = string
mapper( Text, Delimiters ) -> mapper( Text, [], Delimiters, [] ).

mapper( [], Tokens, _, Last) -> 
	append(Tokens, Last);

mapper( [Char | Text], Tokens, Delimiters, Last ) ->
	
	case patternMatching(Char, Delimiters) of
		{match} ->	T = append(Tokens, Last),
						mapper(Text, T, Delimiters, []);
		{no_match} -> mapper(Text, Tokens, Delimiters, Last ++ [Char])
	end.


patternMatching(_, []) -> {no_match};
patternMatching(Char, [Delimiter | Remains]) ->
	case Char of
		Delimiter -> {match};
		_ -> patternMatching(Char, Remains)
	end.

append(Tokens, Last) when length(Last) > 0 ->
	Tokens ++ [{value, Last}];
append(Tokens, _) -> Tokens.

