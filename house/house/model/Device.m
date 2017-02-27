#import <Foundation/Foundation.h>
#import "Device.h"

@implementation Device
-(id)initWithDictionary:(NSDictionary*)initializers
{
    self.name=[initializers valueForKey:@"name"];
    
    return self;
}
-(NSString*)formattedWithUnitsAndLastUpdate
{


    return NULL;
}

-(NSString*)getUnits:(NSString*)name
{





return @"";
}
-(NSDictionary*) getDictionary
{
    NSDictionary* map = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.name ?: [NSNull null], @"name"];
    return map;
}
@end
/*
 candela= radiant power
 lux = lumen per square meter
 inverse square law - greater distance from light, less lux
 
 


 
 Illuminance	Example
 120,000 lux	Brightest sunlight
 110,000 lux	Bright sunlight
 20,000 lux	Shade illuminated by entire clear blue sky, midday
 1,000 - 2,000 lux	Typical overcast day, midday
 <200 lux	Extreme of darkest storm clouds, midday
 400 lux	Sunrise or sunset on a clear day (ambient illumination).
 40 lux	Fully overcast, sunset/sunrise
 <1 lux	Extreme of darkest storm clouds, sunset/rise
 For comparison, nighttime illuminance levels are:
 
 Illuminance	Example
 <1 lux	Moonlight[3]
 0.25 lux	Full Moon on a clear night[4][5]
 0.01 lux	Quarter Moon
 0.002 lux	Starlight clear moonless night sky including airglow[4]
 0.0002 lux	Starlight clear moonless night sky excluding airglow[4]
 0.00014 lux	Venus at brightest[4]
 0.0001 lux	Starlight overcast moonless night sky[4]
 
 Since candela and lumen are units that are adjusted to compensate for the varying sensitivity of the human eye to different wavelengths, and IR and UV are totally invisible (by definition) to the human eye, all IR and UV LEDs are automatically zero lumens and zero mcd. These units of measure, used for visible-light LEDs, can't be used for UV and IR LEDs (despite the "3000 mcd IR LED" currently on eBay).
 
 IR and UV LEDs are measured in watts for radiant flux and watts/steradian for radiant intensity. A fairly typical "bright" IR LED will put out about 27 mW/sr, though they go up to 250 mW/sr or so. Signaling LEDs, like for TV remotes, are considerably less powerful.
 */
