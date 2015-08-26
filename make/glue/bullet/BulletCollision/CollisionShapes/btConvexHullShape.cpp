#include <new>
#include <BulletCollision/CollisionShapes/btConvexHullShape.h>
extern "C" btConvexHullShape* _glue_2984468200561820153(const float* a0, int a1, int a2) {
	return new btConvexHullShape(a0, a1, a2);
}

extern "C" btConvexHullShape* _glue_9127675662215853465(const float* a0, int a1) {
	return new btConvexHullShape(a0, a1);
}

extern "C" void _glue_11360980534075953392(btConvexHullShape* _this, const btVector3& a0, char a1) {
	return _this->addPoint(a0, a1); 
}

extern "C" int _glue_13243766981869592312(btConvexHullShape* _this) {
	return _this->getNumPoints(); 
}

extern "C" btVector3* _glue_12670955770280560605(btConvexHullShape* _this) {
	return _this->getUnscaledPoints(); 
}

