#ifndef __SYM_SHAPE_H
#define __SYM_SHAPE_H

#include <dllexport.h>
#include <stdint.h>
#include "json_tokener.h"
#include <string>
#include "SymStroke.h"
#include <string.h>
#include "SymRect.h"


#define SYM_SHAPE_SYSTEM_LINE       1
#define SYM_SHAPE_SYSTEM_FILL       2
#define SYM_SHAPE_LINESTRING        3
#define SYM_SHAPE_POLYGON           4
#define SYM_SHAPE_ARC               5
#define SYM_SHAPE_CIRCLE            6
#define SYM_SHAPE_ELLIPSE           7
#define SYM_SHAPE_PIE               8
#define SYM_SHAPE_CHORD             9
#define SYM_SHAPE_PATH              10
#define SYM_SHAPE_REGULAR_POLYGON   11




class DLL_EXPORT SymShape
{
public:

    virtual bool fromJsonObject(json_object* obj) = 0;
    virtual json_object* toJsonObject() = 0;
    virtual size_t memorySize();
    virtual const std::string& getErrorMessage() const;

    virtual char* serialize(const char* buf);
    virtual char* deserialize(const char* buf);

    virtual SymRect getMBR() const = 0;
    virtual double getStrokeWidth()  const;
protected:
    uint8_t  _type;
    std::string _errorMessage;
};

#endif
