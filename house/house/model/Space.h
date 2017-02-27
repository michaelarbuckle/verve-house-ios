 

#import <Foundation/Foundation.h>

@interface Space : NSObject
{}
-(id)initWithDictionary:(NSDictionary*)initializers;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSMutableArray *plan;
@property (nonatomic, copy) NSString *href;
@end
