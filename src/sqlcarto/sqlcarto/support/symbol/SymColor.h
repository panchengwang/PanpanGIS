#ifndef __SYM_COLOR_H
#define __SYM_COLOR_H

#include <dllexport.h>
#include <stdint.h>
#include "json_tokener.h"
#include <string>

class DLL_EXPORT SymColor
{
public:
    SymColor();
    SymColor(uint8_t alpha, uint8_t red, uint8_t green, uint8_t blue);



    json_object* to_json_object();
    bool from_json_object(json_object* obj);

    const std::string& getErrorMessage() const;
    size_t memory_size();
    char* serialize(const char* buf);
protected:
    uint8_t _alpha, _red, _green, _blue;
    std::string _errorMessage;
};

#endif
