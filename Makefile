all: ast heapstack executor yacc lexer
	ocamlc -c mini.ml
	ocamlc -thread -o mini unix.cma threads.cma astree.cmo heapstack.cmo executor.cmo miniLEX.cmo miniYACC.cmo mini.cmo

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
	ocamlc -thread -i unix.cma threads.cma executor.ml > executor.mli
	ocamlc -thread -c unix.cma threads.cma executor.mli
	ocamlc -thread -c unix.cma threads.cma executor.ml


clean:
	rm mini *.cmi *.cmo  *.mli miniLEX.ml miniYACC.ml miniYACC.output \
