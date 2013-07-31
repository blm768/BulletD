module bullet.collision.broadphase.broadphaseInterface;

public import bullet.linearMath.scalar;

version(genBindings) {
	static void writeBindings(File f) {
		f.writeIncludes("#include <BulletCollision/BroadphaseCollision/btBroadphaseInterface.h>");
		
		btBroadphaseInterface.writeBindings(f);
	}
}

struct btBroadphaseInterface {
	mixin classBinding!"btBroadphaseInterface";

}

