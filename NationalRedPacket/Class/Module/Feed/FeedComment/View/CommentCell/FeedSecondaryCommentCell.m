//
//  FeedSecondaryCommentCell.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedSecondaryCommentCell.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "XLMenuAttributedLabel.h"

#define AUTHORID @"AuthorID"

#define kLinkAttributes     @{(__bridge NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[UIColor colorWithString:COLOR507DAF].CGColor}

#define kLinkAttributesActive       @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[[UIColor colorWithString:COLOR507DAF] CGColor]}

@interface FeedSecondaryCommentCell ()<XLMenuAttributedLabelDelegate>

@property (strong, nonatomic) XLMenuAttributedLabel *commentContentLabel;
@property (assign, nonatomic) BOOL isCommentSelected;
@property (strong, nonatomic) FeedCommentListRowModel *feedCommentListRowModel;

@end

@implementation FeedSecondaryCommentCell

#pragma mark - Initialize

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *contentView = self.contentView;
    [contentView addSubview:self.commentContentLabel];
    
    [self.commentContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(contentView);
        make.left.equalTo(contentView).mas_equalTo(adaptWidth750(128));
        make.width.mas_equalTo(SCREEN_WIDTH - adaptWidth750(64*2) - adaptWidth750(20*2));
    }];
}

- (void)touchAttributedLabel {
    [self configCommentContenLabelHighLightColor];
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedSecondaryCommentCell:replyWithRowModel:)]) {
        [self.delegate feedSecondaryCommentCell:self replyWithRowModel:self.feedCommentListRowModel];
    }
}

- (void)configCommentContenLabelHighLightColor {
    self.commentContentLabel.backgroundColor = [UIColor colorWithString:COLORE3E3E3];
    [self performSelector:@selector(configCommentContenLabelNormalColor) withObject:nil afterDelay:0.1];
}

- (void)configCommentContenLabelNormalColor {
    self.commentContentLabel.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
}

#pragma mark - MenuItemDelegate

- (void)menuAttributedLabelDeleteAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedSecondaryCommentCell:deletedWithRowModel:)]) {
        [self.delegate feedSecondaryCommentCell:self deletedWithRowModel:self.feedCommentListRowModel];
    }
}

- (void)menuAttributedLabelReportAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedSecondaryCommentCell:reportedWithRowModel:)]) {
        [self.delegate feedSecondaryCommentCell:self reportedWithRowModel:self.feedCommentListRowModel];
    }
}

- (void)menuAttributedLabelCopyAction {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.feedCommentListRowModel.comment.content;
}

#pragma TTTAttributedLabel Delegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedSecondaryCommenCell:nickNameDidClickWithAuthorID:)]) {
        [self.delegate feedSecondaryCommenCell:self nickNameDidClickWithAuthorID:components[AUTHORID]];
    }
}

#pragma mark - Public

- (void)configModelData:(FeedCommentListRowModel *)model indexPath:(NSIndexPath *)indexPath {
    self.feedCommentListRowModel = model;
    self.commentContentLabel.linkAttributes = kLinkAttributes;
    self.commentContentLabel.activeLinkAttributes = kLinkAttributesActive;
    [self.commentContentLabel setExtendsLinkTouchArea:YES];

    if (model.comment.isMyComment) {
        self.commentContentLabel.menuType = XLMenuTypeCopy | XLMenuTypeDelete;
    } else {
        self.commentContentLabel.menuType = XLMenuTypeCopy | XLMenuTypeReport;
    }
    NSString *completeCommont;
    if (!model.comment.toName || [model.comment.toName isEqualToString:@""]) {
        completeCommont = [NSString stringWithFormat:@"%@: %@",model.comment.fromName, model.comment.content];
    } else {
        completeCommont = [NSString stringWithFormat:@"%@ 回复 %@：%@",model.comment.fromName,model.comment.toName,model.comment.content];
    }
    
    [self.commentContentLabel setText:completeCommont afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange fromRange = [[mutableAttributedString string] rangeOfString:model.comment.fromName options:NSCaseInsensitiveSearch];
        NSRange toRange = [[mutableAttributedString string] rangeOfString:model.comment.toName options:NSCaseInsensitiveSearch];

        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor colorWithString:COLOR507DAF].CGColor range:fromRange];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor colorWithString:COLOR507DAF].CGColor range:toRange];
        return mutableAttributedString;
    }];
    self.commentContentLabel.numberOfLines = 0;
    
    
    [self.commentContentLabel addLinkToTransitInformation:@{AUTHORID:model.comment.fromAuthorId}
                                                withRange:[self.commentContentLabel.text rangeOfString:model.comment.fromName]];
    if ([model.comment.toName isEqualToString:model.comment.fromName]) {
        NSArray *array = [self getRangeStr:self.commentContentLabel.text findText:model.comment.toName];
        NSRange range = NSMakeRange([array[1] integerValue], model.comment.fromName.length);
        [self.commentContentLabel addLinkToTransitInformation:@{AUTHORID:model.comment.toAuthorId}
                                                    withRange:range];
    } else {
        [self.commentContentLabel addLinkToTransitInformation:@{AUTHORID:model.comment.toAuthorId}
                                                    withRange:[self.commentContentLabel.text rangeOfString:model.comment.toName]];
    }
    

}

#pragma mark - Private

- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText {
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    if (text == nil || findText == nil || [findText isEqualToString:@""]){
        return nil;
    }
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    if (rang.location != NSNotFound && rang.length != 0) {
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++) {
            if (0 == i) {
                //去掉这个abc字符串
                location = rang.location + rang.length;
                length = text.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                location = rang1.location + rang1.length;
                length = text.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            //在一个range范围内查找另一个字符串的range
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            if (rang1.location == NSNotFound && rang1.length == 0) {
                break;
            }
            else//添加符合条件的location进数组
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
        }
        return arrayRanges;
    }
    return nil;
}

#pragma mark - Custom Accessors

- (XLMenuAttributedLabel *)commentContentLabel {
    if (!_commentContentLabel) {
        _commentContentLabel = [XLMenuAttributedLabel new];
        _commentContentLabel.font = [UIFont systemFontOfSize:adaptFontSize(27)];
        _commentContentLabel.lineSpacing = adaptHeight1334(6);
        _commentContentLabel.textColor = [UIColor colorWithString:COLOR636363];
        _commentContentLabel.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
        _commentContentLabel.delegate = self;
        _commentContentLabel.userInteractionEnabled = YES;
        _commentContentLabel.numberOfLines = 0;
        _commentContentLabel.textInsets = UIEdgeInsetsMake(2, 9, 2, 5);
        _commentContentLabel.normalBackgroundColor = [UIColor colorWithString:COLORF7F7F7];
        _commentContentLabel.pressBackgroundColor = [UIColor colorWithString:COLOREBEBEB];
    }
    return _commentContentLabel;
}

@end
