#include "SymPie.h"
#include "jsonutils.h"

SymPie::SymPie()
{
    _type = SYM_SHAPE_PIE;
}

bool SymPie::from_json_object(json_object *obj)
{
    _type = SYM_SHAPE_PIE;
    if (!SymShapeWithStrokeAndFill::from_json_object(obj))
    {
        return false;
    }

    json_object *centerobj = NULL;
    JSON_GET_OBJ(obj, "center", centerobj, _errorMessage);
    if (!_center.from_json_object(centerobj))
    {
        _errorMessage = _center.getErrorMessage();
        return false;
    }
    JSON_GET_DOUBLE(obj, "xradius", _xradius, _errorMessage);
    JSON_GET_DOUBLE(obj, "yradius", _yradius, _errorMessage);
    JSON_GET_DOUBLE(obj, "startangle", _startAngle, _errorMessage);
    JSON_GET_DOUBLE(obj, "endangle", _endAngle, _errorMessage);
    return true;
}

json_object *SymPie::to_json_object()
{
    json_object *obj = SymShapeWithStrokeAndFill::to_json_object();
    JSON_ADD_STRING(obj, "type", "PIE");
    json_object_object_add(obj,"center",_center.to_json_object());
    JSON_ADD_DOUBLE(obj,"xradius",_xradius);
    JSON_ADD_DOUBLE(obj,"yradius",_yradius);
    JSON_ADD_DOUBLE(obj,"startangle",_startAngle);
    JSON_ADD_DOUBLE(obj,"endangle",_endAngle);
    return obj;
}
