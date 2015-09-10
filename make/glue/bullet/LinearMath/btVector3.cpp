#include <new>
#include <LinearMath/btVector3.h>
extern "C" void _glue_15937731161884602984(btVector3* _this) {
	delete _this;
}

extern "C" btVector3* _glue_15300433069379783171(float a0, float a1, float a2) {
	return new btVector3(a0, a1, a2);
}

extern "C" float _glue_7998324854144534542(btVector3* _this) {
	return _this->x(); 
}

extern "C" float _glue_7389449399463355433(btVector3* _this) {
	return _this->y(); 
}

extern "C" float _glue_6704008353055213128(btVector3* _this) {
	return _this->z(); 
}

extern "C" float _glue_13631049256705738055(btVector3* _this) {
	return _this->w(); 
}

