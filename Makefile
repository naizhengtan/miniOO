all: ast heapstack executor yacc lexer
	ocamlc -c mini.ml
	ocamlc -o mini astree.cmo heapstack.cmo executor.cmo miniLEX.cmo miniYACC.cmo mini.cmo

yacc:
	ocamlyacc miniYACC.mly
	ocamlc -c miniYACC.mli
	ocamlc -c miniYACC.ml

lexer:
	ocamllex miniLEX.mll
	ocamlc -c miniLEX.ml 

ast:
	ocamlc -i astree.ml > astree.mli
	ocamlc -c astree.mli
	ocamlc -c astree.ml

heapstack:
	ocamlc -i heapstack.ml > heapstack.mli
	ocamlc -c heapstack.mli
	ocamlc -c heapstack.ml

executor:
	ocamlc -i executor.ml > executor.mli
	ocamlc -c executor.mli
	ocamlc -c executor.ml


clean:
	rm mini *.cmi *.cmo  *.mli miniLEX.ml miniYACC.ml miniYACC.output \
