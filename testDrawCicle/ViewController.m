//
//  ViewController.m
//  testDrawCicle
//
//  Created by liangzhimy on 2017/9/27.
//  Copyright © 2017年 laig. All rights reserved.
//

#import "ViewController.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ViewController ()
@property (weak) IBOutlet NSImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __block CGFloat process = 0.f;
    [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        process += 0.01;
       self.imageView.image = [self __renderCircleImageRadius:200 process:process strokeWidth:3.f];
        if (process >= 1.f) {
            [timer invalidate];
            return;
        }
    }];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (NSImage *)__renderCircleImageRadius:(CGFloat)radius process:(CGFloat)process strokeWidth:(CGFloat)strokeWidth {
    NSSize imgSize = NSMakeSize(radius * 2, radius * 2);
    NSBitmapImageRep *offscreenRep = [[NSBitmapImageRep alloc]
                                       initWithBitmapDataPlanes:NULL
                                       pixelsWide:imgSize.width
                                       pixelsHigh:imgSize.height
                                       bitsPerSample:8
                                       samplesPerPixel:4
                                       hasAlpha:YES
                                       isPlanar:NO
                                       colorSpaceName:NSDeviceRGBColorSpace
                                       bitmapFormat:NSAlphaFirstBitmapFormat
                                       bytesPerRow:0
                                       bitsPerPixel:0];
    NSGraphicsContext *g = [NSGraphicsContext graphicsContextWithBitmapImageRep:offscreenRep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:g];
    CGContextRef ctx = [g graphicsPort];
    
    if (strokeWidth > 0.f) {
        CGContextSetLineWidth(ctx, strokeWidth);
        CGContextAddArc(ctx, radius - strokeWidth * .5, radius - strokeWidth * .5, radius - strokeWidth * .5, 0, DEGREES_TO_RADIANS(360.f), 1);
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    
    CGContextMoveToPoint(ctx, radius, radius);
    CGFloat endAngle = DEGREES_TO_RADIANS(90.0 - process * 360.0);
    CGFloat startAngle = DEGREES_TO_RADIANS(90.0);
    CGContextAddArc(ctx, radius, radius, radius, startAngle, endAngle, 1);
    CGContextDrawPath(ctx, kCGPathEOFill);
    
    [NSGraphicsContext restoreGraphicsState];
    NSData *data = [offscreenRep representationUsingType:NSPNGFileType properties:@{}];
    NSImage *image = [[NSImage alloc] initWithData:data];
    return image;
}

@end
