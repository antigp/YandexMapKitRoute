Installation:

    0) Install cocoapods http://cocoapods.org/
    1) Run "pod install" in root folder
    2) To create a static library (*.a file) use YandexMapKitRoute.xcworkspace
    3) For sample project run "pod install" in "YandexMapKitRouteExample" folder
    4) In project YandexMapKitRouteExample delete libPods.a from "Linked frameworks and Libraries" (It's already linked in YandexMapKitRoute project from this workspace)
    5) Run YandexMapKitRouteExample.xcworkspace

For more information about "YANDEX_DELETED_MAPKIT_V1_URL" and how get it please read: https://github.com/antigp/YandexMapKitRoute/issues/5

USAGE

[YandexMapKitRoute showRouteOnMap:(YMKMapView *)mapView From:(YMKMapCoordinate) coordinateFrom To: (YMKMapCoordinate) coordinateTo];

Work on IOS 5+, if you need early use SBJson
