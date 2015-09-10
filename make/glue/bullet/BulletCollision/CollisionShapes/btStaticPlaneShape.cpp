#include <new>
#include <BulletCollision/CollisionShapes/btStaticPlaneShape.h>
extern "C" btStaticPlaneShape* _glue_987949734360920780(const btVector3& a0, float a1) {
	return new btStaticPlaneShape(a0, a1);
}

extern "C" float _glue_12953772449009435595(btStaticPlaneShape* _this) {
	return _this->getPlaneConstant(); 
}

