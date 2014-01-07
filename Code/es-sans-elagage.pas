program esSansElagage;

{declaration des constantes}
const
	n = 4;
	k = 5;
	D = 10;
	infini = 4200;

{declaration des variables globales}
var
	cd : array [1..n, 1..k] of integer;
	coutOpt : integer;
	T : array [1..n] of integer;
	j : integer;

{procedure d'affichage d'un tableau}
procedure afficherTableau (var tableau : array of integer; taille : integer);
var
	i : integer;
begin
	for i := 0 to taille-1 do
	begin
		write (' ', tableau[i]);
	end;
	writeln;
end;

{procedure de recherche de la solution optimale sans elagage}
procedure ordonnancementSimple (i : integer);
var
	xi : integer;
	cout,duree : integer;
begin
	for xi := 1 to k do
	begin
		{fix me}
		if i = 1 then begin
			cout := 0;
			duree := 0;
			writeln('cout = ',cout, ' duree = ',duree);
		end;
		duree := duree + xi;
		cout := cout + cd[i,xi];
		writeln('cd[',i,',',xi,'] = ',cd[i,xi]);
		writeln('cout = ',cout);
		if duree <= D then begin
			T[i] := xi;
			if i = n then begin
				if cout <= coutOpt then begin
					afficherTableau (T, n);
					write('duree = ',duree, ' cout = ',cout);
					writeln; writeln;
				end;
			end
			else
				ordonnancementSimple (i+1);
		end;
		T[i] := 0;
		cout := cout - cd[i,xi];
		duree := duree - xi;
	end;
end;

{corps du programme}
begin
	{message de demarrage}
	writeln('----------------------------------------------------------');
	writeln('Ordonnancement simple par la méthode des essais successifs');
	writeln('----------------- version sans elagage -------------------');
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
	coutOpt := 210;
	ordonnancementSimple (1);
end.
