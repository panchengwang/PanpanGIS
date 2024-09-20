#ifndef __SK_CAPI_H
#define __SK_CAPI_H

#include <stdint.h>
#include <stddef.h>
#ifndef __cplusplus
#include <stdbool.h>
#endif // __cplusplus

// #if !defined(SK_C_API)
//     #if defined(SKIA_C_DLL)
//         #if defined(_MSC_VER)
//             #if SKIA_IMPLEMENTATION
//                 #define SK_C_API __declspec(dllexport)
//             #else
//                 #define SK_C_API __declspec(dllimport)
//             #endif
//         #else
//             #define SK_C_API __attribute__((visibility("default")))
//         #endif
//     #else
//         #define SK_C_API
//     #endif
// #endif


#if defined(__MINGW32__) || defined(__MINGW64__)
    #if defined (SK_CAPI_DLL_EXPORT)
        #define SK_C_API __declspec(dllexport)
    #else 
        #define SK_C_API __declspec(dllimport)
    #endif
#else
    #define SK_C_API
#endif

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

// #define SkColorType_Unknown                         0
// #define SkColorType_Alpha_8                         1
// #define SkColorType_RGB_565                         2
// #define SkColorType_ARGB_4444                       3
// #define SkColorType_RGBA_8888                       4
// #define SkColorType_RGB_888x                        5
// #define SkColorType_BGRA_8888                       6
// #define SkColorType_RGBA_1010102                    7
// #define SkColorType_BGRA_1010102                    8
// #define SkColorType_RGB_101010x                     9
// #define SkColorType_BGR_101010x                     10
// #define SkColorType_Gray_8                          11
// #define SkColorType_RGBA_F16Norm                    12
// #define SkColorType_RGBA_F16                        13
// #define SkColorType_RGBA_F32                        14
// #define SkColorType_R8G8_unorm                      15   
// #define SkColorType_A16_float                       16 
// #define SkColorType_R16G16_float                    17
// #define SkColorType_A16_unorm                       18
// #define SkColorType_R16G16_unorm                    19
// #define SkColorType_R16G16B16A16_unorm              20
// #define SkColorType_SRGBA_8888                      21
// #define SkColorType_R8_unorm                        22
// #define SkColorType_LastEnum                        SkColorType_R8_unorm 



#define SkPathFillType_Winding 	0
#define SkPathFillType_EvenOdd 	1
#define SkPathFillType_InverseWinding 	2
#define SkPathFillType_InverseEvenOdd 	3

#define SkPaintStyle_Fill 	        0
#define SkPaintStyle_Stroke 	    1
#define SkPaintStyle_StrokeAndFill 	2

#define SkPaintCap_Butt 	0
#define SkPaintCap_Round 	1
#define SkPaintCap_Square 	2
#define SkPaintCap_Last 	3
#define SkPaintCap_Default 	4

#define SkPaintJoin_Miter   0
#define SkPaintJoin_Round   1
#define SkPaintJoin_Bevel   2
#define SkPaintJoin_Last    3
#define SkPaintJoin_Default 4

typedef     void*       SK_SURFACE_H;
typedef     void*       SK_CANVAS_H; 
typedef     void*       SK_PAINT_H;
typedef     void*       SK_PATH_H;

SK_C_API SK_SURFACE_H sk_surface_create(int32_t width, int32_t height);
SK_C_API void sk_surface_destroy(SK_SURFACE_H hSurface);
SK_C_API void sk_surface_save_to_file(SK_SURFACE_H hSurface, const char* filename, const char* type);
SK_C_API const char* sk_surface_get_image_data(SK_SURFACE_H hSurface, const char* type, uint32_t *len);

SK_C_API SK_CANVAS_H sk_canvas_create(SK_SURFACE_H hSurface);
SK_C_API void sk_canvas_destroy(SK_CANVAS_H hCanvas);
SK_C_API void sk_canvas_draw_arc(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint , float x, float y, float width, float height, float startAngle, float  sweepAngle, bool useCenter );
SK_C_API void sk_canvas_draw_circle(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint , float cx, float cy,float radius );
SK_C_API void sk_canvas_draw_color(SK_CANVAS_H hCanvas, uint8_t red, uint8_t green, uint8_t blue, uint8_t alpha );
SK_C_API void sk_canvas_draw_line(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint, float x0, float y0, float x1, float y1 );
SK_C_API void sk_canvas_draw_path(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint, SK_PATH_H hPath);
SK_C_API void sk_canvas_draw_point(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint , float x, float y );
SK_C_API void sk_canvas_draw_rect(SK_CANVAS_H hCanvas, SK_PAINT_H hPaint , float x, float y, float width, float height );

SK_C_API SK_PAINT_H sk_paint_create();
SK_C_API void sk_paint_destroy(SK_PAINT_H hPaint);
SK_C_API void sk_paint_set_rgba(SK_PAINT_H hPaint, uint8_t red, uint8_t green, uint8_t blue, uint8_t alpha);
SK_C_API void sk_paint_set_antialias(SK_PAINT_H hPaint, uint8_t isAntiAlias);
SK_C_API void sk_paint_set_style(SK_PAINT_H hPaint, uint8_t style);
SK_C_API void sk_paint_set_stroke_cap(SK_PAINT_H hPaint, uint8_t cap);
SK_C_API void sk_paint_set_stroke_join(SK_PAINT_H hPaint, uint8_t join);
SK_C_API void sk_paint_set_stroke_miter(SK_PAINT_H hPaint, float miter);
SK_C_API void sk_paint_set_stroke_width(SK_PAINT_H hPaint, float width);

SK_C_API SK_PATH_H sk_path_create();
SK_C_API void sk_path_destroy(SK_PATH_H hPath);
SK_C_API void sk_path_set_fill_type(SK_PATH_H hPath, int filltype);
SK_C_API void sk_path_add_poly(SK_PATH_H hPath, float *x, float *y, uint32_t npts, uint8_t close);


#ifdef __cplusplus
}
#endif // __cplusplus

#endif // SKIA_DEFINED