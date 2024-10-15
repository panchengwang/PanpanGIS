#include "SymLineString.h"
#include "jsonutils.h"

SymLineString::SymLineString()
{
    _type = SYM_SHAPE_LINESTRING;
}

bool SymLineString::fromJsonObject(json_object* obj)
{
    _points.clear();

    _type = SYM_SHAPE_LINESTRING;
    if (!SymShapeWithStroke::fromJsonObject(obj))
    {
        return false;
    }

    json_object* ptarr = json_object_object_get(obj, "points");
    if (!ptarr) {
        _errorMessage = "no points in linestring";
        return false;
    }
    size_t i = 0;
    size_t len = json_object_array_length(ptarr);
    for (i = 0; i < len; i++) {
        json_object* ptobj = json_object_array_get_idx(ptarr, i);
        SymPoint pt;
        if (!pt.fromJsonObject(ptobj)) {
            _errorMessage = pt.getErrorMessage();
            return false;
        }
        _points.push_back(pt);
    }

    return true;
}

json_object* SymLineString::toJsonObject()
{
    json_object* obj = SymShapeWithStroke::toJsonObject();
    JSON_ADD_STRING(obj, "type", "LINESTRING");
    json_object* ptarr = json_object_new_array();
    for (std::vector<SymPoint>::iterator it = _points.begin(); it != _points.end(); it++) {
        json_object* ptobj = it->toJsonObject();
        json_object_array_add(ptarr, ptobj);
    }
    json_object_object_add(obj, "points", ptarr);
    return obj;
}


size_t SymLineString::memorySize() {
    size_t len = SymShapeWithStroke::memorySize();

    len += sizeof(size_t);    // for num of  points

    for (std::vector<SymPoint>::iterator it = _points.begin(); it != _points.end(); it++) {
        len += it->memorySize();
    }

    return len;

}


char* SymLineString::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStroke::serialize(p);
    size_t numPoints = _points.size();
    memcpy(p, (void*)&numPoints, sizeof(numPoints));
    p += sizeof(numPoints);
    for (size_t i = 0; i < numPoints; i++) {
        p = _points[i].serialize(p);
    }
    return p;
}



char* SymLineString::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStroke::deserialize(p);
    size_t numPoints = _points.size();
    memcpy((void*)&numPoints, p, sizeof(numPoints));
    p += sizeof(numPoints);
    _points.clear();
    for (size_t i = 0; i < numPoints; i++) {
        SymPoint pt;
        p = pt.deserialize(p);
        _points.push_back(pt);
    }
    return p;
}