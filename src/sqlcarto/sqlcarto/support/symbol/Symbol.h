#ifndef __SYMBOL_H
#define __SYMBOL_H

#include <dllexport.h>
#include "SymPoint.h"
#include <string>
#include <json_tokener.h>
#include <vector>
#include "SymShape.h"



class DLL_EXPORT Symbol
{
public:
    Symbol();
    virtual ~Symbol();

    bool from_json_file(const char* filename);
    bool from_json_string(const char* jsonstr);
    std::string to_json_string();

    const std::string& getErrorMessage() const;

    void clear();

    size_t memory_size();

    char* serialize(size_t& len);
    // void deserialize(const char* buf);

protected:
    bool from_json_object(json_object* obj);
    json_object* to_json_object();

private:
    SymPoint _offset;
    double _xscale, _yscale;
    std::vector<SymShape*> _shapes;
    std::string _errorMessage;
};

#endif
