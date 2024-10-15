#ifndef __SYM_COLOR_H
#define __SYM_COLOR_H

#include <dllexport.h>
#include <stdint.h>
#include "json_tokener.h"
#include <string>
#include <string.h>


class DLL_EXPORT SymColor
{
public:
    SymColor();
    SymColor(uint8_t alpha, uint8_t red, uint8_t green, uint8_t blue);



    json_object* toJsonObject();
    bool fromJsonObject(json_object* obj);

    const std::string& getErrorMessage() const;
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);
protected:
    uint8_t _alpha, _red, _green, _blue;
    std::string _errorMessage;
};

#endif
