/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI46_0_0React/ABI46_0_0RCTDivisionAnimatedNode.h>

#import <ABI46_0_0React/ABI46_0_0RCTLog.h>

@implementation ABI46_0_0RCTDivisionAnimatedNode

- (void)performUpdate
{
  [super performUpdate];

  NSArray<NSNumber *> *inputNodes = self.config[@"input"];
  if (inputNodes.count > 1) {
    ABI46_0_0RCTValueAnimatedNode *parent1 = (ABI46_0_0RCTValueAnimatedNode *)[self.parentNodes objectForKey:inputNodes[0]];
    ABI46_0_0RCTValueAnimatedNode *parent2 = (ABI46_0_0RCTValueAnimatedNode *)[self.parentNodes objectForKey:inputNodes[1]];
    if ([parent1 isKindOfClass:[ABI46_0_0RCTValueAnimatedNode class]] &&
        [parent2 isKindOfClass:[ABI46_0_0RCTValueAnimatedNode class]]) {
      if (parent2.value == 0) {
        ABI46_0_0RCTLogError(@"Detected a division by zero in Animated.divide node");
        return;
      }
      self.value = parent1.value / parent2.value;
    }
  }
}

@end
