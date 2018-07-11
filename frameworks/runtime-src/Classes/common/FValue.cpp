/****************************************************************************
 Copyright (c) 2013-2017 Chukong Technologies

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
****************************************************************************/

#include "FValue.h"
#include <cmath>
#include <sstream>
#include <iomanip>
#include "FYDHeaders.h"

FValue::FValue()
: _type(Type::NONE)
{
    memset(&_field, 0, sizeof(_field));
}

FValue::FValue(unsigned char v)
: _type(Type::BYTE)
{
    _field.byteVal = v;
}

FValue::FValue(int v)
: _type(Type::INTEGER)
{
    _field.intVal = v;
}

FValue::FValue(unsigned int v)
: _type(Type::UNSIGNED)
{
    _field.unsignedVal = v;
}

FValue::FValue(float v)
: _type(Type::FLOAT)
{
    _field.floatVal = v;
}

FValue::FValue(double v)
: _type(Type::DOUBLE)
{
    _field.doubleVal = v;
}

FValue::FValue(bool v)
: _type(Type::BOOLEAN)
{
    _field.boolVal = v;
}

FValue::FValue(const char* v)
: _type(Type::STRING)
{
    _field.strVal = new (std::nothrow) std::string();
    if (v)
    {
        *_field.strVal = v;
    }
}

FValue::FValue(const std::string& v)
: _type(Type::STRING)
{
    _field.strVal = new (std::nothrow) std::string();
    *_field.strVal = v;
}

FValue::FValue(const FValueVector& v)
: _type(Type::VECTOR)
{
    _field.vectorVal = new (std::nothrow) FValueVector();
    *_field.vectorVal = v;
}

FValue::FValue(FValueVector&& v)
: _type(Type::VECTOR)
{
    _field.vectorVal = new (std::nothrow) FValueVector();
    *_field.vectorVal = std::move(v);
}

FValue::FValue(const FValueMap& v)
: _type(Type::MAP)
{
    _field.mapVal = new (std::nothrow) FValueMap();
    *_field.mapVal = v;
}

FValue::FValue(FValueMap&& v)
: _type(Type::MAP)
{
    _field.mapVal = new (std::nothrow) FValueMap();
    *_field.mapVal = std::move(v);
}

FValue::FValue(const FValueMapIntKey& v)
: _type(Type::INT_KEY_MAP)
{
    _field.intKeyMapVal = new (std::nothrow) FValueMapIntKey();
    *_field.intKeyMapVal = v;
}

FValue::FValue(FValueMapIntKey&& v)
: _type(Type::INT_KEY_MAP)
{
    _field.intKeyMapVal = new (std::nothrow) FValueMapIntKey();
    *_field.intKeyMapVal = std::move(v);
}

FValue::FValue(const FValue& other)
: _type(Type::NONE)
{
    *this = other;
}

FValue::FValue(FValue&& other)
: _type(Type::NONE)
{
    *this = std::move(other);
}

FValue::~FValue()
{
    clear();
}

FValue& FValue::operator= (const FValue& other)
{
    if (this != &other) {
        reset(other._type);

        switch (other._type) {
            case Type::BYTE:
                _field.byteVal = other._field.byteVal;
                break;
            case Type::INTEGER:
                _field.intVal = other._field.intVal;
                break;
            case Type::UNSIGNED:
                _field.unsignedVal = other._field.unsignedVal;
                break;
            case Type::FLOAT:
                _field.floatVal = other._field.floatVal;
                break;
            case Type::DOUBLE:
                _field.doubleVal = other._field.doubleVal;
                break;
            case Type::BOOLEAN:
                _field.boolVal = other._field.boolVal;
                break;
            case Type::STRING:
                if (_field.strVal == nullptr)
                {
                    _field.strVal = new std::string();
                }
                *_field.strVal = *other._field.strVal;
                break;
            case Type::VECTOR:
                if (_field.vectorVal == nullptr)
                {
                    _field.vectorVal = new (std::nothrow) FValueVector();
                }
                *_field.vectorVal = *other._field.vectorVal;
                break;
            case Type::MAP:
                if (_field.mapVal == nullptr)
                {
                    _field.mapVal = new (std::nothrow) FValueMap();
                }
                *_field.mapVal = *other._field.mapVal;
                break;
            case Type::INT_KEY_MAP:
                if (_field.intKeyMapVal == nullptr)
                {
                    _field.intKeyMapVal = new (std::nothrow) FValueMapIntKey();
                }
                *_field.intKeyMapVal = *other._field.intKeyMapVal;
                break;
            default:
                break;
        }
    }
    return *this;
}

FValue& FValue::operator= (FValue&& other)
{
    if (this != &other)
    {
        clear();
        switch (other._type)
        {
            case Type::BYTE:
                _field.byteVal = other._field.byteVal;
                break;
            case Type::INTEGER:
                _field.intVal = other._field.intVal;
                break;
            case Type::UNSIGNED:
                _field.unsignedVal = other._field.unsignedVal;
                break;
            case Type::FLOAT:
                _field.floatVal = other._field.floatVal;
                break;
            case Type::DOUBLE:
                _field.doubleVal = other._field.doubleVal;
                break;
            case Type::BOOLEAN:
                _field.boolVal = other._field.boolVal;
                break;
            case Type::STRING:
                _field.strVal = other._field.strVal;
                break;
            case Type::VECTOR:
                _field.vectorVal = other._field.vectorVal;
                break;
            case Type::MAP:
                _field.mapVal = other._field.mapVal;
                break;
            case Type::INT_KEY_MAP:
                _field.intKeyMapVal = other._field.intKeyMapVal;
                break;
            default:
                break;
        }
        _type = other._type;

        memset(&other._field, 0, sizeof(other._field));
        other._type = Type::NONE;
    }

    return *this;
}

FValue& FValue::operator= (unsigned char v)
{
    reset(Type::BYTE);
    _field.byteVal = v;
    return *this;
}

FValue& FValue::operator= (int v)
{
    reset(Type::INTEGER);
    _field.intVal = v;
    return *this;
}

FValue& FValue::operator= (unsigned int v)
{
    reset(Type::UNSIGNED);
    _field.unsignedVal = v;
    return *this;
}

FValue& FValue::operator= (float v)
{
    reset(Type::FLOAT);
    _field.floatVal = v;
    return *this;
}

FValue& FValue::operator= (double v)
{
    reset(Type::DOUBLE);
    _field.doubleVal = v;
    return *this;
}

FValue& FValue::operator= (bool v)
{
    reset(Type::BOOLEAN);
    _field.boolVal = v;
    return *this;
}

FValue& FValue::operator= (const char* v)
{
    reset(Type::STRING);
    *_field.strVal = v ? v : "";
    return *this;
}

FValue& FValue::operator= (const std::string& v)
{
    reset(Type::STRING);
    *_field.strVal = v;
    return *this;
}

FValue& FValue::operator= (const FValueVector& v)
{
    reset(Type::VECTOR);
    *_field.vectorVal = v;
    return *this;
}

FValue& FValue::operator= (FValueVector&& v)
{
    reset(Type::VECTOR);
    *_field.vectorVal = std::move(v);
    return *this;
}

FValue& FValue::operator= (const FValueMap& v)
{
    reset(Type::MAP);
    *_field.mapVal = v;
    return *this;
}

FValue& FValue::operator= (FValueMap&& v)
{
    reset(Type::MAP);
    *_field.mapVal = std::move(v);
    return *this;
}

FValue& FValue::operator= (const FValueMapIntKey& v)
{
    reset(Type::INT_KEY_MAP);
    *_field.intKeyMapVal = v;
    return *this;
}

FValue& FValue::operator= (FValueMapIntKey&& v)
{
    reset(Type::INT_KEY_MAP);
    *_field.intKeyMapVal = std::move(v);
    return *this;
}

bool FValue::operator!= (const FValue& v)
{
    return !(*this == v);
}
bool FValue::operator!= (const FValue& v) const
{
    return !(*this == v);
}

bool FValue::operator== (const FValue& v)
{
    const auto &t = *this;
    return t == v;
}
bool FValue::operator== (const FValue& v) const
{
    if (this == &v) return true;
    if (v._type != this->_type) return false;
    if (this->isNull()) return true;
    switch (_type)
    {
        case Type::BYTE:    return v._field.byteVal     == this->_field.byteVal;
        case Type::INTEGER: return v._field.intVal      == this->_field.intVal;
        case Type::UNSIGNED:return v._field.unsignedVal == this->_field.unsignedVal;
        case Type::BOOLEAN: return v._field.boolVal     == this->_field.boolVal;
        case Type::STRING:  return *v._field.strVal     == *this->_field.strVal;
        case Type::FLOAT:   return std::abs(v._field.floatVal  - this->_field.floatVal)  <= FLT_EPSILON;
        case Type::DOUBLE:  return std::abs(v._field.doubleVal - this->_field.doubleVal) <= DBL_EPSILON;
        case Type::VECTOR:
        {
            const auto &v1 = *(this->_field.vectorVal);
            const auto &v2 = *(v._field.vectorVal);
            const auto size = v1.size();
            if (size == v2.size())
            {
                for (size_t i = 0; i < size; i++)
                {
                    if (v1[i] != v2[i]) return false;
                }
                return true;
            }
            return false;
        }
        case Type::MAP:
        {
            const auto &map1 = *(this->_field.mapVal);
            const auto &map2 = *(v._field.mapVal);
            for (const auto &kvp : map1)
            {
                auto it = map2.find(kvp.first);
                if (it == map2.end() || it->second != kvp.second)
                {
                    return false;
                }
            }
            return true;
        }
        case Type::INT_KEY_MAP:
        {
            const auto &map1 = *(this->_field.intKeyMapVal);
            const auto &map2 = *(v._field.intKeyMapVal);
            for (const auto &kvp : map1)
            {
                auto it = map2.find(kvp.first);
                if (it == map2.end() || it->second != kvp.second)
                {
                    return false;
                }
            }
            return true;
        }
        default:
            break;
    };

    return false;
}

/// Convert value to a specified type
unsigned char FValue::asByte() const
{
    FYDASSERT(_type != Type::VECTOR && _type != Type::MAP && _type != Type::INT_KEY_MAP, "Only base type (bool, string, float, double, int) could be converted");

    if (_type == Type::BYTE)
    {
        return _field.byteVal;
    }

    if (_type == Type::INTEGER)
    {
        return static_cast<unsigned char>(_field.intVal);
    }

    if (_type == Type::UNSIGNED)
    {
        return static_cast<unsigned char>(_field.unsignedVal);
    }

    if (_type == Type::STRING)
    {
        return static_cast<unsigned char>(atoi(_field.strVal->c_str()));
    }

    if (_type == Type::FLOAT)
    {
        return static_cast<unsigned char>(_field.floatVal);
    }

    if (_type == Type::DOUBLE)
    {
        return static_cast<unsigned char>(_field.doubleVal);
    }

    if (_type == Type::BOOLEAN)
    {
        return _field.boolVal ? 1 : 0;
    }

    return 0;
}

int FValue::asInt() const
{
    FYDASSERT(_type != Type::VECTOR && _type != Type::MAP && _type != Type::INT_KEY_MAP, "Only base type (bool, string, float, double, int) could be converted");
    if (_type == Type::INTEGER)
    {
        return _field.intVal;
    }

    if (_type == Type::UNSIGNED)
    {
        FYDASSERT(_field.unsignedVal < INT_MAX, "Can only convert values < INT_MAX");
        return (int)_field.unsignedVal;
    }

    if (_type == Type::BYTE)
    {
        return _field.byteVal;
    }

    if (_type == Type::STRING)
    {
        return atoi(_field.strVal->c_str());
    }

    if (_type == Type::FLOAT)
    {
        return static_cast<int>(_field.floatVal);
    }

    if (_type == Type::DOUBLE)
    {
        return static_cast<int>(_field.doubleVal);
    }

    if (_type == Type::BOOLEAN)
    {
        return _field.boolVal ? 1 : 0;
    }

    return 0;
}


unsigned int FValue::asUnsignedInt() const
{
    FYDASSERT(_type != Type::VECTOR && _type != Type::MAP && _type != Type::INT_KEY_MAP, "Only base type (bool, string, float, double, int) could be converted");
    if (_type == Type::UNSIGNED)
    {
        return _field.unsignedVal;
    }

    if (_type == Type::INTEGER)
    {
        FYDASSERT(_field.intVal >= 0, "Only values >= 0 can be converted to unsigned");
        return static_cast<unsigned int>(_field.intVal);
    }

    if (_type == Type::BYTE)
    {
        return static_cast<unsigned int>(_field.byteVal);
    }

    if (_type == Type::STRING)
    {
        // NOTE: strtoul is required (need to augment on unsupported platforms)
        return static_cast<unsigned int>(strtoul(_field.strVal->c_str(), nullptr, 10));
    }

    if (_type == Type::FLOAT)
    {
        return static_cast<unsigned int>(_field.floatVal);
    }

    if (_type == Type::DOUBLE)
    {
        return static_cast<unsigned int>(_field.doubleVal);
    }

    if (_type == Type::BOOLEAN)
    {
        return _field.boolVal ? 1u : 0u;
    }

    return 0u;
}

float FValue::asFloat() const
{
    FYDASSERT(_type != Type::VECTOR && _type != Type::MAP && _type != Type::INT_KEY_MAP, "Only base type (bool, string, float, double, int) could be converted");
    if (_type == Type::FLOAT)
    {
        return _field.floatVal;
    }

    if (_type == Type::BYTE)
    {
        return static_cast<float>(_field.byteVal);
    }

    if (_type == Type::STRING)
    {
        return atof(_field.strVal->c_str());
    }

    if (_type == Type::INTEGER)
    {
        return static_cast<float>(_field.intVal);
    }

    if (_type == Type::UNSIGNED)
    {
        return static_cast<float>(_field.unsignedVal);
    }

    if (_type == Type::DOUBLE)
    {
        return static_cast<float>(_field.doubleVal);
    }

    if (_type == Type::BOOLEAN)
    {
        return _field.boolVal ? 1.0f : 0.0f;
    }

    return 0.0f;
}

double FValue::asDouble() const
{
    FYDASSERT(_type != Type::VECTOR && _type != Type::MAP && _type != Type::INT_KEY_MAP, "Only base type (bool, string, float, double, int) could be converted");
    if (_type == Type::DOUBLE)
    {
        return _field.doubleVal;
    }

    if (_type == Type::BYTE)
    {
        return static_cast<double>(_field.byteVal);
    }

    if (_type == Type::STRING)
    {
        return static_cast<double>(atof(_field.strVal->c_str()));
    }

    if (_type == Type::INTEGER)
    {
        return static_cast<double>(_field.intVal);
    }

    if (_type == Type::UNSIGNED)
    {
        return static_cast<double>(_field.unsignedVal);
    }

    if (_type == Type::FLOAT)
    {
        return static_cast<double>(_field.floatVal);
    }

    if (_type == Type::BOOLEAN)
    {
        return _field.boolVal ? 1.0 : 0.0;
    }

    return 0.0;
}

bool FValue::asBool() const
{
    FYDASSERT(_type != Type::VECTOR && _type != Type::MAP && _type != Type::INT_KEY_MAP, "Only base type (bool, string, float, double, int) could be converted");
    if (_type == Type::BOOLEAN)
    {
        return _field.boolVal;
    }

    if (_type == Type::BYTE)
    {
        return _field.byteVal == 0 ? false : true;
    }

    if (_type == Type::STRING)
    {
        return (*_field.strVal == "0" || *_field.strVal == "false") ? false : true;
    }

    if (_type == Type::INTEGER)
    {
        return _field.intVal == 0 ? false : true;
    }

    if (_type == Type::UNSIGNED)
    {
        return _field.unsignedVal == 0 ? false : true;
    }

    if (_type == Type::FLOAT)
    {
        return _field.floatVal == 0.0f ? false : true;
    }

    if (_type == Type::DOUBLE)
    {
        return _field.doubleVal == 0.0 ? false : true;
    }

    return false;
}

std::string FValue::asString() const
{
    FYDASSERT(_type != Type::VECTOR && _type != Type::MAP && _type != Type::INT_KEY_MAP, "Only base type (bool, string, float, double, int) could be converted");

    if (_type == Type::STRING)
    {
        return *_field.strVal;
    }

    std::stringstream ret;

    switch (_type)
    {
        case Type::BYTE:
            ret << _field.byteVal;
            break;
        case Type::INTEGER:
            ret << _field.intVal;
            break;
        case Type::UNSIGNED:
            ret << _field.unsignedVal;
            break;
        case Type::FLOAT:
            ret << std::fixed << std::setprecision( 7 )<< _field.floatVal;
            break;
        case Type::DOUBLE:
            ret << std::fixed << std::setprecision( 16 ) << _field.doubleVal;
            break;
        case Type::BOOLEAN:
            ret << (_field.boolVal ? "true" : "false");
            break;
        default:
            break;
    }
    return ret.str();
}

FValueVector& FValue::asFValueVector()
{
    FYDASSERT(_type == Type::VECTOR, "The value type isn't Type::VECTOR");
    return *_field.vectorVal;
}

const FValueVector& FValue::asFValueVector() const
{
    FYDASSERT(_type == Type::VECTOR, "The value type isn't Type::VECTOR");
    return *_field.vectorVal;
}

FValueMap& FValue::asFValueMap()
{
    FYDASSERT(_type == Type::MAP, "The value type isn't Type::MAP");
    return *_field.mapVal;
}

const FValueMap& FValue::asFValueMap() const
{
    FYDASSERT(_type == Type::MAP, "The value type isn't Type::MAP");
    return *_field.mapVal;
}

FValueMapIntKey& FValue::asIntKeyMap()
{
    FYDASSERT(_type == Type::INT_KEY_MAP, "The value type isn't Type::INT_KEY_MAP");
    return *_field.intKeyMapVal;
}

const FValueMapIntKey& FValue::asIntKeyMap() const
{
    FYDASSERT(_type == Type::INT_KEY_MAP, "The value type isn't Type::INT_KEY_MAP");
    return *_field.intKeyMapVal;
}

static std::string getTabs(int depth)
{
    std::string tabWidth;

    for (int i = 0; i < depth; ++i)
    {
        tabWidth += "\t";
    }

    return tabWidth;
}

static std::string visit(const FValue& v, int depth);

static std::string visitVector(const FValueVector& v, int depth)
{
    std::stringstream ret;

    if (depth > 0)
        ret << "\n";

    ret << getTabs(depth) << "[\n";

    int i = 0;
    for (const auto& child : v)
    {
        ret << getTabs(depth+1) << i << ": " << visit(child, depth + 1);
        ++i;
    }

    ret << getTabs(depth) << "]\n";

    return ret.str();
}

template <class T>
static std::string visitMap(const T& v, int depth)
{
    std::stringstream ret;

    if (depth > 0)
        ret << "\n";

    ret << getTabs(depth) << "{\n";

    for (auto& iter : v)
    {
        ret << getTabs(depth + 1) << iter.first << ": ";
        ret << visit(iter.second, depth + 1);
    }

    ret << getTabs(depth) << "}\n";

    return ret.str();
}

static std::string visit(const FValue& v, int depth)
{
    std::stringstream ret;

    switch (v.getType())
    {
        case FValue::Type::NONE:
        case FValue::Type::BYTE:
        case FValue::Type::INTEGER:
        case FValue::Type::UNSIGNED:
        case FValue::Type::FLOAT:
        case FValue::Type::DOUBLE:
        case FValue::Type::BOOLEAN:
        case FValue::Type::STRING:
            ret << v.asString() << "\n";
            break;
        case FValue::Type::VECTOR:
            ret << visitVector(v.asFValueVector(), depth);
            break;
        case FValue::Type::MAP:
            ret << visitMap(v.asFValueMap(), depth);
            break;
        case FValue::Type::INT_KEY_MAP:
            ret << visitMap(v.asIntKeyMap(), depth);
            break;
        default:
            FYDASSERT(false, "Invalid type!");
            break;
    }

    return ret.str();
}

std::string FValue::getDescription() const
{
    std::string ret("\n");
    ret += visit(*this, 0);
    return ret;
}

void FValue::clear()
{
    // Free memory the old value allocated
    switch (_type)
    {
        case Type::BYTE:
            _field.byteVal = 0;
            break;
        case Type::INTEGER:
            _field.intVal = 0;
            break;
        case Type::UNSIGNED:
            _field.unsignedVal = 0u;
            break;
        case Type::FLOAT:
            _field.floatVal = 0.0f;
            break;
        case Type::DOUBLE:
            _field.doubleVal = 0.0;
            break;
        case Type::BOOLEAN:
            _field.boolVal = false;
            break;
        case Type::STRING:
            FYD_SAFE_DELETE(_field.strVal);
            break;
        case Type::VECTOR:
            FYD_SAFE_DELETE(_field.vectorVal);
            break;
        case Type::MAP:
            FYD_SAFE_DELETE(_field.mapVal);
            break;
        case Type::INT_KEY_MAP:
            FYD_SAFE_DELETE(_field.intKeyMapVal);
            break;
        default:
            break;
    }

    _type = Type::NONE;
}

void FValue::reset(Type type)
{
    if (_type == type)
        return;

    clear();

    // Allocate memory for the new value
    switch (type)
    {
        case Type::STRING:
            _field.strVal = new (std::nothrow) std::string();
            break;
        case Type::VECTOR:
            _field.vectorVal = new (std::nothrow) FValueVector();
            break;
        case Type::MAP:
            _field.mapVal = new (std::nothrow) FValueMap();
            break;
        case Type::INT_KEY_MAP:
            _field.intKeyMapVal = new (std::nothrow) FValueMapIntKey();
            break;
        default:
            break;
    }

    _type = type;
}

