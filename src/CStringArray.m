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

#import "CArray.h"

OF_ASSUME_NONNULL_BEGIN

@implementation $carray_name(CString)

//split the `_items` into an array of strings (by splitting on '\0')
- (CString *)splitIntoArray: (CString *_Nonnull)out [[clang::objc_direct]]
{
    size_t count = 0;

    char *ptr = _items;
    for (size_t i = 0; i < _capacity; i++) {
        if (_items[i] == '\0') {
            out[count++] = ptr;
            ptr = _items + i + 1;
        }
    }

    return out;
}

- (instancetype)init
{
    self = [super init];

    _count = 0;
    _capacity = 0;
    _items = calloc(1, sizeof(char));

    return self;
}

- (instancetype)initWithCapacity: (size_t)capacity
{
    self = [super init];

    _count = 0;
    _capacity = capacity;
    _items = calloc(capacity, sizeof(char));

    return self;
}

- (instancetype)initWithArray: (CString *)array count: (size_t)count
{
    self = [super init];

    //yes this is a VLA
    //shut up
    size_t slens[count];
    size_t total = 0;
    for (size_t i = 0; i < count; i++) {
        slens[i] = strlen(array[i]);
        total += slens[i];
    }

    _count = count; //`_count` is always the  number of strings
    _capacity = total + count; //this is the actual size of the array, we add `count` to account for the '\0' characters

    _items = calloc(_capacity, sizeof(char));
    char *ptr = _items;
    for (size_t i = 0; i < count; i++) {
        memcpy(ptr, array[i], slens[i]);
        ptr += slens[i] + 1; //add 1 to account for the '\0' character, because we used `calloc` its already zeroed
    }
    return self;
}

//additions must require new alloc
- (void)addObject: (CString)object
{
    size_t slen = strlen(object);
    _items = realloc(_items, _capacity + slen + 1);
    memcpy(_items + _capacity, object, slen);
    _capacity += slen;
    _count++;
}

- (void)addObjectsFromArray: (CString *)array count: (size_t)count
{
    size_t total = 0;
    for (size_t i = 0; i < count; i++) {
        total += strlen(array[i]);
    }

    _items = realloc(_items, _capacity + total + 1);
    for (size_t i = 0; i < count; i++) {
        size_t slen = strlen(array[i]);
        memcpy(_items + _capacity, array[i], slen);
        _capacity += slen;
    }
    _count += count;
}

- (void)insert: (CString)object atIndex: (size_t)index
{
    if (index > _count)
        @throw [OFOutOfRangeException exception];

    size_t slen = strlen(object);
    _items = realloc(_items, _capacity + slen + 1);
    memmove(_items + index + 1, _items + index, _capacity - index);
    memcpy(_items + index, object, slen);
    _capacity += slen;
    _count++;
}

- (void)removeObjectAtIndex: (size_t)index
{
    if (index >= _count)
        @throw [OFOutOfRangeException exception];

    size_t slen = strlen(_items + index);
    memmove(_items + index, _items + index + 1, _capacity - index);
    _capacity -= slen;
    _count--;
}

- (void)removeAllObjects
{
    _count = 0;
    _capacity = 0;
    free(_items);
    _items = NULL;
}

- (CString)objectAtIndex: (size_t)index
{
    if (index >= _count)
        @throw [OFOutOfRangeException exception];

    return _items + index;
}

- (CString)objectAtIndexedSubscript:(size_t)index
{
    return [self objectAtIndex: index];
}

- (void)dealloc
{
    free(_items);
}

@end

@implementation $carray_name(CString)($concat($carray_name(CString), Extensions))

- (CString (*)[])toArray
{
    auto ptr = calloc(_count, sizeof(CString));
    if (!ptr)
        @throw [OFOutOfMemoryException exception];
    return (CString (*)[])[self splitIntoArray: ptr];
}

- (MutableCString (*)[])copyToArray
{
    MutableCString (*arr)[_count] = calloc(_count, sizeof(MutableCString));
    if (!arr)
        @throw [OFOutOfMemoryException exception];

    for (size_t i = 0; i < _count; i++) {
        size_t slen = strlen(_items + i);
        (*arr)[i] = calloc(slen + 1, sizeof(char));
        if (!(*arr)[i])
            @throw [OFOutOfMemoryException exception];
        memcpy((*arr)[i], _items + i, slen);
    }

    return arr;
}

@end

$define_carray(WeakCString);
$define_carray(MutableWeakCString);

OF_ASSUME_NONNULL_END
