#include "Symbol.h"
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "jsonutils.h"
#include "SymSystemLine.h"
#include "SymArc.h"
#include "SymCircle.h"
#include "SymEllipse.h"
#include "SymPie.h"
#include "SymChord.h"
#include "SymLineString.h"
#include "SymPolygon.h"
#include "SymRegularPolygon.h"
#include "SymSystemFill.h"
#include <string.h>
#include <iostream>

Symbol::Symbol()
{
}

Symbol::~Symbol()
{
    clear();
}

void Symbol::clear() {
    for (size_t i = 0; i < _shapes.size(); i++)
    {
        delete _shapes.at(i);
    }
    _shapes.clear();
}

bool Symbol::fromJsonFile(const char* filename)
{
    FILE* fd = fopen(filename, "r");
    if (!fd)
    {
        _errorMessage = std::string("Can not open file : ") + filename;
        return false;
    }

    size_t len;
    fseek(fd, 0, SEEK_END);
    len = ftell(fd);
    char* buf = new char[len + 1];
    buf[len] = '\0';

    fseek(fd, 0, SEEK_SET);
    fread(buf, 1, len, fd);
    fclose(fd);

    bool ret = fromJsonString(buf);

    delete[] buf;
    return ret;
}

bool Symbol::fromJsonString(const char* jsonstr)
{
    json_object* obj = json_tokener_parse(jsonstr);
    if (!obj) {
        _errorMessage = "Can not parse the input string to json object!";
        return false;
    }

    if (!fromJsonObject(obj)) {
        return false;
    }

    json_object_put(obj);

    return true;
}

std::string Symbol::toJsonString()
{
    json_object* obj = toJsonObject();
    std::string jsonstr = json_object_to_json_string(obj);
    json_object_put(obj);
    return jsonstr;
}

bool Symbol::fromJsonObject(json_object* obj)
{
    json_object* offsetobj = NULL;
    JSON_GET_OBJ(obj, "offset", offsetobj, _errorMessage);
    if (!_offset.fromJsonObject(offsetobj))
    {
        _errorMessage = _offset.getErrorMessage();
        return false;
    }

    JSON_GET_DOUBLE(obj, "xscale", _xscale, _errorMessage);
    JSON_GET_DOUBLE(obj, "yscale", _yscale, _errorMessage);

    json_object* shpobjarr = json_object_object_get(obj, "shapes");
    size_t nobjs = json_object_array_length(shpobjarr);
    for (size_t i = 0; i < nobjs; i++)
    {
        json_object* shpobj = json_object_array_get_idx(shpobjarr, i);
        std::string typestr;
        JSON_GET_STRING(shpobj, "type", typestr, _errorMessage);

        SymShape* shp = NULL;
        if (typestr == "SYSTEMLINE") {
            shp = new SymSystemLine();
        }
        else if (typestr == "ARC") {
            shp = new SymArc();
        }
        else if (typestr == "CIRCLE") {
            shp = new SymCircle();
        }
        else if (typestr == "ELLIPSE") {
            shp = new SymEllipse();
        }
        else if (typestr == "PIE") {
            shp = new SymPie();
        }
        else if (typestr == "CHORD") {
            shp = new SymChord();
        }
        else if (typestr == "LINESTRING") {
            shp = new SymLineString();
        }
        else if (typestr == "POLYGON") {
            shp = new SymPolygon();
        }
        else if (typestr == "REGULARPOLYGON") {
            shp = new SymRegularPolygon();
        }
        else if (typestr == "SYSTEMFILL") {
            shp = new SymSystemFill();
        }

        if (!shp) {
            _errorMessage = std::string("Invalid shape: ") + typestr;
            return false;
        }

        if (!shp->fromJsonObject(shpobj))
        {
            _errorMessage = shp->getErrorMessage();
            return false;
        }

        _shapes.push_back(shp);
    }
    return true;
}

json_object* Symbol::toJsonObject()
{
    json_object* obj = json_object_new_object();
    json_object_object_add(obj, "offset", _offset.toJsonObject());
    json_object_object_add(obj, "xscale", json_object_new_double(_xscale));
    json_object_object_add(obj, "yscale", json_object_new_double(_yscale));

    json_object* shpobjarr = json_object_new_array();
    for (size_t i = 0; i < _shapes.size(); i++)
    {
        json_object* shpobj = _shapes.at(i)->toJsonObject();
        json_object_array_add(shpobjarr, shpobj);
    }
    json_object_object_add(obj, "shapes", shpobjarr);
    return obj;
}

const std::string& Symbol::getErrorMessage() const
{
    return _errorMessage;
}

size_t Symbol::memorySize() {
    size_t len = 0;

    len += _offset.memorySize();
    len += sizeof(_xscale);
    len += sizeof(_yscale);
    len += sizeof(size_t);      // for number of shapes
    for (size_t i = 0; i < _shapes.size(); i++) {
        len += _shapes[i]->memorySize();
    }
    return len;
}

char* Symbol::serialize(size_t& len) {
    len = memorySize();
    char* buf = (char*)malloc(len);
    char* p = buf;

    p = _offset.serialize(p);
    memcpy(p, (void*)&_xscale, sizeof(_xscale));
    p += sizeof(_xscale);
    memcpy(p, (void*)&_yscale, sizeof(_yscale));
    p += sizeof(_yscale);
    size_t nshapes = _shapes.size();
    memcpy(p, (void*)&nshapes, sizeof(nshapes));
    p += sizeof(nshapes);

    for (size_t i = 0; i < nshapes; i++) {
        p = _shapes[i]->serialize(p);
    }

    return buf;
}

bool Symbol::deserialize(const char* buf) {
    char* p = (char*)buf;

    p = _offset.deserialize(p);

    memcpy((void*)&_xscale, p, sizeof(_xscale));
    p += sizeof(_xscale);
    memcpy((void*)&_yscale, p, sizeof(_yscale));
    p += sizeof(_yscale);
    size_t nshapes = 0;
    memcpy((void*)&nshapes, p, sizeof(nshapes));
    p += sizeof(nshapes);
    for (size_t i = 0; i < nshapes; i++) {
        uint8_t shptype;
        memcpy((void*)&shptype, p, sizeof(shptype));

        SymShape* shp = NULL;
        if ((int)shptype == SYM_SHAPE_ARC) {
            shp = new SymArc();
        }
        else if (shptype == SYM_SHAPE_SYSTEM_LINE) {
            shp = new SymSystemLine();
        }
        else if (shptype == SYM_SHAPE_SYSTEM_FILL) {
            shp = new SymSystemFill();
        }
        else if (shptype == SYM_SHAPE_CIRCLE) {
            shp = new SymCircle();
        }
        else if (shptype == SYM_SHAPE_ELLIPSE) {
            shp = new SymEllipse();
        }
        else if (shptype == SYM_SHAPE_LINESTRING) {
            shp = new SymLineString();
        }
        else if (shptype == SYM_SHAPE_POLYGON) {
            shp = new SymPolygon();
        }
        else if (shptype == SYM_SHAPE_PIE) {
            shp = new SymPie();
        }
        else if (shptype == SYM_SHAPE_CHORD) {
            shp = new SymChord();
        }
        else if (shptype == SYM_SHAPE_REGULAR_POLYGON) {
            shp = new SymRegularPolygon();
        }

        if (!shp) {
            _errorMessage = "Invalid shape type !";
            return false;
        }

        p = shp->deserialize(p);

        _shapes.push_back(shp);

    }

    return true;

}



SymRect Symbol::getMBR() {

    SymRect rect(-_xscale, -_yscale, _xscale, _yscale);

    for (size_t i = 0; i < _shapes.size(); i++) {
        rect.extend(_shapes[i]->getMBR(_xscale, _yscale));
    }

    return rect;

}