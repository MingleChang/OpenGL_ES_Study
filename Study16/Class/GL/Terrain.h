//
//  Terrain.h
//  Study16
//
//  Created by mingle on 2017/9/26.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "GLObject.h"

@interface Terrain : GLObject

- (instancetype)initWithGLContext:(GLContext *)context
                        heightMap:(UIImage *)image
                             size:(CGSize)terrainSize
                           height:(CGFloat)terrainHeight
                            grass:(GLKTextureInfo *)grassTexture
                             dirt:(GLKTextureInfo *)dirtTexture;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
- (void)draw:(GLContext *)glContext;

@end
