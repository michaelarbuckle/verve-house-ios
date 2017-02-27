#import <UIKit/UIKit.h>
#import "DemoBaseViewController.h"
#import <Charts/Charts.h>
#import "ChartConstants.h"
#import "Measurand.h"
#import "MeasurableSeries.h"
@interface SensorChartViewController : DemoBaseViewController
//@property (nonatomic, assign) enum timescale scale;


- (void)setMeasurand:(Measurand*) measurand series:(MeasurableSeries*)series;

@end
