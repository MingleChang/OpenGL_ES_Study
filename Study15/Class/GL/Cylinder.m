//
//  Cylinder.m
//  Study15
//
//  Created by mingle on 2017/9/25.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "Cylinder.h"
#import "GLGeometry.h"

@interface Cylinder ()

@property (nonatomic, strong)GLGeometry *topCircle;
@property (nonatomic, strong)GLGeometry *bottomCircle;
@property (nonatomic, strong)GLGeometry *middleCylinder;

@property (nonatomic, strong)GLKTextureInfo *diffuseTexture;

@end

@implementation Cylinder

- (instancetype)initWithGLContext:(GLContext *)context sides:(GLint)sides radius:(GLfloat)radius height:(GLfloat)height texture:(GLKTextureInfo *)texture {
    self = [super initWithGLContext:context];
    if (self) {
        self.sideCount = sides;
        self.radius = radius;
        self.height = height;
        self.diffuseTexture = texture;
    }
    return self;
}

- (GLGeometry *)topCircle {
    if (_topCircle == nil) {
        _topCircle = [[GLGeometry alloc] initWithGeometryType:GLGeometryTypeTriangleFan];
        
        GLfloat y = self.height / 2.0;
        
        GLVertex centerVertex = GLVertexMake(0, y, 0, 0, 1, 0, 0.5, 0.5);
        [_topCircle appendVertex:centerVertex];
        for (GLint i = self.sideCount; i >= 0; --i) {
            GLfloat angle = i / (GLfloat)self.sideCount * M_PI * 2;
            GLVertex vertex = GLVertexMake(cos(angle) * self.radius, y, sin(angle) * self.radius, 0, 1, 0, (cos(angle) + 1 ) / 2.0, (sin(angle) + 1 ) / 2.0);
            [_topCircle appendVertex:vertex];
        }
    }
    return _topCircle;
}

- (GLGeometry *)bottomCircle {
    if (_bottomCircle == nil) {
        _bottomCircle = [[GLGeometry alloc] initWithGeometryType:GLGeometryTypeTriangleFan];
        
        GLfloat y = -self.height / 2.0;
        
        GLVertex centerVertex = GLVertexMake(0, y, 0, 0, -1, 0, 0.5, 0.5);
        [_bottomCircle appendVertex:centerVertex];
        for (GLint i = 0; i <= self.sideCount; ++i) {
            GLfloat angle = i / (GLfloat)self.sideCount * M_PI * 2;
            GLVertex vertex = GLVertexMake(cos(angle) * self.radius, y, sin(angle) * self.radius, 0, -1, 0, (cos(angle) + 1 ) / 2.0, (sin(angle) + 1 ) / 2.0);
            [_bottomCircle appendVertex:vertex];
        }
    }
    return _bottomCircle;
}

- (GLGeometry *)middleCylinder {
    if (_middleCylinder == nil) {
        _middleCylinder = [[GLGeometry alloc] initWithGeometryType:GLGeometryTypeTriangleStrip];
        
        GLfloat yUp = self.height / 2.0;
        GLfloat yDown = -self.height / 2.0;
        for (GLint i = 0; i <= self.sideCount; ++i) {
            GLfloat angle = i / (GLfloat)self.sideCount * M_PI * 2;
            GLKVector3 vertexNormal = GLKVector3Normalize(GLKVector3Make(cos(angle) * self.radius, 0, sin(angle) * self.radius));
            GLVertex vertexUp = GLVertexMake(cos(angle) * self.radius, yUp, sin(angle) * self.radius, vertexNormal.x, vertexNormal.y, vertexNormal.z, i / (GLfloat)self.sideCount, 0);
            GLVertex vertexDown = GLVertexMake(cos(angle) * self.radius, yDown, sin(angle) * self.radius, vertexNormal.x, vertexNormal.y, vertexNormal.z, i / (GLfloat)self.sideCount, 1);
            [_middleCylinder appendVertex:vertexDown];
            [_middleCylinder appendVertex:vertexUp];
        }
    }
    return _middleCylinder;
}

- (void)update:(NSTimeInterval)timeSinceLastUpdate {
    
}

- (void)draw:(GLContext *)glContext {
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    glFrontFace(GL_CCW);
    [glContext setUniformMatrix4fv:@"modelMatrix" value:self.modelMatrix];
    bool canInvert;
    GLKMatrix4 normalMatrix = GLKMatrix4InvertAndTranspose(self.modelMatrix, &canInvert);
    [glContext setUniformMatrix4fv:@"normalMatrix" value:canInvert ? normalMatrix : GLKMatrix4Identity];
    [glContext bindTexture:self.diffuseTexture to:GL_TEXTURE0 uniformName:@"diffuseMap"];
    [glContext drawGeometry:self.topCircle];
    [glContext drawGeometry:self.bottomCircle];
    [glContext drawGeometry:self.middleCylinder];
}

@end
