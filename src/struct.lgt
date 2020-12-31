
:- object(element, implements(namedp)).
:- end_object.

:- object(device,
          extends(element),
          implements(devicep)).
:- end_object.

:- object(host,
          extends(device),
          implements(hostp)).
  name(X):-hostname(X).
  publichost:-\+ gray.
  type(host). % router, server, workstation, etc.
  interface(I, external):- external(I),!.
  interface(I, internal):- internal(I).
:- end_object.

:- object(nic(_Name_),
          extends(device),
          implements(devicep)).
  name(_Name_).
  id(X):-name(X). % FIXME: add type prefix
:- end_object.

:- object(conn,
          extends(element),
          implements(namedp)).
:- end_object.
