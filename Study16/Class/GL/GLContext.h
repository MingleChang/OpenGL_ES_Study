//
//  GLContext.h
//  OpenGLES_Template
//
//  Created by mingle on 2017/9/12.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>

@class GLGeometry;

@interface GLContext : NSObject

+ (GLContext *)contextWithVertexShaderSource:(NSString *)vertexShaderSource fragmentShaderSource:(NSString *)fragmentShaderSource;
+ (GLContext *)contextWithVertexShaderPath:(NSString *)vertexShaderPath fragmentShaderPath:(NSString *)fragmentShaderPath;

- (void)active;
- (void)bindAttribs:(CGFloat *)triangleData;

//drawTriangles
- (void)drawTriangles:(GLfloat *)triangleData vertexCount:(GLsizei)vertexCount;
- (void)drawTrianglesWithVBO:(GLuint)vbo vertexCount:(GLint)vertexCount;
- (void)drawTrianglesWithVAO:(GLuint)vao vertexCount:(GLint)vertexCount;
- (void)drawGeometry:(GLGeometry *)geometry;

//set Uniform
- (void)setUniform1i:(NSString *)uniformName value:(GLint)value;
- (void)setUniform1f:(NSString *)uniformName value:(GLfloat)value;
- (void)setUniform3fv:(NSString *)uniformName value:(GLKVector3)value;
- (void)setUniformMatrix4fv:(NSString *)uniformName value:(GLKMatrix4)value;

//texture
- (void)bindTexture:(GLKTextureInfo *)textureInfo to:(GLenum)textureChannel uniformName:(NSString *)uniformName;

@end
