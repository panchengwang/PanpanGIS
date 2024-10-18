#include "SymEllipse.h"
#include "jsonutils.h"
#include "SymCanvas.h"
#include "serializeutils.h"

SymEllipse::SymEllipse()
{
    _type = SYM_SHAPE_ELLIPSE;
}


SymEllipse::~SymEllipse()
{

}

bool SymEllipse::fromJsonObject(json_object* obj)
{
    _type = SYM_SHAPE_ELLIPSE;
    if (!SymShapeWithStrokeAndFill::fromJsonObject(obj)) {
        return false;
    }

    json_object* centerobj = NULL;
    JSON_GET_OBJ(obj, "center", centerobj, _errorMessage);
    if (!_center.fromJsonObject(centerobj)) {
        _errorMessage = _center.getErrorMessage();
        return false;
    }
    JSON_GET_DOUBLE(obj, "rotate", _rotate, _errorMessage);
    JSON_GET_DOUBLE(obj, "xradius", _xradius, _errorMessage);
    JSON_GET_DOUBLE(obj, "yradius", _yradius, _errorMessage);
    return true;
}

json_object* SymEllipse::toJsonObject()
{
    json_object* obj = SymShapeWithStrokeAndFill::toJsonObject();
    JSON_ADD_STRING(obj, "type", "ELLIPSE");
    json_object_object_add(obj, "center", _center.toJsonObject());
    JSON_ADD_DOUBLE(obj, "rotate", _rotate);
    JSON_ADD_DOUBLE(obj, "xradius", _xradius);
    JSON_ADD_DOUBLE(obj, "yradius", _yradius);
    return obj;
}


size_t SymEllipse::memorySize() {
    size_t len = SymShapeWithStrokeAndFill::memorySize();
    len += _center.memorySize();
    len += sizeof(_rotate);
    len += sizeof(_xradius);
    len += sizeof(_yradius);
    return len;
}


char* SymEllipse::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStrokeAndFill::serialize(p);
    p = _center.serialize(p);
    SERIALIZE_TO_BUF(p, _rotate);
    SERIALIZE_TO_BUF(p, _xradius);
    SERIALIZE_TO_BUF(p, _yradius);

    // memcpy(p, (void*)&_xradius, sizeof(_xradius));
    // p += sizeof(_xradius);
    // memcpy(p, (void*)&_yradius, sizeof(_yradius));
    // p += sizeof(_yradius);
    return p;
}


char* SymEllipse::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStrokeAndFill::deserialize(p);
    p = _center.deserialize(p);
    DESERIALIZE_FROM_BUF(p, _rotate);
    DESERIALIZE_FROM_BUF(p, _xradius);
    DESERIALIZE_FROM_BUF(p, _yradius);
    // memcpy((void*)&_xradius, p, sizeof(_xradius));
    // p += sizeof(_xradius);
    // memcpy((void*)&_yradius, p, sizeof(_yradius));
    // p += sizeof(_yradius);
    return p;
}

SymRect SymEllipse::getMBR() const {
    double x1 = (_center.x() - _xradius);
    double y1 = (_center.y() - _yradius);
    double x2 = (_center.x() + _xradius);
    double y2 = (_center.y() + _yradius);

    return SymRect(x1, y1, x2, y2);
}


void SymEllipse::draw(SymCanvas* canvas) {
    cairo_t* cairo = canvas->getCairoContext();

    cairo_save(cairo);
    cairo_translate(cairo, _center.x(), _center.y());
    cairo_rotate(cairo, _rotate);
    cairo_scale(cairo, 1, _yradius / _xradius);
    cairo_arc(cairo, 0, 0, _xradius, 0, M_PI * 2.0);
    cairo_restore(cairo);

    canvas->setFill(_fill);
    cairo_fill_preserve(cairo);
    canvas->setStroke(_stroke);
    cairo_stroke(cairo);

}
