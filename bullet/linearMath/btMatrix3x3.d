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

//D port of Bullet Physics

module bullet.linearMath.btMatrix3x3;

public import bullet.linearMath.btVector3;
public import bullet.linearMath.btQuaternion;

version(BT_USE_DOUBLE_PRECISION) {
	alias btMatrix3x3DoubleData btMatrix3x3Data;
} else {
	alias btMatrix3x3FloatData btMatrix3x3Data;
}

/++The btMatrix3x3 class implements a 3x3 rotation matrix, to perform linear algebra in combination with btQuaternion, btTransform and btVector3.
* Make sure to only include a pure orthogonal matrix without scaling. +/
struct btMatrix3x3 {
	private:
	btVector3 m_el[3];

	public:

	this()(const auto ref btQuaternion q) {
		setRotation(q);
	}

	this()(	const auto ref btScalar xx, const auto ref btScalar xy, const auto ref btScalar xz,
					const auto ref btScalar yx, const auto ref btScalar yy, const auto ref btScalar yz,
					const auto ref btScalar zx, const auto ref btScalar zy, const auto ref btScalar zz) {
		setValue(xx, xy, xz, yx, yy, yz, zx, zy, zz);
	}

	//Assignment operator not needed

	ref const(btVector3) getColumn(int i) const {
		btFullAssert(0 <= i && i < 3);
		return btVector3(m_el[0][i],m_el[1][i],m_el[2][i]);
	}

	ref const(btVector3) getRow(int i) const {
		btFullAssert(0 <= i && i < 3);
		return m_el[i];
	}

	ref btVector3 opIndex(int i) {
		btFullAssert(0 <= i && i < 3);
		return m_el[i];
	}

	ref const(btVector3) opIndex(int i) const {
		btFullAssert(0 <= i && i < 3);
		return m_el[i];
	}

	ref btMatrix3x3 opOpAssign(string op: "*")(const auto ref btMatrix3x3 m){
		setValue(m.tdotx(m_el[0]), m.tdoty(m_el[0]), m.tdotz(m_el[0]),
		m.tdotx(m_el[1]), m.tdoty(m_el[1]), m.tdotz(m_el[1]),
		m.tdotx(m_el[2]), m.tdoty(m_el[2]), m.tdotz(m_el[2]));
		return this;
	}

	ref btMatrix3x3 opOpAssign(string op: "+")(const auto ref btMatrix3x3 m) {
		setValue(
		m_el[0][0]+m.m_el[0][0],
		m_el[0][1]+m.m_el[0][1],
		m_el[0][2]+m.m_el[0][2],
		m_el[1][0]+m.m_el[1][0],
		m_el[1][1]+m.m_el[1][1],
		m_el[1][2]+m.m_el[1][2],
		m_el[2][0]+m.m_el[2][0],
		m_el[2][1]+m.m_el[2][1],
		m_el[2][2]+m.m_el[2][2]);
		return this;
	}

	ref btMatrix3x3 opOpAssign(string op: "-")(const auto ref btMatrix3x3 m) {
		setValue(
		m_el[0][0]-m.m_el[0][0],
		m_el[0][1]-m.m_el[0][1],
		m_el[0][2]-m.m_el[0][2],
		m_el[1][0]-m.m_el[1][0],
		m_el[1][1]-m.m_el[1][1],
		m_el[1][2]-m.m_el[1][2],
		m_el[2][0]-m.m_el[2][0],
		m_el[2][1]-m.m_el[2][1],
		m_el[2][2]-m.m_el[2][2]);
		return this;
	}

	btMatrix3x3 opBinary(string op: "*")(const auto ref btMatrix3x3 k) {
		return btMatrix3x3(
			m_el[0].x()*k,m_el[0].y()*k,m_el[0].z()*k,
			m_el[1].x()*k,m_el[1].y()*k,m_el[1].z()*k,
			m_el[2].x()*k,m_el[2].y()*k,m_el[2].z()*k);
	}

	btVector3 opBinary(string op: "*")(const auto ref btVector3 v) const {
		return btVector3(m_el[0].dot(v), m_el[1].dot(v), m_el[2].dot(v));
	}

	btMatrix3x3 opBinary(string op: "+")(const auto ref btMatrix3x3 m2) {
		return btMatrix3x3(
		m_el[0][0]+m2[0][0],
		m_el[0][1]+m2[0][1],
		m_el[0][2]+m2[0][2],
		m_el[1][0]+m2[1][0],
		m_el[1][1]+m2[1][1],
		m_el[1][2]+m2[1][2],
		m_el[2][0]+m2[2][0],
		m_el[2][1]+m2[2][1],
		m_el[2][2]+m2[2][2]);
	}

	btMatrix3x3 opBinary(string op: "-")(const auto ref btMatrix3x3 m2) {
		return btMatrix3x3(
			m_el[0][0]-m2[0][0],
			m_el[0][1]-m2[0][1],
			m_el[0][2]-m2[0][2],
			m_el[1][0]-m2[1][0],
			m_el[1][1]-m2[1][1],
			m_el[1][2]-m2[1][2],
			m_el[2][0]-m2[2][0],
			m_el[2][1]-m2[2][1],
			m_el[2][2]-m2[2][2]);
	}

	void setFromOpenGLSubMatrix()(const auto ref btScalalar* m) {
		m_el[0].setValue(m[0],m[4],m[8]);
		m_el[1].setValue(m[1],m[5],m[9]);
		m_el[2].setValue(m[2],m[6],m[10]);
	}

	void setValue()(const auto ref btScalar xx, const auto ref btScalar xy, const auto ref btScalar xz,
					const auto ref btScalar yx, const auto ref btScalar yy, const auto ref btScalar yz,
					const auto ref btScalar zx, const auto ref btScalar zy, const auto ref btScalar zz) {
		m_el[0].setValue(xx,xy,xz);
		m_el[1].setValue(yx,yy,yz);
		m_el[2].setValue(zx,zy,zz);
	}

	void setRotation()(const auto ref btQuaternion q) {
		btScalar d = q.length2();
		btFullAssert(d != cast(btScalar)0.0);
		btScalar s = cast(btScalar)2.0 / d;
		btScalar xs = q.x() * s,   ys = q.y() * s,   zs = q.z() * s;
		btScalar wx = q.w() * xs,  wy = q.w() * ys,  wz = q.w() * zs;
		btScalar xx = q.x() * xs,  xy = q.x() * ys,  xz = q.x() * zs;
		btScalar yy = q.y() * ys,  yz = q.y() * zs,  zz = q.z() * zs;
		setValue(cast(btScalar)1.0 - (yy + zz), xy - wz, xz + wy,
			xy + wz, btScalar(1.0) - (xx + zz), yz - wx,
			xz - wy, yz + wx, btScalar(1.0) - (xx + yy));
	}

	void setEulerYPR()(const auto ref btScalar yaw, const auto ref btScalar pitch, const auto ref btScalar roll) {
		setEulerZYX(roll, pitch, yaw);
	}

	void setEulerZYX(btScalar eulerX, btScalar eulerY, btScalar eulerZ) {
		btScalar ci = btCos(eulerX);
		btScalar cj = btCos(eulerY);
		btScalar ch = btCos(eulerZ);
		btScalar si = btSin(eulerX);
		btScalar sj = btSin(eulerY);
		btScalar sh = btSin(eulerZ);
		btScalar cc = ci * ch;
		btScalar cs = ci * sh;
		btScalar sc = si * ch;
		btScalar ss = si * sh;

		setValue(cj * ch, sj * sc - cs, sj * cc + ss,
				cj * sh, sj * ss + cc, sj * cs - sc,
				-sj,     cj * si,      cj * ci);
	}

	void setIdentity() {
		setValue(	cast(btScalar)1.0, cast(btScalar)0.0, cast(btScalar)0.0,
					cast(btScalar)0.0, cast(btScalar)1.0, cast(btScalar)0.0,
					cast(btScalar)0.0, cast(btScalar)0.0, cast(btScalar)1.0);
	}


	enum btMatrix3x3 identityMatrix =
		btMatrix3x3(	cast(btScalar)1.0, cast(btScalar)0.0, cast(btScalar)0.0,
						cast(btScalar)0.0, cast(btScalar)1.0, cast(btScalar)0.0,
						cast(btScalar)0.0, cast(btScalar)0.0, cast(btScalar)1.0);

	void getOpenGLSubMatrix(btScalar* m) const {
		m[0]  = cast(btScalar)(m_el[0].x());
		m[1]  = cast(btScalar)(m_el[1].x());
		m[2]  = cast(btScalar)(m_el[2].x());
		m[3]  = cast(btScalar)(0.0);
		m[4]  = cast(btScalar)(m_el[0].y());
		m[5]  = cast(btScalar)(m_el[1].y());
		m[6]  = cast(btScalar)(m_el[2].y());
		m[7]  = cast(btScalar)(0.0);
		m[8]  = cast(btScalar)(m_el[0].z());
		m[9]  = cast(btScalar)(m_el[1].z());
		m[10] = cast(btScalar)(m_el[2].z());
		m[11] = cast(btScalar)(0.0);
	}

	void getRotation(ref btQuaternion q) const {
		btScalar trace = m_el[0].x() + m_el[1].y() + m_el[2].z();
		btScalar temp[4];

		if (trace > cast(btScalar)0.0)
		{
			btScalar s = btSqrt(trace + cast(btScalar)1.0);
			temp[3]=(s * cast(btScalar)0.5);
			s = cast(btScalar)0.5 / s;

			temp[0]=((m_el[2].y() - m_el[1].z()) * s);
			temp[1]=((m_el[0].z() - m_el[2].x()) * s);
			temp[2]=((m_el[1].x() - m_el[0].y()) * s);
		}
		else
		{
			int i = m_el[0].x() < m_el[1].y() ?
				(m_el[1].y() < m_el[2].z() ? 2 : 1) :
				(m_el[0].x() < m_el[2].z() ? 2 : 0);
			int j = (i + 1) % 3;
			int k = (i + 2) % 3;

			btScalar s = btSqrt(m_el[i][i] - m_el[j][j] - m_el[k][k] + cast(btScalar)1.0);
			temp[i] = s * cast(btScalar)0.5;
			s = cast(btScalar)0.5 / s;

			temp[3] = (m_el[k][j] - m_el[j][k]) * s;
			temp[j] = (m_el[j][i] + m_el[i][j]) * s;
			temp[k] = (m_el[k][i] + m_el[i][k]) * s;
		}
		q.setValue(temp[0],temp[1],temp[2],temp[3]);
	}

	void getEulerYPR(ref btScalar yaw, ref btScalar pitch, ref btScalar roll) const {
		yaw = cast(btScalar)(btAtan2(m_el[1].x(), m_el[0].x()));
		pitch = cast(btScalar)(btAsin(-m_el[2].x()));
		roll = cast(btScalar)(btAtan2(m_el[2].y(), m_el[2].z()));

		// on pitch = +/-HalfPI
		if (btFabs(pitch)==SIMD_HALF_PI)
		{
			if (yaw>0)
				yaw-=SIMD_PI;
			else
				yaw+=SIMD_PI;

			if (roll>0)
				roll-=SIMD_PI;
			else
				roll+=SIMD_PI;
		}
	}

	void getEulerZYX(ref btScalar yaw, ref btScalar pitch, ref btScalar roll, uint solution_number = 1) const {
		struct Euler
		{
			btScalar yaw;
			btScalar pitch;
			btScalar roll;
		}

		Euler euler_out;
		Euler euler_out2; //second solution
		//get the pointer to the raw data

		// Check that pitch is not at a singularity
		if (btFabs(m_el[2].x()) >= 1)
		{
			euler_out.yaw = 0;
			euler_out2.yaw = 0;

			// From difference of angles formula
			btScalar delta = btAtan2(m_el[0].x(),m_el[0].z());
			if (m_el[2].x() > 0)  //gimbal locked up
			{
				euler_out.pitch = SIMD_PI / cast(btScalar)2.0;
				euler_out2.pitch = SIMD_PI / cast(btScalar)2.0;
				euler_out.roll = euler_out.pitch + delta;
				euler_out2.roll = euler_out.pitch + delta;
			}
			else // gimbal locked down
			{
				euler_out.pitch = -SIMD_PI / cast(btScalar)2.0;
				euler_out2.pitch = -SIMD_PI / cast(btScalar)2.0;
				euler_out.roll = -euler_out.pitch + delta;
				euler_out2.roll = -euler_out.pitch + delta;
			}
		}
		else
		{
			euler_out.pitch = - btAsin(m_el[2].x());
			euler_out2.pitch = SIMD_PI - euler_out.pitch;

			euler_out.roll = btAtan2(m_el[2].y()/btCos(euler_out.pitch),
				m_el[2].z()/btCos(euler_out.pitch));
			euler_out2.roll = btAtan2(m_el[2].y()/btCos(euler_out2.pitch),
				m_el[2].z()/btCos(euler_out2.pitch));

			euler_out.yaw = btAtan2(m_el[1].x()/btCos(euler_out.pitch),
				m_el[0].x()/btCos(euler_out.pitch));
			euler_out2.yaw = btAtan2(m_el[1].x()/btCos(euler_out2.pitch),
				m_el[0].x()/btCos(euler_out2.pitch));
		}

		if (solution_number == 1)
		{
			yaw = euler_out.yaw;
			pitch = euler_out.pitch;
			roll = euler_out.roll;
		}
		else
		{
			yaw = euler_out2.yaw;
			pitch = euler_out2.pitch;
			roll = euler_out2.roll;
		}
	}

	btMatrix3x3 scaled()(const auto ref btVector3 s) const {
		return btMatrix3x3(	m_el[0].x() * s.x(), m_el[0].y() * s.y(), m_el[0].z() * s.z(),
							m_el[1].x() * s.x(), m_el[1].y() * s.y(), m_el[1].z() * s.z(),
							m_el[2].x() * s.x(), m_el[2].y() * s.y(), m_el[2].z() * s.z());
	}

	btScalar determinant() const {
		return btTriple(m_el[0], m_el[1], m_el[2]);
	}

	btMatrix3x3 adjoint() const {
		return btMatrix3x3(	cofac(1, 1, 2, 2), cofac(0, 2, 2, 1), cofac(0, 1, 1, 2),
							cofac(1, 2, 2, 0), cofac(0, 0, 2, 2), cofac(0, 2, 1, 0),
							cofac(1, 0, 2, 1), cofac(0, 1, 2, 0), cofac(0, 0, 1, 1));
	}

	btMatrix3x3 absolute() const {
		return btMatrix3x3(
			btFabs(m_el[0].x()), btFabs(m_el[0].y()), btFabs(m_el[0].z()),
			btFabs(m_el[1].x()), btFabs(m_el[1].y()), btFabs(m_el[1].z()),
			btFabs(m_el[2].x()), btFabs(m_el[2].y()), btFabs(m_el[2].z()));
	}

	btMatrix3x3 transpose() const {
		return btMatrix3x3(	m_el[0].x(), m_el[1].x(), m_el[2].x(),
							m_el[0].y(), m_el[1].y(), m_el[2].y(),
							m_el[0].z(), m_el[1].z(), m_el[2].z());
	}

	btMatrix3x3 inverse() const {
		btVector3 co = btVector3(cofac(1, 1, 2, 2), cofac(1, 2, 2, 0), cofac(1, 0, 2, 1));
		btScalar det = m_el[0].dot(co);
		btFullAssert(det != cast(btScalar)0.0);
		btScalar s = cast(btScalar)1.0 / det;
		return btMatrix3x3(	co.x() * s, cofac(0, 2, 2, 1) * s, cofac(0, 1, 1, 2) * s,
							co.y() * s, cofac(0, 0, 2, 2) * s, cofac(0, 2, 1, 0) * s,
							co.z() * s, cofac(0, 1, 2, 0) * s, cofac(0, 0, 1, 1) * s);
	}

	btMatrix3x3 transposeTimes()(const auto ref btMatrix3x3 m) const {
		return btMatrix3x3(
			m_el[0].x() * m[0].x() + m_el[1].x() * m[1].x() + m_el[2].x() * m[2].x(),
			m_el[0].x() * m[0].y() + m_el[1].x() * m[1].y() + m_el[2].x() * m[2].y(),
			m_el[0].x() * m[0].z() + m_el[1].x() * m[1].z() + m_el[2].x() * m[2].z(),
			m_el[0].y() * m[0].x() + m_el[1].y() * m[1].x() + m_el[2].y() * m[2].x(),
			m_el[0].y() * m[0].y() + m_el[1].y() * m[1].y() + m_el[2].y() * m[2].y(),
			m_el[0].y() * m[0].z() + m_el[1].y() * m[1].z() + m_el[2].y() * m[2].z(),
			m_el[0].z() * m[0].x() + m_el[1].z() * m[1].x() + m_el[2].z() * m[2].x(),
			m_el[0].z() * m[0].y() + m_el[1].z() * m[1].y() + m_el[2].z() * m[2].y(),
			m_el[0].z() * m[0].z() + m_el[1].z() * m[1].z() + m_el[2].z() * m[2].z());
	}

	btMatrix3x3 timesTranspose()(const auto ref btMatrix3x3 m) const {
		return btMatrix3x3(
			m_el[0].dot(m[0]), m_el[0].dot(m[1]), m_el[0].dot(m[2]),
			m_el[1].dot(m[0]), m_el[1].dot(m[1]), m_el[1].dot(m[2]),
			m_el[2].dot(m[0]), m_el[2].dot(m[1]), m_el[2].dot(m[2]));
	}

	btScalar tdotx()(const auto ref btVector3 v) {
		return m_el[0].x() * v.x() + m_el[1].x() * v.y() + m_el[2].x() * v.z();
	}

	btScalar tdoty()(const auto ref btVector3 v) const {
		return m_el[0].y() * v.x() + m_el[1].y() * v.y() + m_el[2].y() * v.z();
	}

	btScalar tdotz()(const auto ref btVector3 v) const {
		return m_el[0].z() * v.x() + m_el[1].z() * v.y() + m_el[2].z() * v.z();
	}

	void diagonalize()(ref btMatrix3x3 rot, btScalar threshold, int maxSteps) {
		rot.setIdentity();
		for (int step = maxSteps; step > 0; step--)
		{
			// find off-diagonal element [p][q] with largest magnitude
			int p = 0;
			int q = 1;
			int r = 2;
			btScalar max = btFabs(m_el[0][1]);
			btScalar v = btFabs(m_el[0][2]);
			if (v > max)
			{
				q = 2;
				r = 1;
				max = v;
			}
			v = btFabs(m_el[1][2]);
			if (v > max)
			{
				p = 1;
				q = 2;
				r = 0;
				max = v;
			}

			btScalar t = threshold * (btFabs(m_el[0][0]) + btFabs(m_el[1][1]) + btFabs(m_el[2][2]));
			if (max <= t)
			{
				if (max <= SIMD_EPSILON * t)
				{
					return;
				}
				step = 1;
			}

			// compute Jacobi rotation J which leads to a zero for element [p][q]
			btScalar mpq = m_el[p][q];
			btScalar theta = (m_el[q][q] - m_el[p][p]) / (2 * mpq);
			btScalar theta2 = theta * theta;
			btScalar cos;
			btScalar sin;
			if (theta2 * theta2 < cast(btScalar)(10 / SIMD_EPSILON))
			{
				t = (theta >= 0) ? 1 / (theta + btSqrt(1 + theta2))
					: 1 / (theta - btSqrt(1 + theta2));
				cos = 1 / btSqrt(1 + t * t);
				sin = cos * t;
			}
			else
			{
				// approximation for large theta-value, i.e., a nearly diagonal matrix
				t = 1 / (theta * (2 + cast(btScalar)0.5 / theta2));
				cos = 1 - cast(btScalar)0.5 * t * t;
				sin = cos * t;
			}

			// apply rotation to matrix (this = J^T * this * J)
			m_el[p][q] = m_el[q][p] = 0;
			m_el[p][p] -= t * mpq;
			m_el[q][q] += t * mpq;
			btScalar mrp = m_el[r][p];
			btScalar mrq = m_el[r][q];
			m_el[r][p] = m_el[p][r] = cos * mrp - sin * mrq;
			m_el[r][q] = m_el[q][r] = cos * mrq + sin * mrp;

			// apply rotation to rot (rot = rot * J)
			for (int i = 0; i < 3; i++)
			{
				btVector3& row = rot[i];
				mrp = row[p];
				mrq = row[q];
				row[p] = cos * mrp - sin * mrq;
				row[q] = cos * mrq + sin * mrp;
			}
		}
	}

	btScalar cofac(int r1, int c1, int r2, int c2) const {
		return m_el[r1][c1] * m_el[r2][c2] - m_el[r1][c2] * m_el[r2][c1];
	}

	void serialize(ref btMatrix3x3Data dataOut) const {
		for (int i=0;i<3;i++)
			m_el[i].serialize(dataOut.m_el[i]);
	}

	void serializeFloat(ref btMatrix3x3FloatData dataOut) const {
		for (int i=0;i<3;i++)
			m_el[i].serializeFloat(dataOut.m_el[i]);
	}

	void deSerialize()(const auto ref btMatrix3x3Data dataIn) {
		for (int i=0;i<3;i++)
			m_el[i].deSerialize(dataIn.m_el[i]);
	}

	void deSerializeFloat()(const auto ref btMatrix3x3FloatData dataIn) {
		for (int i=0;i<3;i++)
			m_el[i].deSerializeFloat(dataIn.m_el[i]);
	}

	void deSerializeDouble()(const auto ref btMatrix3x3DoubleData dataIn) {
		for (int i=0;i<3;i++)
			m_el[i].deSerializeDouble(dataIn.m_el[i]);
	}
}

struct	btMatrix3x3FloatData {
	btVector3FloatData m_el[3];
}

struct	btMatrix3x3DoubleData {
	btVector3DoubleData m_el[3];
}
