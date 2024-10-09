#include "SymStroke.h"
#include <iostream>
#include "jsonutils.h"

SymStroke::SymStroke()
{
}

const std::string& SymStroke::getErrorMessage() const
{
    return _errorMessage;
}

bool SymStroke::from_json_object(json_object* obj)
{

    json_object* colorobj = json_object_object_get(obj, "color");
    if (!colorobj) {
        _errorMessage = "Can not find color information of stroke";
        return false;
    }
    if (!_color.from_json_object(colorobj)) {
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

json_object* SymStroke::to_json_object()
{
    json_object* obj = json_object_new_object();
    json_object_object_add(obj, "color", _color.to_json_object());

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


size_t SymStroke::memory_size() {
    size_t len = 0;
    len += _color.memory_size();
    len += sizeof(_width);
    len += sizeof(size_t);          // for num of _dashes
    len += _dashes.size() * sizeof(double);     // for dashes
    len += sizeof(_cap);
    len += sizeof(_join);
    len += sizeof(_miter);

    return len;
}