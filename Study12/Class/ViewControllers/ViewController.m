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
#import "Laser.h"

@interface ViewController ()

@property (nonatomic, assign)GLKMatrix4 projectionMatrix;
@property (nonatomic, assign)GLKMatrix4 cameraMatrix;

@property (nonatomic, assign)GLKVector3 lightDirection;


@property (nonatomic, strong)GLContext *laserContext;

@property (nonatomic, copy)NSArray<Laser *> *lasers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMatrix];
    [self configureLaserGLContext];
    [self configureLasers];
}

#pragma mark - Private

- (void)update {
    [super update];
    [self.lasers enumerateObjectsUsingBlock:^(Laser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj update:self.timeSinceLastUpdate];
    }];
}

#pragma mark - Delegate
#pragma mark - GLKView Delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];
    
    [self.laserContext active];
    [self.laserContext setUniform1f:@"elapsedTime" value:self.elapsedTime];
    [self.laserContext setUniformMatrix4fv:@"projectionMatrix" value:self.projectionMatrix];
    [self.laserContext setUniformMatrix4fv:@"cameraMatrix" value:self.cameraMatrix];
    
    [self.laserContext setUniform3fv:@"lightDirection" value:self.lightDirection];
    
    [self.lasers enumerateObjectsUsingBlock:^(Laser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj draw:self.laserContext];
    }];
}
#pragma mark - Configure
- (void)configureMatrix {
    //使用透视投影矩阵
    GLfloat aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 100.0);
    
    //设置摄像机在 0，0，2 坐标，看向 0，0，0点。Y轴正向为摄像机顶部指向的方向
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2, 0, 0, 0, 0, 1, 0);
    self.lightDirection = GLKVector3Make(0, -1, 0);
}

- (void)configureLaserGLContext {
    NSString *lVertexPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@"glsl"];
    NSString *lFragmentPath = [[NSBundle mainBundle] pathForResource:@"fragment_laser" ofType:@"glsl"];
    self.laserContext = [GLContext contextWithVertexShaderPath:lVertexPath fragmentShaderPath:lFragmentPath];
}

- (void)configureLasers {
    Laser *laser1 = [[Laser alloc] initWithLaserImage:[UIImage imageNamed:@"laser.png"]];
    laser1.position = GLKVector3Make(0, 0, -40);
    laser1.direction = GLKVector3Make(0.08, 0.08, 1);
    laser1.length = 60;
    laser1.radius = 1;
    
    Laser *laser2 = [[Laser alloc] initWithLaserImage:[UIImage imageNamed:@"laser.png"]];
    laser2.position = GLKVector3Make(0, 0, -40);
    laser2.direction = GLKVector3Make(0.08, 0.08, 1);
    laser2.length = 60;
    laser2.radius = 1;
    
    Laser *laser3 = [[Laser alloc] initWithLaserImage:[UIImage imageNamed:@"laser.png"]];
    laser3.position = GLKVector3Make(0, 0, -40);
    laser3.direction = GLKVector3Make(0.08, 0.08, 1);
    laser3.length = 60;
    laser3.radius = 1;
    
    Laser *laser4 = [[Laser alloc] initWithLaserImage:[UIImage imageNamed:@"laser.png"]];
    laser4.position = GLKVector3Make(0, 0, -40);
    laser4.direction = GLKVector3Make(0.08, 0.08, 1);
    laser4.length = 60;
    laser4.radius = 1;
    
    self.lasers = @[laser1,laser2,laser3,laser4];
}

@end
