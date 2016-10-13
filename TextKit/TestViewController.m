//
//  TestViewController.m
//  TextKit
//
//  Created by lx on 2016/10/12.
//  Copyright © 2016年 sunshine. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (nonatomic, strong) NSTextContainer *textContainer;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UITextView *textView;


@property (assign, nonatomic) CGPoint gestureStartingPoint;

@property (assign, nonatomic) CGPoint gestureStartingCenter;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanned:)]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect textViewRect = CGRectInset(self.view.bounds, 20, 70);
    
    // 创建一个存储文本的字符和相关属性
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:_textView.text];
    
    // 创建管理类
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    // 关联
    [textStorage addLayoutManager:layoutManager];
    
    _textContainer = [[NSTextContainer alloc] initWithSize:textViewRect.size];
    
    // 关联
    [layoutManager addTextContainer:_textContainer];
    
    
    [_textView removeFromSuperview];
    
    _textView = [[UITextView alloc] initWithFrame:textViewRect textContainer:_textContainer];
    _textView.editable = NO;
//    [self.view addSubview:_textView];
    [self.view insertSubview:_textView belowSubview:_imageView];
    
    
    //设置凸版印刷效果
    [textStorage beginEditing];
    
    //实现设置凸版印刷效果，这些设置代码是需要放在[textStorage beginEditing]和[textStorage endEditing]之间的
    
    [textStorage setAttributedString:[[NSAttributedString alloc] initWithString:_textView.text attributes:@{NSTextEffectAttributeName: NSTextEffectLetterpressStyle}]];
    
    [self makeWord:@"我" inTextStorge:textStorage];
    [self makeWord:@"I" inTextStorge:textStorage];
    
    [textStorage endEditing];
    
    _textView.textContainer.exclusionPaths = @[[self translatedBezierPath]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];   
    
    
}

- (void)makeWord:(NSString *)word inTextStorge:(NSTextStorage *)textStorge
{
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:word options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matches = [regular matchesInString:_textView.text
                                      options:0
                                        range:NSMakeRange(0, [_textView.text length])];
    
    for (NSTextCheckingResult *match in matches) {                                   
        NSRange matchRange = [match range];                                            
        [textStorge addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor] 
                            range:matchRange];  
    }
}

- (UIBezierPath *)translatedBezierPath 
{
    CGRect imageRect = [self.textView convertRect:_imageView.frame fromView:self.view];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:imageRect];
    return path;
}

- (void)preferredContentSizeChanged:(NSNotification *)notification{                
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];    
}

//- (void)imagePanned:(id)sender
//{
//    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
//        UIPanGestureRecognizer *localSender = sender;
//        
//        if (localSender.state == UIGestureRecognizerStateBegan) {
//            self.gestureStartingPoint = [localSender translationInView:self.textView];
//            self.gestureStartingCenter = self.imageView.center;
//        } else if (localSender.state == UIGestureRecognizerStateChanged) {
//            CGPoint currentPoint = [localSender translationInView:self.textView];
//            
//            CGFloat distanceX = currentPoint.x - self.gestureStartingPoint.x;
//            CGFloat distanceY = currentPoint.y - self.gestureStartingPoint.y;
//            
//            CGPoint newCenter = self.gestureStartingCenter;
//            
//            newCenter.x += distanceX;
//            newCenter.y += distanceY;
//            
//            self.imageView.center = newCenter;
//            
//            self.textView.textContainer.exclusionPaths = @[[self translatedBezierPath]];
//        } else if (localSender.state == UIGestureRecognizerStateEnded) {
//            self.gestureStartingPoint = CGPointZero;
//            self.gestureStartingCenter = CGPointZero;
//        }
//    }
//}

@end
