import Toybox.Activity;
import Toybox.System;
import Toybox.Position;
import Toybox.Lang;
import Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;


class DataManager {

    // ── Battery ─────────────────────────────────────
    static function getBattery() as Lang.Float {
        return System.getSystemStats().battery;
    }

    // ── Steps (null-safe) ───────────────────────────
    static function getSteps() as Lang.Number {
            var info = ActivityMonitor.getInfo();
            if (info != null && info.steps != null) {
                return info.steps;
            }
            return 0;
    }

    // ── Notifications ───────────────────────────────
    static function getUnreadNotifications() as Number {
        var settings = System.getDeviceSettings();
        if (settings != null) {
            return settings.notificationCount;
        }
    }

    // ── UTC Time ─────────────────────────────────────────────────
    static function getUtcTime() as Toybox.Time.Gregorian.Info {
        // retreiving UTC time
        var utcTime = Gregorian.utcInfo(Time.now(), Time.FORMAT_MEDIUM);
        return utcTime;
    }
}