//
//  NSString+CATHelper.m
//  CalendarTest
//
//  Created by m_sugawara on 2015/06/12.
//  Copyright (c) 2015年 Zappallas. All rights reserved.
//

#import "NSString+CATHelper.h"

@implementation NSString (CATHelper)

+ (NSString *)stringFromDate:(NSDate *)date WithFormat:(NSString *)format {
    NSAssert(format, @"format must not be nil");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

@end
