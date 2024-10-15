#ifndef __SYM_FILL_H
#define __SYM_FILL_H

#include <dllexport.h>
#include "SymColor.h"
#include <string>
#include <json_tokener.h>
#include <vector>

#define FILL_SOLID 1
#define FILL_LINEAR 2
#define FILL_RADIAL 3
#define FILL_IMAGE 4

class DLL_EXPORT SymFill
{
public:
    SymFill();
    const std::string& getErrorMessage() const;
    virtual bool fromJsonObject(json_object* obj) = 0;
    virtual json_object* toJsonObject() = 0;
    virtual size_t memorySize();
    virtual char* serialize(const char* buf);
    virtual char* deserialize(const char* buf);
protected:
    uint8_t _type;
    std::string _errorMessage;
};

#endif
