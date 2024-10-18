#include "SymArc.h"
#include "jsonutils.h"
#include <math.h>
#include "serializeutils.h"

SymArc::SymArc()
{
    _type = SYM_SHAPE_ARC;
}

bool SymArc::fromJsonObject(json_object* obj)
{
    _type = SYM_SHAPE_ARC;
    if (!SymShapeWithStroke::fromJsonObject(obj))
    {
        return false;
    }


    json_object* centerobj = NULL;
    JSON_GET_OBJ(obj, "center", centerobj, _errorMessage);
    if (!_center.fromJsonObject(centerobj)) {
        _errorMessage = _center.getErrorMessage();
        return false;
    }
    JSON_GET_DOUBLE(obj, "xradius", _xradius, _errorMessage);
    JSON_GET_DOUBLE(obj, "yradius", _yradius, _errorMessage);
    JSON_GET_DOUBLE(obj, "startangle", _startAngle, _errorMessage);
    JSON_GET_DOUBLE(obj, "endangle", _endAngle, _errorMessage);
    JSON_GET_DOUBLE(obj, "rotate", _rotate, _errorMessage);
    return true;
}

json_object* SymArc::toJsonObject()
{
    json_object* obj = SymShapeWithStroke::toJsonObject();
    JSON_ADD_STRING(obj, "type", "ARC");
    json_object_object_add(obj, "center", _center.toJsonObject());
    JSON_ADD_DOUBLE(obj, "xradius", _xradius);
    JSON_ADD_DOUBLE(obj, "yradius", _yradius);
    JSON_ADD_DOUBLE(obj, "startangle", _startAngle);
    JSON_ADD_DOUBLE(obj, "endangle", _endAngle);
    JSON_ADD_DOUBLE(obj, "rotate", _rotate);
    return obj;
}


size_t SymArc::memorySize() {
    size_t len = SymShapeWithStroke::memorySize();
    len += _center.memorySize();
    len += sizeof(_rotate);
    len += sizeof(_xradius);
    len += sizeof(_yradius);
    len += sizeof(_startAngle);
    len += sizeof(_endAngle);

    return len;
}

char* SymArc::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStroke::serialize(p);
    p = _center.serialize(p);
    SERIALIZE_TO_BUF(p, _rotate);
    SERIALIZE_TO_BUF(p, _xradius);
    SERIALIZE_TO_BUF(p, _yradius);
    SERIALIZE_TO_BUF(p, _startAngle);
    SERIALIZE_TO_BUF(p, _endAngle);
    // memcpy(p, (void*)&_xradius, sizeof(_xradius));
    // p += sizeof(_xradius);
    // memcpy(p, (void*)&_yradius, sizeof(_yradius));
    // p += sizeof(_yradius);
    // memcpy(p, (void*)&_startAngle, sizeof(_startAngle));
    // p += sizeof(_startAngle);
    // memcpy(p, (void*)&_endAngle, sizeof(_endAngle));
    // p += sizeof(_endAngle);
    return p;
}

char* SymArc::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStroke::deserialize(p);
    p = _center.deserialize(p);
    DESERIALIZE_FROM_BUF(p, _rotate);
    DESERIALIZE_FROM_BUF(p, _xradius);
    DESERIALIZE_FROM_BUF(p, _yradius);
    DESERIALIZE_FROM_BUF(p, _startAngle);
    DESERIALIZE_FROM_BUF(p, _endAngle);

    // memcpy((void*)&_xradius, p, sizeof(_xradius));
    // p += sizeof(_xradius);
    // memcpy((void*)&_yradius, p, sizeof(_yradius));
    // p += sizeof(_yradius);
    // memcpy((void*)&_startAngle, p, sizeof(_startAngle));
    // p += sizeof(_startAngle);
    // memcpy((void*)&_endAngle, p, sizeof(_endAngle));
    // p += sizeof(_endAngle);
    return p;
}

SymRect SymArc::getMBR() const {
    double x1 = (_center.x() - _xradius);
    double y1 = (_center.y() - _yradius);
    double x2 = (_center.x() + _xradius);
    double y2 = (_center.y() + _yradius);

    return SymRect(x1, y1, x2, y2);
}



void SymArc::draw(SymCanvas* canvas) {
    cairo_t* cairo = canvas->getCairoContext();

    cairo_save(cairo);
    cairo_translate(cairo, _center.x(), _center.y());
    cairo_rotate(cairo, _rotate / 180.0 * M_PI);
    cairo_scale(cairo, 1, _yradius / _xradius);

    cairo_arc(cairo, 0, 0, _xradius, _startAngle / 180.0 * M_PI, _endAngle / 180.0 * M_PI);
    cairo_restore(cairo);

    canvas->setStroke(_stroke);
    cairo_stroke(cairo);
}
