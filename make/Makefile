################################
# VARIABLES
################################

# os is windows
ifeq ($(OS),Windows_NT)
	os := windows
# os is linux
else
	os := linux
endif

ifeq ($(os), windows)
	# set windows file extensions
	obj_ext := obj
	lib_ext := lib
	exe_ext := .exe

	# no dmd linker flags needed
	dmd_linker_flag_l := 
else
	# set linux file extensions
	obj_ext := o
	lib_ext := a
	exe_ext := 

	# dmd linker flag needed
	dmd_linker_flag_l := -L-l
endif

# set compiler to dmd
DC := dmd
# set compiler to rdmd using dmd
RDC := rdmd --compiler=$(DC)

ifeq ($(os), windows)
	# fix MinGW messing with slashes
	fix_prefix = TEMP="$(shell echo $$TEMP | sed 's|/|\\|g')"
	# apply slashes fix to dmd and rdmd calls
	DC := $(fix_prefix) $(DC)
	RDC := $(fix_prefix) $(RDC)
endif

# needed bullet libs
bullet_libs = BulletDynamics BulletCollision LinearMath

# path to bullet header files
BULLET_LIB_DIR := E:\private\meinmein\bullet-install\lib
# path to bullet libs
BULLET_INCLUDE_DIR := E:\private\meinmein\bullet-install\include\bullet

# flags to pass to the linker (ld)
# += defines OR appends, so it's actually a bug?
# -lBulletDynamics -lBulletCollision -lLinearMath -lstdc++
LDFLAGS += $(bullet_libs:%=-l%) -lstdc++ -static
# redefine ldflags to
# -L C:\_prog\MinGWExternal\bullet\lib -lBulletDynamics -lBulletCollision -lLinearMath -lstdc++
LDFLAGS := -L $(BULLET_LIB_DIR) $(LDFLAGS)

# if not windows
ifneq ($(os), windows)
	# define d_ldflags from ldflags
	# -L-L -LC:\_prog\MinGWExternal\bullet\lib -L-lBulletDynamics -L-lBulletCollision -L-lLinearMath -L-lstdc++
	D_LDFLAGS += $(LDFLAGS:%=-L%)
endif

# dmd flags
# -g
DFLAGS += -g

# g++ flags
# -I C:\_prog\MinGWExternal\bullet\include -g
CFLAGS += -I $(BULLET_INCLUDE_DIR)
CFLAGS += -g

# find case-insensitive (-iname) files in bullet subdir named .d
# bullet/bindings/bindings.d bullet/bindings/types.d bullet/linearMath/scalar.d
d_src := $(shell find bullet -iname '*.d')

# find directories in bullet (so, subdirs of bullet)
# bullet bullet/bindings bullet/linearMath
d_dirs := $(shell find bullet -type d)

# define paths for all.d files
# bullet/all.d bullet/bindings/all.d bullet/linearMath/all.d
d_all_d := $(d_dirs:%=%/all.d)

# define empty d_gen_stage_b
d_gen_stage_b := 

# if windows
ifeq ($(os), windows)
	# add to d_gen_stage_b
	# bullet/bindings/glue.d
	d_gen_stage_b += bullet/bindings/glue.d
endif

# define d_gen_stage_c
# bullet/bindings/sizes.d
d_gen_stage_c := bullet/bindings/sizes.d

# combine above vars. these are all the generated d files
# bullet/all.d bullet/bindings/all.d bullet/linearMath/all.d bullet/bindings/glue.d bullet/bindings/sizes.d
d_gen := $(d_all_d) $(d_gen_stage_b) $(d_gen_stage_c)

# get non-generated files from src (safety feature to make sure no duplicates happen? ie. not cleaned inbetween makes)
# bullet/bindings/bindings.d bullet/bindings/types.d bullet/linearMath/scalar.d
d_nongen := $(filter-out $(d_gen), $(d_src))

# redefine to consist of non-generated and generated .d files
# bullet/all.d bullet/bindings/all.d bullet/linearMath/all.d bullet/bindings/glue.d bullet/bindings/sizes.d bullet/bindings/bindings.d bullet/bindings/types.d bullet/linearMath/scalar.d
d_src := $(d_gen) $(d_nongen)

# get all non bullet/bindings from d_nongen
# bullet/linearMath/scalar.d
d_bindings := $(filter-out bullet/bindings/%, $(d_nongen))

# define glue_src
# glue/bullet/linearMath/scalar.cpp
glue_src := $(d_bindings:%.d=glue/%.cpp)

# define glue_objs
# glue/bullet/linearMath/scalar.o
glue_objs := $(glue_src:%.cpp=%.o)

# define glue_lib
# libBulletD.lib
glue_lib := libBulletD.$(lib_ext)

################################
# TARGETS
################################

# make all
# targets are ordered so everything is made BEFORE attempting to make test.obj & test.exe
all: clean $(d_src) $(glue_lib) test

# create test.exe
# needs test.obj libBulletD.lib
# dmd -v -g test.obj libBulletD.lib -oftest
test: test.$(obj_ext) $(glue_lib)
	$(DC) -v $(DFLAGS) test.$(obj_ext) $(dmd_linker_flag_l)$(glue_lib) $(D_LDFLAGS) -of$@

# create test.obj
# needs test.d bullet/all.d bullet/bindings/all.d bullet/linearMath/all.d bullet/bindings/glue.d bullet/bindings/sizes.d bullet/bindings/bindings.d bullet/bindings/types.d bullet/linearMath/scalar.d
# dmd <seeabove> -c -oftest.obj
test.$(obj_ext): test.d $(d_src)
	$(DC) $^ -c -of$@

ifeq ($(os), windows)
# create libBulletD.lib
# needs libBulletD.lib
# implib //s libBulletD.lib libBulletD.dll
$(glue_lib): libBulletD.dll
	implib //s $@ $<

# create libBulletD.dll
# needs glue/bullet/linearMath/scalar.o
# g++ -shared -Wl,--export-all glue/bullet/linearMath/scalar.o -L C:\_prog\MinGWExternal\bullet\lib -lBulletDynamics -lBulletCollision -lLinearMath -lstdc++-o libBulletD.dll
libBulletD.dll: $(glue_objs)
	g++ -shared -Wl,--export-all $^ $(LDFLAGS) -o libBulletD.dll
else
# linux does above in 1 step via ar
$(glue_lib): $(glue_objs)
	ar rcs $@ $^
endif

# create glue/bullet/linearMath/scalar.o
# needs glue/bullet/linearMath/scalar.cpp
# g++ -I C:\_prog\MinGWExternal\bullet\include -g glue/bullet/linearMath/scalar.cpp -c -o glue/bullet/linearMath/scalar.o
$(glue_objs): %.o: %.cpp
	g++ $(CFLAGS) $< -c -o $@

# create bullet/bindings/sizes.d
# needs gen_c.exe
# runs gen_c.exe
$(d_gen_stage_c): gen_c
	./gen_c

# create gen_c.exe
# needs gen_c.cpp
# g++ -I C:\_prog\MinGWExternal\bullet\include -g gen_c.cpp -L C:\_prog\MinGWExternal\bullet\lib -lBulletDynamics -lBulletCollision -lLinearMath -lstdc++ -o gen_c
gen_c: gen_c.cpp
	g++ $(CFLAGS) $< $(LDFLAGS) -o $@

# create bullet/bindings/glue.d
# create glue/bullet/linearMath/scalar.cpp
# create gen_c.cpp
# via --> compiles & runs gen_b.d
# needs gen_b.d
# rdmd --compiler=dmd -version=genBindings gen_b.d
$(d_gen_stage_b) $(glue_src) gen_c.cpp: gen_b.d
	$(RDC) -version=genBindings gen_b.d

# create gen_b.d
# needs bullet/bindings/bindings.d bullet/bindings/types.d bullet/linearMath/scalar.d bullet/all.d bullet/bindings/all.d bullet/linearMath/all.d gen_a.d
# rdmd --compiler=dmd -version=genBindings gen_a.d
gen_b.d: $(d_nongen) $(d_all_d) gen_a.d
	$(RDC) -version=genBindings gen_a.d

# compile & run gen_import.d
# which creates all.d's
# needs bullet/bindings/bindings.d bullet/bindings/types.d bullet/linearMath/scalar.d
# rdmd --compiler=dmd gen_import.d
$(d_all_d) : $(d_nongen)
	$(RDC) gen_import.d

################################
# CLEANUP
################################

# define clean as a command, not a file
.PHONY: clean
# do the cleanup (leaves /tmp/.rdmd folder behind, manual deletion required)
clean:
	rm -rf glue/ gen_b.d gen_c.cpp gen_c$(exe_ext) $(d_gen) libBulletD.* *.o *.$(obj_ext) *.$(lib_ext) test$(exe_ext)
	
################################
# EXAMPLE MAKE (targets are used from bottom to top!)
################################
#
# $ make
# TEMP="\tmp" rdmd --compiler=dmd gen_import.d
# DMD v2.064 DEBUG
# TEMP="\tmp" rdmd --compiler=dmd -version=genBindings gen_a.d
# DMD v2.064 DEBUG
# TEMP="\tmp" rdmd --compiler=dmd -version=genBindings gen_b.d
# DMD v2.064 DEBUG
# g++ -I C:\_prog\MinGWExternal\bullet\include -g gen_c.cpp -L C:\_prog\MinGWExternal\bullet\lib -lBulletDynamics -lBulletCollision -lLinearMath -lstdc++ -o gen_c
# 
# ./gen_c
# g++ -I C:\_prog\MinGWExternal\bullet\include -g glue/bullet/linearMath/scalar.cpp -c -o glue/bullet/linearMath/scalar.o
# g++ -shared -Wl,--export-all glue/bullet/linearMath/scalar.o -L C:\_prog\MinGWExternal\bullet\lib -lBulletDynamics -lBulletCollision -lLinearMath -lstdc++ -o libBulletD.dll
# implib //s libBulletD.lib libBulletD.dll
# Digital Mars Import Library Manager Version 7.6B1n
# Copyright (C) Digital Mars 2000.  All Rights Reserved.
# Input is a Windows NT DLL file 'libBulletD.dll'.
# Output is a Windows NT import library.
# Digital Mars Import Library Creator complete.
# TEMP="\tmp" dmd test.d bullet/all.d bullet/bindings/all.d bullet/linearMath/all.d bullet/bindings/glue.d bullet/bindings/sizes.d bullet/bindings/bindings.d bullet/bindings/types.d bullet/linearMath/scalar.d -c -oftest.obj
# DMD v2.064 DEBUG
# TEMP="\tmp" dmd -v -g test.obj libBulletD.lib  -oftest
# DMD v2.064 DEBUG
# binary    c:\_prog\D\dmd2\windows\bin\dmd.exe
# version   v2.064
# config    c:\_prog\D\dmd2\windows\bin\sc.ini
# c:\_prog\D\dmd2\windows\bin\link.exe test,test,nul,"libBulletD.lib"+user32+kernel32/co/noi;

################################
# g++ compiler arguments
################################
#
# -I path/to/includes
# -L path/to/libs
# -l name of lib to use
# -g add debuginfo
# -o name of outputfile
# -c compile-only, don't link
# -shared create shared object (.so)
# -Wl,--export-all the linker (ld) includes all symbols
#( -Wl, passes option to linker)
