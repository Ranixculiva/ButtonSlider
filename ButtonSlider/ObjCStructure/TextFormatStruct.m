//
//  TextFormatStruct.m
//  YouPerfect
//
//  Created by Ranix Lin on 2024/10/17.
//  Copyright © 2024 PerfectCorp. All rights reserved.
//

#import "TextFormatStruct.h"

bool isEqual(TextFormat a, TextFormat b) {
    return (a.isBold == b.isBold &&
            a.isItalic == b.isItalic &&
            a.isUnderline == b.isUnderline &&
            a.isStrikethrough == b.isStrikethrough &&
            a.isUppercase == b.isUppercase &&
            a.isLowercase == b.isLowercase &&
            a.isProperCase == b.isProperCase);
}

TextFormat MakeInitialTextFormat(void) {
    TextFormat textFormat;
    textFormat.isBold = NO;
    textFormat.isItalic = NO;
    textFormat.isUnderline = NO;
    textFormat.isStrikethrough = NO;
    textFormat.isUppercase = NO;
    textFormat.isLowercase = NO;
    textFormat.isProperCase = NO;
    return textFormat;
}

NSValue *TextFormatToNSValue(TextFormat textFormat) {
    return [NSValue valueWithBytes:&textFormat objCType:@encode(TextFormat)];
}

TextFormat NSValueToTextFormat(NSValue *value) {
    TextFormat textFormat;
    [value getValue:&textFormat];
    return textFormat;
}
