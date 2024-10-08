#include "SymLineString.h"
#include "jsonutils.h"

SymLineString::SymLineString()
{
    _type = SYM_SHAPE_LINESTRING;
}

bool SymLineString::from_json_object(json_object *obj)
{
    _points.clear();

    _type = SYM_SHAPE_LINESTRING;
    if (!SymShapeWithStroke::from_json_object(obj))
    {
        return false;
    }

    json_object* ptarr = json_object_object_get(obj,"points");
    if(!ptarr){
        _errorMessage = "no points in linestring";
        return false;
    }
    size_t i=0;
    size_t len= json_object_array_length(ptarr);
    for(i=0; i<len; i++){
        json_object *ptobj = json_object_array_get_idx(ptarr, i);
        SymPoint pt;
        if(!pt.from_json_object(ptobj)){
            _errorMessage = pt.getErrorMessage();
            return false;
        }
        _points.push_back(pt);
    }

    return true;
}

json_object *SymLineString::to_json_object()
{
    json_object *obj = SymShapeWithStroke::to_json_object();
    JSON_ADD_STRING(obj, "type", "LINESTRING");
    json_object *ptarr = json_object_new_array();
    for(std::vector<SymPoint>::iterator it=_points.begin(); it != _points.end(); it++){
        json_object *ptobj = it->to_json_object();
        json_object_array_add(ptarr,ptobj);
    }
    json_object_object_add(obj,"points",ptarr);
    return obj;
}
