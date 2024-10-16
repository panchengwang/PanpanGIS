#ifndef __SYM_RECT_H
#define __SYM_RECT_H


#include <dllexport.h>
#include <string>

class DLL_EXPORT SymRect
{
public:
    SymRect();
    SymRect(double minx, double miny, double maxx, double maxy);
    SymRect(const SymRect& rect);

    void extend(const SymRect& rect);

    std::string toString() const;

    SymRect& scale(double xscale, double yscale);
    SymRect ensureSymmetry() const;
    double getWidth() const;
    double getHeight() const;
protected:
    double _minx, _miny, _maxx, _maxy;
};

#endif
