//
//  TextBubbleView.h
//  Tabby
//
//  Created by Michael Arbuckle on 11/23/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#ifndef TextBubbleView_h
#define TextBubbleView_h

@protocol ExpandingTableCellDelegate <NSObject> 
    -(void)updateCellHeight: NSIndexPath, comment:(NSString*)comment
@end
#endif /* TextBubbleView_h */
