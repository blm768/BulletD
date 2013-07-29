DC := dmd
RDC := rdmd --compiler=$(DC)

LDFLAGS += -lBulletDynamics -lBulletCollision -lLinearMath -lstdc++
D_LDFLAGS += $(patsubst %, -L%, $(LDFLAGS))
DFLAGS += -g
CFLAGS += -I /usr/include/bullet
CFLAGS += -g

d_src := $(shell find bullet -iname '*.d')
d_dirs := $(shell find bullet -type d)
d_all_d := $(d_dirs:%=%/all.d)
d_gen := $(d_all_d) bullet/bindings/sizes.d
d_nongen := $(filter-out $(d_gen), $(d_src))
#Redefined to include generated files
d_src := $(d_gen) $(d_nongen)
d_bindings := $(filter-out bullet/bindings/%, $(d_nongen))
glue_src := $(d_bindings:%.d=glue/%.cpp)
glue_objs := $(glue_src:%.cpp=%.o)

test: test.o $(glue_objs)
	$(DC) $(DFLAGS) $^ $(D_LDFLAGS) -of$@

test.o: test.d $(d_src) bullet/bindings/sizes.d
	$(DC) $^ -c -of$@

$(d_all_d) : $(d_nongen)
	$(RDC) gen_import.d

libbullet-d.a: $(glue_objs)
	ar rcs $@ $^

$(glue_objs): %.o: %.cpp
	g++ $(CFLAGS) $< $(LDFLAGS) -c -o $@

bullet/bindings/sizes.d: gen_c
	./gen_c

gen_c: gen_c.cpp
	g++ $(CFLAGS) $< $(LDFLAGS) -o $@

$(glue_src) gen_c.cpp: gen_b.d
	$(RDC) -version=genBindings gen_b.d

gen_b.d: $(d_nongen) gen_a.d
	$(RDC) -version=genBindings gen_a.d

.PHONY: clean

clean:
	rm -rf glue/ gen_b.d gen_c.cpp gen_c $(d_gen) libbullet-d.a test.o test

