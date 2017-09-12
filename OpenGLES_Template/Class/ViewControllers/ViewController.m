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

@interface ViewController ()

@property (nonatomic, assign)GLKMatrix4 projectionMatrix;
@property (nonatomic, assign)GLKMatrix4 cameraMatrix;
@property (nonatomic, assign)GLKMatrix4 modelMatrix;

@property (nonatomic, assign)GLKVector3 lightDirection;

@property (strong, nonatomic) GLKTextureInfo *diffuseTexture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMatrix];
    [self getTexture];
}

#pragma mark - Private
- (void)getTexture {
    NSString *lTexturePath = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"jpg"];
    NSError *error;
    self.diffuseTexture = [GLKTextureLoader textureWithContentsOfFile:lTexturePath options:nil error:&error];
}

- (void)drawXPlanes {
    static GLfloat triangleData[] = {
        //X轴处于0.5f平面
        0.5f,  0.5f,  0.5f, 1, 0, 0, 1, 0,
        0.5f, -0.5f, -0.5f, 1, 0, 0, 0, 1,
        0.5f, -0.5f,  0.5f, 1, 0, 0, 0, 0,
        0.5f,  0.5f,  0.5f, 1, 0, 0, 1, 0,
        0.5f, -0.5f, -0.5f, 1, 0, 0, 0, 1,
        0.5f,  0.5f, -0.5f, 1, 0, 0, 1, 1,
        //X轴处于-0.5f平面
        -0.5f,  0.5f,  0.5f, -1, 0, 0, 1, 0,
        -0.5f, -0.5f, -0.5f, -1, 0, 0, 0, 1,
        -0.5f, -0.5f,  0.5f, -1, 0, 0, 0, 0,
        -0.5f,  0.5f,  0.5f, -1, 0, 0, 1, 0,
        -0.5f, -0.5f, -0.5f, -1, 0, 0, 0, 1,
        -0.5f,  0.5f, -0.5f, -1, 0, 0, 1, 1,
    };
    [self.glContext drawTriangles:triangleData vertexCount:sizeof(triangleData) / 8];
}

- (void)drawYPlanes {
    static GLfloat triangleData[] = {
        //Y轴处于0.5f平面
        0.5f, 0.5f,  0.5f, 0, 1, 0, 1, 0,
        -0.5f, 0.5f, -0.5f, 0, 1, 0, 0, 1,
        0.5f, 0.5f, -0.5f, 0, 1, 0, 1, 1,
        0.5f, 0.5f,  0.5f, 0, 1, 0, 1, 0,
        -0.5f, 0.5f, -0.5f, 0, 1, 0, 0, 1,
        -0.5f, 0.5f,  0.5f, 0, 1, 0, 0, 0,
        //Y轴处于-0.5f平面
        0.5f, -0.5f,  0.5f, 0, -1, 0, 1, 0,
        -0.5f, -0.5f, -0.5f, 0, -1, 0, 0, 1,
        0.5f, -0.5f, -0.5f, 0, -1, 0, 1, 1,
        0.5f, -0.5f,  0.5f, 0, -1, 0, 1, 0,
        -0.5f, -0.5f, -0.5f, 0, -1, 0, 0, 1,
        -0.5f, -0.5f,  0.5f, 0, -1, 0, 0, 0,
    };
    [self.glContext drawTriangles:triangleData vertexCount:sizeof(triangleData) / 8];
}

- (void)drawZPlanes {
    static GLfloat triangleData[] = {
        //Z轴处于0.5f平面
        -0.5f,  0.5f, 0.5f, 0, 0, 1, 0, 0,
        -0.5f, -0.5f, 0.5f, 0, 0, 1, 0, 1,
        0.5f,  0.5f, 0.5f, 0, 0, 1, 1, 0,
        -0.5f, -0.5f, 0.5f, 0, 0, 1, 0, 1,
        0.5f,  0.5f, 0.5f, 0, 0, 1, 1, 0,
        0.5f, -0.5f, 0.5f, 0, 0, 1, 1, 1,
        //Z轴处于-0.5f平面
        -0.5f,  0.5f, -0.5f, 0, 0, -1, 0, 0,
        -0.5f, -0.5f, -0.5f, 0, 0, -1, 0, 1,
        0.5f,  0.5f, -0.5f, 0, 0, -1, 1, 0,
        -0.5f, -0.5f, -0.5f, 0, 0, -1, 0, 1,
        0.5f,  0.5f, -0.5f, 0, 0, -1, 1, 0,
        0.5f, -0.5f, -0.5f, 0, 0, -1, 1, 1,
    };
    [self.glContext drawTriangles:triangleData vertexCount:sizeof(triangleData) / 8];
}
- (void)drawCube {
    [self drawXPlanes];
    [self drawYPlanes];
    [self drawZPlanes];
}

- (void)update {
    [super update];
    GLfloat varyingFactor = (sin(self.elapsedTime) + 1) / 2.0;
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2 * (varyingFactor + 1), 0, 0, 0, 0, 1, 0);
    
    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFactor * M_PI * 2, 1, 1, 1);
    self.modelMatrix = rotateMatrix;
}

#pragma mark - Delegate
#pragma mark - GLKView Delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];
    
    [self.glContext setUniformMatrix4fv:@"projectionMatrix" value:self.projectionMatrix];
    [self.glContext setUniformMatrix4fv:@"cameraMatrix" value:self.cameraMatrix];
    [self.glContext setUniformMatrix4fv:@"modelMatrix" value:self.modelMatrix];
    
    
    bool canInvert;
    GLKMatrix4 normalMatrix = GLKMatrix4InvertAndTranspose(self.modelMatrix, &canInvert);
    if (canInvert) {
        [self.glContext setUniformMatrix4fv:@"normalMatrix" value:normalMatrix];
    }
    [self.glContext setUniform3fv:@"lightDirection" value:self.lightDirection];
    [self.glContext bindTexture:self.diffuseTexture to:GL_TEXTURE0 uniformName:@"diffuseMap"];
    
    [self drawCube];
}
#pragma mark - Configure
- (void)configureMatrix {
    //使用透视投影矩阵
    GLfloat aspect = self.view.frame.size.width / self.view.frame.size.height;
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 100.0);
    
    //设置摄像机在 0，0，2 坐标，看向 0，0，0点。Y轴正向为摄像机顶部指向的方向
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2, 0, 0, 0, 0, 1, 0);
    //先初始化正方体的模型矩阵为单位矩阵
    self.modelMatrix = GLKMatrix4Identity;
    self.lightDirection = GLKVector3Make(0, -1, 0);
}

@end
