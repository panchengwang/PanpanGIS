#include "SymShape.h"


bool SymShape::from_json_object(json_object* obj){
    json_object *strokeobj = json_object_object_get(obj,"stroke");
    if(!strokeobj){
        _errorMessage = "Can not find stroke information!";
        return false;
    }
    if(!_stroke.from_json_object(strokeobj)){
        _errorMessage = _stroke.getErrorMessage();
        return false;
    }
    return true;
}


json_object* SymShape::to_json_object(){
    json_object* obj = json_object_new_object();

    json_object_object_add(obj,"stroke",_stroke.to_json_object());
    
    return obj;
}


const std::string& SymShape::getErrorMessage() const{
    return _errorMessage; 
}

