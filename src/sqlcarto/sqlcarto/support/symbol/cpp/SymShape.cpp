#include "SymShape.h"
#include <string.h>
#include <iostream>
#include <cairo.h>
#include "SymCanvas.h"
// bool SymShape::from_json_object(json_object* obj){
//     json_object *strokeobj = json_object_object_get(obj,"stroke");
//     if(!strokeobj){
//         _errorMessage = "Can not find stroke information!";
//         return false;
//     }
//     if(!_stroke.from_json_object(strokeobj)){
//         _errorMessage = _stroke.getErrorMessage();
//         return false;
//     }
//     return true;
// }


// json_object* SymShape::to_json_object(){
//     json_object* obj = json_object_new_object();

//     json_object_object_add(obj,"stroke",_stroke.to_json_object());

//     return obj;
// }


const std::string& SymShape::getErrorMessage() const {
    return _errorMessage;
}


size_t SymShape::memorySize() {
    return sizeof(_type);
}


char* SymShape::serialize(const char* buf) {
    char* p = (char*)buf;
    memcpy(p, (void*)&_type, sizeof(_type));
    p += sizeof(_type);
    return p;
}



char* SymShape::deserialize(const char* buf) {
    char* p = (char*)buf;
    memcpy((void*)&_type, p, sizeof(_type));
    p += sizeof(_type);
    return p;
}


// SymRect SymShape::getMBR() {
//     return SymRect();
// }

double SymShape::getStrokeWidth()  const {
    return 0.0f;
}



void SymShape::draw(SymCanvas* canvas) {
    cairo_save(canvas->_cairo);
    std::cerr << " shape draw " << std::endl;
    cairo_restore(canvas->_cairo);
}


uint8_t SymShape::getType() const {
    return _type;
}