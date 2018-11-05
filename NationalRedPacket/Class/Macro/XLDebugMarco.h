
//
//  XLDebugMarco.h
//  Kratos
//
//  Created by Zhangziqi on 3/29/16.
//  Copyright © 2016 lyq. All rights reserved.
//

#ifndef XLDebugMarco_h
#define XLDebugMarco_h

// 自定义NSLog,在debug模式下打印，在release模式下取消一切NSLog
#ifdef DEBUG
#define XLLog(FORMAT, ...) fprintf(stderr,"<%s:%d>:\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define XLLog(FORMAT, ...) nil
#endif

#endif /* XLDebugMarco_h */
