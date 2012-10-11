//
//  YandexRouteOverlay.m
//  YandexMapKitRoute
//
//  Created by Eugen Antropov on 10/10/12.
//  Copyright (c) 2012 Eugen Antropov. All rights reserved.
//

#import "YandexRouteOverlay.h"

@implementation YMMapOverlayView(YandexRouteOverlay)
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"observe");
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
}

@end
