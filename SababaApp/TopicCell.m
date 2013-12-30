//
//  TopicCell.m
//  SababaApp
//
//  Created by mata on 12/30/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//

#import "TopicCell.h"

#define START_COLOR 0.9

@implementation TopicCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isSelected = NO;
        self.backgroundColor = [UIColor colorWithWhite:START_COLOR alpha:1.0];
        
    }
    return self;
}

-(void) set:(int)index
{
    switch (index) {
        case 0:
            _titleLabel.text = @"Sports";
            _imageView.image = [UIImage imageNamed:@"sports-icon.png"];
            
            break;
        case 1:
            _titleLabel.text = @"Art";
            break;
        case 2:
            _titleLabel.text = @"Business";
            break;
        case 3:
            _titleLabel.text = @"Technology";
            break;
        case 4:
            _titleLabel.text = @"Politics";
            break;
        case 5:
            _titleLabel.text = @"Health";
            break;
        case 6:
            _titleLabel.text = @"Entertainment";
            _titleLabel.font = [UIFont systemFontOfSize:11];
            break;
        case 7:
            _titleLabel.text = @"Science";
            break;
            
        default:
            break;
    }
    
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
}

-(void) select
{
    _isSelected = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
}

-(void) deselect
{
    _isSelected = NO;
    self.backgroundColor = [UIColor colorWithWhite:START_COLOR alpha:1.0];
}

@end
