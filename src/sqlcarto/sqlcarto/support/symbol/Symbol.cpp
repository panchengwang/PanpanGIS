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

bool Symbol::from_json_file(const char* filename)
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

    bool ret = from_json_string(buf);

    delete[] buf;
    return ret;
}

bool Symbol::from_json_string(const char* jsonstr)
{
    json_object* obj = json_tokener_parse(jsonstr);
    if (!obj) {
        _errorMessage = "Can not parse the input string to json object!";
        return false;
    }

    if (!from_json_object(obj)) {
        return false;
    }

    json_object_put(obj);

    return true;
}

std::string Symbol::to_json_string()
{
    json_object* obj = to_json_object();
    std::string jsonstr = json_object_to_json_string(obj);
    json_object_put(obj);
    return jsonstr;
}

bool Symbol::from_json_object(json_object* obj)
{
    json_object* offsetobj = NULL;
    JSON_GET_OBJ(obj, "offset", offsetobj, _errorMessage);
    if (!_offset.from_json_object(offsetobj))
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
        if (typestr == "SYSTEM_LINE") {
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

        if (!shp->from_json_object(shpobj))
        {
            _errorMessage = shp->getErrorMessage();
            return false;
        }

        _shapes.push_back(shp);
    }
    return true;
}

json_object* Symbol::to_json_object()
{
    json_object* obj = json_object_new_object();
    json_object_object_add(obj, "offset", _offset.to_json_object());
    json_object_object_add(obj, "xscale", json_object_new_double(_xscale));
    json_object_object_add(obj, "yscale", json_object_new_double(_yscale));

    json_object* shpobjarr = json_object_new_array();
    for (size_t i = 0; i < _shapes.size(); i++)
    {
        json_object* shpobj = _shapes.at(i)->to_json_object();
        json_object_array_add(shpobjarr, shpobj);
    }
    json_object_object_add(obj, "shapes", shpobjarr);
    return obj;
}

const std::string& Symbol::getErrorMessage() const
{
    return _errorMessage;
}

size_t Symbol::memory_size() {
    size_t len = 0;

    len += _offset.memory_size();
    len += sizeof(_xscale);
    len += sizeof(_yscale);
    len += sizeof(size_t);      // for number of shapes
    for (size_t i = 0; i < _shapes.size(); i++) {
        len += _shapes[i]->memory_size();
    }
    return len;
}