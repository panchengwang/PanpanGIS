#include "SymPoint.h"
#include "jsonutils.h"



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
