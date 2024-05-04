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

#import "GameOptions.h"

$nonnil_begin

@implementation GameOptions {
    OFINICategory *videoSettings;
}

@synthesize path = _path;

- (instancetype)initWithIRI: (OFIRI *)path
{
    self = [super init];

    if (not [OFFileManager.defaultManager fileExistsAtIRI: path]) {
        OFStream *f = [OFIRIHandler openItemAtIRI: path mode: @"w"];
        [f writeString: @"[Video Settings]\nWidth=1680\nHeight=1050\nMax FPS=60\n"];
        [f close];
    }

    _configFile = [OFINIFile fileWithIRI: path];
    videoSettings = [_configFile categoryForName:@"Video Settings"];
    _path = path;

    return self;
}

- (OFIRI *)path
{ return _path; }

- (void)setPath: (OFIRI *)path
{
    [OFFileManager.defaultManager moveItemAtIRI: _path toIRI: path];
    _path = path;
}

- (bool)fullscreen
{
    return [videoSettings boolValueForKey:@"Fullscreen" defaultValue: false];
}

- (void)setFullscreen: (bool)fullscreen
{
    [videoSettings setBoolValue: fullscreen forKey:@"Fullscreen"];
}

- (bool)resizable
{
    return [videoSettings boolValueForKey:@"Resizable" defaultValue: true];
}

- (void)setResizable: (bool)resizable
{
    [videoSettings setBoolValue: resizable forKey:@"Resizable"];
}

- (size_t)width
{
    return [videoSettings longLongValueForKey:@"Width" defaultValue: 1680];
}

- (void)setWidth: (size_t)width
{
    [videoSettings setLongLongValue: width forKey:@"Width"];
}

- (size_t)height
{
    return [videoSettings longLongValueForKey:@"Height" defaultValue: 1050];
}

- (void)setHeight: (size_t)height
{
    [videoSettings setLongLongValue: height forKey:@"Height"];
}

- (size_t)maxFPS
{
    return [videoSettings longLongValueForKey:@"Max FPS" defaultValue: 60];
}

- (void)setMaxFPS: (size_t)maxFPS
{
    [videoSettings setLongLongValue: maxFPS forKey:@"Max FPS"];
}

- (void)save
{
    [_configFile writeToIRI: _path];
}

@end

$nonnil_end
