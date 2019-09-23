object(r1;r2;ps1;ps2;sh1;sh2).


%effects and precondition
% new robot position.
at(O,R1+R,C1+C,T+1) :- at(O,R1,C1,T), move(O,R,C,T).
%shelf position is same as robot
at(SH,R1+R,C1+C,T+1):- at(SH,R1,C1,T), hasShelf(O,SH,t,T), move(O,R,C,T). 

% at a time no two objects at same place 
:- at(O1,R,C,T), at(O2,R,C,T),1{O1=r1;O1=r2;O1=ps1;O1=ps2}1,1{O2=r1;O2=r2;O2=ps1;O2=ps2}1, O1!=O2.

% robos can not swap their positions.
:- at(O1,R1,C1,T),at(O2,R2,C2,T),O1!=O2,1{O1=r1;O1=r2}1,1{O2=r1;O2=r2}1,2{at(O2,R1,C1,T+1);at(O1,R2,C2,T+1)}2.

% objects are with in max. dim. not out of bound.
:- at(O,R1,C1,T), move(O,R,C,T),not 2{R1+R<=dim;C1+C<=dim}2.

% objects are min dim. not out of bound.
:- at(O,R1,C1,T), move(O,R,C,T),not 2{R1+R>=1;C1+C>=1}2.

%%pickup

hasShelf(O,SH,t,T+1):- pickup(O,SH,T).
% shelf and robot are at same place for pickup action to execute
:- pickup(O,SH,T), at(O,R1,C1,T), at(SH,R2,C2,T),O!=SH, not 2{R1=R2;C1=C2}2.

% pickup can not be executed with shelf already on robot.
:- pickup(O,SH,T), hasShelf(O,SH1,t,T).

% pickup and move can not be executed together
:- pickup(O,SH,T), move(O,R,C,T).

% two robots can not be same place at a time. this might not be needed.
:- pickup(O,SH,T), pickup(O1,SH,T), O!=O1.

%%putdown
hasShelf(O,SH,f,T+1):- putdown(O,SH,T).
:- putdown(O,SH,T), move(O,R,C,T).
:- putdown(O,SH,T), not hasShelf(O,SH,t,T).
 
%% domain independent axioms

% initial state of robots. 
1{at(O,RR,CC,0):RR=1..dim,CC=1..dim}1 :- object(O).

1{hasShelf(O,SH,f,0):SH=(sh1;sh2)}1 :- object(O).

% uniqueness and existence
:- not 1{at(O,RR,CC,T):RR=1..dim,CC=1..dim}1,object(O),T=1..m.
:- not 1{hasShelf(O,SH,B,T):SH=(sh1;sh2)}1, object(O),T=1..m.

%actions 
{move(O,1,0,T):O=(r1;r2);move(O,-1,0,T):O=(r1;r2);move(O,0,1,T):O=(r1;r2);move(O,0,-1,T):O=(r1;r2)}1 :- object(O),T=0..m-1.

{pickup(O,SH,T):O=(r1;r2),SH=(sh1;sh2)} :- T=0..m-1.  
{putdown(O,SH,T):O=(r1;r2),SH=(sh1;sh2)} :- T=0..m-1.  

% intertia
{at(O,R,C,T+1)} :- at(O,R,C,T),T=0..m-1. 
{hasShelf(O,SH,B,T+1)} :- hasShelf(O,SH,B,T),T=0..m-1. 


% input spec: 
:- not at(r1,1,1,0;r2,4,4,0;ps1,1,3,0;ps2,3,3,0;sh1,4,2,0;sh2,2,1,0).
:- not at(r1,1,4,m;r2,2,3,m;sh1,3,2,m;sh2,2,4,m).
%:- not hasShelf(r1,sh1,t,m).

% output spec: 
%:- not at(r1,1,2,1).
%#show move/4.
%#show at/4.
#show hasShelf/4.
#show pickup/3.
#show putdown/3.