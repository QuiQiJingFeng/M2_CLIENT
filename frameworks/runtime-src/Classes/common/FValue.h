

#ifndef __FYD_VALUE__
#define __FYD_VALUE__

#include <string>
#include <vector>
#include <unordered_map>
#include <float.h>
#include <stdlib.h>

class FValue;

typedef std::vector<FValue> FValueVector;
typedef std::unordered_map<std::string, FValue> FValueMap;
typedef std::unordered_map<int, FValue> FValueMapIntKey;

/*
 * 提供一些基本数据类型,以及数组、字典类型的包装,提供一个统一的类型
 */
class FValue
{
public:
    /** 默认构造函数 */
    FValue();
    
    /** 包装无符号字符类型 */
    explicit FValue(unsigned char v);
    
    /** 包装整形 */
    explicit FValue(int v);

    /** 包装无符号整形 */
    explicit FValue(unsigned int v);

    /** 包装浮点类型 */
    explicit FValue(float v);
    
    /** 包装双精度浮点型 */
    explicit FValue(double v);
    
    /** 包装布尔类型 */
    explicit FValue(bool v);
    
    /** 包装字符型 */
    explicit FValue(const char* v);
    
    /** 包装字符串型 */
    explicit FValue(const std::string& v);
    
    /** 包装FValue数组 类型 */
    explicit FValue(const FValueVector& v);
    /** 包装FValue数组类型 std::move 的形式   
     将对象的状态或者所有权从一个对象转移到另一个对象，只是转移，没有内存的搬迁或者内存拷贝 
     所以使用的时候需要注意销毁内存的时候不要重复销毁
     */
    explicit FValue(FValueVector&& v);
    
    /** 包装FValue字典 类型 */
    explicit FValue(const FValueMap& v);
    /** 包装FValue字典 类型 std::move 的形式 */
    explicit FValue(FValueMap&& v);
    
    /** 包装FValue字典,这种字典以整形数字作为key */
    explicit FValue(const FValueMapIntKey& v);
    /** 包装FValue字典,这种字典以整形数字作为key std::move 的形式 */
    explicit FValue(FValueMapIntKey&& v);

    /** 根据另一个FValue 来创建一个新的对象 */
    FValue(const FValue& other);
    /** 根据另一个FValue 来创建一个新的对象 std::move的形式 */
    FValue(FValue&& other);
    
    /** 析构函数 */
    ~FValue();

    /** 操作符重载 赋值操作 FValue to FValue. */
    FValue& operator= (const FValue& other);
    /** 操作符重载 赋值操作 FValue to FValue. It will use std::move internally. */
    FValue& operator= (FValue&& other);

    /** 操作符重载 赋值操作 unsigned char to FValue. */
    FValue& operator= (unsigned char v);
    /** 操作符重载 赋值操作 integer to FValue. */
    FValue& operator= (int v);
    /** 操作符重载 赋值操作 integer to FValue. */
    FValue& operator= (unsigned int v);
    /** 操作符重载 赋值操作 float to FValue. */
    FValue& operator= (float v);
    /** 操作符重载 赋值操作 double to FValue. */
    FValue& operator= (double v);
    /** 操作符重载 赋值操作 bool to FValue. */
    FValue& operator= (bool v);
    /** 操作符重载 赋值操作 char* to FValue. */
    FValue& operator= (const char* v);
    /** 操作符重载 赋值操作 string to FValue. */
    FValue& operator= (const std::string& v);

    /** 操作符重载 赋值操作 FValueVector to FValue. */
    FValue& operator= (const FValueVector& v);
    /** 操作符重载 赋值操作 FValueVector to FValue. */
    FValue& operator= (FValueVector&& v);

    /** 操作符重载 赋值操作 FValueMap to FValue. */
    FValue& operator= (const FValueMap& v);
    /** 操作符重载 赋值操作 FValueMap to FValue. It will use std::move internally. */
    FValue& operator= (FValueMap&& v);

    /** 操作符重载 赋值操作 FValueMapIntKey to FValue. */
    FValue& operator= (const FValueMapIntKey& v);
    /** 操作符重载 赋值操作 FValueMapIntKey to FValue. It will use std::move internally. */
    FValue& operator= (FValueMapIntKey&& v);

    /** != 等号 不等号判断 */
    bool operator!= (const FValue& v);
    /** != 等号 不等号判断 */
    bool operator!= (const FValue& v) const;
    /** == 等号 不等号判断 */
    bool operator== (const FValue& v);
    /** == 等号 不等号判断 */
    bool operator== (const FValue& v) const;

    /** 转换成无符号字节流返回 */
    unsigned char asByte() const;
    /** 转换为整形返回 */
    int asInt() const;
    /** 转换为无符号整形返回 */
    unsigned int asUnsignedInt() const;
    /** 转换为浮点数返回 */
    float asFloat() const;
    /** 转换为双精度浮点类型 */
    double asDouble() const;
    /** 转换成布尔类型 */
    bool asBool() const;
    /** 转换成字符串类型 */
    std::string asString() const;

    /** 转换成FValue数组类型 */
    FValueVector& asFValueVector();
    /** 常函数 转换FValue数组类型 */
    const FValueVector& asFValueVector() const;

    /** 转换FValue字典类型 */
    FValueMap& asFValueMap();
    /** 常函数 转换FValue字典类型 */
    const FValueMap& asFValueMap() const;

    /** 转换FValue字典类型  整形作为key值的字典 */
    FValueMapIntKey& asIntKeyMap();
    /** 常函数 转换FValue字典类型  整形作为key值的字典 */
    const FValueMapIntKey& asIntKeyMap() const;

    /**
     * 检查FValue值是否为空
     */
    bool isNull() const { return _type == Type::NONE; }

    /** FValue type wrapped by FValue. */
    enum class Type
    {
        /// no value is wrapped, an empty FValue
        NONE = 0,
        /// wrap byte
        BYTE,
        /// wrap integer
        INTEGER,
        /// wrap unsigned
        UNSIGNED,
        /// wrap float
        FLOAT,
        /// wrap double
        DOUBLE,
        /// wrap bool
        BOOLEAN,
        /// wrap string
        STRING,
        /// wrap vector
        VECTOR,
        /// wrap FValueMap
        MAP,
        /// wrap FValueMapIntKey
        INT_KEY_MAP
    };

    /** 获取FValue的类型 */
    Type getType() const { return _type; }

    /** 输出一个FValue的值,如果FValue是Map或者Vector则递归输出值 */
    std::string getDescription() const;

private:
    void clear();
    void reset(Type type);
    /* 共用体 用来存储数据的地方 */
    union
    {
        unsigned char byteVal;
        int intVal;
        unsigned int unsignedVal;
        float floatVal;
        double doubleVal;
        bool boolVal;

        std::string* strVal;
        FValueVector* vectorVal;
        FValueMap* mapVal;
        FValueMapIntKey* intKeyMapVal;
    }_field;
    /* FValue 类型 的值的数据类型*/
    Type _type;
};



#endif
