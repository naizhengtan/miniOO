all:
	ocamllex miniLEX.mll
	ocamlyacc miniYACC.mly
	ocamlc -i astree.ml > astree.mli
	ocamlc -i heapstack.ml > heapstack.mli
	ocamlc -c astree.mli
	ocamlc -c heapstack.mli
	ocamlc -c miniYACC.mli
	ocamlc -c astree.ml
	ocamlc -c heapstack.ml
	ocamlc -c miniLEX.ml 
	ocamlc -c miniYACC.ml
	ocamlc -c mini.ml
	ocamlc -o mini astree.cmo heapstack.cmo miniLEX.cmo miniYACC.cmo mini.cmo

clean:
	rm mini *.cmi *.cmo  *.mli miniLEX.ml miniYACC.ml miniYACC.output \
