#ifndef __SYMBOL_H
#define __SYMBOL_H

#include <types.h>

#define SYMBOL_SHAPE_POINT             1
#define SYMBOL_SHAPE_SYSTEM_LINE       2
#define SYMBOL_SHAPE_LINESTRING        3
#define SYMBOL_SHAPE_POLYGON           4
#define SYMBOL_SHAPE_CIRCLE            5
#define SYMBOL_SHAPE_PIE               6              
#define SYMBOL_SHAPE_ARC               7
#define SYMBOL_SHAPE_CHORD             8
#define SYMBOL_SHAPE_ELLIPSE           9
#define SYMBOL_SHAPE_RECTANGLE         10


typedef struct{
    float x,y;
}SymPoint;

typedef struct{
    uint8_t alpha,red,green,blue;
}SymColor;

typedef struct{
    SymColor color;
    uint8_t cap, join;
    float miter;
    float width;
    uint16_t nDashes;
    float* dashes;
}SymStrokeStyle;

typedef struct{
    SymColor color;
}SymFillStyle;


typedef struct{
    uint8_t  type;
    SymStrokeStyle strokeStyle;
}SymShape;

typedef struct{
    uint8_t  type;
    SymStrokeStyle strokeStyle;
    uint16_t nDashes;
    float* dashes;
}SymSystemLine;

typedef struct{
    uint8_t  type;
    SymStrokeStyle strokeStyle;
    uint32_t nPoints;
    SymPoint *points;
}SymLineString;

typedef struct{
    uint8_t  type;
    SymStrokeStyle strokeStyle;
    uint32_t nPoints;
    SymPoint *points;
    uint8_t  isFilled;
    SymFillStyle fillStyle;
}SymPolygon;

typedef struct {
    uint32_t nshapes;
    SymShape* shapes;
}Symbol;




#endif
