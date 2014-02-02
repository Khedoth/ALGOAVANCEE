program esExperimentations;

{declaration des constantes}
const
	n = 50;
	k = 10;
	D = 30;
	infini = 4200;

{declaration des variables globales}
var
	cd : array [1..n, 1..k] of integer; {tableau des couts et durees de depart}
	dmax : array [1..n] of integer; {tableau des durees maximales pour chaque tache}

	cout, duree, coutOpt : integer; {variables de calcul de la solution optimale}
	T : array [1..n] of integer; {vecteur representant un candidat}

	j,l : integer; {variables d'iteration}
	r : integer; {entier aleatoire}

	nbAppel : longint; {compte le nombre d'appels a ordonnancement simple}
	nbAppelElagage : longint; {compte le nombre d'appels a ordannancement simple avec elagage}

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

{procedure de recherche de la solution optimale sans elagage}
procedure ordonnancementSimple (i : integer);
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
					afficherTableau (T, n);
					write('duree = ',duree, ' cout = ',cout);
					writeln; writeln;
				end;
			end
			else begin
				ordonnancementSimple (i+1);
				nbAppel := nbAppel+1;
			end;

			{defaire}
			T[i] := 0;
			cout := cout - cd[i,xi];
			duree := duree - xi;
		end;
	end;
end;

{procedure de recherche de la solution optimale avec elagage}
procedure ordonnancementElagage(i : integer);
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
					ordonnancementElagage(i+1);
					nbAppelElagage := nbAppelElagage+1;
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
	writeln('--------------- version d''experimentation ---------------');
	writeln('----------------------------------------------------------');
	writeln;

	{Nouvelle sequence aleatoire}
	Randomize;

	{initialisation du tableau des couts et durees aleatoires}
	for j := 1 to n do
	begin
		r := 1000;
		for l := 1 to k do
		begin
			r := Random(r);
			if r < 10 then begin
				cd[j,l] := infini;
			end else begin
				cd[j,l] := r;
			end;
		end;
	end;

	{initialisation du tableau des durees maximales pour chaque tache}
	for j := 1 to n do
	begin
		l := k;
		while(cd[j,l] = infini) do l := l-1;
		dmax[j] := l;
	end;

	{affichage des valeurs initiales}
	writeln('Tableau des couts et durees :'); writeln;
	for j := 1 to n do
	begin
		afficherTableau(cd[j], k);
	end;
	writeln;
	writeln('Tableau des dmax : ');
	afficherTableau(dmax,n);
	writeln;
	writeln(' n = ', n);
	writeln(' k = ', k);
	writeln(' D = ', D);
	writeln;

	{appel}
	writeln('Sans élagage :'); writeln;
	coutOpt := infini;
	cout := 0; duree:=0;
	nbAppel := 1;
	ordonnancementSimple (1);

	writeln('Avec élagage :'); writeln;
	coutOpt := infini;
	cout := 0; duree:=0;
	nbAppelElagage := 1;
	ordonnancementElagage (1);

	{affichage du nombres d'appels}
	writeln('Nombre d''appels sans élagage :',nbAppel);
	writeln('Nombre d''appels avec élagage :',nbAppelElagage);
	writeln;
end.
