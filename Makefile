DFLAGS := -g
CFLAGS := $(CFLAGS) -g

D_SRC := $(shell find bullet -iname '*.d')
D_NONGENERATED := $(filter-out bullet/bindings/sizes.d, $(D_SRC))
D_BINDINGS := $(filter-out bullet/bindings/%, $(D_NONGENERATED))
GLUE_SRC := $(D_BINDINGS:%.d=glue/%.cpp)
GLUE_OBJS := $(GLUE_SRC:%.cpp=%.o)

test: test.o $(GLUE_OBJS)
	dmd $^ -of$@

test.o: test.d $(D_SRC) bullet/bindings/sizes.d
	dmd $^ -c -of$@

libbullet-glue.a: $(GLUE_OBJS)
	ar rcs $@ $^

$(GLUE_OBJS): %.o: %.cpp
	g++ $(CFLAGS) $< -c -o $@

bullet/bindings/sizes.d: gen_sizes
	./gen_sizes

gen_sizes: gen_sizes.cpp
	g++ $(CFLAGS) $< -o $@

$(GLUE_SRC) gen_sizes.cpp: gen_b.d
	rdmd -version=genBindings gen_b.d

gen_b.d: $(D_NONGENERATED) gen_a.d
	rdmd -version=genBindings gen_a.d

.PHONY: clean

clean:
	rm -rf $(GLUE_SRC) $(GLUE_OBJS) gen_b.d gen_sizes.cpp gen_sizes bullet/bindings/sizes.d libbullet-glue.a test.o test
