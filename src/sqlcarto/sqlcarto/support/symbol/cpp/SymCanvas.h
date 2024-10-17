#ifndef __SYMBOL_CANVAS_H
#define __SYMBOL_CANVAS_H

#include <dllexport.h>
#include <string>
#include <stdlib.h>
#include <stdio.h>

#include <cairo.h>
#include "Symbol.h"
#include "SymShape.h"
#include "SymFill.h"
#include "SymStroke.h"
#include "SymFillSolid.h"

class DLL_EXPORT SymCanvas {
    friend class SymShape;
public:
    SymCanvas(double width, double height, const char* format);
    virtual ~SymCanvas();
    void setDotsPerMM(double dotsPerMM);
    void setScale(double xscale, double yscale);
    void begin();
    void end();
    unsigned char* imageData(size_t& len);
    void save(const char* filename);

    void draw(const Symbol& sym);
    void setStroke(SymStroke* stroke);
    void setFill(SymFill* fill);
    void setFillSolid(SymFillSolid* fill);

    cairo_t* getCairoContext();
protected:
    double _width, _height;         // 画布大小，使用毫米为单位
    double _xscale, _yscale;
    double _dotsPerMM;              // 每一毫米多少个点，在绘制的图片是为显示而用时，应该根据显示器的dpi设置此值  
    // 如果为打印而用，建议输出为pdf再打印    72/25.4
    std::string _format;
    // double _centerX, _centerY;
    cairo_surface_t* _surface;
    cairo_t* _cairo;
};



#endif