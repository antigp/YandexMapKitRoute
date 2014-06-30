Installation

0) Install cocoapods http://cocoapods.org/
1) Run "pod install" in root folder
2) To create a static library (*.a file) use YandexMapKitRoute.xcworkspace
3) For sample project run "pod install" in "YandexMapKitRouteExample" folder
4) Run YandexMapKitRouteExample.xcworkspace

For more information about and how get it: YANDEX_DELETED_MAPKIT_V1_URL
Please read: https://github.com/antigp/YandexMapKitRoute/issues/5

USAGE

[YandexMapKitRoute showRouteOnMap:(YMKMapView *)mapView From:(YMKMapCoordinate) coordinateFrom To: (YMKMapCoordinate) coordinateTo];

Work on IOS 5+, if you need early use SBJson