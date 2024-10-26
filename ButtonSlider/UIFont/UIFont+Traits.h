//
//  UIFont+Traits.h
//  TextLearning
//
//  Created by Ranix on 2024/10/17.
//

#import <UIKit/UIKit.h>

@interface UIFont (Traits)

- (UIFont *)withTraits:(UIFontDescriptorSymbolicTraits)traits;
- (UIFont *)italic;
- (UIFont *)bold;
- (UIFont *)boldItalic;

@end

