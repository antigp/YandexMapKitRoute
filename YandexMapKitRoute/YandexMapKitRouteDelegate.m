//
//  YandexMapKitRouteDelegate.m
//  YandexMapKitRoute
//
//  Created by Eugen Antropov on 10/10/12.
//  Copyright (c) 2012 Eugen Antropov. All rights reserved.
//

#import "YandexMapKitRouteDelegate.h"
#import "YandexMapKit.h"
#import "YandexMapKitRoute.h"

@implementation YandexMapKitRouteDelegate
@synthesize oldDelegate,mapView;

//Update route view, if scroll or zoom change
- (void)mapViewWasDragged:(fakeYMKMapView *)lomapView{
    CGRect frame=_route.frame;
    frame.origin=_route.YXScrollView.contentOffset;
    _route.frame=frame;
    [_route setNeedsDisplay];
}
- (void)mapView:(fakeYMKMapView *)lomapView regionDidChangeAnimated:(BOOL)animated{
    CGRect frame=_route.frame;
    frame.origin=_route.YXScrollView.contentOffset;
    _route.frame=frame;
    [_route setNeedsDisplay];
}
- (void)mapView:(fakeYMKMapView *)lomapView regionWillChangeAnimated:(BOOL)animated{
    CGRect frame=_route.frame;
    frame.origin=_route.YXScrollView.contentOffset;
    _route.frame=frame;
    [_route setNeedsDisplay];
}

//Send event's for oldDelegate, may be need to write new
#pragma mark Proxy functions
- (void) mapView:(YMKMapView *)lomapView annotationView:(YMKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if([oldDelegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]){
        [oldDelegate  mapView:lomapView annotationView:view calloutAccessoryControlTapped:control];
    }
}

- (void) mapView:(YMKMapView *)lomapView annotationViewCalloutTapped:(YMKAnnotationView *)view{
    if([oldDelegate respondsToSelector:@selector(mapView:annotationViewCalloutTapped:)]){
        [oldDelegate  mapView:lomapView annotationViewCalloutTapped:view];
    }
}
@end
