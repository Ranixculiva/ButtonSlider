//
//  DrawTextUtility.h
//  ButtonSlider
//
//  Created by Ranix on 2024/10/26.
//

#import <Foundation/Foundation.h>
#import "TextFormatStruct.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawTextUtility : NSObject
@property (nonatomic) TextFormat textFormat;
@property (nonatomic) UIColor* strokeColor;
@property (nonatomic) CGFloat letterSpacing;
@property (nonatomic) CGFloat lineSpacing;
- (UIImage*)createImageWithText:(NSString*)text fontSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
