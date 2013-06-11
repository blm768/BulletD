LDFLAGS += -lBulletDynamics -lBulletCollision -lLinearMath
D_LDFLAGS += $(patsubst %, -L%, $(LDFLAGS))
DFLAGS += -g
CFLAGS += -I /usr/include/bullet
CFLAGS += -g

D_SRC := $(shell find bullet -iname '*.d')
D_NONGENERATED := $(filter-out bullet/bindings/sizes.d, $(D_SRC))
D_BINDINGS := $(filter-out bullet/bindings/%, $(D_NONGENERATED))
GLUE_SRC := $(D_BINDINGS:%.d=glue/%.cpp)
GLUE_OBJS := $(GLUE_SRC:%.cpp=%.o)

test: test.o $(GLUE_OBJS)
	dmd $(DFLAGS) $^ $(D_LDFLAGS) -of$@

test.o: test.d $(D_SRC) bullet/bindings/sizes.d
	dmd $^ -c -of$@

libbullet-d.a: $(GLUE_OBJS)
	ar rcs $@ $^

$(GLUE_OBJS): %.o: %.cpp
	g++ $(CFLAGS) $< -c -o $@

bullet/bindings/sizes.d: gen_c
	./gen_c

gen_c: gen_c.cpp
	g++ $(CFLAGS) $< $(LDFLAGS) -o $@

$(GLUE_SRC) gen_c.cpp: gen_b.d
	rdmd -version=genBindings gen_b.d

gen_b.d: $(D_NONGENERATED) gen_a.d
	rdmd -version=genBindings gen_a.d

.PHONY: clean

clean:
	rm -rf glue/ gen_b.d gen_c.cpp gen_c bullet/bindings/sizes.d libbullet-d.a test.o test

