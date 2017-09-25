//
//  GLObject.m
//  OpenGLES_Template
//
//  Created by mingle on 2017/9/14.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "GLObject.h"

@implementation GLObject

- (instancetype)initWithGLContext:(GLContext *)context {
    self = [super init];
    if (self) {
        self.context = context;
        self.modelMatrix = GLKMatrix4Identity;
    }
    return self;
}

- (void)update:(NSTimeInterval)timeSinceLastUpdate {
    
}

- (void)draw:(GLContext *)glContext {
    
}

@end
