#include "SymRegularPolygon.h"
#include "jsonutils.h"
#include "SymCanvas.h"
#include <math.h>
#include "serializeutils.h"

SymRegularPolygon::SymRegularPolygon()
{
    _type = SYM_SHAPE_REGULAR_POLYGON;
}


SymRegularPolygon::~SymRegularPolygon()
{

}

bool SymRegularPolygon::fromJsonObject(json_object* obj)
{
    _type = SYM_SHAPE_REGULAR_POLYGON;
    if (!SymShapeWithStrokeAndFill::fromJsonObject(obj))
    {
        return false;
    }

    // json_object* centerobj = NULL;
    // JSON_GET_OBJ(obj, "center", centerobj, _errorMessage);
    // if (!_center.fromJsonObject(centerobj)) {
    //     _errorMessage = _center.getErrorMessage();
    //     return false;
    // }
    JSON_GET_POINT(obj, "center", _center, _errorMessage);
    JSON_GET_DOUBLE(obj, "rotate", _rotate, _errorMessage);
    JSON_GET_DOUBLE(obj, "radius", _radius, _errorMessage);
    JSON_GET_INT(obj, "numedges", _numEdges, _errorMessage);
    return true;
}

json_object* SymRegularPolygon::toJsonObject()
{
    json_object* obj = SymShapeWithStrokeAndFill::toJsonObject();
    JSON_ADD_STRING(obj, "type", "CIRCLE");
    json_object_object_add(obj, "center", _center.toJsonObject());
    JSON_ADD_DOUBLE(obj, "rotate", _rotate);
    JSON_ADD_DOUBLE(obj, "radius", _radius);
    JSON_ADD_INT(obj, "numedges", _numEdges);
    return obj;
}


size_t SymRegularPolygon::memorySize() {
    size_t len = SymShapeWithStrokeAndFill::memorySize();
    len += _center.memorySize();
    len += sizeof(_rotate);
    len += sizeof(_radius);
    len += sizeof(_numEdges);
    return len;
}


char* SymRegularPolygon::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStrokeAndFill::serialize(p);
    p = _center.serialize(p);

    SERIALIZE_TO_BUF(p, _rotate);
    SERIALIZE_TO_BUF(p, _radius);
    SERIALIZE_TO_BUF(p, _numEdges);

    // memcpy(p, (void*)&_radius, sizeof(_radius));
    // p += sizeof(_radius);
    // memcpy(p, (void*)&_numEdges, sizeof(_numEdges));
    // p += sizeof(_numEdges);
    return p;
}


char* SymRegularPolygon::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStrokeAndFill::deserialize(p);
    p = _center.deserialize(p);
    DESERIALIZE_FROM_BUF(p, _rotate);
    DESERIALIZE_FROM_BUF(p, _radius);
    DESERIALIZE_FROM_BUF(p, _numEdges);
    // memcpy((void*)&_radius, p, sizeof(_radius));
    // p += sizeof(_radius);
    // memcpy((void*)&_numEdges, p, sizeof(_numEdges));
    // p += sizeof(_numEdges);
    return p;
}


SymRect SymRegularPolygon::getMBR() const {
    double x1 = (_center.x() - _radius);
    double y1 = (_center.y() - _radius);
    double x2 = (_center.x() + _radius);
    double y2 = (_center.y() + _radius);

    return SymRect(x1, y1, x2, y2);
}


void SymRegularPolygon::draw(SymCanvas* canvas) {
    cairo_t* cairo = canvas->getCairoContext();
    cairo_save(cairo);
    cairo_translate(cairo, _center.x(), _center.y());
    cairo_rotate(cairo, _rotate / 180.0 * M_PI);
    double rotateangle = 0.0;
    if (_numEdges % 2 == 1) {
        rotateangle = M_PI_2;
    }
    else if (_numEdges % 4 == 0) {
        rotateangle = M_PI / _numEdges;
    }
    cairo_rotate(cairo, rotateangle);
    double step = 2 * M_PI / _numEdges;

    cairo_new_path(cairo);
    cairo_move_to(cairo, _radius, 0);
    for (size_t i = 0; i < _numEdges; i++) {
        cairo_line_to(cairo, _radius * cos(i * step), _radius * sin(i * step));
    }
    cairo_close_path(cairo);

    cairo_restore(cairo);

    canvas->setStroke(_stroke);
    cairo_stroke_preserve(cairo);
    canvas->setFill(_fill);
    cairo_fill(cairo);
}
