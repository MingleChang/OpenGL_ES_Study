//
//  GLGeometry.m
//  Study15
//
//  Created by mingle on 2017/9/25.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "GLGeometry.h"

@interface GLGeometry ()

@property (nonatomic, assign)GLuint vbo;
@property (nonatomic, assign)BOOL vboValid;
@property (nonatomic, strong)NSMutableData *vertexData;

@end

@implementation GLGeometry

- (instancetype)initWithGeometryType:(GLGeometryType)geometryType {
    self = [super init];
    if (self) {
        self.geometryType = geometryType;
        self.vboValid = NO;
        self.vertexData = [NSMutableData data];
    }
    return self;
}

- (void)dealloc {
    if (_vboValid) {
        glDeleteBuffers(1, &_vbo);
    }
}

- (void)appendVertex:(GLVertex)vertex {
    void *pVertex = (void *)(&vertex);
    NSUInteger size = sizeof(GLVertex);
    [self.vertexData appendBytes:pVertex length:size];
}

- (GLuint)getVBO {
    if (_vboValid == NO) {
        glGenBuffers(1, &_vbo);
        _vboValid = YES;
        glBindBuffer(GL_ARRAY_BUFFER, _vbo);
        glBufferData(GL_ARRAY_BUFFER, [self.vertexData length], self.vertexData.bytes, GL_STATIC_DRAW);
    }
    return _vbo;
}

- (GLsizei)vertexCount {
    return (GLsizei)[self.vertexData length] / sizeof(GLVertex);
}

@end
