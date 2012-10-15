//
//  YandexMapKitRoutaAnnotationView.m
//  YandexMapKitRoute
//
//  Created by Eugen Antropov on 10/10/12.
//  Copyright (c) 2012 Eugen Antropov. All rights reserved.
//

#import "YandexMapKitRouteAnnotationView.h"

@implementation YandexMapKitRouteAnnotationView
@synthesize routeArray,mapView,subImageView;
- (id)init{
    self=[super init];
    if(self){
        
    }
    return self;
}
- (void) initImage{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        self.image=nil;
        float minX=MAXFLOAT;
        float minY=MAXFLOAT;
        float maxX=0;
        float maxY=0;
        float zoomScale = [mapView zoomScale];
        
        self.centerOffset=CGPointMake(0, 0);
        float constantY=2913*1.775*4;
        float constantX=2913*4;
        
        for (NSDictionary * position in routeArray) {
            if([[position objectForKey:@"X"] floatValue]>maxX)
                maxX=[[position objectForKey:@"X"] floatValue];
            if([[position objectForKey:@"Y"] floatValue]>maxY)
                maxY=[[position objectForKey:@"Y"] floatValue];
            if([[position objectForKey:@"X"] floatValue]<minX)
                minX=[[position objectForKey:@"X"] floatValue];
            if([[position objectForKey:@"Y"] floatValue]<minY)
                minY=[[position objectForKey:@"Y"] floatValue];
        }
        maxX=maxX-minX;
        maxY=maxY-minY;
        maxX*=constantX;
        maxY*=constantY;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(maxX, maxY),NO,2.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context, 0,
                              maxY);
        
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetLineWidth(context, 10.0);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5].CGColor);
        
        CGContextMoveToPoint(context, ([[[routeArray objectAtIndex:0] objectForKey:@"X"] floatValue]-minX)*constantX , ([[[routeArray objectAtIndex:0] objectForKey:@"Y"] floatValue]-minY)*constantY);
        for (NSDictionary * position in routeArray) {
            CGContextAddLineToPoint(context, ([[position objectForKey:@"X"] floatValue]-minX)*constantX,([[position objectForKey:@"Y"] floatValue]-minY)*constantY);
        }
        
        CGContextStrokePath(context);
        
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.subImageView=[self.subviews objectAtIndex:0];
        [self.subImageView addObserver:self forKeyPath:@"frame" options:0 context:NULL];
    });
}
- (void) updateImage{
    
    float minX=MAXFLOAT;
    float minY=MAXFLOAT;
    float maxX=0;
    float maxY=0;
    float zoomScale = [mapView zoomScale];
    
    self.centerOffset=CGPointMake(0, 0);
    float constantY=2913*1.775*(21.535057/(mapView.metersInPixel / zoomScale));
    float constantX=2913*(21.535057/(mapView.metersInPixel / zoomScale));
    for (NSDictionary * position in routeArray) {
        if([[position objectForKey:@"X"] floatValue]>maxX)
            maxX=[[position objectForKey:@"X"] floatValue];
        if([[position objectForKey:@"Y"] floatValue]>maxY)
            maxY=[[position objectForKey:@"Y"] floatValue];
        if([[position objectForKey:@"X"] floatValue]<minX)
            minX=[[position objectForKey:@"X"] floatValue];
        if([[position objectForKey:@"Y"] floatValue]<minY)
            minY=[[position objectForKey:@"Y"] floatValue];
    }
    
    maxX=maxX-minX;
    maxY=maxY-minY;
    maxX*=constantX;
    maxY*=constantY;
    
    
    [self setFrame:(CGRect){self.frame.origin,CGSizeMake(maxX, maxY)}];
    [self.subImageView setFrame:(CGRect){CGPointZero,CGSizeMake(maxX, maxY)}];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.subImageView && [keyPath isEqualToString:@"frame"]) {
       
        if(self.frame.size.width!=self.subImageView.frame.size.width||self.frame.size.height!=self.subImageView.frame.size.height){
            [self.subImageView setFrame:(CGRect){CGPointZero,CGSizeMake(self.frame.size.width, self.frame.size.height)}];
        }
    }
}
- (void)logViewHierarchy:(UIView *) view
{
    NSLog(@"%@", view);
    for (UIView *subview in view.subviews)
    {
        [self logViewHierarchy:subview];
    }
}

@end
