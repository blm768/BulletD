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

module bullet.linearMath.btMinMax;

public import bullet.linearMath.btScalar;

//To do: figure out how to get auto ref to work?
const(T) btMin(T)(const T a, const T b)
{
  return a < b ? a : b;
}

const(T) btMax(T)(const T a, const T b)
{
  return  a > b ? a : b;
}

const(T) btClamped(T)(const T a, const T lb, const T ub)
{
	return a < lb ? lb : (ub < a ? ub : a);
}

void btSetMin(T)(ref T a, const auto ref T b)
{
    if (b < a)
	{
		a = b;
	}
}

void btSetMax(T)(ref T a, const auto ref T b)
{
    if (a < b)
	{
		a = b;
	}
}

void btClamp(T)(ref T a, const auto ref T lb, const auto ref T ub)
{
	if (a < lb)
	{
		a = lb;
	}
	else if (ub < a)
	{
		a = ub;
	}
}

