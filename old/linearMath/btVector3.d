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

/+
Port of Bullet Physics to D
+/

module bullet.linearMath.btVector3;


public import bullet.linearMath.btScalar;
public import bullet.linearMath.btMinMax;

version(BT_USE_DOUBLE_PRECISION) {
	alias btVector3DoubleData btVector3Data;
	immutable string btVector3DataName = "btVector3DoubleData";
} else {
	alias btVector3FloatData btVector3Data;
	immutable string btVector3DataName = "btVector3FloatData";
}

/**@brief btVector3 can be used to represent 3D points and vectors.
 * It has an un-used w component to suit 16-byte alignment when btVector3 is stored in containers. This extra component can be used by derived classes (Quaternion?) or by user
 * Ideally, this class should be replaced by a platform optimized SIMD version that keeps the data in registers
 */
 
version(__SPU__) {
	version(__CELLOS_LV2__) {
		version = SPU_AND_CELLOS;
	}
}
 //I think this is the right alignment value
 //TODO: check
align(2) struct btVector3
{

	version(SPU_AND_CELLOS) {
		private:
			btScalar	m_floats[4] = [0.0, 0.0, 0.0, 0.0];
		public:
			const ref vec_float4 get128() const
			{
				return *(cast(const vec_float4*)&m_floats[0]);
			}
	} else {
		version(BT_USE_SSE) { //WIN32
			union {
				__m128 mVec128;
				btScalar	m_floats[4] = [0.0, 0.0, 0.0, 0.0];
			}
			__m128	get128() const
			{
				return mVec128;
			}
			void set128(__m128 v128)
			{
				mVec128 = v128;
			}
		} else {
			btScalar	m_floats[4] = [0.0, 0.0, 0.0, 0.0];
		}
	}
	public:

 
	
  /**@brief Constructor from scalars 
   * @param x X value
   * @param y Y value 
   * @param z Z value 
   */
	this()(const auto ref btScalar x, const auto ref btScalar y, const auto ref btScalar z)
	{
		m_floats[0] = x;
		m_floats[1] = y;
		m_floats[2] = z;
		m_floats[3] = cast(btScalar)0.0;
	}
	
	auto ref btVector3 opOpAssign(string op)(auto ref const btVector3 v) {
		static if(op == "+=") {
			m_floats[0 .. 2] += v.m_floats[0 .. 2];
			return this;
		} else static if(op == "-=") {
			m_floats[0 .. 2] -= v.m_floats[0 .. 2];
			return this;
		} else static if(op == "*=") {
			m_floats[0 .. 2] *= v.m_floats[0 .. 2];
			return this;
		} else {
			static assert(false, `"` ~ op ~ `" is an invalid operator for btVector3.`);
		}
	}
	
	ref btVector3 opOpAssign(string op)(const auto ref btScalar s) {
		static if(op == "*") {
			m_floats[0 .. 2] *= s;
			return this;
		} else static if(op == "/") {
			btFullAssert(s != cast(btScalar)0.0);
			return this *= cast(btScalar)1.0 / s;
		} else {
			static assert(false, `"` ~ op ~ `" is an invalid operator for btVector3.`);
		}
	}
	
	btScalar dot()(const auto ref btVector3 v) const
	{
		return m_floats[0] * v.m_floats[0] + m_floats[1] * v.m_floats[1] +m_floats[2] * v.m_floats[2];
	}

  /**@brief Return the length of the vector squared */
	btScalar length2() const
	{
		return dot(this);
	}

  /**@brief Return the length of the vector */
	btScalar length() const
	{
		return btSqrt(length2());
	}

  /**@brief Return the distance squared between the ends of this and another vector
   * This is symantically treating the vector like a point */
	btScalar distance2()(const auto ref btVector3 v) const {return (v - this).length2();}

  /**@brief Return the distance between the ends of this and another vector
   * This is symantically treating the vector like a point */
	btScalar distance()(const auto ref btVector3 v) const {return (v - this).length();}

	auto ref btVector3 safeNormalize() 
	{
		btVector3 absVec = this.absolute();
		int maxIndex = absVec.maxAxis();
		if ((cast(btScalar*)absVec)[maxIndex]>0)
		{
			this /= (cast(btScalar*)absVec)[maxIndex];
			return this /= length();
		}
		setValue(1,0,0);
		return this;
	}

  /**@brief Normalize this vector 
   * x^2 + y^2 + z^2 = 1 */
	ref btVector3 normalize() 
	{
		return this /= length();
	}

  /**@brief Return a normalized version of this vector */
	btVector3 normalized() const {
		return this / length();
	}

  /**@brief Return a rotated version of this vector
   * @param wAxis The axis to rotate about 
   * @param angle The angle to rotate by */
	btVector3 rotate()(const auto ref btVector3 wAxis, const btScalar angle) const {
		// wAxis must be a unit lenght vector

		btVector3 o = wAxis * wAxis.dot( *this );
		btVector3 x = *this - o;
		btVector3 y;

		y = wAxis.cross( *this );

		return ( o + x * btCos( angle ) + y * btSin( angle ) );
	}

  /**@brief Return the angle between this and another vector
   * @param v The other vector */
	btScalar angle()(const auto ref btVector3 v) const 
	{
		btScalar s = btSqrt(length2() * v.length2());
		btFullAssert(s != cast(btScalar)0.0);
		return btAcos(dot(v) / s);
	}
  /**@brief Return a vector will the absolute values of each element */
	btVector3 absolute() const 
	{
		return btVector3(
			btFabs(m_floats[0]), 
			btFabs(m_floats[1]), 
			btFabs(m_floats[2]));
	}
  /**@brief Return the cross product between this and another vector 
   * @param v The other vector */
	btVector3 cross()(const auto ref btVector3 v) const
	{
		return btVector3(
			m_floats[1] * v.m_floats[2] -m_floats[2] * v.m_floats[1],
			m_floats[2] * v.m_floats[0] - m_floats[0] * v.m_floats[2],
			m_floats[0] * v.m_floats[1] - m_floats[1] * v.m_floats[0]);
	}

	btScalar triple()(const auto ref btVector3 v1, const auto ref btVector3 v2) const
	{
		return m_floats[0] * (v1.m_floats[1] * v2.m_floats[2] - v1.m_floats[2] * v2.m_floats[1]) + 
			m_floats[1] * (v1.m_floats[2] * v2.m_floats[0] - v1.m_floats[0] * v2.m_floats[2]) + 
			m_floats[2] * (v1.m_floats[0] * v2.m_floats[1] - v1.m_floats[1] * v2.m_floats[0]);
	}

  /**@brief Return the axis with the smallest value 
   * Note return values are 0,1,2 for x, y, or z */
	int minAxis() const
	{
		return m_floats[0] < m_floats[1] ? (m_floats[0] <m_floats[2] ? 0 : 2) : (m_floats[1] <m_floats[2] ? 1 : 2);
	}

  /**@brief Return the axis with the largest value 
   * Note return values are 0,1,2 for x, y, or z */
	int maxAxis() const 
	{
		return m_floats[0] < m_floats[1] ? (m_floats[1] <m_floats[2] ? 2 : 1) : (m_floats[0] <m_floats[2] ? 2 : 0);
	}

	int furthestAxis() const
	{
		return absolute().minAxis();
	}

	int closestAxis() const 
	{
		return absolute().maxAxis();
	}

	void setInterpolate3()(const auto ref btVector3 v0, const auto ref btVector3 v1, btScalar rt)
	{
		btScalar s = cast(btScalar)1.0 - rt;
		m_floats[0] = s * v0.m_floats[0] + rt * v1.m_floats[0];
		m_floats[1] = s * v0.m_floats[1] + rt * v1.m_floats[1];
		m_floats[2] = s * v0.m_floats[2] + rt * v1.m_floats[2];
		//don't do the unused w component
		//		m_co[3] = s * v0[3] + rt * v1[3];
	}

  /**@brief Return the linear interpolation between this and another vector 
   * @param v The other vector 
   * @param t The ration of this to v (t = 0 => return this, t=1 => return other) */
	btVector3 lerp()(const auto ref btVector3 v, const auto ref btScalar t) const 
	{
		return btVector3(m_floats[0] + (v.m_floats[0] - m_floats[0]) * t,
			m_floats[1] + (v.m_floats[1] - m_floats[1]) * t,
			m_floats[2] + (v.m_floats[2] -m_floats[2]) * t);
	}

	 /**@brief Return the x value */
		const btScalar getX() const { return m_floats[0]; }
  /**@brief Return the y value */
		const btScalar getY() const { return m_floats[1]; }
  /**@brief Return the z value */
		const btScalar getZ() const { return m_floats[2]; }
  /**@brief Set the x value */
		void setX(btScalar x) { m_floats[0] = x;};
  /**@brief Set the y value */
		void setY(btScalar y) { m_floats[1] = y;};
  /**@brief Set the z value */
		void setZ(btScalar z) {m_floats[2] = z;};
  /**@brief Set the w value */
		void setW(btScalar w) { m_floats[3] = w;};
  /**@brief Return the x value */
		const btScalar x() const { return m_floats[0]; }
  /**@brief Return the y value */
		const btScalar y() const { return m_floats[1]; }
  /**@brief Return the z value */
		const btScalar z() const { return m_floats[2]; }
  /**@brief Return the w value */
		const btScalar w() const { return m_floats[3]; }

	//SIMD_FORCE_INLINE btScalar&       operator[](int i)       { return (&m_floats[0])[i];	}      
	//SIMD_FORCE_INLINE const btScalar& operator[](int i) const { return (&m_floats[0])[i]; }
	///operator btScalar*() replaces operator[], using implicit conversion. We added operator != and operator == to avoid pointer comparisons.
	//Note: since D won't do the implicit conversion, we DO need operator[].
	
	T opCast(T: btScalar*)() { return &m_floats[0]; }      
	T opCast(T: const btScalar*)() const { return &m_floats[0]; }
	
	btScalar opIndex(int i) const {
		return m_floats[i];
	}
	
	btScalar opIndexAssign(btScalar val, int i) {
		return (m_floats[i] = val);
	}

	bool opEquals()(const auto ref btVector3 other) const
	{
		return ((m_floats[3]==other.m_floats[3]) && (m_floats[2]==other.m_floats[2]) && (m_floats[1]==other.m_floats[1]) && (m_floats[0]==other.m_floats[0]));
	}
	//operator!= is automatically generated from opEquals by the D compiler

	 /**@brief Set each element to the max of the current values and the values of another btVector3
   * @param other The other btVector3 to compare with 
   */
	void setMax()(const auto ref btVector3 other)
	{
		btSetMax(m_floats[0], other.m_floats[0]);
		btSetMax(m_floats[1], other.m_floats[1]);
		btSetMax(m_floats[2], other.m_floats[2]);
		btSetMax(m_floats[3], other.w());
	}
  /**@brief Set each element to the min of the current values and the values of another btVector3
   * @param other The other btVector3 to compare with 
   */
	void setMin()(const auto ref btVector3 other)
	{
		btSetMin(m_floats[0], other.m_floats[0]);
		btSetMin(m_floats[1], other.m_floats[1]);
		btSetMin(m_floats[2], other.m_floats[2]);
		btSetMin(m_floats[3], other.w());
	}

	void setValue()(const auto ref btScalar x, const auto ref btScalar y, const auto ref btScalar z)
	{
		m_floats[0]=x;
		m_floats[1]=y;
		m_floats[2]=z;
		m_floats[3] = cast(btScalar)0.0;
	}

	void getSkewSymmetricMatrix(btVector3* v0,btVector3* v1,btVector3* v2) const
	{
		v0.setValue(0.0		,-z()		,y());
		v1.setValue(z()	,0.0			,-x());
		v2.setValue(-y()	,x()	,0.0);
	}

	void setZero()
	{
		setValue(cast(btScalar)0.0,cast(btScalar)0.0,cast(btScalar)0.0);
	}

	bool isZero() const 
	{
		return m_floats[0] == cast(btScalar)0.0 && m_floats[1] == cast(btScalar)0.0 && m_floats[2] == cast(btScalar)0.0;
	}

	bool fuzzyZero() const 
	{
		return length2() < SIMD_EPSILON;
	}

	void	serialize(ref btVector3Data dataOut) const {
		///could also do a memcpy, check if it is worth it
		for (int i=0;i<4;i++)
			dataOut.m_floats[i] = m_floats[i];
	}

	void	deSerialize()(const auto ref btVector3Data dataIn) {
		for (int i=0;i<4;i++)
			m_floats[i] = dataIn.m_floats[i];
	}

	void	serializeFloat(ref btVector3FloatData dataOut) const {
		///could also do a memcpy, check if it is worth it
		for (int i=0;i<4;i++)
			dataOut.m_floats[i] = cast(float)(m_floats[i]);
	}

	void	deSerializeFloat()(const auto ref btVector3FloatData dataIn) {
		for (int i=0;i<4;i++)
			m_floats[i] = cast(btScalar)(dataIn.m_floats[i]);
	}

	void	serializeDouble(ref	btVector3DoubleData dataOut) const {
		///could also do a memcpy, check if it is worth it
		for (int i=0;i<4;i++)
			dataOut.m_floats[i] = cast(double)(m_floats[i]);
	}

	void	deSerializeDouble()(const auto ref	btVector3DoubleData dataIn) {
		for (int i=0;i<4;i++)
			m_floats[i] = cast(btScalar)(dataIn.m_floats[i]);
	}
	
	btVector3 opBinary(string op)(const auto ref btVector3 v2) const {
		static if(op == "+") {
			return btVector3(m_floats[0] + v2.m_floats[0], m_floats[1] + v2.m_floats[1], m_floats[2] + v2.m_floats[2]);
		} else static if(op == "*") {
			return btVector3(m_floats[0] * v2.m_floats[0], m_floats[1] * v2.m_floats[1], m_floats[2] * v2.m_floats[2]);
		} else static if(op == "-") {
			return btVector3(m_floats[0] - v2.m_floats[0], m_floats[1] - v2.m_floats[1], m_floats[2] - v2.m_floats[2]);
		} else static if(op == "/") {
			return btVector3(m_floats[0] / v2.m_floats[0], m_floats[1] / v2.m_floats[1], m_floats[2] / v2.m_floats[2]);
		} else {
			static assert(false, `"` ~ op ~ `" is an invalid operator for btVector3.`);
		}
	}
	
	btVector3 opUnary(string op)() if (op == "-") {
		return btVector3(-m_floats[0], -m_floats[1], -m_floats[2]);
	}
	
	btVector3 opBinary(string op)(const auto ref btScalar s) const {
		static if(op == "*") {
			return btVector3(m_floats[0] * s, m_floats[1] * s, m_floats[2] * s);
		} else static if(op == "/") {
			btFullAssert(s != cast(btScalar)0.0);
			return this * (cast(btScalar)1.0 / s);
		} else {
			static assert(false, `"` ~ op ~ `" is an invalid operator for btVector3.`);
		}
	}
	
	btVector3 opBinaryRight(string op)(const auto ref btScalar s) const {
		static if(op == "*") {
			return btVector3(m_floats[0] * s, m_floats[1] * s, m_floats[2] * s);
		} else {
			static assert(false, `"` ~ op ~ `" is an invalid operator for btVector3.`);
		}
	}
}

/**@brief Return the dot product between two vectors */
btScalar btDot()(const auto ref btVector3 v1, const auto ref btVector3 v2) 
{ 
	return v1.dot(v2); 
}


/**@brief Return the distance squared between two vectors */
btScalar btDistance2()(const auto ref btVector3 v1, const auto ref btVector3 v2) 
{ 
	return v1.distance2(v2); 
}


/**@brief Return the distance between two vectors */
btScalar btDistance(const ref btVector3 v1, const ref btVector3 v2) 
{ 
	return v1.distance(v2); 
}

/**@brief Return the angle between two vectors */
btScalar btAngle()(const auto ref btVector3 v1, const auto ref btVector3 v2) 
{ 
	return v1.angle(v2); 
}

/**@brief Return the cross product of two vectors */
btVector3 btCross()(const auto ref btVector3 v1, const auto ref btVector3 v2) 
{ 
	return v1.cross(v2); 
}

btScalar btTriple()(const auto ref btVector3 v1, const auto ref btVector3 v2, const auto ref btVector3 v3)
{
	return v1.triple(v2, v3);
}

/**@brief Return the linear interpolation between two vectors
 * @param v1 One vector 
 * @param v2 The other vector 
 * @param t The ratio of this to v (t = 0 => return v1, t=1 => return v2) */
btVector3 lerp()(const auto ref btVector3 v1, const auto ref btVector3 v2, const auto ref btScalar t)
{
	return v1.lerp(v2, t);
}


struct btVector4 {
public:
	//Simulate inheritance (sort of)
	btVector3 vec3;
	alias vec3 this;
	
	//Not allowed in D
	//this() {}


	this()(const auto ref btScalar x, const auto ref btScalar y, const auto ref btScalar z,const auto ref btScalar w) 
	{
		vec3 = btVector3(x,y,z);
		vec3.m_floats[3] = w;
	}


	btVector4 absolute4() const 
	{
		with(vec3) {
			return btVector4(
				btFabs(m_floats[0]), 
				btFabs(m_floats[1]), 
				btFabs(m_floats[2]),
				btFabs(m_floats[3]));
		}
	}



	btScalar	getW() const { return vec3.m_floats[3];}


		int maxAxis4() const
	{
		with(vec3) {
			int maxIndex = -1;
			btScalar maxVal = cast(btScalar)(-BT_LARGE_FLOAT);
			if (m_floats[0] > maxVal)
			{
				maxIndex = 0;
				maxVal = m_floats[0];
			}
			if (m_floats[1] > maxVal)
			{
				maxIndex = 1;
				maxVal = m_floats[1];
			}
			if (m_floats[2] > maxVal)
			{
				maxIndex = 2;
				maxVal =m_floats[2];
			}
			if (m_floats[3] > maxVal)
			{
				maxIndex = 3;
				maxVal = m_floats[3];
			}

			return maxIndex;
		}
	}


	int minAxis4() const
	{
		with(vec3) {
			int minIndex = -1;
			btScalar minVal = cast(btScalar)BT_LARGE_FLOAT;
			if (m_floats[0] < minVal)
			{
				minIndex = 0;
				minVal = m_floats[0];
			}
			if (m_floats[1] < minVal)
			{
				minIndex = 1;
				minVal = m_floats[1];
			}
			if (m_floats[2] < minVal)
			{
				minIndex = 2;
				minVal =m_floats[2];
			}
			if (m_floats[3] < minVal)
			{
				minIndex = 3;
				minVal = m_floats[3];
			}
			
			return minIndex;
		}
	}


	int closestAxis4() const 
	{
		return absolute4().maxAxis4();
	}

	
 

  /**@brief Set x,y,z and zero w 
   * @param x Value of x
   * @param y Value of y
   * @param z Value of z
   */
		

/*		void getValue(btScalar *m) const 
		{
			m[0] = m_floats[0];
			m[1] = m_floats[1];
			m[2] =m_floats[2];
		}
*/
/**@brief Set the values 
   * @param x Value of x
   * @param y Value of y
   * @param z Value of z
   * @param w Value of w
   */
		void	setValue()(const auto ref btScalar x, const auto ref btScalar y, const auto ref btScalar z,const auto ref btScalar w)
		{
			with(vec3) {
				m_floats[0]=x;
				m_floats[1]=y;
				m_floats[2]=z;
				m_floats[3]=w;
			}
		}


};


///btSwapVector3Endian swaps vector endianness, useful for network and cross-platform serialization
void	btSwapScalarEndian()(const auto ref btScalar sourceVal, ref btScalar destVal)
{
	version(BT_USE_DOUBLE_PRECISION) {
		ubyte* dest = cast(ubyte*) &destVal;
		ubyte* src  = cast(ubyte*) &sourceVal;
		dest[0] = src[7];
		dest[1] = src[6];
		dest[2] = src[5];
		dest[3] = src[4];
		dest[4] = src[3];
		dest[5] = src[2];
		dest[6] = src[1];
		dest[7] = src[0];
	} else {
	ubyte* dest = cast(ubyte*) &destVal;
	ubyte* src  = cast(ubyte*) &sourceVal;
	dest[0] = src[3];
    dest[1] = src[2];
    dest[2] = src[1];
    dest[3] = src[0];
	}
}
///btSwapVector3Endian swaps vector endianness, useful for network and cross-platform serialization
void	btSwapVector3Endian()(const auto ref btVector3 sourceVec, ref btVector3 destVec)
{
	for (int i=0;i<4;i++)
	{
		btSwapScalarEndian(sourceVec[i],destVec[i]);
	}

}

///btUnSwapVector3Endian swaps vector endianness, useful for network and cross-platform serialization
void	btUnSwapVector3Endian(ref btVector3 vector)
{
	btVector3	swappedVec;
	for (int i=0;i<4;i++)
	{
		btSwapScalarEndian((cast(btScalar*)vector)[i],(cast(btScalar*)swappedVec)[i]);
	}
	vector = swappedVec;
}


void btPlaneSpace1(T)(const(T) n, ref T p, ref T q)
{
  if (btFabs(n[2]) > SIMDSQRT12) {
    // choose p in y-z plane
    btScalar a = n[1]*n[1] + n[2]*n[2];
    btScalar k = btRecipSqrt (a);
    p[0] = 0;
	p[1] = -n[2]*k;
	p[2] = n[1]*k;
    // set q = n x p
    q[0] = a*k;
	q[1] = -n[0]*p[2];
	q[2] = n[0]*p[1];
  }
  else {
    // choose p in x-y plane
    btScalar a = n[0]*n[0] + n[1]*n[1];
    btScalar k = btRecipSqrt (a);
    p[0] = -n[1]*k;
	p[1] = n[0]*k;
	p[2] = 0;
    // set q = n x p
    q[0] = -n[2]*p[1];
	q[1] = n[2]*p[0];
	q[2] = a*k;
  }
}


struct	btVector3FloatData
{
	float	m_floats[4];
};

struct	btVector3DoubleData
{
	double	m_floats[4];

};
