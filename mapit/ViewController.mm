//
//  ViewController.m
//  mapit
//
//  Created by chao han on 14-2-28.
//  Copyright (c) 2014年 chao han. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //Add a basemap tiled layer
    NSURL* url = [NSURL URLWithString:@"http://www.arcgisonline.cn/ArcGIS/rest/services/ChinaOnlineStreetColor/MapServer"];
    AGSTiledMapServiceLayer *tiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
    [self.mapView addMapLayer:tiledLayer withName:@"Basemap Tiled Layer"];
    
//    //动态图层，使用ArcGIS Online的全球人口数据
//    NSString *str_URL_1 = @"http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Demographics/ESRI_Population_World/MapServer";
//    NSURL *url_Dynamic =[NSURL URLWithString:str_URL_1];
//    AGSDynamicMapServiceLayer *dynamicLyr =[AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:url_Dynamic];
//    dynamicLyr.opacity = 0.3;
//    [self.mapView addMapLayer:dynamicLyr withName:@"PopulationLayer"];
    

//    //设定地图初始化显示范围为中国
//    AGSEnvelope *chinaEnv = [AGSEnvelope envelopeWithXmin:7800000.00
//                                                    ymin:44000.00
//                                                    xmax:15600000.00
//                                                    ymax:7500000.00
//                                        spatialReference:self.mapView.spatialReference];
//    [self.mapView zoomToEnvelope:chinaEnv animated:YES];
    
    _graphicsLayer=[AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:_graphicsLayer withName:@"GraphicsLayer"];
    
    _sketchLayer= [[AGSSketchGraphicsLayer alloc] initWithGeometry:nil];
    [self.mapView addMapLayer:_sketchLayer withName:@"Sketch layer"];


//    // CLOUD DATA
//    NSURL *featureLayerURL = [NSURL URLWithString:@"http://services.arcgis.com/oKgs2tbjK6zwTdvi/arcgis/rest/services/Major_World_Cities/FeatureServer/0"];
//    AGSFeatureLayer *featureLayer = [AGSFeatureLayer featureServiceLayerWithURL:featureLayerURL mode:AGSFeatureLayerModeOnDemand];
//    [self.mapView addMapLayer:featureLayer withName:@"CloudData"];
//    
//    // SYMBOLOGY
//    AGSSimpleMarkerSymbol *featureSymbol = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor colorWithRed:0 green:0.46 blue:0.68 alpha:1]];
//    featureSymbol.size = CGSizeMake(7,7);
//    featureSymbol.style = AGSSimpleMarkerSymbolStyleCircle;
//    featureSymbol.outline = nil;
//    featureLayer.renderer = [AGSSimpleRenderer simpleRendererWithSymbol:featureSymbol];
    

    self.mapView.layerDelegate = self;
    
    AGSPoint *point = [[AGSPoint alloc] initWithX:0 y:0 spatialReference:_mapView.spatialReference];
    [self.mapView centerAtPoint: point animated:false ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapViewDidLoad:(AGSMapView *) mapView {
    //do something now that the map is loaded
    //for example, show the current location on the map
    [mapView.locationDisplay startDataSource];
    
}

- (IBAction)basemapChanged:(id)sender {
    NSURL* basemapURL ;
    UISegmentedControl* segControl = (UISegmentedControl*)sender;
    AGSLayer *newBasemapLayer = nil;
    switch (segControl.selectedSegmentIndex) {
        case 0: //China
            basemapURL = [NSURL URLWithString:@"http://www.arcgisonline.cn/ArcGIS/rest/services/ChinaOnlineStreetColor/MapServer"];
            newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:basemapURL];
            
            break;
        case 1: //Street
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"];
            newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:basemapURL];
            break;
        case 2: //Imagery
            basemapURL = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer"];
            newBasemapLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:basemapURL];
            break;
        case 3: //OSM
            newBasemapLayer = [[AGSOpenStreetMapLayer alloc]init];
            break;
        default:
            break;
    }
    
    //remove existing basemap layer
    [self.mapView removeMapLayerWithName:@"Basemap Tiled Layer"];
    
    //add new layer
    newBasemapLayer.name = @"Basemap Tiled Layer";
    [self.mapView insertMapLayer:newBasemapLayer atIndex:0];
}

- (IBAction)sketchChanged:(id)sender {
    UISegmentedControl* segControl = (UISegmentedControl*)sender;
    switch ([segControl selectedSegmentIndex]) {
        case 0:
        {
            _mapView.touchDelegate=self;
            _sketchLayer.geometry=nil;
            [_sketchLayer clear];
            break;
        }
        case 1:
        {
            //点
            _sketchLayer.geometry = [[AGSMutablePoint alloc] initWithX:NAN y:NAN spatialReference:_mapView.spatialReference];
            _mapView.touchDelegate=_sketchLayer;
            break;
        }
        case 2:
        {
            //线
            _sketchLayer.geometry = [[AGSMutablePolyline alloc] initWithSpatialReference:_mapView.spatialReference];
            _mapView.touchDelegate=_sketchLayer;
            break;
        }
        case 3:
        {
            //面
            _sketchLayer.geometry = [[AGSMutablePolygon alloc] initWithSpatialReference:_mapView.spatialReference];
            _mapView.touchDelegate=_sketchLayer;
            break;
        }
        default:
            break;
    }
}


//-(void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
//{
//    AGSGeometry* sketchGeometry = [_sketchLayer.geometry copy];
//    _mapView.touchDelegate=_sketchLayer;
//    
//    AGSGraphic *gr=[[AGSGraphic alloc]initWithGeometry:sketchGeometry symbol:nil attributes:nil infoTemplateDelegate:nil];
//    [_graphicsLayer addGraphic:gr];
//    
//}
@end
