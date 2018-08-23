/*
Autores
	José Javier Arce Zeledón
	Julio Rodríguez Chavarría
	Kevin Venegas Loría
	Aaron Villalobos Arguedas
*/

%%Includes
:- ['pl.ini'].
:- ['../prolog_output/study_plan'].


%%Metodo principal
%%all_leaves(-AL) AL es ls lista de cursos que son hojas
all_leaves(AL):- diferencia(_X1, _X2, _, _, AL).

%%Lista de todos los cursos y lista de todos los requerimientos
lista_cursos(X, LC):- findall(X, course(X), LC).
lista_req(X, LR):- findall(X, course_req(_, X), LR).

%Diferencia entre las dos listas anteriores: Lista de todos los cursos - Lista de todos los cursos que son requerimientos
diferencia(X1, X2, LC, LR, LN):- 
							lista_cursos(X1, LC),
							lista_req(X2, LR),
							diff_listas(LR, ['Admission'], LR2),
							diff_listas(LR2, LC, LN).

 %%Metodo que hace la diferencia de listas
diff_listas(X, [], X).
diff_listas(X, [H|T], RS):-
							member(H, X),
							!, delete(X, H, T2),
							delete(T, H, T3),
							diff_listas(T2, T3, RS).
diff_listas(X, [H|T1], [H|T3]):- 
							diff_listas(T1, X, T3).