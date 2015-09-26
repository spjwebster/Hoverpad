//
//  FoohidDevice.h
//
//  Created by Steve Webster on 24/09/2015.
//

#import <Foundation/Foundation.h>
#import "FoohidDeviceImpl.h"

@class FoohidDeviceImpl;

@interface FoohidDevice : NSObject {
@private
    FoohidDeviceImpl *m_Impl;
    NSString         *m_Name;
}

- (id)initWithHIDDescriptor:(NSData*)HIDDescriptor name:(NSString*)name;

- (NSString*)name;

- (BOOL)updateHIDState:(NSData*)HIDState;

@end
