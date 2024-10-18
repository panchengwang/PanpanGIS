#ifndef __SYM_RECT_H
#define __SYM_RECT_H


#include <dllexport.h>
#include <string>

class SymPoint;
class DLL_EXPORT SymRect
{
public:
    SymRect();
    SymRect(double minx, double miny, double maxx, double maxy);
    SymRect(const SymRect& rect);

    void extend(const SymRect& rect);
    void extend(double len);// 往四周扩展len长度
    void offset(double x, double y);
    void offset(const SymPoint& pt);
    std::string toString() const;

    SymRect& scale(double xscale, double yscale);
    const SymRect& ensureSymmetry();
    double getWidth() const;
    double getHeight() const;
protected:
    double _minx, _miny, _maxx, _maxy;
};

#endif
