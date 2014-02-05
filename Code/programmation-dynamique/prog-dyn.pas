program progDynamique;

{declaration des constantes}
const
	n = 4;
	k = 5;
	D = 10;
	infini = 4200;
	
{declaration des variables globales}
var
	cd : array [1..n, 1..k] of integer; {tableau des couts et durees de depart}
	i : integer;
	a : integer;
	l : integer;
	dmax : array [1..n] of integer; {tableau des durees maximales pour chaque tache}
	cmin : array [1..n] of integer; {tableau des couts minimaux pour chaque tache}
	
{procedure d'affichage d'un tableau}
procedure afficherTableau(var tableau : array of integer; taille : integer);
var
	i : integer;
begin
	for i := 0 to taille-1 do
	begin
		write(' ', tableau[i]);
	end;
	writeln;
end;

{procedure de calcul du cout associe laffectation optimale de d unites de temps aux taches consecutives T1 a Tj : construction du tableau solution}
function cout_opt(j : integer; x : integer) : integer;
var
	i : integer;
	l : integer;
	min : integer;
	p : integer;
	q : integer;
	tableau : array [1..n,1..D] of integer;
	
begin
	{pour p taches de 1 a j taches}
	for  p := 1 to j do
	begin
		{pour q durees de 1 a x (D)}
		for q:= 1 to x do
		begin
			{si on est sur la premiere ligne}
			if p = 1 then begin
				if q <= dmax[p] then begin
					tableau[p,q] := cd[1,q];
				end
				else begin
					tableau[p,q] := cmin[p];
				end;
			end
			{si on est sur la diagonale}
			else if p = q then begin
				tableau[p,q] := tableau[p-1,q-1] + cd[p,1];
			end
			{si on est dans le triangle inferieur : on veut ordonner des taches avec moins d'une unite de temps par tache}
			else if p > q then begin
				tableau[p,q] := infini;
			end
			{sinon (on est sur le triangle supérieur du tableau}
			else begin
			
				{calcul du minimum}
				min := infini;
				l:= 1;
				for i := 1 to q-1 do
				begin
					if min > (tableau[p-1, q-i] + cd[p,i]) then begin
						min := tableau[p-1, q-i] + cd[p,i];
						
						l := i; {sauvegarde de l'indice du minimum}
					end;
				end;	
				
				{on enregistre la valeur du minimum trouvee dans le tableau}	
				tableau[p,q] := tableau[p-1, q-l] + cd[p,l];
			end;	
		end;
	end;
	
	{affichage de la structure tabulaire}
	for p := 1 to j do
	begin
		for q := 1 to x do
		begin
			write(tableau[p,q], ', ');
		end;
		writeln;
	end;
	
	cout_opt := tableau[j,x]; {retour de la fonction}
	
	writeln;
	writeln('cout_opt : ', cout_opt); {affichage du resultat}
	writeln;
end;
		
{corps du programme}
begin
	{message de demarrage}
	writeln('---------------------------------------------------------------');
	writeln('Ordonnancement simple par la méthode de programmation dynamique');
	writeln('---------------------------------------------------------------');
	writeln;

	{initialisation du tableau des couts et durees}
	cd[1,1] := 110;
	cd[1,2] := 90;
	cd[1,3] := 65;
	cd[1,4] := 55;
	cd[1,5] := infini;

	cd[2,1] := 120;
	cd[2,2] := 90;
	cd[2,3] := 70;
	cd[2,4] := 50;
	cd[2,5] := 40;

	cd[3,1] := 90;
	cd[3,2] := 70;
	cd[3,3] := 65;
	cd[3,4] := 60;
	cd[3,5] := infini;

	cd[4,1] := 65;
	cd[4,2] := 60;
	cd[4,3] := 55;
	cd[4,4] := infini;
	cd[4,5] := infini;
			
	{affichage des valeurs initiales}
	writeln('Tableau des couts et durees :'); writeln;
	for i := 1 to n do
	begin
		afficherTableau(cd[i], k);
	end;
	writeln;
	writeln(' n = ', n);
	writeln(' k = ', k);
	writeln(' D = ', D);
	writeln;
	
	{initialisation du tableau des durees maximales pour chaque tache}
	for a := 1 to n do
	begin
		l := k;
		while(cd[a,l] = infini) do l := l-1;
		dmax[a] := l;
	end;
	
	
	{initialisation du tableau des couts minimaux pour chaque tache}
	for a := 1 to n do
	begin
		l := k;
		while(cd[a,l] = infini) do l := l-1;
		cmin[a] := cd[a,l];
	end;
	
	write('dmax : [');
	for a := 1 to n do
	begin
		write(dmax[a], ',');
	end;
	writeln(']');
	writeln;
	write('cmin: [');
	for a := 1 to n do
	begin
		write(cmin[a], ',');
	end;
	writeln(']');
	writeln;
	
	{appel}
	cout_opt(n,D);
end.
