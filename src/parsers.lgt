:- object(parser(_Input_, _Graph_, _URI_)).
	% Parses Input text into SW Graph
	:- public(parse/0).
	:- uses(user, [split_string/4]).
	:- use_module(library(dialect/sicstus), [read_line/2]).
	:- use_module(lists, [append/3]).
	:- protected(split/2).
	split(String, List):-
		split_string(String,'\s\t\n\r','\s\t\n\r',List).
	:- public([parse/3,parse/4]).
	parse:-
		read_tokens(I,[]),
		::parse(sent,I,O),
		(O \= [] -> format('Warning REST: ~w\n', [O]);
		true).
	parse(sent,I,I). % Stub.
	:- protected(read_tokens/2).
	read_tokens(T,L):-
		read_line(_Input_, Line),
		Line\=end_of_file, !,
		split(Line, Tokens),
		% format('iiii- ~w\n',[Tokens]),
		append(L,Tokens,AllTokens),
		read_tokens(T, AllTokens).
	read_tokens(L,L).

:- end_object.

:- object(ipasparser(_Input_,_Graph_,_Host_),
   extends(parser(_Input_,_Graph_,_Host_))).
    :- uses(user, [sub_string/4,
	   atom_number/2,
	   split_string/4,
	   forall/2]).
	:- use_module(lists, [member/2]).
	parse(sent,[],[]):-!.
	parse(sent,I,O):-
		parse(ipls,I,O),!. % TODO: implement all.
	% parse(sent,[X|I],O):-
	% 	parse(ipls,[X|I],R),
	% 	parse(sent,R,O).

    parse(ipls,I,O):-
		parse(ipl,I,R),
		parse(setups,R,O).

	parse(ipl,I,O):-
		parse(defcol, I, R1, SNumber),
		atom_number(SNumber, Number),!,
		parse(defcol, R1, R2, Interface),
		format('Interface No ~w is ~w\n',[Number, Interface]),
		parse(hwstate, R2,R3),
		parseparameters(["mtu","qdisc",
			"state","group","qlen"], R3,R4),
		parselink(R4,R5),
		parseparameters(["brd"],R5,R6),
		O=R6.

	parse(hwstate, [StateSring|I],I):-
		split_string(StateSring,"<,",">", [""|List]),
		forall(member(X,List), hwstate(X)).

	parse(setups,[INet,IP,"scope"|I],O):-
	    member(INet,["inet","inet6"]),
		parsescope(INet, I,R1, Scope,IFace),
		format("~w: ~w scope ~w ~w\n",[INet,IP,Scope,IFace]),
		parseparameters(["valid_lft","preferred_lft"],R1,R),
		parse(setups, R,O).
	parse(setups, I,I).

    parse(defcol, [Def|I], I, Result):-
		sub_string(Def, Before, 1, 0, ":"),
		sub_string(Def, 0, Before, 1, Result).

	parsescope("inet", [Scope|I],O, SC,IFace):-
		(["secondary"|R]=I ->
		  SC=[Scope, secondary];
		  R=I,SC=[Scope, primary]),
		[IFace|O]=R.

	parseparameters(List, [Par,ValS|I],O):-
		member(Par,List),!,
		(atom_number(ValS,Val)->true; Val=ValS),
		format('Par: ~w=~w\n',[Par,Val]),
		parseparameters(List,I,O).
	parseparameters(_,I,I).

	parselink([Link,MAC|I],I):-
		split_string(Link,"/","",["link"|T]),
		link_type(T,MAC).

	link_type([],MAC):-
		link_type([none],MAC),!.
	link_type([T],MAC):-
		format("Link_type=~w\n MAC=~w\n",[T,MAC]).

	hwstate(Parameter):-
		format("HWS: ~w\n",[Parameter]).

:- end_object.
