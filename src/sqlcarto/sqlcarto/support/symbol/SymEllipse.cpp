#include "SymEllipse.h"
#include "jsonutils.h"

SymEllipse::SymEllipse()
{
    _type = SYM_SHAPE_CIRCLE;
}


SymEllipse::~SymEllipse()
{

}

bool SymEllipse::from_json_object(json_object *obj)
{
    _type = SYM_SHAPE_CIRCLE;
    if (!SymShapeWithStrokeAndFill::from_json_object(obj))
    {
        return false;
    }

    json_object* centerobj = NULL;
    JSON_GET_OBJ(obj,"center",centerobj,_errorMessage);
    if(!_center.from_json_object(centerobj)){
        _errorMessage = _center.getErrorMessage();
        return false;
    }
    JSON_GET_DOUBLE(obj,"xradius",_xradius,_errorMessage);
    JSON_GET_DOUBLE(obj,"yradius",_yradius,_errorMessage);
    return true;
}

json_object *SymEllipse::to_json_object()
{
    json_object *obj = SymShapeWithStrokeAndFill::to_json_object();
    JSON_ADD_STRING(obj, "type", "ELLIPSE");
    json_object_object_add(obj,"center",_center.to_json_object());
    JSON_ADD_DOUBLE(obj,"xradius",_xradius);
    JSON_ADD_DOUBLE(obj,"yradius",_yradius);
    return obj;
}
