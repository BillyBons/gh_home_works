//
//  GHCar.m
//  Home Work OOP
//
//  Created by Sergey Zalozniy on 10/31/14.
//  Copyright (c) 2014 Sergey Zalozniy. All rights reserved.
//

#include "GHCar.h"

@implementation GHCar

-(GHCar *) initWithEngineCapacity:(float)capacity andHorsePower:(int)horsePower{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    GHEngine *carEngine = [[GHEngine alloc] init];
    carEngine.capacity = capacity;
    carEngine.horsePower = horsePower;
    
    self.engine = carEngine;
    return self;
    
}

-(void) printCarIformation{
    NSLog(@"%@ (%.1f) - %i h/p, max.speed - %.f", self.mark, self.engine.capacity, self.engine.horsePower, self.topSpeed);
}

-(Boolean) isFasterThanCar:(GHCar *)carToCompare{
    return self.topSpeed > carToCompare.topSpeed;
}

@end
