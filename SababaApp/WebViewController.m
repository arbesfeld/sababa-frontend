//
//  WebViewController.m
//  SababaApp
//
//  Created by mata on 12/30/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "WebViewController.h"

#define INSET 5
@interface WebViewController ()

@end

@implementation WebViewController {
    NSDictionary * _args;
    UITouch *_touchLocation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *articles = [_args valueForKey:@"article"];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 280, 0)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:21];
    
    
    _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(20, 60, 280, 0)];
    _contentLabel.font = [UIFont systemFontOfSize:19];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 22, 320, 576)];
    
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 0;
    
    NSString *title = [ articles valueForKey:@"title"];
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    
    int currentHeight = _titleLabel.frame.origin.y + _titleLabel.frame.size.height;
    
    NSArray *item = [articles objectForKey:@"media"];
    for (NSDictionary *media in item) {
        NSString *type = [media objectForKey:@"type"];
        if ([type isEqualToString:@"image"]) {
            NSURL *link = [NSURL URLWithString:[media objectForKey:@"link"]];
            currentHeight = [self addImage:link currentHeight:currentHeight];
            break;
        }
    }
    
    NSString *contentText = [articles valueForKey:@"text"];
    _contentLabel.delegate = self;
    _contentLabel.text = @"Mother hello hi mother"; //contentText;
    [_contentLabel sizeToFit];
    NSString *word = @"mother";
    NSRange range = [_contentLabel.text rangeOfString:word];
    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString *idString = [oNSUUID UUIDString];
    
    NSString *url = [NSString stringWithFormat:@"%@user/%@/translate/%@", BASE_URL, idString, word];
    NSLog(@"Getting %@", url);
    
    [_contentLabel addLinkToURL:[NSURL URLWithString:url ] withRange:range];
    _contentLabel.frame = CGRectMake(20, currentHeight + 80, _contentLabel.frame.size.width, _contentLabel.frame.size.height);
    currentHeight = _contentLabel.frame.origin.y + _contentLabel.frame.size.height;
    
    UIButton *nextArticleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextArticleButton addTarget:self
                          action:@selector(nextArticle)
                    forControlEvents:UIControlEventTouchDown];
    nextArticleButton.frame = CGRectMake(0, currentHeight, 320, 100);
    nextArticleButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [nextArticleButton setTitle:@"Next Article" forState:UIControlStateNormal];
    
    [_scrollView setContentSize:CGSizeMake(320, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 120)];
    [_scrollView addSubview:_titleLabel];
    [_scrollView addSubview:_contentLabel];
    [_scrollView addSubview:nextArticleButton];
    
    [self.view addSubview:_scrollView];
    _translateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _translateLabel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _translateLabel.layer.cornerRadius = 3.0f;
    [_scrollView addSubview:_translateLabel];
    [_scrollView bringSubviewToFront:_translateLabel];
    self.navigationItem.backBarButtonItem = nil;
}
- (void) attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url location:(UITouch *)touch
{
    NSLog(@"Did select link");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    _translationData = [[NSMutableData alloc] init];
    _touchLocation = touch;
    [connection start];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_translationData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Fail");
    _translationData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (!_translationData) {
        NSLog(@"No article data");
        return;
    }
    NSString *stringResult = [[NSString alloc] initWithData:_translationData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", stringResult);
    _translateLabel.text = [NSString stringWithFormat:@"%@",stringResult];
    _translateLabel.textAlignment = NSTextAlignmentCenter;
    [_translateLabel sizeToFit];
    CGPoint origin =[_touchLocation locationInView:_scrollView];
    _translateLabel.frame = CGRectMake(origin.x, origin.y, _translateLabel.frame.size.width, _translateLabel.frame.size.height);
    _translateLabel.hidden = NO;
    
    _translateLabel.frame = CGRectMake(_translateLabel.frame.origin.x - 2*INSET, _translateLabel.frame.origin.y - INSET, _translateLabel.frame.size.width + 4*INSET, _translateLabel.frame.size.height + 2*INSET);
    _translateLabel.layer.borderWidth = 1.0;
    _translateLabel.layer.borderColor = [UIColor blackColor].CGColor;
    [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(fadeTranslateLabel) userInfo:Nil repeats:NO];
}

- (void)fadeTranslateLabel
{
    if (_translateLabel) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{ _translateLabel.alpha = 0;}
                         completion:^(BOOL res){
                             if (res) {
                                 _translateLabel.hidden = YES;
                                 _translateLabel.alpha = 1.0;
                             }
                         }];
    }
}

- (int)addImage:(NSURL *)url currentHeight:(int)currentHeight
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    CGSize size = img.size;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, currentHeight + 40, MIN(280, size.width), size.height)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = img;
    [_scrollView addSubview:imgView];
    return currentHeight + size.height;
}

- (void)nextArticle
{
    [self alert:[_args objectForKey:@"question"]];
}


- (void)alert:(NSDictionary *)question
{
    NSString *headerText = [question objectForKey:@"header"];
    NSString *questionText = [question objectForKey:@"text"];
    
    NSArray *choices = [question objectForKey:@"choices"];
    NSString *message = [NSString stringWithFormat:@"%@", questionText];
    NSArray *choiceArray = [[NSArray alloc] initWithObjects:
                            [NSString stringWithFormat:@"A. %@", choices[0] ],
                            [NSString stringWithFormat:@"B. %@", choices[1] ],
                            [NSString stringWithFormat:@"C. %@", choices[2] ], nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:headerText
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:choiceArray[0], choiceArray[1], choiceArray[2], nil];
    
    _answerText = [question objectForKey:@"answerText"];
    _answerNum = [[question objectForKey:@"answerNum"] intValue];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *finalString = buttonIndex == _answerNum - 1 ? @"correct" : @"incorrect";

    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString *idString = [oNSUUID UUIDString];
    
    NSString *postURL = [NSString stringWithFormat:@"%@user/%@/%@", BASE_URL, idString, finalString];
    
    NSLog(@"POST: %@", postURL);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    [request setHTTPMethod: @"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%@", [response description]);
    }];
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TopicViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)setContent:(NSDictionary *)args
{
    _args = args;
}


@end
