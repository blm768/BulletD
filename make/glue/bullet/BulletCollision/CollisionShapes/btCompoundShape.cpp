#include <new>
#include <BulletCollision/CollisionShapes/btCompoundShape.h>
extern "C" btCompoundShape* _glue_4133160769351169244(char a0) {
	return new btCompoundShape(a0);
}

extern "C" void _glue_1552610721416076809(btCompoundShape* _this, const btTransform& a0, btCollisionShape* a1) {
	return _this->addChildShape(a0, a1); 
}

