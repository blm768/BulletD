ifeq ($(OS),Windows_NT)
	os := windows
else
	#To do: handle other non-Windows OSes
	os := linux
endif

ifeq ($(os), windows)
	obj_ext := obj
	lib_ext := lib
else
	obj_ext := o
	lib_ext := a
endif

DC := dmd
RDC := rdmd --compiler=$(DC)

ifeq ($(os), windows)
	fix_prefix = TEMP="$(shell echo $$TEMP | sed 's|/|\\|g')"
	DC := $(fix_prefix) $(DC) 
	RDC := $(fix_prefix) $(RDC) 
endif

bullet_libs = BulletDynamics BulletCollision LinearMath

BULLET_INCLUDE_DIR := /usr/include/bullet
BULLET_LIB_DIR := /usr/lib

LDFLAGS += $(bullet_libs:%=-l%) -lstdc++
LDFLAGS := -L $(BULLET_LIB_DIR) $(LDFLAGS)
ifneq ($(os), windows)
	D_LDFLAGS += $(LDFLAGS:%=-L%)
endif
DFLAGS += -g
CFLAGS += -I $(BULLET_INCLUDE_DIR)
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

glue_lib := libBulletD.$(lib_ext)

test: test.$(obj_ext) $(glue_lib)
	$(DC) $(DFLAGS) $^ $(D_LDFLAGS) -of$@

test.$(obj_ext): test.d $(d_src) bullet/bindings/sizes.d
	$(DC) $^ -c -of$@

$(d_all_d) : $(d_nongen)
	$(RDC) gen_import.d

ifeq ($(os), windows)
$(glue_lib): libBulletD.dll
	implib $@ $<

libBulletD.dll: $(glue_objs)
	g++ -shared -Wl,--export-all $^ $(LDFLAGS) -o libBulletD.dll

#$(glue_lib): libBulletD.dll
#	implib $@ $<
else
$(glue_lib): $(glue_objs)
	ar rcs $@ $^
endif


$(glue_objs): %.o: %.cpp
	g++ $(CFLAGS) $< -c -o $@

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
	rm -rf glue/ gen_b.d gen_c.cpp gen_c $(d_gen) libBulletD.* *.$(obj_ext) *.lib_ext test

