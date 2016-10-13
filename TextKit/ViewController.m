//
//  ViewController.m
//  TextKit
//
//  Created by lx on 2016/10/12.
//  Copyright © 2016年 sunshine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    
    //设置text
    NSString *str1 = @"Life isn’t always beautiful, but the struggles make you stronger, the changes make you wiser.";
    NSString *str2 = @"生活不一定是一直美好的，但是那些挣扎可以让你变得更坚强，那些改变可以让你变得更有智慧。";
    NSString *str3 = @"早安！星期一！";
    NSString *str4 = @"输入错误的删除线";
    
    
    [string.mutableString appendFormat:@"%@", str1];
    [string.mutableString appendFormat:@"%@", str2];
    [string.mutableString appendFormat:@"%@", str3];
    [string.mutableString appendFormat:@"%@", str4];
    
  
    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor blueColor]} range:NSMakeRange(0, str1.length)];
    [string addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternDash)} range:NSMakeRange([str1 length], [str2 length])];
    [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]} range:NSMakeRange([str1 length] + [str2 length], [str3 length])];
    [string addAttributes:@{NSStrikethroughStyleAttributeName: @1, NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange([str1 length] + [str2 length] + [str3 length], [str4 length])];
    
    self.textView.attributedText = string;
    
    [self setParagraph];
    [self setAttachment];
    [self setupLinks];
}


//设置样式
- (void)setParagraph
{
    NSMutableAttributedString *string = [self.textView.attributedText mutableCopy];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 10.f;
    style.lineBreakMode = NSLineBreakByWordWrapping;//换行模式
    style.paragraphSpacing = 20.f;
    style.paragraphSpacingBefore = 10.f;
    style.lineHeightMultiple = 1.0;
    style.maximumLineHeight = 30.f;
    style.alignment = NSTextAlignmentLeft;
    [string addAttributes:@{NSParagraphStyleAttributeName : style} range:NSMakeRange(0, [string length])];
    self.textView.attributedText = string;
}

//添加附件
- (void)setAttachment
{
    NSMutableAttributedString *string = [self.textView.attributedText mutableCopy];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"delete"];
    attachment.bounds = CGRectMake(0, 0, 50, 50);
    [string insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:30];
    self.textView.attributedText = string;
}

- (void)setupLinks
{
    NSMutableAttributedString *string = [self.textView.attributedText mutableCopy];
    
    NSAttributedString *arrString = [[NSAttributedString alloc] initWithString:@"#百度#" attributes:@{NSForegroundColorAttributeName: [UIColor blueColor]}];
    
    [string insertAttributedString:arrString atIndex:0];
    
    [string addAttributes:@{NSLinkAttributeName: [NSURL URLWithString:@"http//www.baidu.com"]} range:NSMakeRange(0, [arrString length])];
    
    self.textView.attributedText = string;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    return YES;
}

@end
