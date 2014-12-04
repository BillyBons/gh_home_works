//
//  main.m
//  HomeTask1
//
//  Created by Billy on 22.10.14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        int randomNumber = arc4random() % 2;
        
        if (randomNumber == 0)
        {
            NSLog(@"Работает метод №1 (switch & enum)");
            
            enum month {Январь=1, Февраль, Март, Апрель, Май, Июнь, Июль, Август, Сентябрь, Октябрь, Ноябрь, Декабрь};
            enum month i;
            
            for (i=1; i <= 12 ; i++) {
               switch (i){
                case Январь:
                    NSLog(@"Месяц Январь");
                    break;
                case Февраль:
                    NSLog(@"Месяц Февраль");
                    break;
                case Март:
                    NSLog(@"Месяц Март");
                    break;
                case Апрель:
                    NSLog(@"Месяц Апрель");
                    break;
                case Май:
                    NSLog(@"Месяц Май");
                    break;
                case Июнь:
                    NSLog(@"Месяц Июнь");
                    break;
                case Июль:
                    NSLog(@"Месяц Июль");
                    break;
                case Август:
                    NSLog(@"Месяц Август");
                    break;
                case Сентябрь:
                    NSLog(@"Месяц Сентябрь");
                    break;
                case Октябрь:
                    NSLog(@"Месяц Октябрь");
                    break;
                case Ноябрь:
                    NSLog(@"Месяц Ноябрь");
                    break;
                case Декабрь:
                    NSLog(@"Месяц Декабрь");
                    break;
                   default:
                       break;
               }
            }
            
        }
        else
            {
                NSLog(@"Работает метод №2 (if else if)");
                int i;
                    for (i = 1; i <=12; i++)
                    {
                        if (i == 1) { NSLog(@"Месяц Январь");}
                        else if (i == 2) {NSLog(@"Месяц Февраль");}
                        else if (i == 3) {NSLog(@"Месяц Март");}
                        else if (i == 4) {NSLog(@"Месяц Апрель");}
                        else if (i == 5) {NSLog(@"Месяц Май");}
                        else if (i == 6) {NSLog(@"Месяц Июнь");}
                        else if (i == 7) {NSLog(@"Месяц Июль");}
                        else if (i == 8) {NSLog(@"Месяц Август");}
                        else if (i == 9) {NSLog(@"Месяц Сентябрь");}
                        else if (i == 10) {NSLog(@"Месяц Октябрь");}
                        else if (i == 11) {NSLog(@"Месяц Ноябрь");}
                        else if (i == 12) {NSLog(@"Месяц Декабрь");}
                    }
            }
        
    }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }

