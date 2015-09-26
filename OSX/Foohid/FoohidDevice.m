//
//  FoohidDevice.m
//
//  Created by Steve Webster on 24/09/2015.
//

#import "FoohidDevice.h"

@implementation FoohidDevice

- (id)initWithHIDDescriptor:(NSData*)HIDDescriptor name:(NSString*)name {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    m_Impl = [[FoohidDeviceImpl alloc] initWithName:name];
    if (m_Impl == nil) {
        return nil;
    }

    // Try to destroy first, just in case it already exists
    // TODO: Can we leave this hanging around and just connect and use it? Destroying seems to cause
    // games (or at least E:D) to unbind the joystick's controls.
    [m_Impl destroy];

    if (![m_Impl create:HIDDescriptor]) {
        return nil;
    }
    
    m_Name = [name copy];
    return self;
}

- (NSString*)name {
    return m_Name;
}

- (void)dealloc {
    if (m_Impl) {
        [m_Impl destroy];
    }
}

- (BOOL)updateHIDState:(NSData*)HIDState {
    NSLog(@"FoohidDevice updateHIDState:%@", [HIDState description]);
    return [m_Impl send:HIDState];
}

@end
