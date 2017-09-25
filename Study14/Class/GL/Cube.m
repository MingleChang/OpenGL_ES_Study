//
//  Cube.m
//  Study13
//
//  Created by mingle on 2017/9/14.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "Cube.h"

@interface Cube ()

@property (nonatomic, assign)GLuint vbo;
@property (nonatomic, assign)GLuint indiceVbo;
@property (nonatomic, assign)GLuint vao;
@property (nonatomic, strong)GLKTextureInfo *diffuseTexture;

@end

@implementation Cube

- (instancetype)initWithGLContext:(GLContext *)context {
    self = [super initWithGLContext:context];
    if (self) {
        [self genTexture:[UIImage imageNamed:@"texture.jpg"]];
        [self genVBO];
        [self getIndiceVBO];
        [self genVAO];
    }
    return self;
}

- (void)dealloc {
    glDeleteBuffers(1, &_vbo);
    glDeleteBuffers(1, &_vao);
}

- (GLfloat *)cubeData {
    static GLfloat cubeData[] = {
        // X轴0.5处的平面
        0.5,  -0.5,    0.5f, 1,  0,  0, 0, 0,
        0.5,  -0.5f,  -0.5f, 1,  0,  0, 0, 1,
        0.5,  0.5f,   -0.5f, 1,  0,  0, 1, 1,
        0.5,  0.5,    -0.5f, 1,  0,  0, 1, 1,
        0.5,  0.5f,    0.5f, 1,  0,  0, 1, 0,
        0.5,  -0.5f,   0.5f, 1,  0,  0, 0, 0,
        // X轴-0.5处的平面
        -0.5,  -0.5,    0.5f, -1,  0,  0, 0, 0,
        -0.5,  -0.5f,  -0.5f, -1,  0,  0, 0, 1,
        -0.5,  0.5f,   -0.5f, -1,  0,  0, 1, 1,
        -0.5,  0.5,    -0.5f, -1,  0,  0, 1, 1,
        -0.5,  0.5f,    0.5f, -1,  0,  0, 1, 0,
        -0.5,  -0.5f,   0.5f, -1,  0,  0, 0, 0,
        
        -0.5,  0.5,  0.5f, 0,  1,  0, 0, 0,
        -0.5f, 0.5, -0.5f, 0,  1,  0, 0, 1,
        0.5f, 0.5,  -0.5f, 0,  1,  0, 1, 1,
        0.5,  0.5,  -0.5f, 0,  1,  0, 1, 1,
        0.5f, 0.5,   0.5f, 0,  1,  0, 1, 0,
        -0.5f, 0.5,  0.5f, 0,  1,  0, 0, 0,
        
        -0.5, -0.5,   0.5f, 0,  -1,  0, 0, 0,
        -0.5f, -0.5, -0.5f, 0,  -1,  0, 0, 1,
        0.5f, -0.5,  -0.5f, 0,  -1,  0, 1, 1,
        0.5,  -0.5,  -0.5f, 0,  -1,  0, 1, 1,
        0.5f, -0.5,   0.5f, 0,  -1,  0, 1, 0,
        -0.5f, -0.5,  0.5f, 0,  -1,  0, 0, 0,
        
        -0.5,   0.5f,  0.5,   0,  0,  1, 0, 0,
        -0.5f,  -0.5f,  0.5,  0,  0,  1, 0, 1,
        0.5f,   -0.5f,  0.5,  0,  0,  1, 1, 1,
        0.5,    -0.5f, 0.5,   0,  0,  1, 1, 1,
        0.5f,  0.5f,  0.5,    0,  0,  1, 1, 0,
        -0.5f,   0.5f,  0.5,  0,  0,  1, 0, 0,
        
        -0.5,   0.5f,  -0.5,   0,  0,  -1, 0, 0,
        -0.5f,  -0.5f,  -0.5,  0,  0,  -1, 0, 1,
        0.5f,   -0.5f,  -0.5,  0,  0,  -1, 1, 1,
        0.5,    -0.5f, -0.5,   0,  0,  -1, 1, 1,
        0.5f,  0.5f,  -0.5,    0,  0,  -1, 1, 0,
        -0.5f,   0.5f,  -0.5,  0,  0,  -1, 0, 0,
    };
    return cubeData;
}

- (GLfloat *)cubeVertex {
    static GLfloat cubeData[] = {
         0.5, -0.5,   0.5f,  0.5773502691896258, -0.5773502691896258,  0.5773502691896258, 0, 0,   // VertexA
         0.5, -0.5f, -0.5f,  0.5773502691896258, -0.5773502691896258, -0.5773502691896258, 0, 1,   // VertexB
         0.5,  0.5f, -0.5f,  0.5773502691896258,  0.5773502691896258, -0.5773502691896258, 1, 1,   // VertexC
         0.5,  0.5f,  0.5f,  0.5773502691896258,  0.5773502691896258,  0.5773502691896258, 1, 0,   // VertexD
        -0.5, -0.5,   0.5f, -0.5773502691896258, -0.5773502691896258,  0.5773502691896258, 0, 0, // VertexE
        -0.5, -0.5f, -0.5f, -0.5773502691896258, -0.5773502691896258, -0.5773502691896258, 0, 1, // VertexF
        -0.5,  0.5f, -0.5f, -0.5773502691896258,  0.5773502691896258, -0.5773502691896258, 1, 1, // VertexG
        -0.5,  0.5f,  0.5f, -0.5773502691896258,  0.5773502691896258,  0.5773502691896258, 1, 0, // VertexH
    };
    return cubeData;
}

- (GLushort *)cubeVertexIndice {
    static GLushort cubeDataIndice[] = {
        0,      // VertexA
        1,      // VertexB
        2,      // VertexC
        2,      // VertexC
        3,      // VertexD
        0,      // VertexA
        
        4,      // VertexE
        5,      // VertexF
        6,      // VertexG
        6,      // VertexG
        7,      // VertexH
        4,      // VertexE
        
        7,      // VertexH
        6,      // VertexG
        2,      // VertexC
        2,      // VertexC
        3,      // VertexD
        7,      // VertexH
        4,      // VertexE
        5,      // VertexF
        1,      // VertexB
        1,      // VertexB
        0,      // VertexA
        4,      // VertexE
        
        7,      // VertexH
        4,      // VertexE
        0,      // VertexA
        0,      // VertexA
        3,      // VertexD
        7,      // VertexH
        6,      // VertexG
        5,      // VertexF
        1,      // VertexB
        1,      // VertexB
        2,      // VertexC
        6,      // VertexG
    };
    return cubeDataIndice;
}

- (void)genVBO {
    glGenBuffers(1, &_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    glBufferData(GL_ARRAY_BUFFER, 8 * 8 * sizeof(GLfloat), [self cubeVertex], GL_STATIC_DRAW);
}

- (void)getIndiceVBO {
    glGenBuffers(1, &_indiceVbo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indiceVbo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 36 * sizeof(GLushort), [self cubeVertexIndice], GL_STATIC_DRAW);
}

- (void)genVAO {
    glGenVertexArraysOES(1, &_vao);
    glBindVertexArrayOES(_vao);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indiceVbo);
    [self.context bindAttribs:NULL];
    
    glBindVertexArrayOES(0);
}

- (void)update:(NSTimeInterval)timeSinceLastUpdate {
    
}

- (void)draw:(GLContext *)glContext {
    [glContext setUniformMatrix4fv:@"modelMatrix" value:self.modelMatrix];
    bool canInvert;
    GLKMatrix4 normalMatrix = GLKMatrix4InvertAndTranspose(self.modelMatrix, &canInvert);
    [glContext setUniformMatrix4fv:@"normalMatrix" value:canInvert ? normalMatrix : GLKMatrix4Identity];
    [glContext bindTexture:self.diffuseTexture to:GL_TEXTURE0 uniformName:@"diffuseMap"];
    [glContext drawTrianglesWithVAO:_vao vertexCount:36];
}
#pragma mark - Texture
- (void)genTexture:(UIImage *)image {
    if (image) {
        NSError *error;
        self.diffuseTexture = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:&error];
    }
}
@end
