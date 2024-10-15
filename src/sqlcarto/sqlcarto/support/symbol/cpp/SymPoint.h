#ifndef __SYM_POINT_H
#define __SYM_POINT_H

#include <dllexport.h>
#include <stdlib.h>
#include <json-c/json_tokener.h>
#include <string>
#include <iostream>
#include <string.h>


class DLL_EXPORT SymPoint
{
public:
    SymPoint();
    SymPoint(double x, double y);
    SymPoint(const SymPoint& other);
    virtual ~SymPoint();

    bool fromJsonObject(json_object* obj);
    json_object* toJsonObject();

    const std::string& getErrorMessage() const;
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);

    double x() const;
    double y() const;
protected:
    double _x, _y;
    std::string _errorMessage;

    friend bool operator==(const SymPoint& pt1, const SymPoint& pt2);
    friend bool operator!=(const SymPoint& pt1, const SymPoint& pt2);
    friend std::ostream& operator<<(std::ostream& out, const SymPoint& pt);
};

#endif
