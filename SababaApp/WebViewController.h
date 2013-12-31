//
//  WebViewController.h
//  SababaApp
//
//  Created by mata on 12/30/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import "TTTAttributedLabel.h"

@interface WebViewController : UIViewController <UIAlertViewDelegate, TTTAttributedLabelDelegate, NSURLConnectionDelegate> {
    NSString *_answerText;
    int _answerNum;
    NSMutableData *_translationData;
}
@property (weak, nonatomic) IBOutlet UILabel *translateLabel;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) TTTAttributedLabel *contentLabel;
@property (strong, nonatomic) UIScrollView *scrollView;

-(void) nextArticle;
-(void) setContent:(NSDictionary *)args;

@end
