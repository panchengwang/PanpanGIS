#include "SymFill.h"

SymFill::SymFill() {
}

const std::string& SymFill::getErrorMessage() const {
    return _errorMessage;
}


size_t SymFill::memory_size() {
    size_t len = sizeof(_type);

    return len;
}

char* SymFill::serialize(const char* buf) {
    char* p = (char*)buf;
    memcpy(p, (void*)&_type, sizeof(_type));
    p += sizeof(_type);
    return p;
}