//
//  ImagesWithAuthorCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/2/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "FeedImagesCell.h"
#import "NSString+NumberAdapt.h"

@interface FeedImagesCell ()

@end

@implementation FeedImagesCell

- (void)setupViews
{
    [super setupViews];
    
    self.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32.1)];
    self.fullTextButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32.1)];

    self.containerView = [[ContainerImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - adaptWidth750(26) * 2, 0)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.containerView];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.fullTextButton.mas_bottom).offset(adaptHeight1334(16));
        make.height.mas_equalTo(adaptHeight1334(231*2));
        make.bottom.equalTo(self.commentTableView.mas_top);
        
    }];
    
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.containerView.mas_bottom).offset(adaptHeight1334(18));
        make.left.equalTo(self.contentView).offset(adaptWidth750(26));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(18));
        make.right.equalTo(self.titleLabel);
        
    }];

}

- (void)configModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath
{
    [super configModelData:model indexPath:indexPath];
    self.tempModel = model;

    if (self.isDetail == NO) {
        
        [self.containerView configImageArray:model.image layoutType:LayoutTypeHome isDetail:self.isDetail];
        self.containerView.newsModel = model;
        self.detailLabel.hidden = YES;
        self.titleLabel.numberOfLines = model.isAllContent ? 0 : 3;

    } else {
        self.fullTextButton.hidden = YES;
        [self.fullTextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.titleLabel);
            make.height.mas_equalTo(0);
        }];
        
        self.titleLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.containerView configImageArray:model.image layoutType:LayoutTypeDetail isDetail:self.isDetail];
        self.containerView.newsModel = model;
        [self setContentDidRead:NO];
        self.detailLabel.hidden = YES;
        self.lineView.hidden = YES;
        
        self.topAuthorView.hidden = YES;
        [self.topAuthorView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).mas_offset(adaptHeight1334(10));
            make.height.mas_equalTo(0);
        }];
        
        [self.commentContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
}

- (void)updateDetailInfo
{
    [self updateDataWithModel:self.tempModel];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UICollectionView class]]) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
