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
// along with 3DTicTacToe.  If not, see <http://www.gnu.org/licenses/>.

#pragma once

#import <ObjFW/ObjFW.h>
#include <raylib.h>

#define nonnil _Nonnull
#define nillable _Nullable
typedef void *nillable nilptr_t;
#define nilptr ((nilptr_t)nil)
#define auto __auto_type

#define $nonnil_begin _Pragma("clang assume_nonnull begin")
#define $nonnil_end _Pragma("clang assume_nonnull end")

