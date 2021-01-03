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
		parse(setups,R,R1),!,
		parse(ipls,R1,O).

	parse(ipls,I,I).

	parse(ipl,I,O):-
		parse(defcol, I, R1, SNumber),
		atom_number(SNumber, Number),!,
		parse(defcol, R1, R2, Interface),
		format('Interface No ~w is ~w\n',[Number, Interface]),
		parse(hwstate, R2,R3),
		parseparameters(["mtu","qdisc",
			"state","group","qlen","master"], R3,R4),
		parselink(R4,R5),
		parseparameters(["brd","peer","link-netnsid"],R5,O).

	parse(hwstate, [StateSring|I],I):-
		split_string(StateSring,"<,",">", [""|List]),
		forall(member(X,List), hwstate(X)).

	parse(setups,[INet,IP|I],O):-
	    member(INet,["inet","inet6"]),!,
		parseip(INet, IP, PIP),
		parseparameters(["brd","peer"],I,["scope"|R]),
		parsescope(INet, R,R1, Scope,IFace),
		format("~w: ~w scope ~w ~w\n",[INet,PIP,Scope,IFace]),
		parseparameters(["valid_lft","preferred_lft"],R1,R2),
		parse(setups, R2,O).
	parse(setups, I,I).

    parse(defcol, [Def|I], I, Result):-
		sub_string(Def, Before, 1, 0, ":"),
		sub_string(Def, 0, Before, 1, Result).

	parseip(_,IPS,IP/Mask):-
		split_string(IPS,"/","",[IP,MaskS]),
		atom_number(MaskS,Mask),
		format("IP: ~w/~w\n",[IP,Mask]),
		!.
	parseip("inet",IP,IP/32):-!.
	parseip("inet6",IP,IP/128).

	scopepar(X):-
		member(X, ["secondary","noprefixroute","mngtmpaddr",
				  "global","link","dynamic","tentative"]).

	parsescope(INet, [Scope,Par|I],O, [Scope, Par|T],IFace):-
		scopepar(Par),!,
		parsescope(INet, [Scope|I],O, [Scope|T],IFace).
	parsescope("inet", [Scope,IFace|I],I, [Scope], IFace).

	parsescope("inet6", [Scope|I],I, [Scope], '$none').

	parseparameters(List, [Par,ValS|I],O):-
		member(Par,List),!,
		(atom_number(ValS,Val)->true; Val=ValS),
		format('Par: ~w=~w\n',[Par,Val]),
		parseparameters(List,I,O).
	parseparameters(_,I,I).

	parselink([Link,Addr|I],I):-
		(check_MAC(Addr);check_IP(Addr)),!,
		split_string(Link,"/","",["link"|T]),
		link_type(T,Addr).

    parselink([Link|I],O):-
		parselink([Link,"--:--:--:--:--:--"|I],O).

	link_type([],Addr):-
		link_type([none],Addr),!.
	link_type([T],Addr):-
		format("Link_type=~w Addr=~w\n",[T,Addr]).

	check_MAC(MAC):-
		split_string(MAC,":","",[A,B,C,D,E,F]).
	check_IP(IP):-
		split_string(IP,".","",[A,B,C,D]).

	hwstate(Parameter):-
		format("HWS: ~w\n",[Parameter]).

:- end_object.
