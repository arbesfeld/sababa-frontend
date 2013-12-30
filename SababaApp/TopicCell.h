//
//  TopicCell.h
//  SababaApp
//
//  Created by mata on 12/30/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TopicCell : UICollectionViewCell
{
    int _index;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

-(void) set:(int)index;
-(void) select;
-(void) selectSpecial;
-(void) deselect;

@end
