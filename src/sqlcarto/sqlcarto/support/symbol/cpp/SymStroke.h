#ifndef __SYM_STROKE_H
#define __SYM_STROKE_H

#include <dllexport.h>
#include "SymColor.h"
#include <string>
#include <json_tokener.h>
#include <vector>
#include <string.h>

#define LINE_CAP_BUTT       1
#define LINE_CAP_ROUND      2
#define LINE_CAP_SQUARE     3

#define LINE_JOIN_MITER     1
#define LINE_JOIN_ROUND     2
#define LINE_JOIN_BEVEL     3

class DLL_EXPORT SymStroke
{
public:
    SymStroke();
    const std::string& getErrorMessage() const;
    bool fromJsonObject(json_object* obj);
    json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);
    double getWidth() const;
protected:
    SymColor    _color;
    double _width;
    std::vector<double> _dashes;
    uint8_t _cap;
    uint8_t _join;
    double _miter;
    std::string _errorMessage;
};

#endif
