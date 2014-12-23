//
//  NSArray+Helpers.m
//  Muq
//
//  Created by Sergey Petrov on 3/5/14.
//  Copyright (c) 2014 supudo.net. All rights reserved.
//

#import "NSArray+Helpers.h"

@implementation NSArray (Helpers)

- (NSArray *)shuffled {
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self count]];
	for (id anObject in self) {
		NSUInteger randomPos = arc4random() % ([tmpArray count] + 1);
		[tmpArray insertObject:anObject atIndex:randomPos];
	}
	return [NSArray arrayWithArray:tmpArray];
}

@end
