//
//  GLContext.m
//  OpenGLES_Template
//
//  Created by mingle on 2017/9/12.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "GLContext.h"

@interface GLContext ()

@property (nonatomic, assign)GLuint program;

@end

@implementation GLContext

- (instancetype)initWithVertexShaderSource:(NSString *)vertexShaderSource fragmentShaderSource:(NSString *)fragmentShaderSource {
    self = [super init];
    if (self) {
        [self createProgramWithVertexShaderSource:vertexShaderSource fragmentShaderSource:fragmentShaderSource];
    }
    return self;
}

+ (GLContext *)contextWithVertexShaderSource:(NSString *)vertexShaderSource fragmentShaderSource:(NSString *)fragmentShaderSource {
    return [[GLContext alloc] initWithVertexShaderSource:vertexShaderSource fragmentShaderSource:fragmentShaderSource];
}

+ (GLContext *)contextWithVertexShaderPath:(NSString *)vertexShaderPath fragmentShaderPath:(NSString *)fragmentShaderPath {
    NSString *lVertexShaderSource = [NSString stringWithContentsOfFile:vertexShaderPath encoding:NSUTF8StringEncoding error:nil];
    NSString *lFragmentShaderSource = [NSString stringWithContentsOfFile:fragmentShaderPath encoding:NSUTF8StringEncoding error:nil];
    return [[GLContext alloc] initWithVertexShaderSource:lVertexShaderSource fragmentShaderSource:lFragmentShaderSource];
}

- (void)active {
    glUseProgram(self.program);
}

- (void)drawTriangles:(GLfloat *)triangleData vertexCount:(GLsizei)vertexCount {
    GLuint positionAttribLocation = glGetAttribLocation(self.program, "position");
    glEnableVertexAttribArray(positionAttribLocation);
    GLuint normalAttribLocation = glGetAttribLocation(self.program, "normal");
    glEnableVertexAttribArray(normalAttribLocation);
    GLuint uvAttribLocation = glGetAttribLocation(self.program, "uv");
    glEnableVertexAttribArray(uvAttribLocation);
    
    glVertexAttribPointer(positionAttribLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (char *)triangleData);
    glVertexAttribPointer(normalAttribLocation, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (char *)triangleData + 3 * sizeof(GLfloat));
    glVertexAttribPointer(uvAttribLocation, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (char *)triangleData + 6 * sizeof(GLfloat));
    glDrawArrays(GL_TRIANGLES, 0, vertexCount);
}

#pragma mark - Uniform
- (void)setUniform1i:(NSString *)uniformName value:(GLint)value {
    GLuint location = glGetUniformLocation(self.program, uniformName.UTF8String);
    glUniform1i(location, value);
}

- (void)setUniform1f:(NSString *)uniformName value:(GLfloat)value {
    GLuint location = glGetUniformLocation(self.program, uniformName.UTF8String);
    glUniform1f(location, value);
}

- (void)setUniform3fv:(NSString *)uniformName value:(GLKVector3)value {
    GLuint location = glGetUniformLocation(self.program, uniformName.UTF8String);
    glUniform3fv(location, 1, value.v);
}

- (void)setUniformMatrix4fv:(NSString *)uniformName value:(GLKMatrix4)value {
    GLuint location = glGetUniformLocation(self.program, uniformName.UTF8String);
    glUniformMatrix4fv(location, 1, 0, value.m);
}

#pragma mark - Texture
- (void)bindTexture:(GLKTextureInfo *)textureInfo to:(GLenum)textureChannel uniformName:(NSString *)uniformName {
    glActiveTexture(textureChannel);
    glBindTexture(GL_TEXTURE_2D, textureInfo.name);
    GLuint textureID = (GLuint)textureChannel - (GLuint)GL_TEXTURE0;
    [self setUniform1i:uniformName value:textureID];
}

#pragma mark - Private
- (BOOL)createProgramWithVertexShaderSource:(NSString *)vertexShaderSource fragmentShaderSource:(NSString *)fragmentShaderSource {
    GLuint lVertexShader, lFragmentShader, lProgram;
    const GLchar *lVertexSource = [vertexShaderSource UTF8String];
    const GLchar *lFragmentSource = [fragmentShaderSource UTF8String];
    
    lProgram = glCreateProgram();
    
    if (![self compileShader:&lVertexShader type:GL_VERTEX_SHADER source:lVertexSource]) {
        printf("Failed to compile vertex shader");
        return NO;
    }
    if (![self compileShader:&lFragmentShader type:GL_FRAGMENT_SHADER source:lFragmentSource]) {
        printf("Failed to compile fragment shader");
        return NO;
    }
    
    glAttachShader(lProgram, lVertexShader);
    glAttachShader(lProgram, lFragmentShader);
    
    if (![self linkProgram:lProgram]) {
        NSLog(@"Failed to link program: %d", lProgram);
        if (lVertexShader) {
            glDeleteShader(lVertexShader);
            lVertexShader = 0;
        }
        if (lFragmentShader) {
            glDeleteShader(lFragmentShader);
            lFragmentShader = 0;
        }
        if (lProgram) {
            glDeleteProgram(lProgram);
            lProgram = 0;
        }
    }
    NSLog(@"Effect build success => %d \n", lProgram);
    self.program = lProgram;
    return YES;
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

@end
