//
//  GLGeometry.h
//  Study15
//
//  Created by mingle on 2017/9/25.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "GLObject.h"

typedef NS_ENUM(NSUInteger, GLGeometryType) {
    GLGeometryTypeTriangles,
    GLGeometryTypeTriangleStrip,
    GLGeometryTypeTriangleFan,
};

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
    GLfloat normalX;
    GLfloat normalY;
    GLfloat normalZ;
    GLfloat u;
    GLfloat v;
} GLVertex;

static inline GLVertex GLVertexMake(GLfloat x,
                                    GLfloat y,
                                    GLfloat z,
                                    GLfloat normalX,
                                    GLfloat normalY,
                                    GLfloat normalZ,
                                    GLfloat u,
                                    GLfloat v) {
    GLVertex vertex;
    vertex.x = x;
    vertex.y = y;
    vertex.z = z;
    vertex.normalX = normalX;
    vertex.normalY = normalY;
    vertex.normalZ = normalZ;
    vertex.u = u;
    vertex.v = v;
    return vertex;
}

@interface GLGeometry : GLObject
@property (assign, nonatomic) GLGeometryType geometryType;

- (instancetype)initWithGeometryType:(GLGeometryType)geometryType;
- (void)appendVertex:(GLVertex)vertex;
- (GLuint)getVBO;
- (GLsizei)vertexCount;

@end
