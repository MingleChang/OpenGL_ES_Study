//
//  ViewController.m
//  Study09
//
//  Created by mingle on 2017/9/5.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <mach/mach_time.h>

@interface ViewController ()

@property (nonatomic, strong)EAGLContext *context;
@property (nonatomic, assign)GLuint programHandle;

@property (nonatomic, assign)GLKMatrix4 projectionMatrix;
@property (nonatomic, assign)GLKMatrix4 cameraMatrix;
@property (nonatomic, assign)GLKMatrix4 modelMatrix;

@property (nonatomic, assign)GLKVector3 lightDirection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMatrix];
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

- (void)bindAttribs:(GLfloat *)triangleData {
    GLuint positionAttribLocation = glGetAttribLocation(self.programHandle, "position");
    glEnableVertexAttribArray(positionAttribLocation);
    GLuint colorAttribLocation = glGetAttribLocation(self.programHandle, "color");
    glEnableVertexAttribArray(colorAttribLocation);
    GLuint normalAttribLocation = glGetAttribLocation(self.programHandle, "normal");
    glEnableVertexAttribArray(normalAttribLocation);
    
    glVertexAttribPointer(positionAttribLocation, 3, GL_FLOAT, GL_FALSE, 9 * sizeof(GLfloat), (char *)triangleData);
    glVertexAttribPointer(colorAttribLocation, 3, GL_FLOAT, GL_FALSE, 9 * sizeof(GLfloat), (char *)triangleData + 3 * sizeof(GLfloat));
    glVertexAttribPointer(normalAttribLocation, 3, GL_FLOAT, GL_FALSE, 9 * sizeof(GLfloat), (char *)triangleData + 6 * sizeof(GLfloat));
}

- (void)drawXPlanes {
    static GLfloat triangleData[] = {
        //X轴处于0.5f平面
        0.5f,  0.5f,  0.5f, 1, 0, 0, 1, 0, 0,
        0.5f, -0.5f, -0.5f, 1, 0, 0, 1, 0, 0,
        0.5f, -0.5f,  0.5f, 1, 0, 0, 1, 0, 0,
        0.5f,  0.5f,  0.5f, 1, 0, 0, 1, 0, 0,
        0.5f, -0.5f, -0.5f, 1, 0, 0, 1, 0, 0,
        0.5f,  0.5f, -0.5f, 1, 0, 0, 1, 0, 0,
        //X轴处于-0.5f平面
        -0.5f,  0.5f,  0.5f, 1, 0, 0, -1, 0, 0,
        -0.5f, -0.5f, -0.5f, 1, 0, 0, -1, 0, 0,
        -0.5f, -0.5f,  0.5f, 1, 0, 0, -1, 0, 0,
        -0.5f,  0.5f,  0.5f, 1, 0, 0, -1, 0, 0,
        -0.5f, -0.5f, -0.5f, 1, 0, 0, -1, 0, 0,
        -0.5f,  0.5f, -0.5f, 1, 0, 0, -1, 0, 0,
    };
    [self bindAttribs:triangleData];
    glDrawArrays(GL_TRIANGLES, 0, sizeof(triangleData) / 6);
}

- (void)drawYPlanes {
    static GLfloat triangleData[] = {
        //Y轴处于0.5f平面
         0.5f, 0.5f,  0.5f, 0, 1, 0, 0, 1, 0,
        -0.5f, 0.5f, -0.5f, 0, 1, 0, 0, 1, 0,
         0.5f, 0.5f, -0.5f, 0, 1, 0, 0, 1, 0,
         0.5f, 0.5f,  0.5f, 0, 1, 0, 0, 1, 0,
        -0.5f, 0.5f, -0.5f, 0, 1, 0, 0, 1, 0,
        -0.5f, 0.5f,  0.5f, 0, 1, 0, 0, 1, 0,
        //Y轴处于-0.5f平面
         0.5f, -0.5f,  0.5f, 0, 1, 0, 0, -1, 0,
        -0.5f, -0.5f, -0.5f, 0, 1, 0, 0, -1, 0,
         0.5f, -0.5f, -0.5f, 0, 1, 0, 0, -1, 0,
         0.5f, -0.5f,  0.5f, 0, 1, 0, 0, -1, 0,
        -0.5f, -0.5f, -0.5f, 0, 1, 0, 0, -1, 0,
        -0.5f, -0.5f,  0.5f, 0, 1, 0, 0, -1, 0,
    };
    [self bindAttribs:triangleData];
    glDrawArrays(GL_TRIANGLES, 0, sizeof(triangleData) / 6);
}

- (void)drawZPlanes {
    static GLfloat triangleData[] = {
        //Z轴处于0.5f平面
        -0.5f,  0.5f, 0.5f, 0, 0, 1, 0, 0, 1,
        -0.5f, -0.5f, 0.5f, 0, 0, 1, 0, 0, 1,
         0.5f,  0.5f, 0.5f, 0, 0, 1, 0, 0, 1,
        -0.5f, -0.5f, 0.5f, 0, 0, 1, 0, 0, 1,
         0.5f,  0.5f, 0.5f, 0, 0, 1, 0, 0, 1,
         0.5f, -0.5f, 0.5f, 0, 0, 1, 0, 0, 1,
        //Z轴处于-0.5f平面
        -0.5f,  0.5f, -0.5f, 0, 0, 1, 0, 0, -1,
        -0.5f, -0.5f, -0.5f, 0, 0, 1, 0, 0, -1,
         0.5f,  0.5f, -0.5f, 0, 0, 1, 0, 0, -1,
        -0.5f, -0.5f, -0.5f, 0, 0, 1, 0, 0, -1,
         0.5f,  0.5f, -0.5f, 0, 0, 1, 0, 0, -1,
         0.5f, -0.5f, -0.5f, 0, 0, 1, 0, 0, -1,
    };
    [self bindAttribs:triangleData];
    glDrawArrays(GL_TRIANGLES, 0, sizeof(triangleData) / 6);
}
- (void)drawCube {
    [self drawXPlanes];
    [self drawYPlanes];
    [self drawZPlanes];
}

- (void)update {
    uint64_t nanos = mach_absolute_time ();
    GLfloat seconds = (GLfloat)nanos / NSEC_PER_SEC * 10;
    GLfloat varyingFactor = (sin(seconds) + 1) / 2.0;
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2 * (varyingFactor + 1), 0, 0, 0, 0, 1, 0);
    
    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFactor * M_PI * 2, 1, 1, 1);
    self.modelMatrix = rotateMatrix;
}

#pragma mark - Delegate
#pragma mark - GLKView Delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.1, 0.2, 0.3, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glUseProgram(self.programHandle);
    
    
    GLuint projectionMatrixUniformLocation = glGetUniformLocation(self.programHandle, "projectionMatrix");
    glUniformMatrix4fv(projectionMatrixUniformLocation, 1, 0, self.projectionMatrix.m);
    
    GLuint cameraMatrixUniformLocation = glGetUniformLocation(self.programHandle, "cameraMatrix");
    glUniformMatrix4fv(cameraMatrixUniformLocation, 1, 0, self.cameraMatrix.m);
    
    GLuint modelMatrixUniformLocation = glGetUniformLocation(self.programHandle, "modelMatrix");
    glUniformMatrix4fv(modelMatrixUniformLocation, 1, 0, self.modelMatrix.m);
    
    bool canInvert;
    GLKMatrix4 normalMatrix = GLKMatrix4InvertAndTranspose(self.modelMatrix, &canInvert);
    if (canInvert) {
        GLuint modelMatrixUniformLocation = glGetUniformLocation(self.programHandle, "normalMatrix");
        glUniformMatrix4fv(modelMatrixUniformLocation, 1, 0, normalMatrix.m);
    }
    
    GLuint lightDirectionUniformLocation = glGetUniformLocation(self.programHandle, "lightDirection");
    glUniform3fv(lightDirectionUniformLocation, 1, self.lightDirection.v);
    
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
    glEnable(GL_DEPTH_TEST);
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
