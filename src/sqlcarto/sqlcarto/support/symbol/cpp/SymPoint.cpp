#include "SymPoint.h"
#include "jsonutils.h"
#include <limits>

SymPoint::SymPoint()
{
    _x = 0.0f;
    _y = 0.0f;
}

SymPoint::SymPoint(double x, double y)
{
}

SymPoint::~SymPoint()
{
}

SymPoint::SymPoint(const SymPoint& other)
{
    _x = other._x;
    _y = other._y;
}

const std::string& SymPoint::getErrorMessage() const
{
    return _errorMessage;
}

bool SymPoint::fromJsonObject(json_object* obj)
{
    JSON_GET_DOUBLE(obj, "x", _x, _errorMessage);
    JSON_GET_DOUBLE(obj, "y", _y, _errorMessage);
    return true;
}

json_object* SymPoint::toJsonObject()
{
    json_object* obj = json_object_new_object();
    JSON_ADD_DOUBLE(obj, "x", _x);
    JSON_ADD_DOUBLE(obj, "y", _y);
    return obj;
}

bool operator==(const SymPoint& pt1, const SymPoint& pt2)
{
    return (pt1._x - pt2._x) * (pt1._x - pt2._x) + (pt1._y - pt2._y) * (pt1._y - pt2._y) <= std::numeric_limits<double>::epsilon();
}

bool operator!=(const SymPoint& pt1, const SymPoint& pt2)
{
    return !(pt1 == pt2);
}

size_t SymPoint::memorySize() {
    size_t len = 0;
    len += sizeof(_x);
    len += sizeof(_y);

    return len;
}


char* SymPoint::serialize(const char* buf) {
    char* p = (char*)buf;
    memcpy(p, (void*)&_x, sizeof(_x));
    p += sizeof(_x);
    memcpy(p, (void*)&_y, sizeof(_y));
    p += sizeof(_y);
    return p;
}


char* SymPoint::deserialize(const char* buf) {
    char* p = (char*)buf;
    memcpy((void*)&_x, p, sizeof(_x));
    p += sizeof(_x);
    memcpy((void*)&_y, p, sizeof(_y));
    p += sizeof(_y);
    return p;
}



std::ostream& operator<<(std::ostream& out, const SymPoint& pt) {
    out << "x: " << pt._x << ", y: " << pt._y;
    return out;
}


double SymPoint::x() const {
    return _x;
}

double SymPoint::y() const {
    return _y;
}