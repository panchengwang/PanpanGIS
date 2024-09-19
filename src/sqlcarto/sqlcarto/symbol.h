#ifndef __SYMBOL_H
#define __SYMBOL_H

#define GSYMBOL_SHAPE_POINT             1
#define GSYMBOL_SHAPE_LINESTRING        2
#define GSYMBOL_SHAPE_POLYGON           3
#define GSYMBOL_SHAPE_CIRCLE            4
#define GSYMBOL_SHAPE_PIE               5               
#define GSYMBOL_SHAPE_ARC               6
#define GSYMBOL_SHAPE_CHORD             7
#define GSYMBOL_SHAPE_ELLIPSE           8
#define GSYMBOL_SHAPE_RECTANGLE         9
#define GSYMBOL_SHAPE_SYSTEM_LINE       10

typedef struct{
    unsigned char red,green,blue,alpha;
}GColor;


typedef struct{
    int type;
}GSymShape;

typedef struct{
    double x,y;
}GSymPoint;

typedef struct{
    int type;
    
}GSymLineString;

typedef struct{
    int nshapes;
}GSymbol;

#endif
