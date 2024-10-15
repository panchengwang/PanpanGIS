#include "SymCanvas.h"


SymCanvas::SymCanvas(double width, double height, const char* format) {
    _dotsPerMM = 72.0 / 25.4;
    _width = width;
    _height = height;
    _format = format;
}