/*
Copyright (c) 2003-2009 Erwin Coumans  http://bullet.googlecode.com

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.
Permission is granted to anyone to use this software for any purpose, 
including commercial applications, and to alter it and redistribute it freely, 
subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

/+
Port of Bullet Physics to D
+/

module bullet.linearMath.btScalar;

import std.math;

/* SVN $Revision$ on $Date$ from http://bullet.googlecode.com*/
enum int BT_BULLET_VERSION = 281;

//TODO: Reinstate platform-specific code here if possible
//To do: remove this function; it's pointless in D.
int	btGetVersion() {
	return BT_BULLET_VERSION;
}

void btAssert(bool pred) {
	debug(bullet) {
		assert(pred);
	}
}
void btAssert(bool pred, lazy const(char)[] msg) {
	debug(bullet) {
		assert(pred, msg);
	}
}
void btFullAssert(bool pred) {
	//Optional
}
T btLikely(T)(c) {
	return c;
}
T btUnlikely(T)(c) {
	return c;
}



///The btScalar type abstracts floating point numbers, to easily switch between double and single floating point precision.
version(BT_USE_DOUBLE_PRECISION) {
	alias double btScalar;
	//this number could be bigger in double precision
	immutable float BT_LARGE_FLOAT = 1e30;
} else {
	alias float btScalar;
	//keep BT_LARGE_FLOAT*BT_LARGE_FLOAT < FLT_MAX
	immutable float BT_LARGE_FLOAT = 1e18f;
}

/*mixin template BT_DECLARE_ALIGNED_ALLOCATOR() {
	string BT_DECLARE_ALIGNED_ALLOCATOR = q{
	   SIMD_FORCE_INLINE void* operator new(size_t sizeInBytes)   { return btAlignedAlloc(sizeInBytes,16); }
	   SIMD_FORCE_INLINE void  operator delete(void* ptr)         { btAlignedFree(ptr); }
	   SIMD_FORCE_INLINE void* operator new(size_t, void* ptr)   { return ptr; }
	   SIMD_FORCE_INLINE void  operator delete(void*, void*)      { }
	   SIMD_FORCE_INLINE void* operator new[](size_t sizeInBytes)   { return btAlignedAlloc(sizeInBytes,16); }
	   SIMD_FORCE_INLINE void  operator delete[](void* ptr)         { btAlignedFree(ptr); }
	   SIMD_FORCE_INLINE void* operator new[](size_t, void* ptr)   { return ptr; }
	   SIMD_FORCE_INLINE void  operator delete[](void*, void*)      { }
   };
}*/

version(BT_USE_DOUBLE_PRECISION) {
	version = useDoubleFunctions;
}

version(BT_FORCE_DOUBLE_FUNCTIONS) {
	version = useDoubleFunctions;
}

version(useDoubleFunctions) {
		
	btScalar btSqrt(btScalar x) { return sqrt(x); }
	btScalar btFabs(btScalar x) { return fabs(x); }
	btScalar btCos(btScalar x) { return cos(x); }
	btScalar btSin(btScalar x) { return sin(x); }
	btScalar btTan(btScalar x) { return tan(x); }
	btScalar btAcos(btScalar x) { if (x<cast(btScalar)(-1))	x=cast(btScalar)(-1); if (x>cast(btScalar)(1))	x=cast(btScalar)(1); return acos(x); }
	btScalar btAsin(btScalar x) { if (x<cast(btScalar)(-1))	x=cast(btScalar)(-1); if (x>cast(btScalar)(1))	x=cast(btScalar)(1); return asin(x); }
	btScalar btAtan(btScalar x) { return atan(x); }
	btScalar btAtan2(btScalar x, btScalar y) { return atan2(x, y); }
	btScalar btExp(btScalar x) { return exp(x); }
	btScalar btLog(btScalar x) { return log(x); }
	btScalar btPow(btScalar x,btScalar y) { return pow(x,y); }
	btScalar btFmod(btScalar x,btScalar y) { return fmod(x,y); }

} else {
		
	btScalar btSqrt(btScalar y) { 
		version(USE_APPROXIMATION) {
			double x, z, tempf;
			ulong *tfptr = (cast(ulong*)&tempf) + 1;

			tempf = y;
			*tfptr = (0xbfcdd90a - *tfptr)>>1; /* estimate of 1/sqrt(y) */
			x =  tempf;
			z =  y*btScalar(0.5);
			x = (btScalar(1.5)*x)-(x*x)*(x*z);         /* iteration formula     */
			x = (btScalar(1.5)*x)-(x*x)*(x*z);
			x = (btScalar(1.5)*x)-(x*x)*(x*z);
			x = (btScalar(1.5)*x)-(x*x)*(x*z);
			x = (btScalar(1.5)*x)-(x*x)*(x*z);
			return x*y;
		} else {
			return sqrt(y);
		}
	}

	btScalar btFabs(btScalar x) { return fabs(x); }
	btScalar btCos(btScalar x) { return cos(x); }
	btScalar btSin(btScalar x) { return sin(x); }
	btScalar btTan(btScalar x) { return tan(x); }
	btScalar btAcos(btScalar x) { 
		if (x<cast(btScalar)(-1))	
			x=cast(btScalar)(-1); 
		if (x>cast(btScalar)(1))	
			x=cast(btScalar)(1);
		return acos(x); 
	}
	btScalar btAsin(btScalar x) { 
		if (x<cast(btScalar)(-1))	
			x=cast(btScalar)(-1); 
		if (x>cast(btScalar)(1))	
			x=cast(btScalar)(1);
		return asin(x); 
	}
	btScalar btAtan(btScalar x) { return atan(x); }
	btScalar btAtan2(btScalar x, btScalar y) { return atan2(x, y); }
	btScalar btExp(btScalar x) { return exp(x); }
	btScalar btLog(btScalar x) { return log(x); }
	btScalar btPow(btScalar x,btScalar y) { return pow(x,y); }
	btScalar btFmod(btScalar x, btScalar y) {
		//Needed because of how modf is implemented (second argument is a reference)
		//TODO: consider moving ref to the definition of btFmod instead of copying y
		real lvalue = y;
		return modf(x,lvalue);
	}
	
}

immutable btScalar SIMD_2_PI = 6.283185307179586232;
immutable btScalar SIMD_PI = SIMD_2_PI * cast(btScalar)0.5;
immutable btScalar SIMD_HALF_PI = SIMD_2_PI * cast(btScalar)0.25;
immutable btScalar SIMD_RADS_PER_DEG = SIMD_2_PI / cast(btScalar)360.0;
immutable btScalar SIMD_DEGS_PER_RAD = cast(btScalar)360.0 / SIMD_2_PI;
immutable btScalar SIMDSQRT12 = 0.7071067811865475244008443621048490;

btScalar btRecipSqrt(btScalar x) {return cast(btScalar)1.0/btSqrt(x);}	/* reciprocal square root */

immutable btScalar SIMD_EPSILON = btScalar.epsilon;
//NOTE: Shouldn't this be btScalar.infinity? (I haven't changed it in case it would break some of Bullet's functions)
immutable btScalar SIMD_INFINITY = btScalar.max;


btScalar btAtan2Fast(btScalar y, btScalar x) {
	btScalar coeff_1 = SIMD_PI / 4.0f;
	btScalar coeff_2 = 3.0f * coeff_1;
	btScalar abs_y = btFabs(y);
	btScalar angle;
	if (x >= 0.0f) {
		btScalar r = (x - abs_y) / (x + abs_y);
		angle = coeff_1 - coeff_1 * r;
	} else {
		btScalar r = (x + abs_y) / (abs_y - x);
		angle = coeff_2 - coeff_1 * r;
	}
	return (y < 0.0f) ? -angle : angle;
}

bool btFuzzyZero(btScalar x) { return btFabs(x) < SIMD_EPSILON; }

bool btEqual(btScalar a, btScalar eps) {
	return (((a) <= eps) && !((a) < -eps));
}
bool btGreaterEqual (btScalar a, btScalar eps) {
	return (!((a) <= eps));
}

int btIsNegative(btScalar x) {
    return x < cast(btScalar)0.0 ? 1 : 0;
}

btScalar btRadians(btScalar x) { return x * SIMD_RADS_PER_DEG; }
btScalar btDegrees(btScalar x) { return x * SIMD_DEGS_PER_RAD; }

template BT_DECLARE_HANDLE(string name) {
	string BT_DECLARE_HANDLE = "struct " ~ name ~ "__ {int unused;}
	alias " ~ name ~ "__* " ~ name;
}

btScalar btFsel(btScalar a, btScalar b, btScalar c) {
	return a >= 0 ? b : c;
}

btScalar btFsels(btScalar a, btScalar b, btScalar c) {return btFsel(a,b,c);}

version(LittleEndian) {
	immutable bool btMachineIsLittleEndian = true;
} else {
	immutable bool btMachineIsLittleEndian = false;
}



///btSelect avoids branches, which makes performance much better for consoles like Playstation 3 and XBox 360
///Thanks Phil Knight. See also http://www.cellperformance.com/articles/2006/04/more_techniques_for_eliminatin_1.html
uint btSelect(uint condition, uint valueIfConditionNonZero, uint valueIfConditionZero)  {
    // Set testNz to 0xFFFFFFFF if condition is nonzero, 0x00000000 if condition is zero
    // Rely on positive value or'ed with its negative having sign bit on
    // and zero value or'ed with its negative (which is still zero) having sign bit off 
    // Use arithmetic shift right, shifting the sign bit through all 32 bits
    uint testNz = cast(uint)((cast(int)condition | -cast(int)condition) >> 31);
    uint testEqz = ~testNz;
    return ((valueIfConditionNonZero & testNz) | (valueIfConditionZero & testEqz)); 
}
int btSelect(uint condition, int valueIfConditionNonZero, int valueIfConditionZero) {
    uint testNz = cast(uint)((cast(int)condition | -cast(int)condition) >> 31);
    uint testEqz = ~testNz; 
    return cast(int)((valueIfConditionNonZero & testNz) | (valueIfConditionZero & testEqz));
}
float btSelect(uint condition, float valueIfConditionNonZero, float valueIfConditionZero) {
	version(BT_HAVE_NATIVE_FSEL) {
		return cast(float)btFsel(cast(btScalar)condition - cast(btScalar)1.0f, valueIfConditionNonZero, valueIfConditionZero);
	} else {
		return (condition != 0) ? valueIfConditionNonZero : valueIfConditionZero;
	}
}

void btSwap(T)(ref T a, ref T b) {
	T tmp = a;
	a = b;
	b = tmp;
}


//PCK: endian swapping functions
uint btSwapEndian(uint val)
{
	return (((val & 0xff000000) >> 24) | ((val & 0x00ff0000) >> 8) | ((val & 0x0000ff00) << 8)  | ((val & 0x000000ff) << 24));
}

ushort btSwapEndian(ushort val)
{
	return cast(ushort)(((val & 0xff00) >> 8) | ((val & 0x00ff) << 8));
}

uint btSwapEndian(int val)
{
	return btSwapEndian(cast(uint)val);
}

ushort btSwapEndian(short val)
{
	return btSwapEndian(cast(ushort) val);
}

///btSwapFloat uses using char pointers to swap the endianness
////btSwapFloat/btSwapDouble will NOT return a float, because the machine might 'correct' invalid floating point values
///Not all values of sign/exponent/mantissa are valid floating point numbers according to IEEE 754. 
///When a floating point unit is faced with an invalid value, it may actually change the value, or worse, throw an exception. 
///In most systems, running user mode code, you wouldn't get an exception, but instead the hardware/os/runtime will 'fix' the number for you. 
///so instead of returning a float/double, we return integer/long long integer
uint  btSwapEndianFloat(float d)
{
    uint a = 0;
    ubyte *dst = cast(ubyte*)&a;
    ubyte *src = cast(ubyte*)&d;

    dst[0] = src[3];
    dst[1] = src[2];
    dst[2] = src[1];
    dst[3] = src[0];
    return a;
}

// unswap using char pointers
float btUnswapEndianFloat(uint a) 
{
    float d = 0.0f;
    ubyte* src = cast(ubyte*)&a;
    ubyte* dst = cast(ubyte*)&d;

    dst[0] = src[3];
    dst[1] = src[2];
    dst[2] = src[1];
    dst[3] = src[0];

    return d;
}


// swap using char pointers
void  btSwapEndianDouble(double d, ubyte* dst)
{
    ubyte* src = cast(ubyte*)&d;

    dst[0] = src[7];
    dst[1] = src[6];
    dst[2] = src[5];
    dst[3] = src[4];
    dst[4] = src[3];
    dst[5] = src[2];
    dst[6] = src[1];
    dst[7] = src[0];

}

// unswap using char pointers
double btUnswapEndianDouble(const ubyte* src) 
{
    double d = 0.0;
    ubyte* dst = cast(ubyte*)&d;

    dst[0] = src[7];
    dst[1] = src[6];
    dst[2] = src[5];
    dst[3] = src[4];
    dst[4] = src[3];
    dst[5] = src[2];
    dst[6] = src[1];
    dst[7] = src[0];

	return d;
}

// returns normalized value in range [-SIMD_PI, SIMD_PI]
btScalar btNormalizeAngle(btScalar angleInRadians) 
{
	angleInRadians = btFmod(angleInRadians, SIMD_2_PI);
	if(angleInRadians < -SIMD_PI)
	{
		return angleInRadians + SIMD_2_PI;
	}
	else if(angleInRadians > SIMD_PI)
	{
		return angleInRadians - SIMD_2_PI;
	}
	else
	{
		return angleInRadians;
	}
}

///rudimentary class to provide type info
class btTypedObject {
	this(int objectType) {
		m_objectType = objectType;
	}
	int	m_objectType;
	int getObjectType() const {
		return m_objectType;
	}
}
