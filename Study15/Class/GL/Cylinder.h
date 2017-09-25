//
//  Cylinder.h
//  Study15
//
//  Created by mingle on 2017/9/25.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "GLObject.h"

@interface Cylinder : GLObject

@property (nonatomic, assign)GLint sideCount;
@property (nonatomic, assign)GLfloat radius;
@property (nonatomic, assign)GLfloat height;

- (instancetype)initWithGLContext:(GLContext *)context
                            sides:(GLint)sides
                           radius:(GLfloat)radius
                           height:(GLfloat)height
                          texture:(GLKTextureInfo *)texture;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
- (void)draw:(GLContext *)glContext;

@end
