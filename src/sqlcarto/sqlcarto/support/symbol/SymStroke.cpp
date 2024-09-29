#include "SymStroke.h"

SymStroke::SymStroke()
{
}

const std::string &SymStroke::getErrorMessage() const
{
    return _errorMessage;
}

bool SymStroke::from_json_object(json_object *obj)
{
    return true;
}

json_object *SymStroke::to_json_object()
{
    return NULL;
}
