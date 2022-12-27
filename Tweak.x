#import <theos/IOSMacros.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>

// First, we need to prevent the auto-lock value from being changed.
%group profiled
%hook MCBatterySaverMode
// originally return nil when low power mode is off so it's safe to return nil
+(NSDictionary *)currentBatterySaverRestrictions{
    return nil;
}
%end //MCBatterySaverMode
%end //profiled

// Second, we discovered that SpringBoard has a mind of its own.
%group SB
%hook SBIdleTimerDescriptorFactory
- (_Bool)updateIdleTimerSettingsForBatterySaverMode:(id)arg1{
    return 0;
}
%end //SBIdleTimerDescriptorFactory
%end //SB

// Last, unlock the setting and profit!
@interface DBSSettingsController : PSListController
@end
%group PS
%hook DBSSettingsController
-(void)updateAutoLockSpecifier{
    %orig;
    [[self specifierForID:@"AUTOLOCK"] setProperty:@YES forKey:@"enabled"];
}
%end //DBSSettingsController
%end //PS

%ctor{
    NSLog(@"ctor: NoLowPowerMode30SecAutoLock");
    if(IN_SPRINGBOARD){
        %init(SB);
    }
    else if(IN_BUNDLE(@"com.apple.managedconfiguration.profiled")){
        %init(profiled);
    }
    else if(IN_BUNDLE(@"com.apple.Preferences")){
        %init(PS, DBSSettingsController=objc_getClass("DBSSettingsController")?:objc_getClass("PSUIDisplayController"));
    }
}
