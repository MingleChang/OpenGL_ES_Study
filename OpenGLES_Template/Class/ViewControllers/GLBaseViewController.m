//
//  GLBaseViewController.m
//  OpenGLES_Template
//
//  Created by mingle on 2017/9/12.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "GLBaseViewController.h"
#import "GLContext.h"
//#import <OpenGLES/ES3/gl.h>
//#import <OpenGLES/ES3/glext.h>

@interface GLBaseViewController () <GLKViewDelegate>

@property (nonatomic, strong)EAGLContext *context;

@end

@implementation GLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureContext];
    [self configureGLContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)update {
    NSTimeInterval deltaTime = self.timeSinceLastUpdate;
    self.elapsedTime += deltaTime;
}

#pragma mark - Delegate
#pragma mark - GLKView Delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.glContext active];
    [self.glContext setUniform1f:@"elapsedTime" value:self.elapsedTime];
}

#pragma mark - Configure
- (void)configureContext {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    self.preferredFramesPerSecond = 60;
    if (!self.context) {
        NSLog(@"Failed to create ES context");
        return;
    }
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
//    view.drawableMultisample = GLKViewDrawableMultisample4X;
    [EAGLContext setCurrentContext:self.context];
    
    // 设置OpenGL状态
    glEnable(GL_DEPTH_TEST);
}

- (void)configureGLContext {
    NSString *lVertexPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@"glsl"];
    NSString *lFragmentPath = [[NSBundle mainBundle] pathForResource:@"fragment" ofType:@"glsl"];
    self.glContext = [GLContext contextWithVertexShaderPath:lVertexPath fragmentShaderPath:lFragmentPath];
}

@end
