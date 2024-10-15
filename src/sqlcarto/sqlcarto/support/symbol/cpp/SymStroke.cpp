#include "SymStroke.h"
#include <iostream>
#include "jsonutils.h"
#include <string.h>

SymStroke::SymStroke()
{
}

const std::string& SymStroke::getErrorMessage() const
{
    return _errorMessage;
}

bool SymStroke::fromJsonObject(json_object* obj)
{

    json_object* colorobj = json_object_object_get(obj, "color");
    if (!colorobj) {
        _errorMessage = "Can not find color information of stroke";
        return false;
    }
    if (!_color.fromJsonObject(colorobj)) {
        _errorMessage = _color.getErrorMessage();
        return true;
    }

    JSON_GET_DOUBLE(obj, "width", _width, _errorMessage);
    std::string capstr;
    JSON_GET_STRING(obj, "cap", capstr, _errorMessage);
    if (capstr == "butt") {
        _cap = LINE_CAP_BUTT;
    }
    else if (capstr == "round") {
        _cap = LINE_CAP_ROUND;
    }
    else if (capstr == "square") {
        _cap == LINE_CAP_SQUARE;
    }
    else {
        _errorMessage = "Invalid cap type. Must be: butt,round,square";
        return false;
    }

    std::string joinstr;
    JSON_GET_STRING(obj, "join", joinstr, _errorMessage);
    if (joinstr == "bevel") {
        _join = LINE_JOIN_BEVEL;
    }
    else if (joinstr == "round") {
        _join = LINE_JOIN_ROUND;
    }
    else if (joinstr == "miter") {
        _join == LINE_JOIN_MITER;
    }
    else {
        _errorMessage = "Invalid join type. Must be: bevel,round,miter";
        return false;
    }

    JSON_GET_DOUBLE(obj, "miter", _miter, _errorMessage);

    _dashes.clear();
    json_object* dashesobj = json_object_object_get(obj, "dashes");
    for (size_t i = 0; i < json_object_array_length(dashesobj); i++) {
        json_object* dobj = json_object_array_get_idx(dashesobj, i);
        _dashes.push_back(json_object_get_double(dobj));
    }

    return true;
}

json_object* SymStroke::toJsonObject()
{
    json_object* obj = json_object_new_object();
    json_object_object_add(obj, "color", _color.toJsonObject());

    JSON_ADD_DOUBLE(obj, "width", _width);
    std::string capstr = "butt";
    if (_cap == LINE_CAP_BUTT) {
        capstr = "butt";
    }
    else if (_cap == LINE_CAP_ROUND) {
        capstr = "round";
    }
    else if (_cap == LINE_CAP_SQUARE) {
        capstr = "square";
    }
    JSON_ADD_STRING(obj, "cap", capstr.c_str());

    std::string joinstr = "bevel";
    if (_join == LINE_JOIN_BEVEL) {
        joinstr = "bevel";
    }
    else if (_join == LINE_JOIN_ROUND) {
        joinstr = "round";
    }
    else if (_join == LINE_JOIN_MITER) {
        joinstr = "miter";
    }
    JSON_ADD_STRING(obj, "join", joinstr.c_str());
    JSON_ADD_DOUBLE(obj, "miter", _miter);
    json_object* dashesobj = json_object_new_array();
    for (size_t i = 0; i < _dashes.size(); i++) {
        json_object_array_add(dashesobj, json_object_new_double(_dashes[i]));
    }
    json_object_object_add(obj, "dashes", dashesobj);

    return obj;
}


size_t SymStroke::memorySize() {
    size_t len = 0;
    len += _color.memorySize();
    len += sizeof(_width);
    len += sizeof(size_t);          // for num of _dashes

    len += _dashes.size() * sizeof(double);     // for dashes
    len += sizeof(_cap);
    len += sizeof(_join);
    len += sizeof(_miter);

    return len;
}


char* SymStroke::serialize(const char* buf) {
    char* p = (char*)buf;
    p = _color.serialize(p);
    memcpy(p, (void*)&_width, sizeof(_width));
    p += sizeof(_width);
    size_t numdashes = _dashes.size();
    memcpy(p, (void*)&numdashes, sizeof(numdashes));
    p += sizeof(numdashes);
    for (size_t i = 0; i < numdashes; i++) {
        double dash = _dashes[i];
        memcpy(p, (void*)&dash, sizeof(double));
        p += sizeof(double);
    }
    memcpy(p, (void*)&_cap, sizeof(_cap));
    p += sizeof(_cap);
    memcpy(p, (void*)&_join, sizeof(_join));
    p += sizeof(_join);
    memcpy(p, (void*)&_miter, sizeof(_miter));
    p += sizeof(_miter);
    return p;
}



char* SymStroke::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = _color.deserialize(p);
    memcpy((void*)&_width, p, sizeof(_width));
    p += sizeof(_width);
    size_t numdashes = _dashes.size();
    memcpy((void*)&numdashes, p, sizeof(numdashes));
    p += sizeof(numdashes);
    _dashes.clear();
    for (size_t i = 0; i < numdashes; i++) {
        double dash;
        memcpy((void*)&dash, p, sizeof(dash));
        p += sizeof(dash);
        _dashes.push_back(dash);

    }

    memcpy((void*)&_cap, p, sizeof(_cap));
    p += sizeof(_cap);
    memcpy((void*)&_join, p, sizeof(_join));
    p += sizeof(_join);
    memcpy((void*)&_miter, p, sizeof(_miter));
    p += sizeof(_miter);
    return p;
}