//
//  WebViewController.m
//  SababaApp
//
//  Created by mata on 12/30/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController {
    NSDictionary * _args;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"New Article" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 0)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:21];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 280, 0)];
    _contentLabel.font = [UIFont systemFontOfSize:19];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 22, 320, 576)];
    
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 0;
    
    NSString *title = [_args valueForKey:@"title"];
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    
    NSString *contentText = [_args valueForKey:@"text"];
    
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: _contentLabel.textColor,
                              NSFontAttributeName: _contentLabel.font
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:contentText
                                           attributes:attribs];
    
    // Purple and bold text attributes
    UIColor *purpleColor = [UIColor purpleColor];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:_contentLabel.font.pointSize];
    NSRange purpleBoldTextRange = [contentText rangeOfString:@"the"];
    
    [attributedText setAttributes:@{NSForegroundColorAttributeName:purpleColor,
                                    NSFontAttributeName:boldFont}
                            range:purpleBoldTextRange];
    
    _contentLabel.attributedText = attributedText;
    [_contentLabel sizeToFit];
    
    _contentLabel.frame = CGRectMake(20, _titleLabel.frame.size.height + 70, _contentLabel.frame.size.width, _contentLabel.frame.size.height);
    [_scrollView setContentSize:CGSizeMake(320, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 40)];
    [_scrollView addSubview:_titleLabel];
    [_scrollView addSubview:_contentLabel];
    [self.view addSubview:_scrollView];
    
    [[self navigationItem] setBackBarButtonItem: newBackButton];
}

- (IBAction)hi:(id)sender {
    NSLog(@"%f", _contentLabel.frame.size.height);
}
- (void)setContent:(NSDictionary *)args
{
    _args = args;
}


@end
