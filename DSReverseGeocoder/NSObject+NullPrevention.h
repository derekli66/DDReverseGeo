//
//  Created by LEE CHIEN-MING on 7/29/13.
//  Copyright (c) 2013 iamds. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSNumber* numberUnNull(id aNumber)
{
    if (!aNumber) {
        NSLog(@"Error: input is a null pointer");
        return [NSNumber numberWithInt:0];
    }
    if ([aNumber isKindOfClass:[NSNull class]]) {
        NSLog(@"Error: %@ not a NSNumber class",NSStringFromClass([aNumber class]));
        return [NSNumber numberWithInt:0];
    }
    if ([aNumber isKindOfClass:[NSString class]]) {
        NSLog(@"Warning: converted %@ to a NSNumber class",NSStringFromClass([aNumber class]));
        NSInteger intVal = [aNumber intValue];
        return [NSNumber numberWithInteger:intVal];
    }
    else if ([aNumber isKindOfClass:[NSNumber class]]) {
        return aNumber;
    }
    else {
        NSLog(@"Error: %@ not a NSNumber class",NSStringFromClass([aNumber class]));
        return [NSNumber numberWithInt:0];
    }
}
static NSString* stringUnNull(id aString)
{
    if (!aString) {
        NSLog(@"Error: input is a null pointer");
        return @"0";
    }
    if ([aString isKindOfClass:[NSNull class]]) {
        NSLog(@"Error: %@ not a NSString class",NSStringFromClass([aString class]));
        return @"0";
    }
    if ([aString isKindOfClass:[NSNumber class]]) {
        NSLog(@"Warning: converted %@ to a NSString class",NSStringFromClass([aString class]));
        NSInteger intVal = [aString intValue];
        return [NSString stringWithFormat:@"%d",intVal];
    }
    else if ([aString isKindOfClass:[NSString class]]) {
        return aString;
    }
    else {
        NSLog(@"Error: %@ not a NSString class",NSStringFromClass([aString class]));
        return @"0";
    }
}