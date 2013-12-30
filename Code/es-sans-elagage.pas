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

{procedure de recherche de la solution optimale sans elagage}
procedure ordonnancementSimple (i : integer);
var
	xi, cout, duree : integer;
	T : array [1..n] of integer;
begin
	cout := 0;
	duree := 0;
	for xi := 1 to k do
	begin
		if duree <= D then begin
			T[i] := xi;
			cout := cout + cd[i,xi];
			duree := duree + xi;
			if i = n then begin
				if cout < coutOpt then begin
					{afficher T}
					for i := 1 to n do
					begin
						write (' ', T[i]);
					end;
					writeln;
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
	{initialisation du tableau des couts et durees}
	cd[1,1] := 110;
	cd[1,2] := 90;
	cd[1,3] := 65;
	cd[1,4] := 55;
	cd[1,5] := infini;

	cd[1,1] := 120;
	cd[1,2] := 90;
	cd[1,3] := 70;
	cd[1,4] := 50;
	cd[1,5] := 40;

	cd[1,1] := 90;
	cd[1,2] := 70;
	cd[1,3] := 65;
	cd[1,4] := 60;
	cd[1,5] := infini;

	cd[1,1] := 65;
	cd[1,2] := 60;
	cd[1,3] := 55;
	cd[1,4] := infini;
	cd[1,5] := infini;


	{appel}
	coutOpt := 210;
	ordonnancementSimple (1);
end.

