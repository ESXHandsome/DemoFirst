//
//  NewUserGuideViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NewUserGuideViewController.h"
#import "NewUserGuideChooseViewController.h"

@interface NewUserGuideViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *maleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *femaleImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UIView *otherView2;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UILabel *boyLabel;
@property (weak, nonatomic) IBOutlet UILabel *girlLabel;
@property (assign, nonatomic) Sex sex;

@end

@implementation NewUserGuideViewController

- (IBAction)maleButtonClickedAction:(UIButton *)sender {
    [self changeMaleButtonState];
}

- (IBAction)femaleButtonClickedAction:(UIButton *)sender {
    [self changeFemaleButtonState];
}

- (void)presentController:(Sex)sex {
    self.sex = sex;
    NewUserGuideChooseViewController *controller = [[NewUserGuideChooseViewController alloc] init];
    if (self.sex == male) {
        controller.sex = 1;
    }else{
        controller.sex = 2;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:controller animated:YES completion:nil];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maleImageView.layer.cornerRadius = _maleImageView.height/2;
    self.femaleImageView.layer.cornerRadius = _femaleImageView.height/2;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:(adaptFontSize(23*2))];
    self.titleLabel.textColor = [UIColor colorWithString:COLOR333333];
    self.subTitleLabel.font = [UIFont systemFontOfSize:adaptFontSize(15*2)];
    self.subTitleLabel.textColor = [UIColor colorWithString:COLOR9A9A9A];
    self.otherView.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    self.otherView2.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    self.maleImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *boyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maleImageViewTaped:)];
    [self.maleImageView addGestureRecognizer:boyTap];
    self.femaleImageView.userInteractionEnabled = YES;
     UITapGestureRecognizer *girlTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fimaleImageViewTaped:)];
    [self.femaleImageView addGestureRecognizer:girlTap];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.boyLabel.font = [UIFont systemFontOfSize:adaptFontSize(16*2)];
    self.girlLabel.font = [UIFont systemFontOfSize:adaptFontSize(16*2)];
    self.boyLabel.textColor = [UIColor colorWithString:COLOR666666];
    self.girlLabel.textColor = [UIColor colorWithString:COLOR666666];
    self.maleImageView.image = [UIImage imageNamed:@"cus_man"];
    self.femaleImageView.image = [UIImage imageNamed:@"cus_woman"];
    [self.maleButton setImage:[UIImage imageNamed:@"cus_hook"] forState:UIControlStateNormal];
    [self.femaleButton setImage:[UIImage imageNamed:@"cus_hook"] forState:UIControlStateNormal];
    self.maleButton.userInteractionEnabled = YES;
    self.maleImageView.userInteractionEnabled = YES;
    self.femaleButton.userInteractionEnabled = YES;
    self.femaleImageView.userInteractionEnabled = YES;
    
    [StatServiceApi statEvent:NEW_USER_GENDER_PAGE_PV];
}

- (void)maleImageViewTaped:(UITapGestureRecognizer *)sender {
    [self changeMaleButtonState];
}

- (void)fimaleImageViewTaped:(UITapGestureRecognizer *)sender {
    [self changeFemaleButtonState];
}

- (void)changeMaleButtonState {
    self.maleImageView.image = [UIImage imageNamed:@"cus_man_click"];
    [self.maleButton setImage:[UIImage imageNamed:@"cus_man_hook"] forState:UIControlStateNormal];
    self.boyLabel.textColor = [UIColor colorWithString:COLOR04B5E1];
    [self presentController:male];
    self.maleButton.userInteractionEnabled = NO;
    self.maleImageView.userInteractionEnabled = NO;
}

- (void)changeFemaleButtonState {
    self.femaleImageView.image = [UIImage imageNamed:@"cus_woman_click"];
    [self.femaleButton setImage:[UIImage imageNamed:@"cus_woman_hook"] forState:UIControlStateNormal];
    self.girlLabel.textColor = [UIColor colorWithString:COLORFE2C55];
    self.femaleButton.userInteractionEnabled = NO;
    self.femaleImageView.userInteractionEnabled = NO;
    [self presentController:female];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
}
@end

