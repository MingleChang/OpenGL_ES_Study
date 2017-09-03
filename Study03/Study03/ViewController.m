//
//  ViewController.m
//  Study03
//
//  Created by 常峻玮 on 17/9/3.
//  Copyright © 2017年 Mingle. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>


@interface ViewController ()

@property (nonatomic, strong)EAGLContext *context;
@property (nonatomic, assign)GLuint programHandle;
@property (nonatomic, assign)GLfloat elapsedTime;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureContext];
    [self configureProgram];
}

#pragma mark - Private
- (const GLchar *)vertexSource {
    NSString *lVertexPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@"glsl"];
    NSString *lVertexText = [NSString stringWithContentsOfFile:lVertexPath encoding:NSUTF8StringEncoding error:nil];
    return [lVertexText UTF8String];
}

- (const GLchar *)fragmentSource {
    NSString *lFragmentPath = [[NSBundle mainBundle] pathForResource:@"fragment" ofType:@"glsl"];
    NSString *lFragmentText = [NSString stringWithContentsOfFile:lFragmentPath encoding:NSUTF8StringEncoding error:nil];
    return [lFragmentText UTF8String];
}

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
    
    GLuint positionAttribLocation = glGetAttribLocation(self.programHandle, "position");
    glEnableVertexAttribArray(positionAttribLocation);
    GLuint colorAttribLocation = glGetAttribLocation(self.programHandle, "color");
    glEnableVertexAttribArray(colorAttribLocation);
    
    glVertexAttribPointer(positionAttribLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (char *)triangleData);
    glVertexAttribPointer(colorAttribLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (char *)triangleData + 3 * sizeof(GLfloat));
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

#pragma mark - Delegate
#pragma mark - GLKView Delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    self.elapsedTime = self.elapsedTime + 0.1;
    glClearColor(1.0, 0.2, 0.2, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glUseProgram(self.programHandle);
    
    GLuint elapsedTimeUniformLocation = glGetUniformLocation(self.programHandle, "elapsedTime");
    glUniform1f(elapsedTimeUniformLocation, self.elapsedTime);
    
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
    const GLchar *vertexSource = [self vertexSource];
    [self compileShader:&vertexHandle type:GL_VERTEX_SHADER source:vertexSource];
    
    GLuint fragmentHandle;
    const GLchar *fragmentSource = [self fragmentSource];
    [self compileShader:&fragmentHandle type:GL_FRAGMENT_SHADER source:fragmentSource];
    
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
