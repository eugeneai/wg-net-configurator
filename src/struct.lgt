
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
          implements(nicp)).
  name(_Name_).
  id(X):-name(X). % FIXME: add type prefix
:- end_object.

:- object(conn,
          extends(element),
          implements(connp)).
:- end_object.

:- object(ptp(_Peer_),
          extends(conn)).
  peer(_Peer_).
:- end_object.

:- object(ptmp(_Peers_),
          extends(conn))).
  peer(P):-
    lists:member(P,_Peers_).
:- end_object.

:- object(bcast,
          extends(conn)).
:- end_object.

:- object(mcast,
          extends(conn)).
:- end_object.
