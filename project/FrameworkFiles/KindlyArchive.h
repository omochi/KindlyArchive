//
//  KindlyArchive.h
//  KindlyArchive
//
//  Created by omochimetaru on 2018/03/16.
//  Copyright © 2018年 omochimetaru. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#   import <Foundation/Foundation.h>
#elif TARGET_OS_MAC
#   import <Cocoa/Cocoa.h>
#endif

//! Project version number for KindlyArchive.
FOUNDATION_EXPORT double KindlyArchiveVersionNumber;

//! Project version string for KindlyArchive.
FOUNDATION_EXPORT const unsigned char KindlyArchiveVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KindlyArchive/PublicHeader.h>


