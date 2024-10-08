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

SymPoint::SymPoint(const SymPoint& other){
    _x = other._x;
    _y = other._y;
}

const std::string& SymPoint::getErrorMessage() const{
    return _errorMessage;
}




bool SymPoint::from_json_object(json_object *obj)
{
    // json_object *xobj = json_object_object_get(obj,"x");
    // if(!xobj){
    //     _errorMessage = "error: parse x of SymPoint ";
    //     return false;
    // }
    // _x = json_object_get_double(xobj);
    JSON_GET_DOUBLE(obj,"x",_x,_errorMessage);
    JSON_GET_DOUBLE(obj,"y",_y,_errorMessage);
    return true;
}

json_object *SymPoint::to_json_object()
{
    json_object *obj = json_object_new_object();

    json_object_object_add(obj,"x",json_object_new_double(_x));
    json_object_object_add(obj,"y",json_object_new_double(_y));
    return obj;
}


bool operator==(const SymPoint& pt1, const SymPoint& pt2){
    return (pt1._x - pt2._x)*(pt1._x - pt2._x) + (pt1._y - pt2._y) * (pt1._y - pt2._y) <= std::numeric_limits<double>::epsilon();
}


bool operator!=(const SymPoint& pt1, const SymPoint& pt2){
    return !(pt1 == pt2);
}