//
// SFDelegate2Block.m
//
// Copyright (c) 2013 Viktor Gubriienko. All rights reserved.
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

#import "SFDelegate2Block.h"
#import <objc/runtime.h>

@implementation SFDelegate2Block {
    NSMutableDictionary *_metadata;
    Protocol *_protocol;
}

#pragma mark - Init

- (id)initWithProtocol:(Protocol*)protocol {
    self = [super init];
    if (self) {
        _protocol = protocol;
        _metadata = [NSMutableDictionary new];
    }
    return self;
}

+ (id)delegate2BlockWithProtocol:(Protocol*)protocol {
    return [[self alloc] initWithProtocol:protocol];
}

#pragma mark - Public

- (void)setBlock:(id)block forSelector:(SEL)delegateSelector {
    NSString *selectorString = NSStringFromSelector(delegateSelector);
    [_metadata setValue:[block copy] forKey:selectorString];
}

- (void)removeBlockForSelector:(SEL)delegateSelector {
    NSString *selectorString = NSStringFromSelector(delegateSelector);
    [_metadata removeObjectForKey:selectorString];
}

#pragma mark - NSObject

- (void)forwardInvocation:(NSInvocation *)anInvocation {

    id block = _metadata[NSStringFromSelector(anInvocation.selector)];
    
    if ( block ) {
        [anInvocation invokeWithTarget:block];
    } else {
        [super forwardInvocation:anInvocation];
    }
    
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    
    if (!signature) {
        
        struct objc_method_description method_description;
        method_description = protocol_getMethodDescription(_protocol, selector, NO, NO);
        if ( method_description.name == NULL ) {
            method_description = protocol_getMethodDescription(_protocol, selector, YES, NO);
        }
        if ( method_description.name == NULL ) {
            method_description = protocol_getMethodDescription(_protocol, selector, NO, YES);
        }
        if ( method_description.name == NULL ) {
            method_description = protocol_getMethodDescription(_protocol, selector, YES, YES);
        }
        
        signature = [NSMethodSignature signatureWithObjCTypes:method_description.types];
        
    }
    
    return signature;
    
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ( [super respondsToSelector:aSelector] ) {
        return YES;
    } else  {
        for (NSString *selectorName in _metadata.allKeys) {
            if ( aSelector == NSSelectorFromString(selectorName) ) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [super conformsToProtocol:aProtocol] || aProtocol == _protocol;
}

@end
