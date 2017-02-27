#import <Foundation/Foundation.h>
#import "Action.h"

@implementation Action

-(id)initWithName:(NSString*)name type:(NSString*)type image:(NSString*)image
{
    self.name= name;
    self.type= type;
    self.imageName=image ;
    self.timestamp= @"------";
    
    return self;
}

-(id)initWithDictionary:(NSDictionary*)initializers
{
    self.name=[initializers valueForKey:@"name"];
    self.type=[initializers valueForKey:@"type"];
    self.parameters=[initializers valueForKey:@"parameters"];
    self.timestamp=[initializers valueForKey:@"timestamp"];
    
    return self;
}



-(NSDictionary*) getDictionary
{
    NSDictionary* map = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.name ?: [NSNull null], @"name",
                         self.type ?: [NSNull null], @"type",
                         self.parameters ?: [NSNull null], @"parameters",
                         self.timestamp ?: [NSNull null], @"timestamp"];
    return map;
}
@end
