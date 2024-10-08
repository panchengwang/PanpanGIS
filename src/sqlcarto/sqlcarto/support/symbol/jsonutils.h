#ifndef __JSON_C_UTILS_H
#define __JSON_C_UTILS_H


#include <iostream>

#define JSON_GET_DOUBLE(parent,key,val,errormsg)                            \
    {                                                                       \
        json_object *myobj = json_object_object_get(parent,key);            \
        if(!myobj){                                                         \
            errormsg = std::string("no key: ") + key;                       \
            return false;                                                   \
        }                                                                   \
        val = json_object_get_double(myobj);                                \
    }

#define JSON_GET_INT(parent,key,val,errormsg)                               \
    {                                                                       \
        json_object *myobj = json_object_object_get(parent,key);            \
        if(!myobj){                                                         \
            errormsg = std::string("no key: ") + key;                       \
            return false;                                                   \
        }                                                                   \
        val = json_object_get_int(myobj);                                   \
    }

#define JSON_GET_STRING(parent,key,val,errormsg)                            \
    {                                                                       \
        json_object *myobj = json_object_object_get(parent,key);            \
        if(!myobj){                                                         \
            errormsg = std::string("no key: ") + key;                       \
            return false;                                                   \
        }                                                                   \
        val = json_object_get_string(myobj);                                \
    }

#define JSON_GET_OBJ(parent,key,val,errormsg)                               \
    val = json_object_object_get(obj,key);                                  \
    if(!val){                                                               \
        errormsg = std::string("no key: ") + key;                           \
        return false;                                                       \
    }


#define JSON_ADD_DOUBLE(parent,key,val)                                     \
    json_object_object_add(parent,key,json_object_new_double(val));

#define JSON_ADD_INT(parent,key,val)                                        \
    json_object_object_add(parent,key,json_object_new_int(val));


#define JSON_ADD_STRING(parent,key,val)                                     \
    json_object_object_add(parent,key,json_object_new_string(val));

#endif
