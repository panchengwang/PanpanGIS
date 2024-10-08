#ifndef __SYM_SYSTEM_FILL_SHAPE_H
#define __SYM_SYSTEM_FILL_SHAPE_H

#include "SymShape.h"



class DLL_EXPORT SymSystemFillShape : public SymShape
{
public:

    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object();

    const std::string& getErrorMessage() const;
    
protected:
    uint8_t  _type;
    SymStroke _stroke;
    std::string _errorMessage;
};

#endif
