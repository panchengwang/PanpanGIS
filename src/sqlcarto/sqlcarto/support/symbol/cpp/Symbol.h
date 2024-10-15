#ifndef __SYMBOL_H
#define __SYMBOL_H

#include <dllexport.h>
#include "SymPoint.h"
#include <string>
#include <json_tokener.h>
#include <vector>
#include "SymShape.h"
#include "SymRect.h"


class DLL_EXPORT Symbol
{
public:
    Symbol();
    virtual ~Symbol();

    bool fromJsonFile(const char* filename);
    bool fromJsonString(const char* jsonstr);
    std::string toJsonString();

    const std::string& getErrorMessage() const;

    void clear();

    size_t memorySize();

    char* serialize(size_t& len);
    bool deserialize(const char* buf);

    SymRect getMBR();             // 计算绘制范围
protected:
    bool fromJsonObject(json_object* obj);
    json_object* toJsonObject();

private:
    SymPoint _offset;
    double _xscale, _yscale;
    std::vector<SymShape*> _shapes;
    std::string _errorMessage;
};

#endif
