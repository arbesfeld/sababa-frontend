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
    
    NSTextCheckingResult *result = [NSTextCheckingResult linkCheckingResultWithRange:range URL:[NSURL URLWithString:url ]];
    NSDictionary *attrs = [[NSDictionary alloc] initWithObjectsAndKeys:(id)[UIColor yellowColor].CGColor, kTTTBackgroundFillColorAttributeName, nil];
    [_contentLabel addLinkToURL:[NSURL URLWithString:url ] withRange:range];
    [_contentLabel addLinkWithTextCheckingResult:result attributes:attrs];
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
    [self.view bringSubviewToFront:_translateLabel];
    self.navigationItem.backBarButtonItem = nil;
}
- (void) attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"Did select link");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    _translationData = [[NSMutableData alloc] init];
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
    _translateLabel.text = stringResult;
    [_translateLabel sizeToFit];
    _translateLabel.hidden = NO;
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
