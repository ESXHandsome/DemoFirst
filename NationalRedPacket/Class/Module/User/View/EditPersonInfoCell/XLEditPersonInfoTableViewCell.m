//
//  XLEditPersonInfoTableViewCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/27.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLEditPersonInfoTableViewCell.h"

@interface XLEditPersonInfoTableViewCell ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UITextField *inputView;
@property (copy, nonatomic) NSString *textFieldText;
@property (strong, nonatomic) UILabel *sexManLabel;
@property (strong, nonatomic) UILabel *sexWomLabel;
@property (strong, nonatomic) UIButton *sexManButton;
@property (strong, nonatomic) UIButton *sexWomButton;
@property (strong, nonatomic) UITextField *introTextField;

@end

@implementation XLEditPersonInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    /**添加子视图*/
    [self addSubview:self.nameLabel];
    [self addSubview:self.inputView];
    [self addSubview:self.tailLabel];
    [self addSubview:self.sexManLabel];
    [self addSubview:self.sexWomLabel];
    [self addSubview:self.sexManButton];
    [self addSubview:self.sexWomButton];
    [self addSubview:self.introTextField];
    
    /**autoLayout 子视图*/
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(adaptHeight1334(16*2));
        make.left.equalTo(self).offset(adaptWidth750(16*2));
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-adaptWidth750(16*2));
        make.top.equalTo(self).offset(adaptHeight1334(16*2));
        make.left.equalTo(self.nameLabel.mas_right).offset(adaptWidth750(16*2));
    }];
    
    [self.tailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-adaptWidth750(16*2));
        make.top.equalTo(self).offset(adaptHeight1334(16*2));
    }];
    
    [self.sexManLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(239*2));
        make.top.equalTo(self).offset(adaptHeight1334(16*2));
    }];
    
    [self.sexManButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexManLabel.mas_right).offset(adaptWidth750(8*2));
        make.top.equalTo(self).offset(adaptHeight1334(15*2));
        make.height.mas_equalTo(adaptHeight1334(24*2));
        make.width.mas_equalTo(adaptWidth750(24*2));
    }];
    
    [self.sexWomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexManButton.mas_right).offset(adaptWidth750(24*2));
        make.top.equalTo(self).offset(adaptHeight1334(16*2));
    }];
    
    [self.sexWomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexWomLabel.mas_right).offset(adaptWidth750(8*2));
        make.top.equalTo(self).offset(adaptHeight1334(15*2));
        make.height.mas_equalTo(adaptHeight1334(24*2));
        make.width.mas_equalTo(adaptWidth750(24*2));
    }];
    
    [self.introTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(adaptHeight1334(8*2));
        make.right.equalTo(self.tailLabel);
    }];
    
    self.inputView.hidden = YES;
    self.tailLabel.hidden = YES;
    self.sexManLabel.hidden = YES;
    self.sexWomLabel.hidden = YES;
    self.sexWomButton.hidden = YES;
    self.sexManButton.hidden = YES;
    self.sexManButton.selected = YES;
    self.introTextField.hidden = YES;
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([self unicodeLengthOfString:textField.text] > 32) {
        textField.text = self.textFieldText;
    } else {
        self.textFieldText = textField.text;
    }
    if ([self.delegate respondsToSelector:@selector(nameFieldDidFinish:)]) {
        [self.delegate nameFieldDidFinish:textField.text];
    }
}

- (void)introTextFieldAction:(UITextField *)textField {
    if ([self unicodeLengthOfString:textField.text] < 61) {
        self.textFieldText = textField.text;
    } else {
        textField.text = self.textFieldText;
    }
    NSInteger length = (unsigned long)[self unicodeLengthOfString:textField.text];
    self.tailLabel.text = [NSString stringWithFormat:@"%ld/30",(long)length/2];

    if ([self.delegate respondsToSelector:@selector(introFieldDidFinish:)]) {
        if (textField.text == 0) {
            textField.text = @"";
        }
        [self.delegate introFieldDidFinish:textField.text];
    }
}

- (void)textFieldBigan:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEdit)]) {
        [self.delegate textFieldDidBeginEdit];
    }
}

- (void)textFieldEnd:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldDidFinidh:)]) {
        [self.delegate textFieldDidFinidh:self.inputView.text];
    }
}

- (void)nameFieldDidFinish:(UITextField *)textField {

}

//按照中文两个字符，英文数字一个字符计算字符数
- (NSUInteger)unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

- (void)configTableViewCell:(PPSMyInfoModel *)model title:(NSString *)title {
    /**应该不存在复用---反正我不想考虑*/
    if ([title isEqualToString:@"昵称"]) {
        self.inputView.hidden = NO;
        if (![model.nickname isEqualToString:@""]) {
            self.inputView.text = model.nickname;
        } else {
            self.inputView.placeholder = @"点击输入名称";
        }
    } else if ([title isEqualToString:@"性别"]) {
        self.sexManLabel.hidden = NO;
        self.sexWomLabel.hidden = NO;
        self.sexWomButton.hidden = NO;
        self.sexManButton.hidden = NO;
        
        if ([model.sex isEqualToString:@"1"]) {
            [self manButtonAction];
        } else {
            [self womenButtonAction];
        }
        
    } else if ([title isEqualToString:@"生日"]) {
        self.tailLabel.hidden = NO;
    
        if (![model.birth isEqualToString:@""]) {
            self.tailLabel.text = model.birth;
        } else {
            self.tailLabel.text = @"选择生日";
        }
        
    } else if ([title isEqualToString:@"地区"]) {
        self.tailLabel.hidden = NO;
        
        if (![model.province isEqualToString:@""]) {
            self.tailLabel.text = [model.province stringByAppendingString:model.city];
        } else {
           self.tailLabel.text = @"选择地区";
        }
        
    } else if ([title isEqualToString:@"签名"]) {
        self.tailLabel.hidden = NO;
        self.introTextField.hidden = NO;
        self.tailLabel.text = @"0/30";
        if (![model.intro isEqualToString:@""]) {
            self.introTextField.text = model.intro;
            NSInteger length = (unsigned long)[self unicodeLengthOfString:model.intro];
            self.tailLabel.text = [NSString stringWithFormat:@"%ld/30",(long)length/2];
        } else {
            self.introTextField.placeholder = @"这个人很懒，还没有设置签名";
        }
    }
    self.nameLabel.text = title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

#pragma mark -
#pragma mark - Button action

- (void)manButtonAction {
    self.sexManButton.selected = YES;
    self.sexWomButton.selected = NO;
    
    [self.sexManLabel setTextColor:GetColor(COLOR04B5E1)];
    [self.sexWomLabel setTextColor:GetColor(COLOR999999)];
    
    if ([self.delegate respondsToSelector:@selector(changeSexFinish:)]) {
        [self.delegate changeSexFinish:@"1"];
    }
    
}

- (void)womenButtonAction {
    self.sexWomButton.selected = YES;
    self.sexManButton.selected = NO;
    
    [self.sexManLabel setTextColor:GetColor(COLOR999999)];
    [self.sexWomLabel setTextColor:GetColor(COLORFB3958)];
    
    if ([self.delegate respondsToSelector:@selector(changeSexFinish:)]) {
        [self.delegate changeSexFinish:@"2"];
    }
}

#pragma mark -
#pragma mark - Lazy load

- (UITextField *)inputView {
    if (!_inputView) {
        _inputView = [[UITextField alloc] init];
        _inputView.placeholder = @"点击输入名称";
        [_inputView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _inputView.textAlignment = NSTextAlignmentRight;
        _inputView.font = [UIFont systemFontOfSize:adaptFontSize(16*2)];
        _inputView.textColor = GetColor(COLOR999999);
        [_inputView addTarget:self action:@selector(nameFieldDidFinish:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _inputView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(16*2) textColorString:COLOR333333];
    }
    return _nameLabel;
}

- (UILabel *)tailLabel {
    if (!_tailLabel) {
        _tailLabel  = [UILabel labWithText:@"选择生日" fontSize:adaptFontSize(16*2) textColorString:COLOR999999];
    }
    return _tailLabel;
}

- (UILabel *)sexManLabel {
    if (!_sexManLabel) {
        _sexManLabel = [UILabel labWithText:@"男" fontSize:adaptFontSize(16*2) textColorString:COLOR04B5E1];
    }
    return _sexManLabel;
}

- (UILabel *)sexWomLabel {
    if (!_sexWomLabel) {
        _sexWomLabel = [UILabel labWithText:@"女" fontSize:adaptFontSize(16*2) textColorString:COLOR999999];
    }
    return _sexWomLabel;
}

- (UIButton *)sexManButton {
    if (!_sexManButton) {
        _sexManButton = [[UIButton alloc] init];
        [_sexManButton setImage:GetImage(@"choose_none") forState:UIControlStateNormal];
        [_sexManButton setImage:GetImage(@"choose_man") forState:UIControlStateSelected];
        _sexManButton.layer.cornerRadius = adaptHeight1334(24);
        _sexManButton.layer.masksToBounds = YES;
        [_sexManButton addTarget:self action:@selector(manButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sexManButton;
}

- (UIButton *)sexWomButton {
    if (!_sexWomButton) {
        _sexWomButton = [[UIButton alloc] init];
        [_sexWomButton setImage:GetImage(@"choose_none") forState:UIControlStateNormal];
        [_sexWomButton setImage:GetImage(@"choose_women") forState:UIControlStateSelected];
        _sexWomButton.layer.cornerRadius = adaptHeight1334(24);
        _sexWomButton.layer.masksToBounds = YES;
        [_sexWomButton addTarget:self action:@selector(womenButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sexWomButton;
}

- (UITextField *)introTextField {
    if (!_introTextField) {
        _introTextField = [[UITextField alloc] init];
        [_introTextField addTarget:self action:@selector(introTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
        [_introTextField addTarget:self action:@selector(textFieldBigan:) forControlEvents:UIControlEventEditingDidBegin];
        [_introTextField addTarget:self action:@selector(textFieldEnd:) forControlEvents:UIControlEventEditingDidEnd];
        _introTextField.textColor = GetColor(COLOR999999);
        _introTextField.font = [UIFont systemFontOfSize:adaptFontSize(14*2)];
        _introTextField.placeholder = @"这个人很懒，还没有设置签名";
    }
    return _introTextField;
}

@end
