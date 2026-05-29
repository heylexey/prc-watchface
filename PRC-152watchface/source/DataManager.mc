import Toybox.Activity;
import Toybox.System;
import Toybox.Position;
import Toybox.Lang;
import Toybox.Time;
//import Toybox.Time.Gregorian;
using Toybox.Time.Gregorian;

class DataManager {

    // ── Battery ─────────────────────────────────────
    static function getBattery() as Lang.Float {
        return System.getSystemStats().battery;
    }

    // ── Heart Rate (null-safe) ───────────────────────
    static function getHeartRate() as Lang.String {
        var info = Activity.getActivityInfo();
        if (info != null && info.currentHeartRate != null) {
            return info.currentHeartRate.format("%03d");
        }
        return "---";
    }

    // ── Steps (null-safe) ───────────────────────────
    static function getSteps() as Lang.Number {
        // var info = Activity.getActivityInfo();
        // if (info != null && info.steps != null) {
        //     return info.steps;
        // }
        return 0;
    }

    // ── GPS Status ──────────────────────────────────
    static function getGpsStatus() as Lang.String {
        try {
            var posInfo = Position.getInfo();
            if (posInfo != null && posInfo.accuracy >= Position.QUALITY_GOOD) {
                return "FIX";
            }
        } catch (e instanceof Lang.Exception) {
            // GPS not available in this context
        }
        return "---";
    }

    // ── Notifications ───────────────────────────────
    static function getNotifications() as Lang.Number {
        return System.getDeviceSettings().notificationCount;
    }

    // ── Date string ─────────────────────────────────
    static function getDateString() as Lang.String {
        var now  = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_SHORT);
        return Lang.format("$1$/$2$", [
            info.month.format("%02d"),
            info.day.format("%02d")
        ]);
    }

    // ── UTC Time ─────────────────────────────────────────────────
    //
    // How it works:
    //   System.getClockTime() → local time (already timezone-adjusted)
    //   getDeviceSettings().timeZoneOffset → seconds east of UTC
    //     e.g. Bangkok UTC+7 = 25200, New York UTC-5 = -18000
    //   We convert local H:M to total minutes, subtract the offset,
    //   then normalize into 0–1439 range to handle day boundary wrapping.
    //
    static function getUtcTime() as Toybox.Time.Gregorian.Info {
        // retreiving UTC time
        var utcTime = Gregorian.utcInfo(Time.now(), Time.FORMAT_MEDIUM);
        return utcTime;
    }
}