#ifndef __SYM_POINT_H
#define __SYM_POINT_H

#include <dllexport.h>
#include <stdlib.h>
#include <json-c/json_tokener.h>
#include <string>

class DLL_EXPORT SymPoint
{
public:
    SymPoint();
    SymPoint(double x, double y);
    SymPoint(const SymPoint& other);
    virtual ~SymPoint();

    bool from_json_object(json_object* obj);
    json_object* to_json_object();

    const std::string& getErrorMessage() const;
    size_t memory_size();
    char* serialize(const char* buf);
protected:
    float _x, _y;
    std::string _errorMessage;

    friend bool operator==(const SymPoint& pt1, const SymPoint& pt2);
    friend bool operator!=(const SymPoint& pt1, const SymPoint& pt2);
};

#endif
