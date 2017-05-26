//
//  ViewController.m
//  CreatUIScrollview
//
//  Created by 董真真 on 17/3/1.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "ViewController.h"
//屏幕的物理宽度
#define     kScreenWidth   [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.textField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
}


#pragma mark -
#pragma mark - Setters && Getters
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200,kScreenWidth, 50)];
        _scrollView.backgroundColor = [UIColor yellowColor];
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.bouncesZoom = NO;
        
    }
    return _scrollView;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 85, 30)];
        _textField.backgroundColor = [UIColor greenColor];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.placeholder = @"添加标签";
        _textField.delegate = self;
       
    }
    return _textField;
}
- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray new];
    }
    return _buttonArray;
}
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray new];
    }
    return _titleArray;
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    if (textField.text.length > 0) {
        [self.titleArray addObject:textField.text];
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.textField.frame = CGRectMake(0, 10, 85, 30);
        [self.scrollView addSubview:self.textField];
        [self addButtonToScorllView];
        textField.text = @"";
    }
      return YES;
}
- (void)textFieldChanged:(UITextField *)textField{
    CGRect tfFrame = self.textField.frame;
    tfFrame.size.width = [self.textField.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width + 10 * 2.0;
    tfFrame.size.width = MAX(tfFrame.size.width, 85);
    self.textField.frame = tfFrame;
    if (tfFrame.size.width + tfFrame.origin.x > self.scrollView.contentSize.width) {
         [self layOutButtons];
    }
}

- (void)addButtonToScorllView{
    [self.buttonArray removeAllObjects];
    if (self.titleArray.count > 0) {
        [self.titleArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [[UIButton alloc]init];
            button.tag = 100 + idx;
            button.backgroundColor = [UIColor redColor];
            [button setTitle:str forState:UIControlStateNormal];
            CGRect btnFrame = CGRectZero;
            btnFrame.size.height = 30;
            btnFrame.size.width = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width ;
            button.frame = btnFrame;
            [button addTarget:self action:@selector(delectSelf:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.scrollView addSubview:button];
            [self.buttonArray addObject:button];
            [self layOutButtons];
        }];
    }else{
        [self.buttonArray removeAllObjects];
    [self layOutButtons];
    }

}
//重新布局
- (void)layOutButtons{
    float offsetX = 10.0,offsetY = 10 ;
   
     self.scrollView.contentSize = CGSizeMake(kScreenWidth,30);
     CGRect tfFrame = self.textField.frame;
    if (self.buttonArray.count > 0) {
        for (int i = 0; i < self.buttonArray.count; i++) {
            UIButton *butt = self.buttonArray[i];
            CGRect frame = butt.frame;
            
            frame.origin.x = offsetX;
            frame.origin.y = offsetY;
            frame.size.height = 30;
            frame.size.width = [butt.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width + 10;
            butt.frame = frame;
            offsetX = offsetX + butt.frame.size.width + 20;
            
        }
       
        tfFrame.origin.x = offsetX + 10;
        tfFrame.origin.y = offsetY;
        self.textField.frame = tfFrame;

    }else{
        tfFrame.origin.x = offsetX ;
        tfFrame.origin.y = offsetY;
        self.textField.frame = tfFrame;

    }
    
    if (tfFrame.origin.x + tfFrame.size.width >= self.scrollView.frame.size.width- 10) {
        self.scrollView.contentSize = CGSizeMake(offsetX + tfFrame.size.width + 30,30);
          [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width- self.scrollView.frame.size.width, 0)];
    }else{
         self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,30);
          [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    [self.textField becomeFirstResponder];
}
//删除自己
- (void)delectSelf:(UIButton *)btn{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(btn.frame.size.width - 10, 0, 20, 20)];
    button.tag = 100 ;
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(sureDelete:) forControlEvents:UIControlEventTouchUpInside];
    [btn addSubview:button];
}
- (void)sureDelete:(UIButton *)buttton{
    UIButton *b = (UIButton *)buttton.superview;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     [self.scrollView addSubview:self.textField];
    [self.titleArray removeObject:b.titleLabel.text];
    [self.buttonArray removeObject:b];
    [self addButtonToScorllView];
}
@end

