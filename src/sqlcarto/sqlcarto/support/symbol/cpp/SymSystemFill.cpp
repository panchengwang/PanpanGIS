#include "SymSystemFill.h"
#include "jsonutils.h"
#include "SymFillSolid.h"
#include "SymCanvas.h"

SymSystemFill::SymSystemFill() {
    _type = SYM_SHAPE_SYSTEM_FILL;
    _fill = new SymFillSolid();
}


SymSystemFill::~SymSystemFill() {
    if (_fill) {
        delete _fill;
    }
}


bool SymSystemFill::fromJsonObject(json_object* obj) {
    _type = SYM_SHAPE_SYSTEM_FILL;
    if (_fill) {
        delete _fill;
    }

    json_object* fillobj = NULL;
    JSON_GET_OBJ(obj, "fill", fillobj, _errorMessage);
    std::string typestr;
    JSON_GET_STRING(fillobj, "type", typestr, _errorMessage);


    if (typestr == "SOLID") {
        _fill = new SymFillSolid();
    }

    if (!_fill) {
        _errorMessage = "Invalid fill type: " + typestr;
        return false;
    }

    if (!_fill->fromJsonObject(fillobj)) {
        _errorMessage = _fill->getErrorMessage();
        return false;
    }

    return true;
}


json_object* SymSystemFill::toJsonObject() {
    json_object* obj = json_object_new_object();
    JSON_ADD_STRING(obj, "type", "SYSTEMFILL");
    json_object_object_add(obj, "fill", _fill->toJsonObject());
    return obj;
}


size_t SymSystemFill::memorySize() {
    size_t len = SymShape::memorySize();
    if (_fill) {
        len += _fill->memorySize();
    }
    return len;
}


char* SymSystemFill::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShape::serialize(p);
    if (_fill) {
        p = _fill->serialize(p);
    }
    return p;
}

char* SymSystemFill::deserialize(const char* buf) {
    char* p = (char*)buf;

    p = SymShape::deserialize(p);
    uint8_t filltype;
    memcpy((void*)&filltype, p, sizeof(filltype));


    SymFill* myfill = NULL;
    if (filltype == FILL_SOLID) {
        myfill = new SymFillSolid();
    }

    if (!myfill) {
        return p;
    }

    p = myfill->deserialize(p);
    if (_fill) {
        delete _fill;
    }
    _fill = myfill;

    return p;
}


SymRect SymSystemFill::getMBR() const {
    return SymRect(-1, -1, 1, 1);
}


void SymSystemFill::draw(SymCanvas* canvas) {
    cairo_t* cairo = canvas->getCairoContext();

    // cairo_save(cairo);
    // cairo_translate(cairo, _center.x(), _center.y());
    // cairo_rotate(cairo, _rotate);
    // cairo_scale(cairo, 1, _yradius / _xradius);
    // cairo_arc(cairo, 0, 0, _xradius, 0, M_PI * 2.0);
    // cairo_restore(cairo);

    canvas->setFill(_fill);
    cairo_paint(cairo);
    // cairo_fill_preserve(cairo);
    // canvas->setStroke(_stroke);
    // cairo_stroke(cairo);
}
