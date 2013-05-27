/*
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2003-2009 Erwin Coumans  http://bulletphysics.org

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

module bullet.linearMath.btSerializer;

import std.string;

import bullet.linearMath.btAlignedObjectArray;
import bullet.linearMath.btScalar;
import bullet.linearMath.btStackAlloc;

///only the 32bit versions for now
extern ubyte[] sBulletDNAstr;
extern int sBulletDNAlen;
extern ubyte[] sBulletDNAstr64;
extern int sBulletDNAlen64;

int btStrLen(const(char)* str) {
    if (!str) 
		return(0);
	int len = 0;
    
	while (*str != 0) {
        str++;
        len++;
    }

    return len;
}

struct btChunk {
public:
	int		m_chunkCode;
	int		m_length;
	void	*m_oldPtr;
	int		m_dna_nr;
	int		m_number;
};

enum	btSerializationFlags {
	BT_SERIALIZE_NO_BVH = 1,
	BT_SERIALIZE_NO_TRIANGLEINFOMAP = 2,
	BT_SERIALIZE_NO_DUPLICATE_ASSERT = 4
};

interface btSerializer {

public:

	const(ubyte[]) getBuffer() const;

	int	getCurrentBufferSize() const;

	btChunk* allocate(size_t size, int numElements);

	void finalizeChunk(btChunk* chunk, string structType, int chunkCode, void* oldPtr);

	void* findPointer(void* oldPtr);

	void* getUniquePointer(void* oldPtr);

	void startSerialization();
	
	void finishSerialization();

	string findNameForPointer(const void* ptr) const;

	void registerNameForPointer(const void* ptr, string name);

	void serializeName(string name);

	int	getSerializationFlags() const;

	void setSerializationFlags(int flags);


};


enum size_t BT_HEADER_LENGTH = 12;

version(BigEndian) {
	pure int MAKE_ID(char a, char b, char c, char d) {return cast(int)a<<24 | cast(int)b<<16 | c<<8 | d;}
} else {
	pure int MAKE_ID(char a, char b, char c, char d) {return cast(int)d<<24 | cast(int)c<<16 | b<<8 | a;}
}

immutable int BT_SOFTBODY_CODE =		MAKE_ID('S','B','D','Y');
immutable int BT_COLLISIONOBJECT_CODE =	MAKE_ID('C','O','B','J');
immutable int BT_RIGIDBODY_CODE =		MAKE_ID('R','B','D','Y');
immutable int BT_CONSTRAINT_CODE =		MAKE_ID('C','O','N','S');
immutable int BT_BOXSHAPE_CODE =		MAKE_ID('B','O','X','S');
immutable int BT_QUANTIZED_BVH_CODE = 	MAKE_ID('Q','B','V','H');
immutable int BT_TRIANLGE_INFO_MAP =	MAKE_ID('T','M','A','P');
immutable int BT_SHAPE_CODE =			MAKE_ID('S','H','A','P');
immutable int BT_ARRAY_CODE =			MAKE_ID('A','R','A','Y');
immutable int BT_SBMATERIAL_CODE =		MAKE_ID('S','B','M','T');
immutable int BT_SBNODE_CODE =			MAKE_ID('S','B','N','D');
immutable int BT_DNA_CODE =				MAKE_ID('D','N','A','1');


struct	btPointerUid {
	union {
		void*	m_ptr;
		int[2]	m_uniqueIds;
	};
};

///The btDefaultSerializer is the main Bullet serialization class.
///The constructor takes an optional argument for backwards compatibility; it is recommended to leave this empty/zero.
class btDefaultSerializer:	btSerializer{
	btAlignedObjectArray!string		mTypes;
	btAlignedObjectArray!(short*)	mStructs;
	btAlignedObjectArray!short		mTlens;
	int[int]						mStructReverse;
	int[string]						mTypeLookup;

	
	void*[void*]	m_chunkP;
	
	string[void*] m_nameMap;

	btPointerUid[void*]	m_uniquePointers;
	int	m_uniqueIdGenerator;

	int					m_totalSize;
	ubyte[]				m_buffer;
	int					m_currentSize;
	ubyte[] 			m_dna;

	int					m_serializationFlags;


	btChunk*[]	m_chunkPtrs;
	
protected:

	void* findPointer(void* oldPtr)  {
		void** ptr = oldPtr in m_chunkP;
		if (ptr && *ptr)
			return *ptr;
		return null;
	}
	
	//To do: Something tells me this is buggy.
	void writeDNA() {
		btChunk[] dnaChunk;
		dnaChunk.length = m_dna.length;
		dnaChunk[0].m_oldPtr[0 .. m_dna.length] = m_dna[];
		finalizeChunk(dnaChunk.ptr, "DNA1", BT_DNA_CODE, m_dna.ptr);
	}

	int getReverseType(string type) const {
		const int* valuePtr = type in mTypeLookup;
		if (valuePtr)
			return *valuePtr;
		
		return -1;
	}

	void initDNA(ubyte[] bdnaOrg) {
		///was already initialized
		if (m_dna)
			return;

		m_dna = bdnaOrg.dup;

		int *intPtr = null;
		short *shtPtr = null;
		char *cp = null;
		int dataLen = 0;
		long nr = 0;
		intPtr = cast(int*)m_dna.ptr;

		/*
			SDNA (4 bytes) (magic number)
			NAME (4 bytes)
			<nr> (4 bytes) amount of names (int)
			<string>
			<string>
		*/

		if ((cast(char[])m_dna)[0 .. 4] == "SDNA") {
			// skip ++ NAME
			intPtr += 2;
		}

		// Parse names
		version(BigEndian)
			*intPtr = btSwapEndian(*intPtr);
			
		dataLen = *intPtr;
		
		intPtr++;

		cp = cast(char*)intPtr;
		int i;
		for ( i=0; i<dataLen; i++) {
			while (*cp)cp++;
			cp++;
		}
		
		{
			nr= cast(long)cp;
		//	long mask=3;
			nr= ((nr+3)&~3)-nr;
			while (nr--)
			{
				cp++;
			}
		}

		/*
			TYPE (4 bytes)
			<nr> amount of types (int)
			<string>
			<string>
		*/

		intPtr = cast(int*)cp;
		assert(cp[0 .. 4] == "TYPE"); intPtr++;

		version(BigEndian)
			*intPtr =  btSwapEndian(*intPtr);
		
		dataLen = *intPtr;
		intPtr++;

		
		cp = cast(char*)intPtr;
		for (i=0; i < dataLen; i++) {
			uint strlen = btStrLen(cp);
			mTypes.push_back(cp[0 .. strlen].idup);
			cp += strlen;
			cp++;
		}

	{
			nr= cast(long)cp;
		//	long mask=3;
			nr= ((nr+3)&~3)-nr;
			while (nr--)
			{
				cp++;
			}
		}


		/*
			TLEN (4 bytes)
			<len> (short) the lengths of types
			<len>
		*/

		// Parse type lens
		intPtr = cast(int*)cp;
		assert(cp[0 .. 4] == "TLEN"); intPtr++;

		dataLen = cast(int)mTypes.size();

		shtPtr = cast(short*)intPtr;
		for (i=0; i<dataLen; i++, shtPtr++) {
			version(BigEndian)
				shtPtr[0] = btSwapEndian(shtPtr[0]);
			mTlens.push_back(shtPtr[0]);
		}

		if (dataLen & 1) shtPtr++;

		/*
			STRC (4 bytes)
			<nr> amount of structs (int)
			<typenr>
			<nr_of_elems>
			<typenr>
			<namenr>
			<typenr>
			<namenr>
		*/

		intPtr = cast(int*)shtPtr;
		cp = cast(char*)intPtr;
		assert(cp[0 .. 4] == "STRC"); intPtr++;

		version(BigEndian)
			*intPtr = btSwapEndian(*intPtr);
		dataLen = *intPtr ; 
		intPtr++;


		shtPtr = cast(short*)intPtr;
		for (i=0; i<dataLen; i++) {
			mStructs.push_back (shtPtr);
			
			version(BigEndian) {
				shtPtr[0]= btSwapEndian(shtPtr[0]);
				shtPtr[1]= btSwapEndian(shtPtr[1]);

				int len = shtPtr[1];
				shtPtr+= 2;

				for (int a=0; a<len; a++, shtPtr+=2)
				{
						shtPtr[0]= btSwapEndian(shtPtr[0]);
						shtPtr[1]= btSwapEndian(shtPtr[1]);
				}

			} else {
				shtPtr+= (2*shtPtr[1])+2;
			}
		}

		// build reverse lookups
		for (i = 0; i < cast(int)mStructs.size(); i++) {
			short* strc = mStructs.at(i);
			mStructReverse[strc[0]] = i;
			mTypeLookup[mTypes[strc[0]]] = i;
			//mTypeLookup.insert(btHashString(mTypes[strc[0]]),i);
		}
	}

	public:	
	this(int totalSize = 0) {
		m_totalSize = totalSize;
		if(m_totalSize) {
			m_buffer.length = 0;
			m_buffer.length = totalSize;
		}
		
		const bool VOID_IS_8 = ((void*).sizeof == 8);

		version(BT_INTERNAL_UPDATE_SERIALIZATION_STRUCTURES) {
			static if (VOID_IS_8) {
				version(Win64) {
					initDNA(cast(const char*)sBulletDNAstr64,sBulletDNAlen64);
				} else {
					btAssert(0);
				}
			} else {
				version(Win64) {
					initDNA(cast(const char*)sBulletDNAstr,sBulletDNAlen);
				} else {
					btAssert(0);
				}
			}
		} else {
			static if (VOID_IS_8) {
				initDNA(sBulletDNAstr64);
			} else {
				initDNA(sBulletDNAstr);
			}
		}
	}

		void writeHeader(ubyte[] buffer) const
		in {
			assert(buffer.length >= 12);
		} body {
		
		version(BT_USE_DOUBLE_PRECISION) {
			buffer[0 .. 7] = cast(ubyte[])"BULLETd";
		} else {
			buffer[0 .. 7] = cast(ubyte[])"BULLETf";
		}
	
		static if ((void*).sizeof == 8) {
			buffer[7] = '-';
		} else {
			buffer[7] = '_';
		}

		version (LittleEndian) {
			buffer[8]='v';				
		} else {
			buffer[8]='V';
		}


		buffer[9] = '2';
		buffer[10] = '7';
		buffer[11] = '8';
		}

		void startSerialization() {
			m_uniqueIdGenerator = 1;
			if (m_totalSize) {
				ubyte[] buffer = internalAlloc(BT_HEADER_LENGTH);
				writeHeader(buffer);
			}
			
		}

		void finishSerialization() {
			writeDNA();

			//if we didn't pre-allocate a buffer, we need to create a contiguous buffer now
			int mysize = 0;
			if (!m_totalSize) {
				//Free the buffer
				m_buffer.length = 0;

				m_currentSize += BT_HEADER_LENGTH;
				m_buffer.length = m_currentSize;

				ubyte* currentPtr = m_buffer.ptr;
				writeHeader(m_buffer);
				currentPtr += BT_HEADER_LENGTH;
				mysize += BT_HEADER_LENGTH;
				foreach(ref btChunk* chunk; m_chunkPtrs) {
					int curLength = btChunk.sizeof + chunk.m_length;
					currentPtr[0 .. curLength] = cast(ubyte[])chunk[0 .. curLength];
					//Release the memory.
					chunk = null;
					currentPtr += curLength;
					mysize += curLength;
				}
			}

			mTypes.clear();
			mStructs.clear();
			mTlens.clear();
			mStructReverse.clear();
			mTypeLookup.clear();
			m_chunkP.clear();
			m_nameMap.clear();
			m_uniquePointers.clear();
			m_chunkPtrs.clear();
		}

		void* getUniquePointer(void* oldPtr) {
			if (!oldPtr)
				return null;

			btPointerUid* uptr = oldPtr in m_uniquePointers;
			if (uptr) {
				return uptr.m_ptr;
			}
			m_uniqueIdGenerator++;
			
			btPointerUid uid;
			uid.m_uniqueIds[0] = m_uniqueIdGenerator;
			uid.m_uniqueIds[1] = m_uniqueIdGenerator;
			m_uniquePointers[oldPtr] = uid;
			return uid.m_ptr;

		}

		const(ubyte[]) getBuffer() const {
			return m_buffer;
		}

		int	getCurrentBufferSize() const {
			return	m_currentSize;
		}

		void finalizeChunk(btChunk* chunk, string structType, int chunkCode, void* oldPtr) {
			if (!(m_serializationFlags & btSerializationFlags.BT_SERIALIZE_NO_DUPLICATE_ASSERT)) {
				btAssert(!findPointer(oldPtr));
			}

			chunk.m_dna_nr = getReverseType(structType);
			
			chunk.m_chunkCode = chunkCode;
			
			void* uniquePtr = getUniquePointer(oldPtr);
			
			m_chunkP[oldPtr] = uniquePtr;//chunk->m_oldPtr);
			chunk.m_oldPtr = uniquePtr;//oldPtr;
			
		}

		
		ubyte[] internalAlloc(size_t size) {
			ubyte[] buf;

			if (m_totalSize) {
				buf = (m_buffer.ptr + m_currentSize)[0 .. size];
				m_currentSize += cast(int)size;
				btAssert(m_currentSize < m_totalSize);
			} else {
				buf.length = size;
				m_currentSize += cast(int)size;
			}
			return buf;
		}

		

		btChunk* allocate(size_t size, int numElements) {

			ubyte[] buf = internalAlloc(cast(int)size * numElements + btChunk.sizeof);

			ubyte[] data = buf[btChunk.sizeof .. $];
			
			btChunk* chunk = cast(btChunk*)&buf[0];
			chunk.m_chunkCode = 0;
			chunk.m_oldPtr = data.ptr;
			chunk.m_length = cast(int)size * numElements;
			chunk.m_number = numElements;
			
			m_chunkPtrs ~= chunk;
			
			return chunk;
		}

		string findNameForPointer(const void* ptr) const {
			const(string*) namePtr = ptr in m_nameMap;
			if (namePtr && *namePtr)
				return *namePtr;
			return null;
		}

		void registerNameForPointer(const void* ptr, string name) {
			m_nameMap[ptr] = name;
		}

		void serializeName(string name) {
			if (name.length) {
				//don't serialize name twice
				if (findPointer(cast(void*)name.ptr))
					return;

				int len = name.length;
				if (len) {
					int newLen = len + 1;
					int padding = ((newLen+3)&~3) - newLen;
					newLen += padding;

					//serialize name string now
					btChunk* chunk = allocate(char.sizeof, newLen);
					char* destinationName = cast(char*)chunk.m_oldPtr;
					for (int i=0; i<len; i++) {
						destinationName[i] = name[i];
					}
					destinationName[len] = 0;
					finalizeChunk(chunk, "char", BT_ARRAY_CODE, cast(void*)name);
				}
			}
		}

		int	 getSerializationFlags() const {
			return m_serializationFlags;
		}

		void setSerializationFlags(int flags) {
			m_serializationFlags = flags;
		}

};

