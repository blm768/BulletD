
D_SRC := $(shell find bullet -iname '*.d')
C_BINDING := $(D_SRC:%.d=c-binding/%.cpp)

$(C_BINDING): $(D_SRC)
	rdmd -version=genBindings test.d

