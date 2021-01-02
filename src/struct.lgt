
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

:- object(conn(_Source_),
          extends(element),
          implements(connp)).
  source(_Source_).
:- end_object.

:- object(ptp(_Source_,_Peer_),
          extends(conn(_Source_))).
  peer(_Peer_).
:- end_object.

:- object(ptmp(_Source_,_Peers_),
          extends(conn(_Source_)))).
  peer(P):-
    lists:member(P,_Peers_).
:- end_object.

:- object(bcast(_Source_),
          extends(conn(_Source_))).
  bcast.
  mcast.  % FIXME: Really?
:- end_object.

:- object(mcast(_Source_),
          extends(conn(_Source_))).
  mcast.
:- end_object.
