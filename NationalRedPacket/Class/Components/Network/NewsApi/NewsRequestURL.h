//
//  NewsRequestURL.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/11/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#ifndef NewsRequestURL_h
#define NewsRequestURL_h

#define URL_FETCH_NEW_CLASSIFY  URL_BASE@"/Item/fetchNewClassify"
#define URL_FETCH_NEW_ITEM      URL_BASE@"/Item/fetchNewItem"
#define URL_FETCH_COMMENT       URL_BASE@"/Item/fetchComment"
#define URL_FETCH_SECONDARY_COMMENT URL_BASE@"/Item/fetchSecondComment"
#define URL_PRAISE              URL_BASE@"/Item/praise"
#define URL_TREAD             URL_BASE@"/Item/tread"
#define URL_COLLECTION          URL_BASE@"/Item/collection"  ///收藏与取消收藏
#define URL_COMMENT             URL_BASE@"/Item/conmment"
#define URL_SECONDARY_COMMENT   URL_BASE@"/Item/secondComment"
#define URL_FOLLOW              URL_BASE@"/Item/attention"
#define URL_MYPRISE             URL_BASE@"/Item/myPraise"
#define URL_MYCOLLECTION        URL_BASE@"/Item/myCollection" ///我的收藏
#define URL_PERSONAL            URL_BASE@"/Item/fetchPersonPage"
#define URL_FOLLOW_LIST         URL_BASE@"/Item/fetchAttentionList"
#define URL_COMMENTPRAISE       URL_BASE@"/Item/commentPraise"
#define URL_DELETECOMMENT       URL_BASE@"/Item/deleteComment"
#define URL_FETCH_FOLLOW_FEEDS  URL_BASE@"/Item/fetchAttentionPage"
#define URL_DELETE_SECONDARY_COMMENT  URL_BASE@"/Item/deleteSecondComment"
#define URL_REPORT_COMMENT      URL_BASE@"/Tool/reportComment"
#define URL_NEGATIVE_FEEDBACK   URL_BASE@"/Tool/feedbackItem" ///负反馈
#define URL_REPORT_PUBLISHER    URL_BASE@"/Tool/feedbackAuthor" ///举报发布者
#define URL_FETCH_FEED_DETAIL   URL_BASE@"/Item/itemDetail"
#define URL_FETCH_MY_UPLOAD     URL_BASE@"/Item/fetchMyUpload" ///我的帖子
#define URL_FEED_FORWARD        URL_BASE@"/Item/forward"    ///转发成功

#endif /* NewsRequestURL_h */
