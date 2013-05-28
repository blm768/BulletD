module bullet.collision.broadphase.broadphaseInterface;

public import bullet.linearMath.btScalar;

version(genBindings) {
	static void writeBindings(File f) {
		f.writeIncludes("#include <bullet/BulletCollision/BroadphaseCollision/btBroadphaseInterface.h>");
		
		btBroadphaseInterface.writeBindings(f);
	}
}

struct btBroadphaseInterface {
	mixin classBinding!"btBroadphaseInterface";

}

