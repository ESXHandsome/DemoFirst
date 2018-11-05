//
//  BaseNewsCell.m
//  WatermelonNews
//
//  Created by sunmingyue on 17/11/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "BaseFeedCell.h"

@interface BaseFeedCell ()

@property (strong, nonatomic) UIView *cellSelectView;
@property (strong, nonatomic) UIView *cellSelectGrayView;
@property (strong, nonatomic) UIView *cellSelectClearView;
@property (strong, nonatomic) XLFeedModel *model;

@end

@implementation BaseFeedCell

#pragma mark -
#pragma mark UI Initialize

- (void)setupViews {
    // 标题
    self.titleLabel = [TTTAttributedLabel new];
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    self.titleLabel.lineSpacing = adaptHeight1334(6);
    self.titleLabel.textColor = [UIColor colorWithString:COLOR1C1C1C];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.fullTextButton];
    
    // 说明
    self.detailLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(24) textColorString:COLOR9D9D9D];
    self.detailLabel.numberOfLines = 1;
    [self.contentView addSubview:self.detailLabel];
    
    // 分隔线
    [self setupSeperatorLine];
    
    // cell选中样式
    [self setupSelectedView];
}

/**
 * 设置分割线
 */
- (void)setupSeperatorLine {
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    [self.contentView addSubview:_lineView];
    
    UILabel *topLineLabel = [UILabel new];
    topLineLabel.backgroundColor = [UIColor colorWithString:COLORE8E8E8];
    [_lineView addSubview:topLineLabel];
    
    UILabel *bottomLineLabel = [UILabel new];
    bottomLineLabel.backgroundColor = [UIColor colorWithString:COLORE8E8E8];
    [_lineView addSubview:bottomLineLabel];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(kSeparatLineHeight);
    }];
    [topLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_top);
        make.left.equalTo(self.lineView.mas_left);
        make.right.equalTo(self.lineView.mas_right);
        make.height.mas_equalTo(adaptHeight1334(0.5));
    }];
    [bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.lineView.mas_left);
        make.right.equalTo(self.lineView.mas_right);
        make.height.mas_equalTo(adaptHeight1334(0.5));
    }];
}

/**
 * 设置cell选中视图样式
 */
- (void)setupSelectedView {
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];//这句不可省略
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithString:COLORF9F8F5];
    
    [self.cellSelectView addSubview:self.cellSelectClearView];
    [self.cellSelectView addSubview:self.cellSelectGrayView];
    self.selectedBackgroundView = self.cellSelectView;;
}

#pragma mark - Event Response

- (void)fullTextButtonDidClickAction {
    if (self.backResult) {
        self.backResult(0);
    }
}

#pragma mark -
#pragma mark Public Method

/**
 * 标记已读
 * @param isRead 是否已读
 */
- (void)setContentDidRead:(BOOL)isRead {
    
//    @weakify(self);
//    
//    [self.titleLabel setText:self.titleLabel.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//        @strongify(self);
//        
//        NSRange topicString = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"#%@#",self.model.topic] options:NSCaseInsensitiveSearch];
//        
//        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor colorWithString:COLOR507daf].CGColor range:topicString];
//        
//        NSRange titleStringRange = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"%@",self.model.title] options:NSCaseInsensitiveSearch];
//        
//        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor colorWithString: isRead ? COLORA9A9A9 : COLOR1C1C1C].CGColor range:titleStringRange];
//        
//        return mutableAttributedString;
//    }
//     ];
}

/**
 * 配置数据
 *
 */
- (void)configModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath {
    _model = model;
    
    [self showTitleWithModel:model];
}

#pragma mark -
#pragma mark Private Method

/**
 * 设置标题
 *
 * @param model item模型
 */
- (void)showTitleWithModel:(XLFeedModel *)model {
    if (!model.title) {
        return;
    }
    
    NSString *title;
   
    if (model.topic.length > 0) {
        title = [NSString stringWithFormat:@"#%@#%@",model.topic, model.title];
    } else {
        title = model.title;
    }
    
    if (model.topic.length > 0) {
        
        [self.titleLabel setText:title afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
          
            NSRange topicString = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"#%@#",model.topic] options:NSCaseInsensitiveSearch];
            
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor colorWithString:COLORFE6969].CGColor range:topicString];
            
            return mutableAttributedString;
        }];
    } else {
        self.titleLabel.text = title;
    }
    [self setContentDidRead:model.isRead];

    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    self.titleLabel.numberOfLines = model.isAllContent ? 0 : 3;
}

- (NSString *)removeSpaceAndNewline:(NSString *)string {
    NSString *temp = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  配置cell选中状态
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.cellSelectGrayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height - kSeparatLineHeight);
    self.cellSelectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    self.cellSelectClearView.frame = CGRectMake(0, self.frame.size.height - kSeparatLineHeight, SCREEN_WIDTH, kSeparatLineHeight);
}

#pragma mark -
#pragma mark Setters and Getters

- (UIView *)cellSelectView {
    if (_cellSelectView == nil) {
        _cellSelectView = [UIView new];
    }
    return _cellSelectView;
}

- (UIView *)cellSelectGrayView {
    if (_cellSelectGrayView == nil) {
        _cellSelectGrayView = [UIView new];
        _cellSelectGrayView.backgroundColor = [UIColor colorWithString:COLORF6F6F6];
    }
    return _cellSelectGrayView;
}

- (UIView *)cellSelectClearView {
    if (_cellSelectClearView == nil) {
        _cellSelectClearView = [UIView new];
        _cellSelectClearView.backgroundColor = [UIColor colorWithString:COLOREFEFEF];
    }
    return _cellSelectClearView;
}

- (UIButton *)fullTextButton {
    if (!_fullTextButton) {
        _fullTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullTextButton setTitle:@"全文" forState:UIControlStateNormal];
        _fullTextButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
        [_fullTextButton setTitleColor:[UIColor colorWithString:COLOR507DAF] forState:UIControlStateNormal];
        [_fullTextButton addTarget:self action:@selector(fullTextButtonDidClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullTextButton;
}

@end
