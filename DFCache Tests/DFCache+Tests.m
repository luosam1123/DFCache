// The MIT License (MIT)
//
// Copyright (c) 2014 Alexander Grebenyuk (github.com/kean).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DFCache+Tests.h"

@implementation DFCache (Tests)

- (void)storeStringsWithCount:(NSUInteger)count strings:(NSDictionary *__autoreleasing *)s {
    NSMutableDictionary *strings = [NSMutableDictionary new];
    for (NSUInteger i = 0; i < count; i++) {
        NSString *key = [NSString stringWithFormat:@"key_%lu", (unsigned long)i];
        NSString *string = [self _randomStringWithLength:(arc4random_uniform(30) + 1)];
        [self storeObject:string forKey:key];
        strings[key] = string;
    }
    *s = strings;
}

- (NSString *)_randomStringWithLength:(NSUInteger)length {
    char data[length];
    for (int x = 0; x < length; x++) {
        data[x] = (char)('A' + arc4random_uniform(26));
    };
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

@end


@implementation TDFCacheUnsupportedDummy {
    NSUUID *_UUID;
    
}

- (instancetype)initWithUUID:(NSUUID *)UUID {
    if (self = [super init]) {
        _UUID = UUID;
    }
    return self;
}

- (instancetype)init {
    return [self initWithUUID:[NSUUID UUID]];
}

- (instancetype)initWithData:(NSData *)data {
    NSString *UUID = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    return [self initWithUUID:[[NSUUID alloc] initWithUUIDString:UUID]];
}

- (BOOL)isEqual:(id)object {
    if (!object) {
        return NO;
    }
    if ([object class] != [self class]) {
        return NO;
    }
    TDFCacheUnsupportedDummy *other = object;
    return [other->_UUID isEqual:_UUID];
}

- (NSData *)dataRepresentation {
    return [[_UUID UUIDString] dataUsingEncoding:NSUTF8StringEncoding];
}

@end


@implementation TDFValueTransformerCacheUnsupportedDummy

- (NSData *)transformedValue:(id)value {
    return value ? [((TDFCacheUnsupportedDummy *)value) dataRepresentation] : nil;
}

- (id)reverseTransfomedValue:(NSData *)data {
    return data ? [[TDFCacheUnsupportedDummy alloc] initWithData:data] : nil;
}

@end
