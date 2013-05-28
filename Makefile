D_SRC := $(shell find bullet -iname '*.d')
D_BINDINGS := $(filter-out bullet/bindings/%, $(D_SRC))
GLUE_SRC := $(D_BINDINGS:%.d=glue/%.cpp)
GLUE_OBJS := $(GLUE_SRC:%.cpp=%.o)

test: test.d $(GLUE_OBJS) bullet/bindings/sizes.d
	rdmd $^ -of=$@

bullet-glue.a: $(GLUE_OBJS)
	ar rcs $@ $^

$(GLUE_OBJS): %.o: %.cpp
	g++ $(CFLAGS) $< -c -o $@

bullet/bindings/sizes.d: gen_sizes
	./gen_sizes

gen_sizes: gen_sizes.cpp
	g++ $(CFLAGS) $< -o $@

$(GLUE_SRC) gen_sizes.cpp: gen_b.d
	rdmd -version=genBindings gen_b.d

gen_b.d: $(D_SRC) gen_a.d
	rdmd -version=genBindings gen_a.d

