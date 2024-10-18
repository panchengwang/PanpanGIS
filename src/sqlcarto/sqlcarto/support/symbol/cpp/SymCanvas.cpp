#include "SymCanvas.h"
#include <string.h>
#include <math.h>
#include <string>
#include "SymStroke.h"
#include <iostream>
#include "SymFillSolid.h"

SymCanvas::SymCanvas(double width, double height, const char* format) {
    _dotsPerMM = 72.0 / 25.4;
    _width = width;
    _height = height;
    _format = format;
    _surface = NULL;
    _cairo = NULL;
    _xscale = 1.0f;
    _yscale = 1.0f;
}

SymCanvas::~SymCanvas() {
    if (_cairo) {
        cairo_destroy(_cairo);
        _cairo = NULL;
    }

    if (_surface) {
        cairo_surface_finish(_surface);
        cairo_surface_destroy(_surface);
        _surface = NULL;
    }
}

void SymCanvas::setDotsPerMM(double dotsPerMM) {
    _dotsPerMM = dotsPerMM;
}

void SymCanvas::setScale(double xscale, double yscale) {
    _xscale = xscale;
    _yscale = yscale;
}

void SymCanvas::begin() {

    if (strcasecmp(_format.c_str(), "png") == 0 ||
        strcasecmp(_format.c_str(), "jpg") == 0 ||
        strcasecmp(_format.c_str(), "jpeg") == 0
        ) {
        // std::cerr << _format << " width: " << _width << " height: " << _height << std::endl;
        _surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32,
            ceil(_width * _dotsPerMM),
            ceil(_height * _dotsPerMM)
        );
    }
    if (_surface) {
        _cairo = cairo_create(_surface);
    }
}

void SymCanvas::end() {
    cairo_surface_flush(_surface);
}



typedef struct
{
    unsigned char* data;
    size_t len;
} DataBuffer;

static cairo_status_t
_write_image(void* closure,
    const unsigned char* data,
    unsigned int length) {

    DataBuffer* buffer = (DataBuffer*)closure;
    buffer->data = (unsigned char*)realloc(buffer->data, buffer->len + length);
    memcpy(buffer->data + buffer->len, data, length);
    buffer->len += length;
    return CAIRO_STATUS_SUCCESS;
}


unsigned char* SymCanvas::imageData(size_t& len) {
    DataBuffer buffer;
    buffer.data = NULL;
    buffer.len = 0;

    cairo_surface_write_to_png_stream(_surface, _write_image, &buffer);

    len = buffer.len;
    return buffer.data;
}

void SymCanvas::save(const char* filename) {
    cairo_surface_write_to_png(_surface, filename);
}

void SymCanvas::draw(const Symbol& sym) {
    cairo_save(_cairo);
    cairo_translate(_cairo,
        ceil(_width * _dotsPerMM) * 0.5,
        ceil(_height * _dotsPerMM) * 0.5
    );
    cairo_scale(_cairo, sym._xscale, sym._yscale);
    cairo_scale(_cairo, _dotsPerMM, -_dotsPerMM);

    for (size_t i = 0; i < sym._shapes.size(); i++) {
        sym._shapes[i]->draw(this);
    }

    cairo_restore(_cairo);
}


void SymCanvas::setStroke(SymStroke* stroke) {

    cairo_set_line_width(_cairo, stroke->getWidth() / _xscale);

    const SymColor& color = stroke->getColor();
    cairo_set_source_rgba(
        _cairo,
        color.getRed() / 255.0,
        color.getGreen() / 255.0,
        color.getBlue() / 255.0,
        color.getAlpha() / 255.0
    );


    const std::vector<double>& dashes = stroke->getDashes();

    if (dashes.size() > 1) {
        double* mydashes = new double[dashes.size()];
        for (size_t i = 0; i < dashes.size(); i++) {
            mydashes[i] = dashes[i] / _xscale;
        }
        cairo_set_dash(_cairo, mydashes, dashes.size(), stroke->_dashOffset / _xscale);
        delete mydashes;
    }


    uint8_t cap = stroke->getCap();
    if (cap == LINE_CAP_BUTT) {
        cairo_set_line_cap(_cairo, CAIRO_LINE_CAP_BUTT);
    }
    else if (cap == LINE_CAP_ROUND) {
        cairo_set_line_cap(_cairo, CAIRO_LINE_CAP_ROUND);
    }
    else if (cap == LINE_CAP_SQUARE) {
        cairo_set_line_cap(_cairo, CAIRO_LINE_CAP_SQUARE);
    }

    uint8_t join = stroke->getJoin();
    if (join == LINE_JOIN_BEVEL) {
        cairo_set_line_join(_cairo, CAIRO_LINE_JOIN_BEVEL);
    }
    else if (join == LINE_JOIN_MITER) {
        cairo_set_line_join(_cairo, CAIRO_LINE_JOIN_MITER);
    }
    else if (join == LINE_JOIN_ROUND) {
        cairo_set_line_join(_cairo, CAIRO_LINE_JOIN_ROUND);
    }

}

void SymCanvas::setFill(SymFill* fill) {
    if (fill->getType() == FILL_SOLID) {
        setFillSolid((SymFillSolid*)fill);
    }
}

void SymCanvas::setFillSolid(SymFillSolid* fill) {
    const SymColor& color = fill->getColor();
    cairo_set_source_rgba(
        _cairo,
        color.getRed() / 255.0,
        color.getGreen() / 255.0,
        color.getBlue() / 255.0,
        color.getAlpha() / 255.0
    );
}

cairo_t* SymCanvas::getCairoContext() {
    return _cairo;
}