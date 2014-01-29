program esSansElagage;

{declaration des constantes}
const
	n = 4;
	k = 5;
	D = 10;
	infini = 4200;

{declaration des variables globales}
var
	cd : array [1..n, 1..k] of integer; {tableau des couts et durees de depart}
	dmax : array [1..n] of integer; {tableau des durees maximales pour chaque tache}

	cout, duree, coutOpt : integer; {variables de calcul de la solution optimale}
	T : array [1..n] of integer; {vecteur representant un candidat}

	j : integer; {variable d'iteration}

	nbAppel : integer; {compte le nombre d'appels a ordonnancement simple}

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

{fonction de calcul de la somme des elements d'un tableau d'entiers}
function sommeTableau(var tableau : array of integer; taille : integer) : integer;
var
	somme : integer; {somme courante}
	i : integer;
begin
	somme := 0;
	for i:=0 to taille-1 do
	begin
		somme := somme+tableau[i];
	end;
	sommeTableau := somme;
end;

{fonction de test pour elagage}
function encorepossible(di : integer; ci : integer) : boolean;
var
	S : integer; {Somme des durees choisies + des durees max restantes}
begin
	S := sommeTableau(dmax,n);

	{si D est grand, alors retourner vrai (il est impossible d'atteindre D)}
	if (S < D) and (ci = 1) then begin
		encorepossible := true;
	end

	{sinon on retourne vrai uniquement s'il est possible d'atteindre D avec les durees restantes}
	else begin
		if S-dmax[ci]+di < D then begin
			encorepossible := false;
		end
		else begin
			dmax[ci] := di;
			encorepossible := true;
		end;
	end;
end;

{procedure de recherche de la solution optimale avec elagage}
procedure ordonnancementSimple(i : integer);
var
	xi : integer;
begin
	for xi := 1 to k do {pour xi parcourant Si}
	begin
		if duree+xi <= D then begin {si satisfaisant}

			{enregistrer}
			duree := duree + xi;
			cout := cout + cd[i,xi];
			T[i] := xi;

			if i = n then begin {si soltrouvee}
				if cout < coutOpt then begin {si meilleure}

					coutOpt := cout; {majvalopt}

					{afficher la solution}
					afficherTableau(T, n);
					write('duree = ',duree, ' cout = ',cout);
					writeln; writeln;
				end;
			end
			else begin

				{application de l'elagage}
				if encorepossible(xi, i) then
				begin
					ordonnancementSimple(i+1);
					nbAppel := nbAppel+1;
				end;
			end;

			{defaire}
			T[i] := 0;
			cout := cout - cd[i,xi];
			duree := duree - xi;
		end;
	end;
end;

{corps du programme}
begin
	{message de demarrage}
	writeln('----------------------------------------------------------');
	writeln('Ordonnancement simple par la méthode des essais successifs');
	writeln('----------------- version avec elagage -------------------');
	writeln('----------------------------------------------------------');
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

	{initialisation tableau des durees maximales pour chaque tache}
	dmax[1] := 4;
	dmax[2] := 5;
	dmax[3] := 4;
	dmax[4] := 3;

	{affichage des valeurs initiales}
	writeln('Tableau des couts et durees :'); writeln;
	for j := 1 to n do
	begin
		afficherTableau(cd[j], k);
	end;
	writeln;
	writeln(' n = ', n);
	writeln(' k = ', k);
	writeln;

	{appel}
	coutOpt := infini;
	cout := 0; duree:=0;
	nbAppel := 1;
	ordonnancementSimple (1);

	{affichage du nombres d'appels d'ordonnancementSimple}
	writeln('Nombre d''appels : ',nbAppel);
	writeln;
end.
