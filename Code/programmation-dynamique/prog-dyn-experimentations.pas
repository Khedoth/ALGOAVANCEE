program progDynamique;

{declaration des constantes}
const
	n = 10000;
	k = 5;
	D = 30;
	infini = 4200;
	
{declaration des variables globales}
var
	cd : array [1..n, 1..k] of integer; {tableau des couts et durees de depart}
	i : integer;
	a,b,r : integer;
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
function cout_opt(j : integer; x : integer) : longint;
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

	{Nouvelle sequence aleatoire}
	Randomize;

	{initialisation du tableau des couts et durees aleatoires}
	for a := 1 to n do
	begin
		r := 1000;
		for b := 1 to k do
		begin
			r := Random(r);
			if r < 10 then begin
				cd[a,b] := infini;
			end else begin
				cd[a,b] := r;
			end;
		end;
	end;
			
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
