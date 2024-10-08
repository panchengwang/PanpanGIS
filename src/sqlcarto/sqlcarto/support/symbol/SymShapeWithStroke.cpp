#include "SymShapeWithStroke.h"

#include "jsonutils.h"

SymShapeWithStroke::SymShapeWithStroke(){
    _stroke = new SymStroke();
}

SymShapeWithStroke::~SymShapeWithStroke(){
    if(_stroke){
        delete _stroke;
    }
}



bool SymShapeWithStroke::from_json_object(json_object* obj){
    json_object *strokeobj = json_object_object_get(obj,"stroke");
    if(!strokeobj){
        _errorMessage = "Can not find stroke information!";
        return false;
    }
    if(_stroke){
        delete _stroke;
    }
    _stroke = new SymStroke();
    if(!_stroke->from_json_object(strokeobj)){
        _errorMessage = _stroke->getErrorMessage();
        return false;
    }
    return true;
}


json_object* SymShapeWithStroke::to_json_object(){
    json_object* obj = json_object_new_object();

    json_object_object_add(obj,"stroke",_stroke->to_json_object());
    
    return obj;
}