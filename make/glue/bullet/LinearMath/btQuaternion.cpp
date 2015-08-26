#include <new>
#include <LinearMath/btQuaternion.h>
extern "C" void _glue_6090680929231982206(btQuaternion* _this) {
	delete _this;
}

extern "C" btQuaternion* _glue_11530428453167992567(float a0, float a1, float a2, float a3) {
	return new btQuaternion(a0, a1, a2, a3);
}

extern "C" float _glue_5061122478393517352(btQuaternion* _this) {
	return _this->x(); 
}

extern "C" float _glue_4436871453106463219(btQuaternion* _this) {
	return _this->y(); 
}

extern "C" float _glue_6232856627101071598(btQuaternion* _this) {
	return _this->z(); 
}

extern "C" float _glue_13159897530751596525(btQuaternion* _this) {
	return _this->w(); 
}

extern "C" btVector3 _glue_6658186237716193833(btQuaternion* _this) {
	return _this->getAxis(); 
}

extern "C" float _glue_9993676166438047533(btQuaternion* _this) {
	return _this->getAngle(); 
}

