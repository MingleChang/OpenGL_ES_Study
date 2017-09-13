//
//  Laser.h
//  Study12
//
//  Created by mingle on 2017/9/13.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import <GLKit/GLKit.h>

@class GLContext;

@interface Laser : NSObject

@property (nonatomic, assign)GLfloat life;
@property (nonatomic, assign)GLKVector3 position;
@property (nonatomic, assign)GLKVector3 direction;
@property (nonatomic, assign)GLfloat length;
@property (nonatomic, assign)GLfloat radius;

- (instancetype)initWithLaserImage:(UIImage *)image;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
- (void)draw:(GLContext *)glContext;

@end
