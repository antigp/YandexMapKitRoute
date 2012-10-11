//
//  YandexRouteOverlay.h
//  YandexMapKitRoute
//
//  Created by Eugen Antropov on 10/10/12.
//  Copyright (c) 2012 Eugen Antropov. All rights reserved.
//

#import "YMKPinAnnotationView.h"
#import "YMMapOverlayView.h"

@interface YMMapOverlayView(YandexRouteOverlay)
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
@end
