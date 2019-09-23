%%%%%%%%%%%%%%%%%%%
% File: warehouse.lp:
%%%%%%%%%%%%%%%%%%%

%converting init to objects of type and label and cordinates
at(TYPE, LABEL, X, Y, 0):-init(object(TYPE,LABEL),value(at,pair(X,Y))).
asset(TYPE,LABEL):-init(object(TYPE,LABEL),value(at,pair(X,Y))).
%%
on(product,LABEL,shelf,SHELF, QUANT, 0):-init(object(product,LABEL),value(on,pair(SHELF,QUANT))).
producton(LABEL,shelf,SHELF, QUANT, 0):-init(object(product,LABEL),value(on,pair(SHELF,QUANT))).
orderline(LABEL, PS, PRODLABEL, PRODQUANT):- init(object(order,LABEL),value(line,pair(PRODLABEL,PRODQUANT))), init(object(order,LABEL),value(pickingStation,PS)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sort and object declaration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
productontype(shelf;pickingStation).
shelfontype(node;robot).
movabletype(robot).
immovabletype(node; shelf; pickingStation; highway, product).

%%%%%%%%%%%%%%%%%%%%%%%%%%
% state constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%
% two same type objects except product cannot be on same coordinates
:- at(TYPE1,LABEL1, X, Y, T), at(TYPE2,LABEL2, X, Y, T), TYPE1=TYPE2, not LABEL1=LABEL2, T = 0..m.
% shelf cannot be on highway unless it's on robot 
:- at(shelf,LABEL1, X, Y, T), at(highway,LABEL2, X, Y, T), not 1{at(robot,LABEL3, X, Y, T)}1, T = 0..m.
%%
%shelf moves along with robot if robot picksup shelf
%at(shelf, SLABEL, X, Y, T):- at(robot, RLABEL, X,Y,T), on(shelf,SLABEL,robot,RLABEL, 1, T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% effect and preconditions of action
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% effect of moving a robot
at(robot,LABEL1,X+DIFFX,Y+DIFFY,T+1) :- occurs(object(robot, LABEL1),move(DIFFX,DIFFY),T), 
                                at(robot,LABEL1,X,Y,T), at(node, NLABEL, X+DIFFX,Y+DIFFY,0).
% constraint on move to avoid collision
:-occurs(object(robot, LABEL1),move(DIFFX1,DIFFY1),T), at(robot,LABEL1,X1,Y1,T), 
    occurs(object(robot, LABEL2),move(DIFFX2,DIFFY2),T), at(robot,LABEL2,X2,Y2,T),
    X1+DIFFX1=X2, X2+DIFFX2=X1, Y1+DIFFY1=Y2, Y2+DIFFY2=Y1, T=0..m-1.

%%
% pickup 
%action effect for robot and shelf
on(shelf,SLABEL,robot,RLABEL, 1, T+1):-occurs(object(robot,RLABEL),pickup,T), at(shelf, SLABEL, X ,Y, T), 
                                    at(robot, RLABEL, X, Y, T).
%shelf already on robot the no pickup allowed
:-on(shelf,SLABEL,robot,RLABEL, 1, T), occurs(object(robot,RLABEL),pickup,T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%domain independent axioms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%uniqunes and existence of fluent values
% one object at one location
:- not 1{at(TYPE, LABEL,X,Y,T)}1, asset(TYPE, LABEL), T=1..m.

%exogenous actions
% move
{occurs(object(robot, LABEL),move(DIFFX,DIFFY),T)}:- asset(robot, LABEL), DIFFX=-1..1, DIFFY=-1..1, T=0..m-1.
%%
%pickup
{occurs(object(robot,LABEL),pickup,T)}:- asset(robot,LABEL), T=0..m-1.


%inertia
{at(TYPE, LABEL, X, Y, T+1)}:-at(TYPE, LABEL, X, Y, T), T=0..m-1.
{on(TYPE1,LABEL1,TYPE2,LABEL2, X, T+1)}:-on(TYPE1,LABEL1,TYPE2,LABEL2, X, T), T=0..m-1.


%test
{occurs(object(robot, 1),move(-1,0),0)}.
{occurs(object(robot,1),pickup,1)}.
{occurs(object(robot, 1),move(1,0),2)}.

#show occurs/3.
#show on/6.
%#show at/5.