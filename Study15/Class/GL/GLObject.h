//
//  GLObject.h
//  OpenGLES_Template
//
//  Created by mingle on 2017/9/14.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "GLContext.h"

@interface GLObject : NSObject

@property (nonatomic, strong)GLContext *context;
@property (nonatomic, assign)GLKMatrix4 modelMatrix;

- (instancetype)initWithGLContext:(GLContext *)context;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
- (void)draw:(GLContext *)glContext;

@end
