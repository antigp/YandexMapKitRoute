//
//  YandexMapKitRouteDelegate.h
//  YandexMapKitRoute
//
//  Created by Eugen Antropov on 10/10/12.
//  Copyright (c) 2012 Eugen Antropov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YandexMapKit.h"


@interface fakeYMKMapView: YMKMapView{
    
}
- (float) zoomScale;
@property (atomic) double metersInPixel;


@end
@class YandexMapKitRouteAnnotationView;
@interface YandexMapKitRouteDelegate : UIViewController<YMKMapViewDelegate>{
    
}

@property (nonatomic) YMKMapView * mapView;
@property (nonatomic) NSObject * oldDelegate;
@property (nonatomic) id<YMKAnnotation> anotation;
@property (nonatomic) YandexMapKitRouteAnnotationView * anotationView;
@end
