//
//  ViewController.m
//  Study01
//
//  Created by 常峻玮 on 17/9/2.
//  Copyright © 2017年 Mingle. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

#define STRINGIZE(x)    #x
#define SHADER_STRING(text) @ STRINGIZE(text)

//顶点着色器
const char *kVertexShader = STRINGIZE(
    attribute vec4 position;
    attribute vec4 color;

    varying vec4 fragColor;

    void main(void) {
        fragColor = color;
        gl_Position = position;
    }
);
//片元着色器
const char *kFragmentShader = STRINGIZE(
    varying lowp vec4 fragColor;

    void main(void) {
        gl_FragColor = fragColor;
    }
);

@interface ViewController ()

@property (nonatomic, strong)EAGLContext *context;
@property (nonatomic, assign)GLuint programHandle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureContext];
    [self configureProgram];
}

#pragma mark - Private
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(const GLchar *)source {
    if (!source) {
        NSLog(@"Failed to load shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, 0);
    glCompileShader(*shader);
#if Debug
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s\n", log);
        NSLog(@"Shader:\n%s\n", source);
        free(log);
    }
#endif
    
    GLint compileResult;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &compileResult);
    if (compileResult == GL_FALSE) {
        glDeleteShader(*shader);
        return NO;
    }
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog {
    glLinkProgram(prog);
#if Debug
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    GLint linkResult;
    glGetProgramiv(prog, GL_LINK_STATUS, &linkResult);
    if (linkResult == GL_FALSE) {
        return NO;
    }
    
    return YES;
}

- (void)drawTriangle {
    static GLfloat triangleData[18] = {
        0,      0.5f,  0,  1,  0,  0, // x, y, z, r, g, b,每一行存储一个点的信息，位置和颜色
        -0.5f, -0.5f,  0,  0,  1,  0,
        0.5f,  -0.5f,  0,  0,  0,  1,
    };
    
    // 启用Shader中的两个属性
    // attribute vec4 position;
    // attribute vec4 color;
    GLuint positionAttribLocation = glGetAttribLocation(self.programHandle, "position");
    glEnableVertexAttribArray(positionAttribLocation);
    GLuint colorAttribLocation = glGetAttribLocation(self.programHandle, "color");
    glEnableVertexAttribArray(colorAttribLocation);
    
    // 为shader中的position和color赋值
    // glVertexAttribPointer (GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* ptr)
    // indx: 上面Get到的Location
    // size: 有几个类型为type的数据，比如位置有x,y,z三个GLfloat元素，值就为3
    // type: 一般就是数组里元素数据的类型
    // normalized: 暂时用不上
    // stride: 每一个点包含几个byte，本例中就是6个GLfloat，x,y,z,r,g,b
    // ptr: 数据开始的指针，位置就是从头开始，颜色则跳过3个GLFloat的大小
    glVertexAttribPointer(positionAttribLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (char *)triangleData);
    glVertexAttribPointer(colorAttribLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (char *)triangleData + 3 * sizeof(GLfloat));
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}
#pragma mark - Delegate
#pragma mark - GLKView Delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 0.2, 0.2, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glUseProgram(self.programHandle);
    [self drawTriangle];
}



#pragma mark - Configure
- (void)configureContext {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
        return;
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:self.context];
}

- (void)configureProgram {
    GLuint vertexHandle;
    [self compileShader:&vertexHandle type:GL_VERTEX_SHADER source:kVertexShader];
    
    GLuint fragmentHandle;
    [self compileShader:&fragmentHandle type:GL_FRAGMENT_SHADER source:kFragmentShader];
    
    self.programHandle = glCreateProgram();
    glAttachShader(self.programHandle, vertexHandle);
    glAttachShader(self.programHandle, fragmentHandle);
    if (![self linkProgram:self.programHandle]) {
        NSLog(@"Failed to link program: %d", self.programHandle);
        if (vertexHandle) {
            glDeleteShader(vertexHandle);
            vertexHandle = 0;
        }
        if (fragmentHandle) {
            glDeleteShader(fragmentHandle);
            fragmentHandle = 0;
        }
        if (self.programHandle) {
            glDeleteProgram(self.programHandle);
            self.programHandle = 0;
        }
    }
}
@end
