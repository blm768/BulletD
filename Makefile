D_SRC := $(shell find bullet -iname '*.d')
C_BINDINGS := $(D_SRC:%.d=c-binding/%.cpp)

$(C_BINDINGS): gen_b.d
	rdmd -version=genBindings gen_b.d

gen_b.d: $(D_SRC) gen_a.d
	rdmd -version=genBindings gen_a.d

