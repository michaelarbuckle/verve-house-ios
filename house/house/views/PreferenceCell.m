
#import <Foundation/Foundation.h>

#import "PreferenceCell.h"


@implementation PreferenceCell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    NSLog(@"MeasCell init@ithStyle");
    if (self) {
        // Helpers
        //CGSize size = self.contentView.frame.size;
        
        // Initialize Main Label
       // self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 8.0, size.width - 16.0, size.height - 16.0)];
        
        // Configure Main Label
        [self.name setFont:[UIFont boldSystemFontOfSize:24.0]];
        
        NSMutableString* icon = [NSMutableString stringWithCapacity:20];
        
        [icon appendFormat:@"%@_%@.png",self.name.text,@"green"];
        NSLog(@"image for %@",icon);
        UIImage* iconImage = [UIImage imageNamed:icon];
        self.greenIcon.image = iconImage;
        
       // NSLocalizedString* max = [NSLocalizedStringFromTable(<#key#>, <#tbl#>, <#comment#>);
        
    }
    
    return self;
}

- (void) updateData:(NSArray*)Activity
{
    

    
}

@end
