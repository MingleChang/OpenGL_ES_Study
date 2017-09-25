//
//  ViewController.m
//  OpenGLES_Template
//
//  Created by mingle on 2017/9/11.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "ViewController.h"
#import "GLContext.h"
#import "Cube.h"

@interface ViewController ()

@property (nonatomic, assign)GLKMatrix4 projectionMatrix;
@property (nonatomic, assign)GLKMatrix4 cameraMatrix;

@property (nonatomic, assign)GLKVector3 lightDirection;

@property (nonatomic, strong)NSMutableArray<Cube *> *cubes;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMatrix];
    [self configureCubes];
}

#pragma mark - Private

- (void)update {
    [super update];
    GLKVector3 eyePosition = GLKVector3Make(2 * sin(self.elapsedTime), 2, 2 * cos(self.elapsedTime));
    self.cameraMatrix = GLKMatrix4MakeLookAt(eyePosition.x, eyePosition.y, eyePosition.z, 0, 0, 0, 0, 1, 0);
    [self.cubes enumerateObjectsUsingBlock:^(Cube * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj update:self.timeSinceLastUpdate];
    }];
}

#pragma mark - Delegate
#pragma mark - GLKView Delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];
    
    [self.cubes enumerateObjectsUsingBlock:^(Cube * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 1000.0);
    
    //设置摄像机在 0，0，2 坐标，看向 0，0，0点。Y轴正向为摄像机顶部指向的方向
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 1, 3, 0, 0, 0, 0, 1, 0);

    self.lightDirection = GLKVector3Make(1, -1, 0);
}

- (void)configureCubes {
    self.cubes = [NSMutableArray array];
    for (int j = -4; j <= 4; ++j) {
        for (int i = -4; i <= 4; ++i) {
            Cube *cube = [[Cube alloc] initWithGLContext:self.glContext];
            cube.modelMatrix = GLKMatrix4MakeTranslation(j * 2, 0, i * 2);
            [self.cubes addObject:cube];
        }
    }
}

@end
