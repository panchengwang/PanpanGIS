#ifndef __SERIALIZE_UTILS_H
#define __SERIALIZE_UTILS_H

#define SERIALIZE_TO_BUF(buf,val)                       \
    {                                                   \
        memcpy(buf, (void*)&val, sizeof(val));          \
        buf += sizeof(val);                             \
    }

#define DESERIALIZE_FROM_BUF(buf,val)                   \
    {                                                   \
        memcpy((void*)&val, buf, sizeof(val));          \
        buf += sizeof(val);                             \
    }

#endif