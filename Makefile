all:
	ocamllex miniLEX.mll
	ocamlyacc miniYACC.mly
	ocamlc -i astree.ml > astree.mli
	ocamlc -c astree.mli
	ocamlc -c miniYACC.mli
	ocamlc -c astree.ml
	ocamlc -c miniLEX.ml 
	ocamlc -c miniYACC.ml
	ocamlc -c mini.ml
	ocamlc -o mini miniLEX.cmo miniYACC.cmo astree.cmo mini.cmo

clean:
	rm mini *.cmi *.cmo miniLEX.ml miniYACC.ml miniYACC.mli miniYACC.output \
	astree.mli
