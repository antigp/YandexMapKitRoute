//
//  YandexMapKitRouteDelegate.h
//  YandexMapKitRoute
//
//  Created by Eugen Antropov on 10/10/12.
//  Copyright (c) 2012 Eugen Antropov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YandexMapKit/YandexMapKit.h"


@interface fakeYMKMapView: YMKMapView{
}
- (float) zoomScale;
@property (atomic) double metersInPixel;
@property (nonatomic) BOOL _performingZoomingAnimation;


@end
@class YandexMapKitRoute;
@interface YandexMapKitRouteDelegate : UIViewController<YMKMapViewDelegate>{
}

@property (nonatomic) YMKMapView * mapView;
@property (nonatomic) id<YMKMapViewDelegate> oldDelegate;
@property (nonatomic) YandexMapKitRoute * route;
@end
