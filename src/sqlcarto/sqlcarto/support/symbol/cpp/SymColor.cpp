#include "SymColor.h"
#include "jsonutils.h"

SymColor::SymColor()
{
    _alpha = 255;
    _red = 255;
    _green = 255;
    _blue = 255;
}

SymColor::SymColor(uint8_t alpha, uint8_t red, uint8_t green, uint8_t blue)
{
    _alpha = alpha;
    _red = red;
    _green = green;
    _blue = blue;
}

json_object* SymColor::toJsonObject()
{
    json_object* obj = json_object_new_object();

    JSON_ADD_INT(obj, "alpha", _alpha);
    JSON_ADD_INT(obj, "red", _red);
    JSON_ADD_INT(obj, "green", _green);
    JSON_ADD_INT(obj, "blue", _blue);

    return obj;
}

bool SymColor::fromJsonObject(json_object* obj)
{
    JSON_GET_INT(obj, "alpha", _alpha, _errorMessage);
    JSON_GET_INT(obj, "red", _red, _errorMessage);
    JSON_GET_INT(obj, "green", _green, _errorMessage);
    JSON_GET_INT(obj, "blue", _blue, _errorMessage);
    return true;
}



const std::string& SymColor::getErrorMessage() const {
    return _errorMessage;
}


size_t SymColor::memorySize() {
    size_t len = 0;
    len += sizeof(_alpha);
    len += sizeof(_red);
    len += sizeof(_green);
    len += sizeof(_blue);
    return len;
}



char* SymColor::serialize(const char* buf) {
    char* p = (char*)buf;
    memcpy(p, (void*)&_alpha, sizeof(_alpha));
    p += sizeof(_alpha);
    memcpy(p, (void*)&_red, sizeof(_red));
    p += sizeof(_red);
    memcpy(p, (void*)&_green, sizeof(_green));
    p += sizeof(_green);
    memcpy(p, (void*)&_blue, sizeof(_blue));
    p += sizeof(_blue);
    return p;
}


char* SymColor::deserialize(const char* buf) {
    char* p = (char*)buf;
    memcpy((void*)&_alpha, p, sizeof(_alpha));
    p += sizeof(_alpha);
    memcpy((void*)&_red, p, sizeof(_red));
    p += sizeof(_red);
    memcpy((void*)&_green, p, sizeof(_green));
    p += sizeof(_green);
    memcpy((void*)&_blue, p, sizeof(_blue));
    p += sizeof(_blue);
    return p;
}



uint8_t SymColor::getAlpha() const {
    return _alpha;
}
uint8_t SymColor::getRed() const {
    return _red;
}
uint8_t SymColor::getGreen() const {
    return _green;
}
uint8_t SymColor::getBlue() const {
    return _blue;
}