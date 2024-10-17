#include "SymRect.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

SymRect::SymRect() {
    _minx = _maxx = 0.0f;
    _miny = _maxy = 0.0f;
}


SymRect::SymRect(double minx, double miny, double maxx, double maxy) {
    _minx = minx;
    _miny = miny;
    _maxx = maxx;
    _maxy = maxy;
}


void SymRect::extend(const SymRect& rect) {
    _minx = _minx < rect._minx ? _minx : rect._minx;
    _miny = _miny < rect._miny ? _miny : rect._miny;
    _maxx = _maxx > rect._maxx ? _maxx : rect._maxx;
    _maxy = _maxy > rect._maxy ? _maxy : rect._maxy;
}


SymRect::SymRect(const SymRect& rect) {
    _minx = rect._minx;
    _miny = rect._miny;
    _maxx = rect._maxx;
    _maxy = rect._maxy;
}

std::string SymRect::toString() const {
    char buf[256];
    sprintf(buf, "minx: %lf, miny: %lf, maxx: %lf, maxy: %lf", _minx, _miny, _maxx, _maxy);
    return buf;
}



SymRect& SymRect::scale(double xscale, double yscale) {
    _minx *= xscale;
    _miny *= yscale;
    _maxx *= xscale;
    _maxy *= yscale;
    return *this;
}

const SymRect& SymRect::ensureSymmetry() {
    double maxx = std::max(fabs(_minx), fabs(_maxx));
    double maxy = std::max(fabs(_miny), fabs(_maxy));
    _minx = -maxx;
    _maxx = maxx;
    _miny = -maxy;
    _maxy = maxy;
    return *this;
}


double SymRect::getWidth() const {
    return _maxx - _minx;
}


double SymRect::getHeight() const {
    return _maxy - _miny;
}


void SymRect::extend(double len) {
    _minx -= len;
    _maxx += len;
    _miny -= len;
    _maxy += len;
}