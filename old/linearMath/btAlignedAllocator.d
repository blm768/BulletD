/*
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2003-2006 Erwin Coumans  http://continuousphysics.com/Bullet/

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.
Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it freely,
subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

//D port of Bullet Physics

module bullet.linearMath.btAlignedAllocator;

import std.c.stdlib;

import bullet.linearMath.btScalar;

//To do: support BT_DEBUG_MEMORY_ALLOCATIONS

alias btAlignedAllocInternal btAlignedAlloc;
alias btAlignedFreeInternal btAlignedFree;

alias void* function(size_t size, int alignment) btAlignedAllocFunc;
alias void function(void* memblock) btAlignedFreeFunc;
alias void* function(size_t size) btAllocFunc;
alias void function(void* memblock) btFreeFunc;

/++
If the developer has already an custom aligned allocator, then btAlignedAllocSetCustomAligned can be used.
The default aligned allocator pre-allocates extra memory using the non-aligned allocator, and instruments it.
+/
void btAlignedAllocSetCustomAligned(btAlignedAllocFunc allocFunc, btAlignedFreeFunc freeFunc) {
	sAlignedAllocFunc = allocFunc ? allocFunc : &btAlignedAllocDefault;
	sAlignedFreeFunc = freeFunc ? freeFunc : &btAlignedFreeDefault;
}

///The developer can let all Bullet memory allocations go through a custom memory allocator, using btAlignedAllocSetCustom
void btAlignedAllocSetCustom(btAllocFunc allocFunc, btFreeFunc freeFunc) {
  sAllocFunc = allocFunc ? allocFunc : &btAllocDefault;
  sFreeFunc = freeFunc ? freeFunc : &btFreeDefault;
}

private void* btAllocDefault(size_t size) {
	return malloc(size);
}

private void btFreeDefault(void* ptr) {
	free(ptr);
}

private btAllocFunc sAllocFunc = &btAllocDefault;
private btFreeFunc sFreeFunc = &btFreeDefault;

static btAlignedAllocFunc sAlignedAllocFunc = &btAlignedAllocDefault;
static btAlignedFreeFunc sAlignedFreeFunc = &btAlignedFreeDefault;

int gNumAlignedAllocs = 0;
int gNumAlignedFree = 0;
int gTotalBytesAlignedAllocs = 0;//detect memory leaks

void*	btAlignedAllocInternal	(size_t size, int alignment) {
	gNumAlignedAllocs++;
	void* ptr;
	ptr = sAlignedAllocFunc(size, alignment);
//	printf("btAlignedAllocInternal %d, %x\n",size,ptr);
	return ptr;
}

void	btAlignedFreeInternal	(void* ptr) {
	if (!ptr) {
		return;
	}

	gNumAlignedFree++;
//	printf("btAlignedFreeInternal %x\n",ptr);
	sAlignedFreeFunc(ptr);
}

//To do: support BT_HAS_ALIGNED_ALLOCATOR
version(BT_HAS_ALIGNED_ALLOCATOR) {
	private void *btAlignedAllocDefault(size_t size, int alignment) {
		return _aligned_malloc(size, cast(size_t)alignment);
	}
	
	private void btAlignedFreeDefault(void *ptr) {
		_aligned_free(ptr);
	}
} else version(CELLOS_LV2) {
	private void *btAlignedAllocDefault(size_t size, int alignment) {
		return memalign(alignment, size);
	}
	
	private void btAlignedFreeDefault(void *ptr) {
		free(ptr);
	}
} else {
	private void *btAlignedAllocDefault(size_t size, int alignment) {
	  void *ret;
	  char *_real;
	  _real = cast(char *)sAllocFunc(size + (void *).sizeof + (alignment-1));
	  if (_real) {
		ret = btAlignPointer(_real + (void *).sizeof,alignment);
		*(cast(void **)(ret)-1) = cast(void *)(_real);
	  } else {
		ret = cast(void *)(_real);
	  }
	  return (ret);
	}

	private void btAlignedFreeDefault(void *ptr) {
	  void* _real;

	  if (ptr) {
		_real = *(cast(void **)(ptr)-1);
		sFreeFunc(_real);
	  }
	}
}

///The btAlignedAllocator is a portable class for aligned memory allocations.
///Default implementations for unaligned and aligned allocations can be overridden by a custom allocator using btAlignedAllocSetCustom and btAlignedAllocSetCustomAligned.
class btAlignedAllocator (T, size_t alignment) {
public:

        //just going down a list:
        this()() {}
        /*
        btAlignedAllocator( const ref btAlignedAllocator ) {}
        */

        this(Other)(const btAlignedAllocator!(Other, alignment) ) {}

		static if(is(T == class)) {
			alias T Pointer;
		} else {
			alias T* Pointer;
		}
        alias T ValueType;

		//To do: remove? (doesn't work well with objects)
		//inout(Pointer) address (inout ref T reference) inout {return reference; }

        Pointer allocate ( size_t n, const void* hint = null ) {
                cast(void)hint;
                return cast(Pointer)(btAlignedAlloc(T.sizeof * n , alignment));
        }

        //To do: redesign?
        void construct()(Pointer ptr, const auto ref T value) {
        	//To do: verify that this is OK for classes.
			(cast(ubyte*)ptr)[0 .. T.sizeof] = T.init[];
			static if(is(T == class)) {
				T._ctor(value);
			}
        }
        void deallocate(Pointer ptr) {
                btAlignedFree(cast(void*)ptr);
        }
        void destroy (Pointer ptr) { _d_callfinalizer(cast(void*)ptr); }


        struct rebind(O) {
                alias btAlignedAllocator!(O, alignment) other;
        };
        //To do: duplicate Bullet's operator= (which is a no-op)?

        bool opEquals(const btAlignedAllocator other) { return true; }
};


