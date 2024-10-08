#include "SymShapeWithStrokeAndFill.h"
#include "SymFill.h"
#include "jsonutils.h"
#include "SymFillSolid.h"

SymShapeWithStrokeAndFill::SymShapeWithStrokeAndFill(){
    _fill = NULL;
}

SymShapeWithStrokeAndFill::~SymShapeWithStrokeAndFill(){
    if(_fill){
        delete _fill;
    }
}

bool SymShapeWithStrokeAndFill::from_json_object(json_object* obj){
    if(!SymShapeWithStroke::from_json_object(obj)){
        return false;
    }
    json_object *fillobj = NULL;
    JSON_GET_OBJ(obj,"fill",fillobj,_errorMessage);
    std::string typestr ;
    JSON_GET_STRING(fillobj,"type",typestr,_errorMessage);


    if(typestr == "SOLID"){
        _fill = new SymFillSolid();
    }

    if(!_fill){
        _errorMessage = "Invalid fill type: " + typestr;
        return false;
    }

    if(!_fill->from_json_object(fillobj)){
        _errorMessage = _fill->getErrorMessage();
        return false;
    }

    return true; 
}


json_object* SymShapeWithStrokeAndFill::to_json_object(){
    json_object* obj = SymShapeWithStroke::to_json_object();
    json_object_object_add(obj,"fill",_fill->to_json_object());
    return obj;
}