//
//  XLCommentTableViewCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/19.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLCommentTableViewCell.h"
#import "XLSessionCommentModel.h"
#import "NSDate+SessionHeader.h"
#import "M80AttributedLabel.h"

@interface XLCommentTableViewCell () <UITextViewDelegate, M80AttributedLabelDelegate>

@property (strong, nonatomic) UILabel *nameLabel;          /// 用户名称
@property (strong, nonatomic) UIImageView *iconImageView;  /// 头像
@property (strong, nonatomic) UILabel *contentLabel;    /// 内容
@property (strong, nonatomic) UILabel *dateLabel;          /// 时间
@property (strong, nonatomic) UIImageView *photoView;      /// 图像
@property (strong, nonatomic) UILabel *line;
@property (copy, nonatomic)   NSString *imageString;
@property (strong, nonatomic) NSTextAttachment *attchment;
@property (strong, nonatomic) XLSessionCommentImageModel *model;
@property (strong, nonatomic) XLSessionCommentModel *commentModel;
@property (strong, nonatomic) M80AttributedLabel *attributedLabel;
@property (strong, nonatomic) UIImageView *textImageView;
@end


@implementation XLCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark -
#pragma mark - private method

- (void)setupViews {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.photoView];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.attributedLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(17*2));
        make.top.equalTo(self).offset(adaptHeight1334(11*2));
        make.width.mas_equalTo(adaptWidth750(40*2));
        make.height.mas_equalTo(adaptHeight1334(40*2));

    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(adaptWidth750(70*2));
        make.top.equalTo(self.contentView).offset(adaptHeight1334(15*2));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(106*2));
    }];
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(adaptHeight1334(14*2));
        make.right.equalTo(self).offset(-adaptWidth750(12*2));
        make.height.mas_equalTo(adaptHeight1334(60*2));
        make.width.mas_equalTo(adaptWidth750(60*2));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(adaptHeight1334(5*2));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(5*2));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(9.5*2));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.dateLabel);
        make.right.mas_equalTo(adaptWidth750(303*2));
        make.bottom.equalTo(self.contentView);

    }];
    
}

#pragma mark -
#pragma mark - public method

- (void)configHigh:(id)model {
    XLSessionCommentModel *dataModel = (XLSessionCommentModel *)model;
    BOOL isAnswer = [dataModel.receiveType isEqualToString:@"item"];
    NSString *contentString = [[NSString alloc] init];
    self.nameLabel.attributedText = [self changeNameString:dataModel.nickname isAnswer:!isAnswer];
    
    if (self.isLikedView) {
        if (isAnswer) {
            contentString = dataModel.item.title;
        } else {
            contentString = dataModel.comment.content;
        }
    } else {
        contentString = dataModel.comment.content;
    }
    
    if (dataModel.comment.image.count != 0) {
        self.contentLabel.attributedText = [self changeContentString:contentString];
    } else {
        if ([contentString isEqualToString:@""]){
            [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel);
                make.top.equalTo(self.nameLabel.mas_bottom).offset(adaptHeight1334(15*2));
                make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(9.5*2));
            }];
        } else {
           
            [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentLabel);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(5*2));
                make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(9.5*2));
            }];
            self.contentLabel.text = contentString;
        }
    }
    self.dateLabel.text = [NSDate changeTimestampToString:dataModel.time];
}

- (void)configModelData:(id)model indexPath:(NSIndexPath *)indexPath {
    
    self.contentLabel.hidden = YES;
    
    XLSessionCommentModel *dataModel = (XLSessionCommentModel *)model;
    self.commentModel = dataModel;
    
    NSString *contentString = [[NSString alloc] init];
    
    [self.attributedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(self.contentLabel);
    }];
    
    BOOL isAnswer = [dataModel.receiveType isEqualToString:@"item"];
    if (self.isLikedView) {
        if (isAnswer) {
            contentString = dataModel.item.title;
        } else {
            contentString = dataModel.comment.content;
        }
    } else {
        contentString = dataModel.comment.content;
    }
    
   
    self.nameLabel.attributedText = [self changeNameString:dataModel.nickname isAnswer:!isAnswer];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.icon]
                          placeholderImage:GetImage(@"my_avatar")];
    
    if (dataModel.comment.image.count != 0) {
        /**加图片标签  可以打开*/
        self.attributedLabel.text = contentString;
        [self.attributedLabel appendView:self.textImageView margin:UIEdgeInsetsMake(adaptHeight1334(5), 0, adaptHeight1334(5), 0)];
        [self.attributedLabel appendText:@" 查看图片"];
        self.attributedLabel.textColor = GetColor(COLOR666666);
        [self.attributedLabel addCustomLink:@"link" forRange:[self.attributedLabel.text rangeOfString:@"查看图片"] linkColor:GetColor(COLOR406599)];
        self.attributedLabel.underLineForLink = NO;
        self.attributedLabel.delegate = self;
        self.attributedLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:adaptFontSize(14*2)];

        self.contentLabel.attributedText = [self changeContentString:contentString];
//        self.contentLabel.linkTextAttributes = @{NSForegroundColorAttributeName:GetColor(COLOR406599),
//                                                 NSFontAttributeName: [UIFont systemFontOfSize:adaptFontSize(14*2)]
//                                                 };

        
        XLSessionCommentImageModel *imageModel = dataModel.comment.image[0];
        self.model = imageModel;
    } else {
        
        if ([contentString isEqualToString:@""]){
            /**没有内容*/
            self.attributedLabel.hidden = YES;
            [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel);
                make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(9.5*2));
            }];
        } else {
            /**有内容*/
            self.attributedLabel.hidden = NO;
            [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentLabel);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(adaptHeight1334(1*2));
                make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(9.5*2));
            }];
            
            self.attributedLabel.textColor = GetColor(COLOR666666);
            self.attributedLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:adaptFontSize(14*2)];
            self.attributedLabel.text = contentString;
            
            self.contentLabel.attributedText = [[NSMutableAttributedString alloc]
                                                initWithString:contentString
                                                attributes:@{
                                                             NSForegroundColorAttributeName : GetColor(COLOR666666),
                                                             NSFontAttributeName: [UIFont systemFontOfSize:adaptFontSize(14*2)]
                                                             }];
        }

    }
    
    if (dataModel.item.image.firstObject.preview) {
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:dataModel.item.image.firstObject.preview]];
    } else {
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:dataModel.item.picture.firstObject]];
    }
    
    self.dateLabel.text = [NSDate changeTimestampToString:dataModel.time];
}



- (NSMutableAttributedString *)changeContentString:(NSString *)string {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttributes:@{
                                      NSForegroundColorAttributeName : GetColor(COLOR666666),
                                      NSFontAttributeName: [UIFont systemFontOfSize:adaptFontSize(14*2)]
                                      } range:NSMakeRange(0, string.length)];
    
    self.attchment = [[NSTextAttachment alloc] init];
    self.attchment.bounds = CGRectMake(0, -2, adaptWidth750(17*2), adaptHeight1334(14*2));
    self.attchment.image = GetImage(@"text_image");
    
    NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:self.attchment];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [attributedString appendAttributedString:imageString];
    NSMutableAttributedString *tailString = [[NSMutableAttributedString alloc] initWithString:@" 查看图片"];
    self.contentLabel.userInteractionEnabled = YES;
    [tailString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
    [tailString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:adaptFontSize(14*2)] range:NSMakeRange(0, 5)];
    [tailString addAttribute:NSLinkAttributeName value:@"link://" range:NSMakeRange(0, 5)];
    
    
    [attributedString appendAttributedString:tailString];
    
    return attributedString;
}

- (NSMutableAttributedString *)changeNameString:(NSString *)string isAnswer:(BOOL)isAnswer {
    if (!string) string = @"";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:GetColor(COLOR406599) range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:adaptFontSize(15*2)] range:NSMakeRange(0, string.length)];
    
    if (isAnswer) {
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:self.isLikedView ? @" 赞了你的评论":@" 回复了你"]];
    } else {
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:self.isLikedView ? @" 赞了你的动态":@" 评论了你"]];
    }
    return attributedString;
}

- (void)pushPublisherController {
    if ([self.delegate respondsToSelector:@selector(pushPublisherController:)]) {
        [self.delegate pushPublisherController:self.commentModel];
    }
}

- (void)m80AttributedLabel:(M80AttributedLabel *)label
             clickedOnLink:(id)linkData {
    if ([self.delegate respondsToSelector:@selector(clickShowPictureText:imageView:)]) {
        [self.delegate clickShowPictureText:self.model imageView:self.textImageView];
    }
}

#pragma mark -
#pragma mark - lazy loaz

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:adaptFontSize(15*2)];
        _nameLabel.textColor = GetColor(COLOR151515);
        _nameLabel.numberOfLines = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPublisherController)];
        [_nameLabel addGestureRecognizer:tap];
        _nameLabel.userInteractionEnabled = YES;
    }
    return _nameLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = adaptHeight1334(40);
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPublisherController)];
        [_iconImageView addGestureRecognizer:tap];
    }
    return _iconImageView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:adaptFontSize(14*2)];
        _contentLabel.textColor = GetColor(COLOR666666);
        [_contentLabel setTextAlignment:NSTextAlignmentLeft];//并设置左对齐
        _contentLabel.userInteractionEnabled = NO;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:adaptFontSize(12*2)];
        [_dateLabel setTextColor:GetColor(COLORA7A7A7)];
    }
    return _dateLabel;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.layer.masksToBounds = YES;
    }
    return _photoView;
}

- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = GetColor(COLORE6E6E6);
    }
    return _line;
}

- (M80AttributedLabel *)attributedLabel {
    if (!_attributedLabel) {
        _attributedLabel = [[M80AttributedLabel alloc] init];
        _attributedLabel.numberOfLines = 0;
        _attributedLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:adaptFontSize(14*2)];
        _attributedLabel.textColor = GetColor(COLOR666666);
    }
    return _attributedLabel;
}

- (UIImageView *)textImageView {
    if (!_textImageView) {
        _textImageView = [[UIImageView alloc] init];
        _textImageView.image = GetImage(@"text_image");
        [_textImageView setBounds:CGRectMake(0, 0, adaptWidth750(32), adaptHeight1334(26))];
    }
    return _textImageView;
}

@end
