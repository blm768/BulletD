/*
Copyright (c) 2003-2006 Gino van den Bergen / Erwin Coumans  http://continuousphysics.com/Bullet/

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.
Permission is granted to anyone to use this software for any purpose, 
including commercial applications, and to alter it and redistribute it freely, 
subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

/*
StackAlloc extracted from GJK-EPA collision solver by Nathanael Presson
Nov.2006
*/

//D port of Bullet Physics

module bullet.linearMath.btStackAlloc;

import bullet.linearMath.btScalar;

///The btBlock class is an internal structure for the btStackAlloc memory allocator.
struct btBlock {
	btBlock* previous;
	ubyte* address;
};

///The StackAlloc struct provides a fast stack-based memory allocator (LIFO last-in first-out)
struct btStackAlloc {
public:

	this(uint size)	{create(size);}
	~this()	{destroy();}
	
	void create(size_t size) {
		destroy();
		pool.length = size;
	}
	
	void destroy() {
		btAssert(usedsize == 0, "StackAlloc is still in use.");

		if(usedsize==0) {
			pool.length = 0;
		}
	}

	int	getAvailableMemory() const {
		return cast(int)(pool.length - usedsize);
	}

	ubyte* allocate(size_t size) {
		const size_t nus = usedsize + size;
		if(nus < pool.length) {
			usedsize = nus;
			return(data + (usedsize - size));
		}
		btAssert(false, "Not enough memory");
		
		return(0);
	}
	
	btBlock* beginBlock() {
		btBlock* pb = cast(btBlock*)allocate(btBlock.sizeof);
		pb.previous	=	current;
		pb.address = data.ptr + usedsize;
		current	= pb;
		return pb;
	}
	void endBlock(btBlock* block) {
		btAssert(block == current, "Unmatched blocks");
		
		if(block == current) {
			current	= block.previous;
			usedsize = cast(size_t)((block.address - data.ptr) - btBlock.sizeof);
		}
	}

private:
	ubyte[]		pool;
	size_t		usedsize;
	btBlock*	current;
};
