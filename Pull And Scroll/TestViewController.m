//
//  TestViewController.m
//  Pull And Scroll
//
//  Created by 许明洋 on 2021/1/21.
//

#import "TestViewController.h"
#import "Masonry.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface TestViewController ()

@property (nonatomic, strong) UIView *myView;
@property (nonatomic, assign) CGFloat minViewHeight;
@property (nonatomic, assign) CGFloat maxViewHeight;
@property (nonatomic, strong) UIButton *changeHeightButton;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"测试出现的问题";
    
    //初始化高度
    self.minViewHeight = 200;
    self.maxViewHeight = 400;
    
//    self.myView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.maxViewHeight);
    [self.view addSubview:self.myView];
    [self.myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(CGRectGetWidth(self.view.bounds));
        make.height.mas_equalTo(self.maxViewHeight);
    }];
    
    [self.view addSubview:self.changeHeightButton];
    [self.changeHeightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self addObserve];
}

- (void)addObserve {
    @weakify(self)
    [RACObserve(self.myView, frame) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSLog(@"-----------");
        NSLog(@"当前的myView的高度为%f",self.myView.frame.size.height);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)changeHeightButtonClicked {
    NSLog(@"点击了改变高度的按钮");
    self.myView.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.minViewHeight);
}

- (UIView *)myView {
    if (_myView) {
        return _myView;
    }
    _myView = [[UIView alloc] initWithFrame:CGRectZero];
    _myView.backgroundColor = [UIColor yellowColor];
    return _myView;
}

- (UIButton *)changeHeightButton {
    if (_changeHeightButton) {
        return _changeHeightButton;
    }
    _changeHeightButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_changeHeightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_changeHeightButton setTitle:@"改变MyView高度" forState:UIControlStateNormal];
    [_changeHeightButton addTarget:self action:@selector(changeHeightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    return _changeHeightButton;
}

@end
