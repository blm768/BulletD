D_SRC := $(shell find bullet -iname '*.d' | grep -v '^bullet/bindings')
GLUE_SRC := $(D_SRC:%.d=glue/%.cpp)
GLUE_OBJS := $(GLUE_SRC:%.cpp=%.o)

$(GLUE_OBJS): %.o: %.cpp
	g++ $(CFLAGS) $< -c -o $@

$(GLUE_SRC): gen_b.d
	rdmd -version=genBindings gen_b.d

gen_b.d: $(D_SRC) gen_a.d
	rdmd -version=genBindings gen_a.d

