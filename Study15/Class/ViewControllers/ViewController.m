//
//  ViewController.m
//  OpenGLES_Template
//
//  Created by mingle on 2017/9/11.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "ViewController.h"
#import "GLContext.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <mach/mach_time.h>
#import "Cylinder.h"

@interface ViewController ()

@property (nonatomic, assign)GLKMatrix4 projectionMatrix;
@property (nonatomic, assign)GLKMatrix4 cameraMatrix;
@property (nonatomic, assign)GLKVector3 lightDirection;

@property (nonatomic, copy)NSArray<GLObject *> *objects;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMatrix];
    [self configureCylinder];
}

#pragma mark - Private


- (void)update {
    [super update];
    GLKVector3 eyePostion = GLKVector3Make(4 * sin(self.elapsedTime), 4 * sin(self.elapsedTime), 4 * cos(self.elapsedTime));
    self.cameraMatrix = GLKMatrix4MakeLookAt(eyePostion.x, eyePostion.y, eyePostion.z, 0, 0, 0, 0, 1, 0);
    [self.objects enumerateObjectsUsingBlock:^(GLObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj update:self.timeSinceLastUpdate];
    }];
}

#pragma mark - Delegate
#pragma mark - GLKView Delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];
    [self.objects enumerateObjectsUsingBlock:^(GLObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.context active];
        [obj.context setUniform1f:@"elapsedTime" value:self.elapsedTime];
        [obj.context setUniformMatrix4fv:@"projectionMatrix" value:self.projectionMatrix];
        [obj.context setUniformMatrix4fv:@"cameraMatrix" value:self.cameraMatrix];
        [obj.context setUniform3fv:@"lightDirection" value:self.lightDirection];
        
        [obj draw:obj.context];
    }];
}
#pragma mark - Configure
- (void)configureMatrix {
    //使用透视投影矩阵
    GLfloat aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 100.0);
    
    //设置摄像机在 0，0，2 坐标，看向 0，0，0点。Y轴正向为摄像机顶部指向的方向
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 1, 6.5, 0, 0, 0, 0, 1, 0);
    
    self.lightDirection = GLKVector3Make(0, -1, 0);
}

- (void)configureCylinder {
    GLKTextureInfo *metal1 = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"metal_01.png"].CGImage options:nil error:nil];
    GLKTextureInfo *metal2 = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"metal_02.jpg"].CGImage options:nil error:nil];
    GLKTextureInfo *metal3 = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"metal_03.png"].CGImage options:nil error:nil];
    
    Cylinder *cylinder1 = [[Cylinder alloc] initWithGLContext:self.glContext sides:4 radius:0.9 height:1.2 texture:metal1];
    cylinder1.modelMatrix = GLKMatrix4MakeTranslation(0, 2, 0);
    
    Cylinder *cylinder2 = [[Cylinder alloc] initWithGLContext:self.glContext sides:16 radius:0.2 height:4.0 texture:metal2];
    
    Cylinder *cylinder3 = [[Cylinder alloc] initWithGLContext:self.glContext sides:4 radius:0.41 height:0.3 texture:metal3];
    cylinder3.modelMatrix = GLKMatrix4MakeTranslation(0, -2, 0);
    
    self.objects = @[cylinder1, cylinder2, cylinder3];
}

@end
