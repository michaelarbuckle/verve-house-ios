#import <Foundation/Foundation.h>

@interface RuleItem : NSObject
{}
-(id)initWithDictionary:(NSDictionary*)initializers;
-(NSString*)formattedForDrools;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *fieldName;
@property (nonatomic, copy) NSString *op;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *logicalOperator; //eg Sensor AND, OR, XOR, NOT, NAND, NOR, and XNOR
@property (nonatomic, copy) NSString *isOperator;//{,}S

//eg NOT(Sensor(type=CO2, value > 75)) AND
@end
