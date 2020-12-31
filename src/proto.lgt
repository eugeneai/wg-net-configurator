:- protocol(namedp).
  :- public(name/1).
  :- public(id/1).
:- end_protocol.

:- protocol(devicep, extends(namedp)).
  :- public([type/1]).
:- end_protocol.

:- protocol(hostp, extends(devicep)).
  :- public([hostname/1,
          publichost/0,
          internal/1, % internal interface
          external/2 % external interface
          ]).
  :- protected([interface/2]).
  :- private([gray/0]).
:- end_protocol.

:- protocol(nicp, extends(devicep)).
  :- public([]).
:- end_protocol.

:- protocol(connp, extends(namedp)).
  :- public([peer/1, bcast/0, mcast/0]).
:- end_protocol.
