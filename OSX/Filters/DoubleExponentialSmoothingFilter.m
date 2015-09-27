//
//  DoubleExponentialSmoothingFilter.m
//
//  Created by Steve Webster on 27/09/2015.
//

#import "DoubleExponentialSmoothingFilter.h"

@implementation DoubleExponentialSmoothingFilter

- (id)init {
    self = [super init];
    
    alpha = 0.35;
    interval = 350;

    return self;
}

- (id)initWithConfig:(NSDictionary *)config {
    return [self init];
}

- (void)applyFilterToAxis:(float [])axis {
    
    if (initialised) {
        for (int i = 0; i < 3; i++) {
            sp[i] = alpha * axis[i] + (1 - alpha) * sp[i];
            sp2[i] = alpha * sp[i] + (1 - alpha) * sp2[i];
        }
        
        int elapsed = fabs([lastTickTime timeIntervalSinceNow]) * 1000;
        
        int step = elapsed / interval;
        float ratio = (alpha * step) / (1 - alpha);
        for (int i = 0; i < 3; i++) {
            axis[i] = (2 + ratio) * sp[i] - (1 + ratio) * sp2[i];
        }
        
    } else {
        for (int i = 0; i < 3; i++) {
            sp[i] = sp2[i] = axis[i];
        }

        initialised = true;
    }
    lastTickTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

@end
