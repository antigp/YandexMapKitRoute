//
//  YandexMapKitRouteDelegate.m
//  YandexMapKitRoute
//
//  Created by Eugen Antropov on 10/10/12.
//  Copyright (c) 2012 Eugen Antropov. All rights reserved.
//

#import "YandexMapKitRouteDelegate.h"
#import "YandexMapKit.h"
#import "YandexMapKitRouteAnnotation.h"
#import "YandexMapKitRouteAnnotationView.h"

@implementation YandexMapKitRouteDelegate
@synthesize oldDelegate,mapView,anotation,anotationView;
- (BOOL)respondsToSelector:(SEL)aSelector{
    //NSLog(@"selector %@",NSStringFromSelector(aSelector));
    return [super respondsToSelector:(SEL)aSelector];
}

- (YMKAnnotationView *)mapView:(fakeYMKMapView *)lomapView viewForAnnotation:(YandexMapKitRouteAnnotation *)anAnnotation {
    
    YandexMapKitRouteAnnotationView * view;
    if([anAnnotation isKindOfClass:[YandexMapKitRouteAnnotation class]]){
        static NSString * identifier = @"routeAnnotation";
        view = (YandexMapKitRouteAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (view == nil) {
            view = [[YandexMapKitRouteAnnotationView alloc] initWithAnnotation:anAnnotation
                                                            reuseIdentifier:identifier];
            view.routeArray=anAnnotation.routeArray;
            [view initImage];
        }
        view.mapView=lomapView;
        [view updateImage];
    }
    else{
        
    }
    
    if(anAnnotation==self.anotation){
        self.anotationView=view;
    }
    return view;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
}
- (void)mapViewWasDragged:(fakeYMKMapView *)lomapView{
    if(lomapView.zoomScale!=prevZoomScale){
        self.anotationView.alpha=0;
    }
    prevZoomScale=lomapView.zoomScale;
   [self.anotationView updateImage];
}
- (void)mapView:(fakeYMKMapView *)lomapView regionDidChangeAnimated:(BOOL)animated{
    [self.anotationView updateImage];
    self.anotationView.alpha=1;
}
- (void)mapView:(fakeYMKMapView *)lomapView regionWillChangeAnimated:(BOOL)animated{
    
}
@end
