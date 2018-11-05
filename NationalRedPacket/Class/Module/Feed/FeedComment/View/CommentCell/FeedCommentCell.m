//
//  FeedCommentCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedCommentCell.h"
#import "TTTAttributedLabel.h"
#import "LikeParticleEmissionButton.h"
#import "FLAnimatedImageView.h"
#import "NSDate+Timestamp.h"
#import "UIImage+Tool.h"
#import "NSString+NumberAdapt.h"
#import "LikeAnimationButton.h"

@interface FeedCommentCell () <TTTAttributedLabelDelegate,LikeAnimationButtonDelegate, XLMenuAttributedLabelDelegate>

@property (strong, nonatomic) UIImageView                *crownImageView;
@property (strong, nonatomic) UIImageView                *watermarkImageView;
@property (strong, nonatomic) UIButton                   *fullTextButton;
@property (strong, nonatomic) UIButton                   *deleteButton;
@property (strong, nonatomic) LikeAnimationButton        *praiseButton;

@property (strong, nonatomic) CAEmitterLayer             *emitterLayer;

@property (strong, nonatomic) FeedCommentListRowModel    *tempRowModel;

@end

@implementation FeedCommentCell

- (void)setupViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.praiseButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.crownImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView insertSubview:self.watermarkImageView aboveSubview:self.contentLabel];
    [self.contentView addSubview:self.fullTextButton];
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.replyButton];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.deleteButton];
    [self.contentView addSubview:self.praiseButton];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(30));
        make.top.equalTo(self.contentView).offset(adaptHeight1334(35));
        make.height.width.mas_equalTo(adaptHeight1334(36*2));
        
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.headImageView.mas_right).offset(adaptWidth750(24));
        make.top.equalTo(self.headImageView).offset(-adaptHeight1334(4));
        
    }];
    
    [self.crownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel.mas_right).offset(adaptWidth750(16));
        make.centerY.equalTo(self.usernameLabel);
    }];
    
    [self.watermarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView);
        make.right.equalTo(self.contentView).offset(-adaptWidth750(170));
    }];
    
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.usernameLabel);
        make.right.equalTo(self.contentView).offset(-adaptWidth750(32));
        make.width.mas_equalTo(adaptWidth750(60*2));
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(adaptHeight1334(14));
        make.left.equalTo(self.usernameLabel);
        make.width.mas_equalTo(SCREEN_WIDTH - adaptWidth750(64*2) - adaptWidth750(20*2));
    }];
    
    [self.fullTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(7));
        make.left.equalTo(self.contentLabel);
        make.height.mas_equalTo(adaptHeight1334(30));
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.fullTextButton.mas_bottom).offset(adaptHeight1334(18));
        make.width.mas_equalTo(adaptHeight1334(140*2));
        make.height.mas_equalTo(adaptHeight1334(105*2));
    }];
    
    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImageView.mas_bottom).offset(adaptHeight1334(18));
        make.left.equalTo(self.timeLabel.mas_right).offset(adaptWidth750(20));
        make.height.mas_equalTo(adaptHeight1334(40));
        make.width.mas_equalTo(adaptWidth750(53*2));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(22));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentLabel);
        make.centerY.equalTo(self.replyButton);
        
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).offset(-adaptWidth750(20));
        make.centerY.equalTo(self.replyButton);
        make.width.mas_equalTo(adaptWidth750((24+9*2)*2));
        
    }];
    
}

#pragma mark - Event Action

- (void)deleteButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedCommentCell:deleteRow:)]) {
        [self.delegate feedCommentCell:self deleteRow:self.tempRowModel];
    }
}

- (void)replyAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedCommentCell:replyRow:)]) {
        [self.delegate feedCommentCell:self replyRow:self.tempRowModel];
    }
}

- (void)avatarClickAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedCommentCell:didSelectAvatarAndNicknameForRow:)]) {
        [self.delegate feedCommentCell:self didSelectAvatarAndNicknameForRow:self.tempRowModel];
    }
}

- (void)nickNameClickAction {
    [self avatarClickAction];
}

- (void)fullTextButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedCommentCell:fullTextRow:)]) {
        [self.delegate feedCommentCell:self fullTextRow:self.tempRowModel];
    }
}

- (void)contentImageViewClickAction {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedCommentCell:didSelectContentImageView:forRow:)]) {
        [self.delegate feedCommentCell:self didSelectContentImageView:self.contentImageView forRow:self.tempRowModel];
    }
}

- (void)contentImageViewLongPressAction {
    if (self.tempRowModel.comment.isMyComment) {
        [self menuAttributedLabelDeleteAction];
    } else {
        [self menuAttributedLabelReportAction];
    }
}

#pragma mark - ppsPhotoShowViewDelegate
- (UIView *)dismissAction:(NSInteger)currentPage {
    return self.contentImageView;
}

- (void)dismissAtCurrentPage:(NSInteger)currentPage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedCommentCell:didDismissImageBrowserForRow:)]) {
        [self.delegate feedCommentCell:self didDismissImageBrowserForRow:self.tempRowModel];
    }
}

#pragma mark - XLMenuAttributedLabelDelegate

- (void)menuAttributedLabelDeleteAction {
    [self deleteButtonClick];
}

- (void)menuAttributedLabelReportAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedCommentCell:reportRow:)]) {
        [self.delegate feedCommentCell:self reportRow:self.tempRowModel];
    }
}

#pragma mark - LikeAnimationButtonDelegate

- (void)didClickAnimationButton:(LikeAnimationButton *)animationButton type:(LikeAnimationButtonType)animationType {
    
    if (animationButton.selected && self.tempRowModel.comment.isPraise) {
        return;
    }
    if (animationButton.selected) {
        [animationButton setTitle:[NSString stringWithFormat:@"%ld", animationButton.titleLabel.text.integerValue+1] forState:UIControlStateNormal];
    } else {
        if (animationButton.titleLabel.text.integerValue - 1 <= 0) {
            [animationButton setTitle:@"赞" forState:UIControlStateNormal];
            
        } else {
            [animationButton setTitle:[NSString stringWithFormat:@"%ld", animationButton.titleLabel.text.integerValue-1] forState:UIControlStateNormal];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedCommentCell:didSelectPraiseButton:forRow:)]) {
        [self.delegate feedCommentCell:self didSelectPraiseButton:animationButton forRow:self.tempRowModel];
    }
}

#pragma mark - Public method

- (void)configModelData:(FeedCommentListRowModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.tempRowModel = model;
    
    self.usernameLabel.text = model.comment.fromName;
    self.crownImageView.hidden = !model.comment.bestComment;
    self.watermarkImageView.hidden = !model.comment.bestComment;
    self.timeLabel.text = [NSDate timeIntervalCompareWithTimestamp:model.comment.createdAt.integerValue isContainHour:YES];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.comment.fromIcon] placeholderImage:[UIImage imageNamed:@"my_avatar"]];
    if (model.comment.isMyComment) {
        _contentLabel.menuType = XLMenuTypeCopy | XLMenuTypeDelete;
    } else {
        _contentLabel.menuType = XLMenuTypeCopy | XLMenuTypeReport;
    }
    
    self.contentLabel.text = model.comment.content;
    self.fullTextButton.hidden = model.isAllContent;
    self.contentLabel.numberOfLines = model.isAllContent ? 0 : 6;
    [self.fullTextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(model.isAllContent ? 0 : adaptHeight1334(7));
        make.left.equalTo(self.contentLabel);
        make.height.mas_equalTo(model.isAllContent ? 0 : adaptHeight1334(30));
    }];
    
    self.deleteButton.hidden = !model.comment.isMyComment;
    self.praiseButton.selected = model.comment.isPraise;
    if (model.comment.upNum.integerValue == 0) {
        [self.praiseButton setTitle:@"赞" forState:UIControlStateNormal];
    } else {
        [self.praiseButton setTitle:[NSString numberAdaptWithStringNumber:model.comment.upNum] forState:UIControlStateNormal];
    }
    
    BOOL isHaveImage = model.comment.images.count == 0 ? NO : YES;
    self.contentImageView.hidden = !isHaveImage;
    CGSize contentImageViewSize = isHaveImage ? [self contentImageWithImageModel:model.comment.images.firstObject] : CGSizeMake(0, 0);
    
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.comment.images.firstObject.originalImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if ([model.comment.images.firstObject.originalImage hasSuffix:@".gif"]) {
            self.contentImageView.image = image;
        } else {
            self.contentImageView.image = [UIImage clipImage:image toWidth:contentImageViewSize.width toHeight:contentImageViewSize.height];
        }
    }];
    
    [self.contentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(contentImageViewSize.width);
        make.height.mas_equalTo(contentImageViewSize.height);
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.fullTextButton.mas_bottom).offset(isHaveImage ? adaptHeight1334(18) : 0);
    }];

}

- (CGSize)contentImageWithImageModel:(ImageModel *)imageModel
{
    CGFloat scale = imageModel.width.floatValue / imageModel.height.floatValue;
    CGFloat width;
    CGFloat height;
    if (scale < 1){
        width = adaptWidth750(105*2);
        height = adaptHeight1334(140*2);
    } else if (scale == 1) {
        width = adaptHeight1334(140*2);
        height = adaptHeight1334(140*2);
    } else {
        width = adaptWidth750(140*2);
        height = adaptHeight1334(105*2);
    }
    return CGSizeMake(width, height);
}

#pragma mark - Private method

#pragma mark - Lazy loading

- (UIImageView *)headImageView {
    if (!_headImageView) {
        self.headImageView = [UIImageView new];
        self.headImageView.userInteractionEnabled = YES;
        self.headImageView.layer.cornerRadius = adaptHeight1334(36);
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.borderWidth = 0.5;
        self.headImageView.layer.borderColor = [UIColor colorWithString:COLORE6E6E6].CGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClickAction)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(28) textColorString:COLOR636363];
        _usernameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nickNameClickAction)];
        [_usernameLabel addGestureRecognizer:tap];
    }
    return _usernameLabel;
}

- (UIImageView *)crownImageView {
    if (!_crownImageView) {
        _crownImageView = [UIImageView new];
        _crownImageView.image = [UIImage imageNamed:@"super_comment_crown"];
    }
    return _crownImageView;
}

- (UIImageView *)watermarkImageView {
    if (!_watermarkImageView) {
        _watermarkImageView = [UIImageView new];
        _watermarkImageView.image = [UIImage imageNamed:@"super_comment_watermark"];
    }
    return _watermarkImageView;
}

- (XLMenuAttributedLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [XLMenuAttributedLabel new];
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.numberOfLines = 6;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
        _contentLabel.textColor = [UIColor colorWithString:COLOR060606];
        _contentLabel.lineSpacing = adaptHeight1334(7);
        _contentLabel.delegate = self;
        _contentLabel.normalBackgroundColor = self.contentView.backgroundColor;
    }
    return _contentLabel;
}

- (UIButton *)fullTextButton {
    if (!_fullTextButton) {
        _fullTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullTextButton setTitle:@"全文" forState:UIControlStateNormal];
        _fullTextButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
        [_fullTextButton setTitleColor:[UIColor colorWithString:COLOR507DAF] forState:UIControlStateNormal];
        [_fullTextButton addTarget:self action:@selector(fullTextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullTextButton;
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [FLAnimatedImageView new];
        _contentImageView.runLoopMode = NSRunLoopCommonModes;
        _contentImageView.backgroundColor = [UIColor colorWithString:COLOREDECED];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.layer.borderWidth = 0.5;
        _contentImageView.layer.borderColor = [UIColor colorWithString:COLORE6E6E6].CGColor;
        _contentImageView.userInteractionEnabled = YES;
        _contentImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImageViewClickAction)];
        [_contentImageView addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contentImageViewLongPressAction)];
        [_contentImageView addGestureRecognizer:longPress];

    }
    return _contentImageView;
}

- (UIButton *)replyButton
{
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replyButton setTitle:@"回复TA" forState:UIControlStateNormal];
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(22)];
        [_replyButton setTitleColor:[UIColor colorWithString:COLOR848E98] forState:UIControlStateNormal];
        _replyButton.layer.borderWidth = 1;
        _replyButton.layer.borderColor = [UIColor colorWithString:COLORE5E5E5].CGColor;
        _replyButton.layer.cornerRadius = adaptHeight1334(20);
        [_replyButton addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _replyButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(22) textColorString:COLOR939393];
    }
    return _timeLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(24)];
        [_deleteButton setTitleColor:[UIColor colorWithString:COLOR222222] forState:UIControlStateNormal];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (LikeAnimationButton *)praiseButton {
    if (!_praiseButton) {
        _praiseButton = [LikeAnimationButton animationButtonWithType:LikeAnimationButtonTypeTop];
        _praiseButton.delegate = self;
        _praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        _praiseButton.loginSourceType = LoginSourceTypeCommentPraise;
        [_praiseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    return _praiseButton;
}

@end
