#include "Symbol.h"
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "jsonutils.h"
#include "SymSystemLine.h"
#include "SymShape.h"

Symbol::Symbol()
{
}

bool Symbol::from_json_file(const char *filename)
{
    FILE *fd = fopen(filename, "r");
    if (!fd)
    {
        _errorMessage = std::string("Can not open file : ") + filename;
        return false;
    }

    size_t len;
    fseek(fd, 0, SEEK_END);
    len = ftell(fd);
    char *buf = new char[len + 1];
    buf[len] = '\0';

    fseek(fd, 0, SEEK_SET);
    fread(buf, 1, len, fd);
    fclose(fd);

    bool ret = from_json_string(buf);

    delete[] buf;
    return ret;
}

bool Symbol::from_json_string(const char *jsonstr)
{
    json_object *obj = json_tokener_parse(jsonstr);
    if (!obj)
    {
        _errorMessage = "Can not parse the input string to json object!";
        return false;
    }

    if (!from_json_object(obj))
    {
        return false;
    }

    json_object_put(obj);

    return true;
}

std::string Symbol::to_json_string()
{
    json_object *obj = to_json_object();
    std::string jsonstr = json_object_to_json_string(obj);
    json_object_put(obj);
    return jsonstr;
}

bool Symbol::from_json_object(json_object *obj)
{
    if (!_offset.from_json_object(json_object_object_get(obj, "offset")))
    {
        _errorMessage = _offset.getErrorMessage();
        return false;
    }

    JSON_GET_DOUBLE(obj, "xscale", _xscale, _errorMessage);
    JSON_GET_DOUBLE(obj, "yscale", _yscale, _errorMessage);

    json_object *shpobjs = json_object_object_get(obj, "shapes");
    size_t nobjs = json_object_array_length(shpobjs);
    for (size_t i = 0; i < nobjs; i++)
    {
        json_object *shpobj = json_object_array_get_idx(shpobjs, i);
        std::string typestr;
        JSON_GET_STRING(shpobj,"type",typestr,_errorMessage);
        SymShape *shp = NULL;
        if(typestr == "SYSTEM_LINE"){
            shp = new SymSystemLine();
        }
    }
    return true;
}

json_object *Symbol::to_json_object()
{
    json_object *obj = json_object_new_object();
    json_object_object_add(obj, "offset", _offset.to_json_object());
    json_object_object_add(obj, "xscale", json_object_new_double(_xscale));
    json_object_object_add(obj, "yscale", json_object_new_double(_yscale));
    return obj;
}

const std::string &Symbol::getErrorMessage() const
{
    return _errorMessage;
}