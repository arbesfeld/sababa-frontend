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
        self.backgroundColor = [UIColor colorWithWhite:START_COLOR alpha:1.0];
        
    }
    return self;
}

-(void) set:(int)index
{
    _index = index;
    switch (index) {
        case 0:
            _titleLabel.text = @"Sports";
            _imageView.image = [UIImage imageNamed:@"sports-icon.png"];
            
            break;
            
        case 1:
            _titleLabel.text = @"Art";
            _imageView.image = [UIImage imageNamed:@"art-icon.png"];
            
            break;
            
        case 2:
            _titleLabel.text = @"Business";
            _imageView.image = [UIImage imageNamed:@"business-icon.png"];
            
            break;
            
        case 3:
            _titleLabel.text = @"Technology";
            _imageView.image = [UIImage imageNamed:@"technology-icon.png"];
            
            break;
            
        case 4:
            _titleLabel.text = @"Politics";
            _imageView.image = [UIImage imageNamed:@"politics-icon.png"];
            
            break;
            
        case 5:
            _titleLabel.text = @"Health";
            _imageView.image = [UIImage imageNamed:@"health-icon.png"];
            
            break;
            
        case 6:
            _titleLabel.text = @"Entertainment";
            _titleLabel.font = [UIFont systemFontOfSize:11];
            _imageView.image = [UIImage imageNamed:@"movie-icon.png"];
            
            break;
            
        case 7:
            _titleLabel.text = @"Science";
            _imageView.image = [UIImage imageNamed:@"science-icon.png"];
            
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
    self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
}

-(void) selectSpecial
{
    self.backgroundColor = [UIColor colorWithHue:_index/8.0 saturation:0.3 brightness:0.85 alpha:1.0];
}

-(void) deselect
{
    self.backgroundColor = [UIColor colorWithWhite:START_COLOR alpha:1.0];
}

@end
