
#import <Foundation/Foundation.h>

#import "MenuCell.h"



@implementation MenuCell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    NSLog(@"MeasCell init@ithStyle");
    if (self) {
        
        // Add Main Label to Content View
      //  [self.contentView addSubview:self.mainLabel];
    }
    
    return self;
}


@end
