//
//  NegativeFeedback.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NegativeFeedbackTableView, NegativeFeedTableViewCell;

@protocol NegativeFeedbackTableViewDelegate <NSObject>
- (void)NegativeFeedbackTableView:(NegativeFeedbackTableView *)tableView didClickAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface NegativeFeedbackTableView : UITableView
@property (weak, nonatomic) id<NegativeFeedbackTableViewDelegate> negativeFeedbackDelegate;
- (instancetype)initWithOrigin:(CGPoint)origin;
@end
