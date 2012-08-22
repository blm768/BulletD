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

module bullet.linearMath.btPoolAllocator;

import bullet.linearMath.btScalar;

//If overflow is allowed, overflow will fall back to standard memory allocation rather than throwing an exception.
//version = allowAllocationOverflow;

///The btPoolAllocator class allows to efficiently allocate a large pool of objects, instead of dynamically allocating them separately.
class btPoolAllocator(T) {
	alias ubyte[T.sizeof] block;
	
	int				m_maxElements;
	int				m_freeCount;
	void*			m_firstFree;
	block[] m_pool;

public:

	this(int maxElements) {
		m_maxElements = maxElements;
		
		m_pool.length = m_maxElements;
		
		//Each empty block starts with a pointer to the next empty block.
		block* p = m_pool.ptr;
        m_firstFree = p;
        m_freeCount = m_maxElements;
        int count = m_maxElements;
        while (--count) {
            *cast(void**)p = (p + 1);
            p += 1;
        }
        *cast(void**)p = null;
    }

	int	getFreeCount() const {
		return m_freeCount;
	}

	int getUsedCount() const {
		return m_maxElements - m_freeCount;
	}

	int getMaxCount() const {
		return m_maxElements;
	}

	void* allocate() {
		version(allowAllocationOverflow) {
			//In case of overflow, just allocate a new block.
			if(m_freeCount == 0) {
				return cast(void*)(new block);
			}
		} else {
			btAssert(m_freeCount > 0);
		}
        void* result = m_firstFree;
		
		//Set m_firstFree to the next free block.
        m_firstFree = *cast(void**)m_firstFree;
        --m_freeCount;
        return result;
	}

	bool validPtr(void* ptr) {
		if (ptr) {
			return cast(block*)ptr >= m_pool.ptr && cast(block*)ptr < m_pool.ptr + m_maxElements;
		}
		return false;
	}

	void freeMemory(void* ptr) {
		 if (ptr) {
			version(allowAllocationOverflow) {
				if(cast(block*)ptr < m_pool.ptr || cast(block*)ptr >= m_pool.ptr + m_maxElements)
					//This pointer is outside our range; let the GC handle it.
					return;
			} else {
				//Pointers shouldn't be outside our range; if they are, complain loudly.
				btAssert(cast(block*)ptr >= m_pool.ptr && cast(block*)ptr < m_pool.ptr + m_maxElements);
			}
			
			//Now this block is the first free one.
            *cast(void**)ptr = m_firstFree;
            m_firstFree = ptr;
            ++m_freeCount;
        }
	}

	int	getElementSize() const {
		return T.sizeof;
	}

	ubyte*	getPoolAddress() {
		return cast(ubyte*)m_pool.ptr;
	}

	const ubyte* getPoolAddress() const {
		return cast(ubyte*)m_pool.ptr;
	}

};