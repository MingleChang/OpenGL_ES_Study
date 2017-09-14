//
//  GLBaseViewController.h
//  OpenGLES_Template
//
//  Created by mingle on 2017/9/12.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import <GLKit/GLKit.h>
@class GLContext;

@interface GLBaseViewController : GLKViewController

@property (nonatomic, strong)GLContext *glContext;
@property (assign, nonatomic) GLfloat elapsedTime;

- (void)update;

@end
