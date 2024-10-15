#ifndef __SYMBOL_CANVAS_H
#define __SYMBOL_CANVAS_H

#include <dllexport.h>
#include <string>
#include <stdlib.h>
#include <stdio.h>

#include <cairo.h>

class DLL_EXPORT SymCanvas {
public:
    SymCanvas(double width, double height, const char* format);


protected:
    double _width, _height;         // 画布大小，使用毫米为单位
    double _dotsPerMM;              // 每一毫米多少个点，在绘制的图片是为显示而用时，应该根据显示器的dpi设置此值  
    // 如果为打印而用，建议输出为pdf再打印    72/25.4
    std::string _format;
    double _centerX, _centerY;
    cairo_surface_t* _surface;
    cairo_t* _cairo;
};



#endif