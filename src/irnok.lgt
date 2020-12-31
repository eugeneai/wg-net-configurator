
:- object(ppp(_Name_), extends(nic(_Name_))).
  type(ppp).
:- end_object.

:- object(eth(_Name_), extends(nic(_Name_))).
  type(eth). % by default, can be also wifi
:- end_object.

:- object(br(_Name_), extends(eth(_Name_))).
  type(wifi).
:- end_object.

:- object(router, extends(host)).
  type(router).
  type(T):-^^type(T). % inherit 'host'.
:- end_object.

:- object('irnok-gw', extends(router)).
  hostname('irnok-gw.isclan.ru').
  name(home).
  external(ppp('pppoe-PPP')).
  internal(br('br-lan')).
:- end_object.
