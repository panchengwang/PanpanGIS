#include "sk_capi.h"

#include <stdio.h>
#include <skia/include/core/SkImageInfo.h>
#include <skia/include/core/SkSurface.h>
#include <skia/include/core/SkSize.h>
#include <skia/include/core/SkColorSpace.h>
#include <skia/include/core/SkCanvas.h>
#include <skia/include/core/SkImage.h>
#include <skia/include/core/SkData.h>
#include <skia/include/core/SkEncodedImageFormat.h>
#include <skia/include/core/SkPath.h>
#include <skia/include/core/SkStream.h>
#include <skia/include/encode/SkPngEncoder.h>
#include <skia/include/encode/SkJpegEncoder.h>
#include <skia/include/encode/SkWebpEncoder.h>
#include <string.h>

SK_SURFACE_H sk_surface_create(int width, int height){
    SkImageInfo info = SkImageInfo::MakeN32Premul(width,height);
    return SkSurface::MakeRaster(info).release();
}


void sk_surface_destroy(SK_SURFACE_H hSurface){
    delete (SkSurface*)hSurface;
}


void sk_surface_save_to_file(SK_SURFACE_H hSurface, 
    const char* filename, 
    const char* type){

    SkSurface* surface = (SkSurface*)hSurface;
    sk_sp<SkImage> img = surface->makeImageSnapshot();
    if(!img){
        return;
    }
    
    sk_sp<SkData> imgdata;
    if(strcasecmp(type,"png") == 0){
        imgdata = img->encodeToData(SkEncodedImageFormat::kPNG, 100);
    }else if(strcasecmp(type,"jpeg") ==0 || strcasecmp(type,"jpg") == 0){
        imgdata = img->encodeToData(SkEncodedImageFormat::kJPEG,100);
    }else if(strcasecmp(type,"webp") ==0){
        imgdata = img->encodeToData(SkEncodedImageFormat::kWEBP,100);
    }

    if (!imgdata)
    {
        return;
    }
    SkFILEWStream out(filename);
    out.write(imgdata->data(), imgdata->size());
}


const char* sk_surface_get_image_data(SK_SURFACE_H hSurface, const char* type, uint32_t *len){
    SkSurface* surface = (SkSurface*)hSurface;
    sk_sp<SkImage> img = surface->makeImageSnapshot();
    if(!img){
        *len = 0;
        return NULL;
    }
    
    sk_sp<SkData> imgdata;
    if(strcasecmp(type,"png") == 0){
        imgdata = img->encodeToData(SkEncodedImageFormat::kPNG, 100);
    }else if(strcasecmp(type,"jpeg") ==0 || strcasecmp(type,"jpg") == 0){
        imgdata = img->encodeToData(SkEncodedImageFormat::kJPEG,100);
    }else if(strcasecmp(type,"webp") ==0){
        imgdata = img->encodeToData(SkEncodedImageFormat::kWEBP,100);
    }

    if (!imgdata)
    {
        *len = 0;
        return NULL;
    }

    *len = imgdata->size();
    return (const char*)imgdata->data();
}


SK_CANVAS_H sk_canvas_create(SK_SURFACE_H hSurface){
    SkSurface* surface = (SkSurface*) hSurface;
    SkCanvas* canvas = surface->getCanvas();
    canvas->clear(SK_AlphaTRANSPARENT);

    return (SK_CANVAS_H)canvas;
}


void sk_canvas_destroy(SK_CANVAS_H hCanvas){

}




SK_PAINT_H sk_paint_create(){
    return (SK_PAINT_H)(new SkPaint());
}


void sk_paint_destroy(SK_PAINT_H hPaint){
    delete (SkPaint*)hPaint;
}


void sk_paint_set_rgba(SK_PAINT_H hPaint, 
    uint8_t red, uint8_t green, uint8_t blue, uint8_t alpha)
{
    SkPaint* paint = (SkPaint*)hPaint;
    paint->setColor(SkColorSetARGB(alpha,red,green,blue));
}


void sk_paint_set_antialias(SK_PAINT_H hPaint, uint8_t isAntiAlias){
    SkPaint* paint = (SkPaint*)hPaint;
    paint->setAntiAlias(isAntiAlias);
}


void sk_paint_set_style(SK_PAINT_H hPaint, uint8_t style){
    SkPaint* paint = (SkPaint*)hPaint;
    paint->setStyle((SkPaint::Style)style);
}


void sk_paint_set_stroke_cap(SK_PAINT_H hPaint, uint8_t cap)
{
    SkPaint* paint = (SkPaint*)hPaint;
    paint->setStrokeCap((SkPaint::Cap)cap);
}


void sk_paint_set_stroke_join(SK_PAINT_H hPaint, uint8_t join)
{
    SkPaint* paint = (SkPaint*)hPaint;
    paint->setStrokeJoin((SkPaint::Join)join);
}


void sk_paint_set_stroke_miter(SK_PAINT_H hPaint, float miter)
{
    SkPaint* paint = (SkPaint*)hPaint;
    paint->setStrokeMiter(miter);
}


void sk_paint_set_stroke_width(SK_PAINT_H hPaint, float width)
{
    SkPaint* paint = (SkPaint*)hPaint;
    paint->setStrokeWidth(width);
}




void sk_canvas_draw_arc(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint , float x,float y,float width, float height, float startAngle, float  sweepAngle, bool useCenter )
{
    SkCanvas* canvas = (SkCanvas*)hCanvas;
    SkPaint* paint = (SkPaint*)hPaint;

    canvas->drawArc(SkRect::MakeXYWH(x,y,width,height), startAngle, sweepAngle, useCenter, *paint);

}


void sk_canvas_draw_point(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint , float x, float y )
{
    SkCanvas* canvas = (SkCanvas*)hCanvas;
    SkPaint* paint = (SkPaint*)hPaint;
    
    canvas->drawPoint(SkPoint::Make(x,y), *paint);
}


void sk_canvas_draw_rect(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint , float x, float y, float width, float height){
    SkCanvas* canvas = (SkCanvas*)hCanvas;
    SkPaint* paint = (SkPaint*)hPaint;

    canvas->drawRect(SkRect::MakeXYWH(x,y,width,height),*paint);
}



void sk_canvas_draw_circle(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint,  float cx, float cy,float radius ){
    SkCanvas* canvas = (SkCanvas*)hCanvas;
    SkPaint* paint = (SkPaint*)hPaint;
    canvas->drawCircle(cx,cy,radius,*paint);
}


void sk_canvas_draw_color(SK_CANVAS_H hCanvas, uint8_t red, uint8_t green, uint8_t blue, uint8_t alpha){
    SkCanvas* canvas = (SkCanvas*)hCanvas;

    canvas->drawColor(SkColorSetARGB(alpha,red,green,blue));
}


void sk_canvas_draw_line(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint, float x0, float y0, float x1, float y1 ){
    SkCanvas* canvas = (SkCanvas*)hCanvas;
    SkPaint* paint = (SkPaint*)hPaint;
    canvas->drawLine(x0,y0,x1,y1,*paint);
}

void sk_canvas_draw_path(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint, SK_PATH_H hPath){
    SkCanvas* canvas = (SkCanvas*)hCanvas;
    SkPaint* paint = (SkPaint*)hPaint;
    SkPath* path = (SkPath*)hPath;
    canvas->drawPath(*path, *paint);    
}


SK_PATH_H sk_path_create()
{
    return (SK_PATH_H)(new SkPath());
}


void sk_path_destroy(SK_PATH_H hPath)
{
    delete (SkPath*)hPath;
}

void sk_path_set_fill_type(SK_PATH_H hPath, int filltype){
    SkPath* path = (SkPath*)hPath;
    path->setFillType((SkPathFillType)filltype);
}


void sk_path_add_poly(SK_PATH_H hPath, float *x, float *y, uint32_t npts, uint8_t close){

    
    SkPath* path = (SkPath*)hPath;

    SkPoint *points = new SkPoint[npts];
    for(uint32_t i=0; i<npts; i++){
        points[i].set(x[i],y[i]);
    }

    path->addPoly(points,npts,close);

    delete [] points;
}

