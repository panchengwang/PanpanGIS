#include "SymShape.h"
#include <string.h>
#include <iostream>
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


SymRect SymShape::getMBR(double xscale, double yscale) {
    return SymRect();
}

