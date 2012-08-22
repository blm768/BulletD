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

module bullet.linearMath.btAlignedObjectArray;

import bullet.linearMath.btScalar;

///If the platform doesn't support placement new, you can disable BT_USE_PLACEMENT_NEW
///then the btAlignedObjectArray doesn't support objects with virtual methods, and non-trivial constructors/destructors
///You can enable BT_USE_MEMCPY, then swapping elements in the array will use memcpy instead of operator=
///see discussion here: http://continuousphysics.com/Bullet/phpBB2/viewtopic.php?t=1231 and
///http://www.continuousphysics.com/Bullet/phpBB2/viewtopic.php?t=1240

//#define BT_USE_PLACEMENT_NEW 1
//#define BT_USE_MEMCPY 1 //disable, because it is cumbersome to find out for each platform where memcpy is defined. It can be in <memory.h> or <string.h> or otherwise...

version(BT_USE_MEMCPY) {
	import std.c.memory;
	import std.string;
}

///The btAlignedObjectArray template class uses a subset of the stl::vector interface for its methods
///It is developed to replace stl::vector to avoid portability issues, including STL alignment issues to add SIMD/SSE data

//To do: replace m_capacity with reserve() to prevent loss of synchronization?
struct btAlignedObjectArray (T) {

	T[] m_data;
	size_t m_capacity;

	protected:
		int	allocSize(int size) {
			return (size ? size*2 : 1);
		}
		void copy(int start, int end, T* dest) const {
			dest[0 .. (end - start)] = cast(T[])m_data[start .. end];
		}
		
		//Replaced by GC
		/*void* allocate(int size) {
			if (size)
				return m_allocator.allocate(size);
			return 0;
		}

		void deallocate() {
			if(m_data)	{
				//PCK: enclosed the deallocation in this block
				if (m_ownsMemory) {
					m_allocator.deallocate(m_data);
				}
				m_data = 0;
			}
		}*/

	


	public:

		//Postblit
		//Todo: remove in favor of class + const references?
		this(this) {
			m_data = m_data.dup;
			m_capacity = m_data.length;
		}
		
		/// return the number of elements in the array
		@property int length() const {	
			return m_data.length;
		}
		alias length size;
		
		ref T at(int n) {
			btAssert(n >= 0);
			btAssert(n<size());
			return m_data[n];
		}

		T opIndex(int n) {
			btAssert(n>=0);
			btAssert(n<size());
			return m_data[n];
		}
		
		void opIndexOpAssign()(uint n, auto ref T value) {
			m_data[n] = value;
		}
		

		///clear the array, deallocated memory. Generally it is better to use array.resize(0), to reduce performance overhead of run-time memory (de)allocations.
		void clear() {
			m_data.length = 0;
			m_capacity = 0;
		}

		void pop_back() {
			btAssert(m_data.length>0);
			m_data.length = m_data.length - 1;
		}

		///resize changes the number of elements in the array. If the new size is larger, the new elements will be constructed using the optional second argument.
		///when the new number of elements is smaller, memory will not be freed, to reduce performance overhead of run-time memory (de)allocations.
		void resize()(int newsize, const auto ref T fillData = T.init) {
			//The runtime should handle the gnarly details.
			m_data.length = newsize;
			m_capacity = newsize;
		}
	
		ref T expandNonInitializing() {
			int sz = m_data.length;
			if(sz >= m_capacity) {
				reserve(allocSize(m_data.length));
			}
			m_data = m_data.ptr[0 .. m_data.length + 1];

			return m_data[sz];
		}
		
		ref T expand()() {
			int sz = m.data.length;
			if(sz >= m_capacity) {
				reserve(allocSize(data.length));
			}
			data.length += 1;
		}

		ref T expand()(const auto ref T fillValue) {	
			int sz = m.data.length;
			expandNonInitializing();
			data[$ - 1] = fillValue;

			return m_data[sz];		
		}


		void push_back()(auto ref T _Val) {	
			m_data ~= _Val;
		}

	
		/// return the pre-allocated (reserved) elements, this is at least as large as the total number of elements,see size() and reserve()
		int capacity() const {	
			return m_capacity;
		}
		
		void reserve(int _Count) {
			m_capacity = m_data.reserve(_Count);
		}


		alias bool function(T a, T b) Comparator;
		
		static bool less(T a, T b) {
			return a < b;
		}
	
		void quickSortInternal(Comparator CompareFunc, int lo, int hi) {
		//  lo is the lower index, hi is the upper index
		//  of the region of array a that is to be sorted
			int i=lo, j=hi;
			T x=m_data[(lo+hi)/2];

			//  partition
			do
			{    
				while (CompareFunc(m_data[i],x)) 
					i++; 
				while (CompareFunc(x,m_data[j])) 
					j--;
				if (i<=j)
				{
					swap(i,j);
					i++; j--;
				}
			} while (i<=j);

			//  recursion
			if (lo<j) 
				quickSortInternal( CompareFunc, lo, j);
			if (i<hi) 
				quickSortInternal( CompareFunc, i, hi);
		}


		void quickSort(L)(L CompareFunc)
		{
			//don't sort 0 or 1 elements
			if (m_data.length > 1) {
				quickSortInternal(CompareFunc,0,size()-1);
			}
		}


		///heap sort from http://www.csse.monash.edu.au/~lloyd/tildeAlgDS/Sort/Heap/
		void downHeap(L)(T *pArr, int k, int n, L CompareFunc) {
			/*  PRE: a[k+1..N] is a heap */
			/* POST:  a[k..N]  is a heap */
			
			T temp = pArr[k - 1];
			/* k has child(s) */
			while (k <= n/2) 
			{
				int child = 2*k;
				
				if ((child < n) && CompareFunc(pArr[child - 1] , pArr[child]))
				{
					child++;
				}
				/* pick larger child */
				if (CompareFunc(temp , pArr[child - 1]))
				{
					/* move child up */
					pArr[k - 1] = pArr[child - 1];
					k = child;
				}
				else
				{
					break;
				}
			}
			pArr[k - 1] = temp;
		} /*downHeap*/

		void swap(int index0 ,int index1) {
			version(BT_USE_MEMCPY) {
				char temp[T.sizeof];
				memcpy(temp,&m_data[index0],sizeof(T));
				memcpy(&m_data[index0],&m_data[index1],sizeof(T));
				memcpy(&m_data[index1],temp,sizeof(T));
			} else {
				T temp = m_data[index0];
				m_data[index0] = m_data[index1];
				m_data[index1] = temp;
			}
		}

	void heapSort(L)(L CompareFunc) {
		/* sort a[0..N-1],  N.B. 0 to N-1 */
		int k;
		int n = m_data.length;
		for (k = n/2; k > 0; k--) {
			downHeap(m_data, k, n, CompareFunc);
		}

		/* a[1..N] is now a heap */
		while ( n>=1 ) {
			swap(0,n-1); /* largest of a[0..n-1] */

			n = n - 1;
			/* restore a[1..i-1] heap */
			downHeap(m_data, 1, n, CompareFunc);
		} 
	}

	///non-recursive binary search, assumes sorted array
	int	findBinarySearch()(const auto ref T key) const {
		int first = 0;
		int last = size()-1;

		//assume sorted array
		while (first <= last) {
			int mid = (first + last) / 2;  // compute mid point.
			if (key > m_data[mid]) 
				first = mid + 1;  // repeat search in top half.
			else if (key < m_data[mid]) 
				last = mid - 1; // repeat search in bottom half.
			else
				return mid;     // found it. return position /////
		}
		return size();    // failed to find key
	}


	int	findLinearSearch()(const auto ref T key) const {
		int index=size();
		int i;

		for (i=0;i<size();i++)
		{
			if (m_data[i] == key)
			{
				index = i;
				break;
			}
		}
		return index;
	}

	void remove()(const auto ref T key) {

		int findIndex = findLinearSearch(key);
		if (findIndex<size()) {
			swap( findIndex,size()-1);
			pop_back();
		}
	}

	//PCK: whole function
	void initializeFromBuffer(void* buffer, int size, int capacity) {
		m_data = cast(T[])(buffer[0 .. size]);
		m_capacity = capacity;
		//To make sure the capacity given is accurate, uncomment this:
		//btAssert(capacity <= m_data.reserve(m_data.length));
	}

	void copyFromArray()(const auto ref btAlignedObjectArray otherArray) {
		m_data = otherArray.m_data.dup;
		m_capacity = m_data.length;
	}
}
