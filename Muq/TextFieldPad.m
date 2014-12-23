//
//  TextFieldPad.m
//  Pixelffector
//
//  Created by Sergey Petrov on 2/20/14.
//  Copyright (c) 2014 supudo.net. All rights reserved.
//

#import "TextFieldPad.h"

@implementation TextFieldPad

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 4, 4);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 4, 4);
}

@end
