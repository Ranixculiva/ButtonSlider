//
//  TextFormatStruct.h
//  TextControlPanel
//
//  Created by Ranix on 2024/10/16.
//

#import <Foundation/Foundation.h>

typedef struct {
    BOOL isBold;
    BOOL isItalic;
    BOOL isUnderline;
    BOOL isStrikethrough;
    BOOL isUppercase;
    BOOL isLowercase;
    BOOL isProperCase;
    CGFloat strikethroughLineThicknessFactor;
} TextFormat;

bool isEqual(TextFormat a, TextFormat b);
TextFormat MakeInitialTextFormat(void);
NSValue *TextFormatToNSValue(TextFormat textFormat);
TextFormat NSValueToTextFormat(NSValue *value);
