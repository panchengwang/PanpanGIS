#include "SymStar.h"
#include "serializeutils.h"
#include "jsonutils.h"
#include "SymCanvas.h"

SymStar::SymStar() {
    _type = SYM_SHAPE_STAR;
}


SymStar::~SymStar() {

}


bool SymStar::fromJsonObject(json_object* obj) {
    if (!SymRegularPolygon::fromJsonObject(obj)) {
        return false;
    }
    _type = SYM_SHAPE_STAR;

    JSON_GET_DOUBLE(obj, "radius2", _radius2, _errorMessage);

    return true;
}


json_object* SymStar::toJsonObject() {
    json_object* obj = SymRegularPolygon::toJsonObject();
    JSON_ADD_STRING(obj, "type", "STAR");
    JSON_ADD_DOUBLE(obj, "radius2", _radius2);
    return obj;
}


size_t SymStar::memorySize() {
    size_t len = SymRegularPolygon::memorySize();
    len += sizeof(_radius2);
    return len;
}


char* SymStar::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymRegularPolygon::serialize(p);
    SERIALIZE_TO_BUF(p, _radius2);
    return p;
}


char* SymStar::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = SymRegularPolygon::deserialize(p);
    DESERIALIZE_FROM_BUF(p, _radius2);
    return p;
}





void SymStar::draw(SymCanvas* canvas) {
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
    double step = M_PI / _numEdges;

    cairo_new_path(cairo);
    cairo_move_to(cairo, _radius, 0);
    for (size_t i = 0; i < _numEdges; i++) {
        cairo_line_to(cairo, _radius * cos(2 * i * step), _radius * sin(2 * i * step));
        cairo_line_to(cairo, _radius2 * cos(2 * i * step + step), _radius2 * sin(2 * i * step + step));
    }
    cairo_close_path(cairo);

    cairo_restore(cairo);

    canvas->setStroke(_stroke);
    cairo_stroke_preserve(cairo);
    canvas->setFill(_fill);
    cairo_fill(cairo);
}

