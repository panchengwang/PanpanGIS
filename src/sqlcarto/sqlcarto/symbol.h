#ifndef __SYMBOL_H
#define __SYMBOL_H

#include <types.h>

#define SYMBOL_SHAPE_POINT             1
#define SYMBOL_SHAPE_LINESTRING        2
#define SYMBOL_SHAPE_POLYGON           3
#define SYMBOL_SHAPE_CIRCLE            4
#define SYMBOL_SHAPE_PIE               5               
#define SYMBOL_SHAPE_ARC               6
#define SYMBOL_SHAPE_CHORD             7
#define SYMBOL_SHAPE_ELLIPSE           8
#define SYMBOL_SHAPE_RECTANGLE         9
#define SYMBOL_SHAPE_SYSTEM_LINE       10


typedef struct{
    uint8_t antiAlias;              // 1 antiAlias, 0 not antiAlias
    uint8_t red,green,blue,alpha;
    uint8_t style;                  // fill 0, stroke 1, strokeandfill 2
    uint8_t strokeCap;              // Butt  0, Round 1, square 2, last 3, default 4
    uint8_t strokeJoin;             // Miter   0,Round   1, Bevel   2, Last    3 , Default 4
    float strokeMiter;              // 
    float strokeWidth; 

}MapPaint;



#endif
