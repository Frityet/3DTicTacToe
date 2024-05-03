// Copyright (C) 2024 Amrit Bhogal
//
// This file is part of 3DTicTacToe.
//
// 3DTicTacToe is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// 3DTicTacToe is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with 3DTicTacToe.  If not, see <https://www.gnu.org/licenses/>.

#import <ObjFW/ObjFW.h>

OF_ASSUME_NONNULL_BEGIN

#define $_concat(a, b) a##b
#define $concat(...) $_concat(__VA_ARGS__)

#if !defined($CArray)
#   define $CArray(T) $concat(T, Array)
#endif

#define $declare_carray(T)                                                          \
@interface $CArray(T) : OFObject                                               \
@property(readonly) size_t count;                                                   \
@property(readonly) size_t capacity;                                                \
@property(readonly) T *items;                                                       \
                                                                                    \
- (instancetype)init;                                                               \
- (instancetype)initWithCapacity: (size_t)capacity;                                 \
- (instancetype)initWithArray: (T *)array count: (size_t)count;                     \
                                                                                    \
- (void)addObject: (T)object [[clang::objc_direct]];                                \
- (void)addObjectsFromArray: (T *)array count: (size_t)count [[clang::objc_direct]];\
- (void)insert: (T)object atIndex: (size_t)index [[clang::objc_direct]];            \
- (void)removeObjectAtIndex: (size_t)index [[clang::objc_direct]];                  \
- (void)removeAllObjects [[clang::objc_direct]];                                    \
                                                                                    \
- (T)objectAtIndex: (size_t)index [[clang::objc_direct]];                           \
- (T)objectAtIndexedSubscript: (size_t)index [[clang::objc_direct]];                \
@end

#define $define_carray(T)                                                           \
@implementation $CArray(T)                                                     \
- (instancetype)init                                                                \
{                                                                                   \
    self = [super init];                                                            \
                                                                                    \
    _count = 0;                                                                     \
    _capacity = 16;                                                                 \
    _items = calloc(_capacity, sizeof(T));                                          \
                                                                                    \
    return self;                                                                    \
}                                                                                   \
                                                                                    \
- (instancetype)initWithCapacity: (size_t)capacity                                  \
{                                                                                   \
    self = [super init];                                                            \
                                                                                    \
    _count = 0;                                                                     \
    _capacity = capacity;                                                           \
    _items = calloc(_capacity, sizeof(T));                                          \
                                                                                    \
    return self;                                                                    \
}                                                                                   \
                                                                                    \
- (instancetype)initWithArray: (T *)array count: (size_t)count                      \
{                                                                                   \
    self = [super init];                                                            \
                                                                                    \
    _count = count;                                                                 \
    _capacity = count;                                                              \
    _items = calloc(_capacity, sizeof(T));                                          \
                                                                                    \
    memcpy(_items, array, sizeof(T) * count);                                       \
                                                                                    \
    return self;                                                                    \
}                                                                                   \
                                                                                    \
- (void)addObject: (T)object                                                        \
{                                                                                   \
    if (_count == _capacity) {                                                      \
        _capacity *= 2;                                                             \
        _items = realloc(_items, sizeof(T) * _capacity);                            \
    }                                                                               \
                                                                                    \
    _items[_count++] = object;                                                      \
}                                                                                   \
                                                                                    \
- (void)addObjectsFromArray: (T *)array count: (size_t)count                        \
{                                                                                   \
    if (_count + count > _capacity) {                                               \
        _capacity = _count + count;                                                 \
        _items = realloc(_items, sizeof(T) * _capacity);                            \
    }                                                                               \
                                                                                    \
    memcpy(_items + _count, array, sizeof(T) * count);                              \
    _count += count;                                                                \
}                                                                                   \
                                                                                    \
- (void)insert: (T)object atIndex: (size_t)index                                    \
{                                                                                   \
    if (index > _count)                                                             \
        @throw [OFOutOfRangeException exception];                                   \
                                                                                    \
    if (_count == _capacity) {                                                      \
        _capacity *= 2;                                                             \
        _items = realloc(_items, sizeof(T) * _capacity);                            \
    }                                                                               \
                                                                                    \
    memmove(_items + index + 1, _items + index, sizeof(T) * (_count - index));      \
    _items[index] = object;                                                         \
    _count++;                                                                       \
}                                                                                   \
                                                                                    \
- (void)removeObjectAtIndex: (size_t)index                                          \
{                                                                                   \
    if (index >= _count)                                                            \
        @throw [OFOutOfRangeException exception];                                   \
                                                                                    \
    memmove(_items + index, _items + index + 1, sizeof(T) * (_count - index - 1));  \
    _count--;                                                                       \
}                                                                                   \
                                                                                    \
- (void)removeAllObjects                                                            \
{                                                                                   \
    _count = 0;                                                                     \
}                                                                                   \
                                                                                    \
- (T)objectAtIndex: (size_t)index                                                   \
{                                                                                   \
    if (index >= _count)                                                            \
        @throw [OFOutOfRangeException exception];                                   \
                                                                                    \
    return _items[index];                                                           \
}                                                                                   \
                                                                                    \
- (T)objectAtIndexedSubscript: (size_t)index                                        \
{                                                                                   \
    return [self objectAtIndex: index];                                             \
}                                                                                   \
                                                                                    \
- (void)dealloc                                                                     \
{                                                                                   \
    free(_items);                                                                   \
}                                                                                   \
@end

typedef const char *CString;
typedef char *MutableCString;
typedef const char *WeakCString;
typedef char *MutableWeakCString;

//specialisation, the CStringArray will copy and store its memory in one `const char *`
@interface $CArray(CString) : OFObject {
    @private MutableCString _items;
}
@property(readonly) size_t count;
@property(readonly) size_t capacity;
@property(readonly) CString items; //elements are seperated by '\0'

- (instancetype)init;
- (instancetype)initWithCapacity: (size_t)capacity;
- (instancetype)initWithArray: (CString *)array count: (size_t)count;

- (void)addObject: (CString)object [[clang::objc_direct]];
- (void)addObjectsFromArray: (CString *)array count: (size_t)count [[clang::objc_direct]];
- (void)insert: (CString)object atIndex: (size_t)index [[clang::objc_direct]];
- (void)removeObjectAtIndex: (size_t)index [[clang::objc_direct]];
- (void)removeAllObjects [[clang::objc_direct]];

- (CString)objectAtIndex: (size_t)index [[clang::objc_direct]];
- (CString)objectAtIndexedSubscript: (size_t)index [[clang::objc_direct]];
@end

@interface $CArray(CString)($concat($CArray(CString), Extensions))
- (CString (*)[])toArray [[clang::objc_direct]];
- (MutableCString (*)[])copyToArray [[clang::objc_direct]];
@end

$declare_carray(WeakCString); //this one doesn't copy
$declare_carray(MutableWeakCString);

OF_ASSUME_NONNULL_END
