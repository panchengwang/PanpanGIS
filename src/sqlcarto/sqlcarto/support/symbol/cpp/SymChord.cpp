#include "SymChord.h"
#include "jsonutils.h"
#include "SymArc.h"

SymChord::SymChord()
{
    _type = SYM_SHAPE_CHORD;

}

SymChord::~SymChord()
{
}

bool SymChord::fromJsonObject(json_object* obj)
{
    _type = SYM_SHAPE_CHORD;
    if (!SymPie::fromJsonObject(obj)) {
        return false;
    }
    _type = SYM_SHAPE_CHORD;
    return true;
}

json_object* SymChord::toJsonObject()
{
    json_object* obj = SymPie::toJsonObject();
    JSON_ADD_STRING(obj, "type", "CHORD");
    return obj;
}


void SymChord::draw(SymCanvas* canvas) {
    cairo_t* cairo = canvas->getCairoContext();

    cairo_save(cairo);
    cairo_translate(cairo, _center.x(), _center.y());
    cairo_scale(cairo, 1, _yradius / _xradius);
    cairo_new_path(cairo);
    cairo_arc(cairo, 0, 0, _xradius, _startAngle / 180.0 * M_PI, _endAngle / 180.0 * M_PI);
    cairo_close_path(cairo);
    cairo_restore(cairo);

    canvas->setFill(_fill);
    cairo_fill_preserve(cairo);
    canvas->setStroke(_stroke);
    cairo_stroke(cairo);
}

