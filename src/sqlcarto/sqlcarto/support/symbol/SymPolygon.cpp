#include "SymPolygon.h"
#include "jsonutils.h"

SymPolygon::SymPolygon()
{
    _type = SYM_SHAPE_POLYGON;
}


SymPolygon::~SymPolygon()
{

}

bool SymPolygon::from_json_object(json_object *obj)
{
    _points.clear();

    _type = SYM_SHAPE_POLYGON;
    if (!SymShapeWithStrokeAndFill::from_json_object(obj))
    {
        return false;
    }

    json_object* ptarr = json_object_object_get(obj,"points");
    if(!ptarr){
        _errorMessage = "no points in polygon";
        return false;
    }
    size_t i=0;
    size_t len= json_object_array_length(ptarr);
    if(len < 3){
        _errorMessage = "more than 3 points must be given to polygon.";
        return false;
    }

    for(i=0; i<len; i++){
        json_object *ptobj = json_object_array_get_idx(ptarr, i);
        SymPoint pt;
        if(!pt.from_json_object(ptobj)){
            _errorMessage = pt.getErrorMessage();
            return false;
        }
        _points.push_back(pt);
    }

    if(_points[0] != _points[_points.size()-1]){
        _points.push_back(_points[0]);
    }

    return true;
}

json_object *SymPolygon::to_json_object()
{
    json_object *obj = SymShapeWithStrokeAndFill::to_json_object();
    JSON_ADD_STRING(obj, "type", "POLYGON");
    json_object *ptarr = json_object_new_array();
    for(std::vector<SymPoint>::iterator it=_points.begin(); it != _points.end(); it++){
        json_object *ptobj = it->to_json_object();
        json_object_array_add(ptarr,ptobj);
    }
    json_object_object_add(obj,"points",ptarr);
    return obj;
}
