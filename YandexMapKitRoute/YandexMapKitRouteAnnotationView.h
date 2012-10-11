//
//  YandexMapKitRoutaAnnotationView.h
//  YandexMapKitRoute
//
//  Created by Eugen Antropov on 10/10/12.
//  Copyright (c) 2012 Eugen Antropov. All rights reserved.
//

#import "YMKPinAnnotationView.h"
#import "YandexMapKitRouteDelegate.h"

@interface YandexMapKitRouteAnnotationView : YMKPinAnnotationView
@property (nonatomic) NSArray * routeArray;
@property (nonatomic) fakeYMKMapView * mapView;
- (void) updateImage;
@end
