 

#import <Foundation/Foundation.h>

@interface Structure : NSObject
{}
-(id)initWithDictionary:(NSDictionary*)initializers;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSMutableArray *plan;
@property (nonatomic, copy) NSString *imageName;
@end
