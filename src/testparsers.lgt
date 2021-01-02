% :- use_library(library(filesex)).

:- object(config).
	:- uses(user,[absolute_file_name/2,open/3]).
    :- public([option/1, current_option/1]).
    option(testfile='../testdata/ipas.txt').
	option(cwd=Absolute):-
		absolute_file_name('./',Absolute).
	current_option(X):-
		option(X).

	:- public(test_file/2).
	file(Name, Path):-
		absolute_file_name(Name, Path).
	:- public(open_file/2).
	open_file(Name, Stream):-
		file(Name, AbsoluteFN),
		open(AbsoluteFN,read,Stream).
	% :- public(read_file/2).
	% read_file(Name, String):-
	% 	open_file(Name,Stream),
	% 	read_tokens(Stream, Tokens).
:- end_object.

:- object(tests, extends(lgtunit)).
    :- info([
                   version is 0:1:0,
                   author is 'Evgeny Cherkashin',
                   date is 2021-01-02,
                   comment is 'Unit tests for ip x x parser.'
               ]).

    succeeds(test_test) :-
        true.
    succeeds(test_ip_a_s_parse) :-
		config::current_option(testfile=TestFile),
		config::open_file(TestFile,Source),
        ipasparser(Source, [], 'test.isclan.ru')::parse.
:- end_object.
