// Prc152View.mc
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;           // FIX: Required to resolve 'Number' and 'Lang.format'
import Toybox.Time;           // FIX: Required for Time.now() in the bottom bar
import Toybox.Time.Gregorian;
using Toybox.System;

class Prc152View extends WatchUi.WatchFace {

    //=========Notification area==========
    public var notifX = 0;
    public var notifY = 0;
    public var notifWidth = 0;
    public var notifHeight = 0;

    //=========GSC area==========
    public var gscX = 0;
    public var gscY = 0;
    public var gscWidth = 0;
    public var gscHeight = 0;

    //=========Calendar area==========
    public var cldrX = 0;
    public var cldrY = 0;
    public var cldrWidth = 0;
    public var cldrHeight = 0;

    // Cache screen dimensions — computed once
    private var _width  as Number = 0;
    private var _height as Number = 0;

    //Fonts
    private var _milfont16b = loadResource(Rez.Fonts.MilFont16Bold);
    private var _milfont15b = loadResource(Rez.Fonts.MilFont15Bold);
    private var _milfont18b = loadResource(Rez.Fonts.MilFont18Bold);
    private var _milfont20b = loadResource(Rez.Fonts.MilFont20Bold);
    private var _milfont26b = loadResource(Rez.Fonts.MilFont26Bold);
    private var _milfont30b = loadResource(Rez.Fonts.MilFont30Bold);
    private var _milfont34bl = loadResource(Rez.Fonts.MilFont34BoldItalic);
    private var _milfont42b_l = loadResource(Rez.Fonts.MilFont42BoldItalic);     
    private var _milfont46b = loadResource(Rez.Fonts.MilFont46Bold);
    private var _milfont60b = loadResource(Rez.Fonts.MilFont60Bold);
    private var _milfont70b = loadResource(Rez.Fonts.MilFont70Bold);

    private var _topBarBelly = 0;
    private var _bottomBarIcepick = 0;
    private var _basicGreen = Graphics.COLOR_GREEN;

    function initialize() { 
        System.println("WatchFace!");
        WatchFace.initialize();     
    }

    function onLayout(dc as Dc) {
        _width  = dc.getWidth();
        _height = dc.getHeight();
        _topBarBelly = Math.round(_height * 0.2);
        _bottomBarIcepick = Math.round(_height * 0.75);
    }

    function onUpdate(dc as Dc) {
        _drawBackground(dc);
        // _drawScanlines(dc);
        _drawTopBar(dc);
        _drawPrimaryFreq(dc);     // TIME as frequency
        _drawSecondaryFreq(dc);   // HR as frequency
        _drawBatteryBar(dc);
        _drawCentralBar(dc);
        _drawBottomBar(dc);
        _drawRightPanel(dc);
    }

    private function _drawBackground(dc as Dc) {
        // Clear screen to black first
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Draw green area
        dc.setColor(_basicGreen, _basicGreen);

        dc.fillRectangle(
            0,
            _topBarBelly,
            dc.getWidth(),
            _bottomBarIcepick - _topBarBelly
        );
    }

    private function _drawScanlines(dc as Dc) {
        // Subtle horizontal lines for CRT/LCD feel
        dc.setColor(0x005500, Graphics.COLOR_TRANSPARENT);
        for (var y = 0; y < _height; y += 4) {
            dc.drawLine(0, y, _width, y);
        }
    }

    private function _drawTopBar(dc as Dc) {
        // "WIDEBAND NETWORKING" equivalent — mission/callsign label
        dc.setColor(_basicGreen, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            _width / 2, _height * 0.125,
            _milfont20b,
            "WIDEBAND NETWORKING",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Separator line
        dc.drawLine(0, _topBarBelly, _width / 1.037, _topBarBelly);
    }

    // ─────────────────────────────────────────────────────────────
    // How it works:
    //   - Gets battery float (0.0–100.0) from DataManager
    //   - Draws an outline rectangle (the "empty" bar)
    //   - Fills a proportional inner rectangle (the "charged" portion)
    //   - Guards against filled=0 to avoid drawing 0-width rectangle
    // ─────────────────────────────────────────────────────────────
    private function _drawBatteryBar(dc as Graphics.Dc) as Void {
        var strBat = "R BAT";
        var bat    = DataManager.getBattery();
        var barW   = _width * 0.1964;
        var barH   = _height * 0.0321;
        var barX   = _width * 0.2729;
        var filled = (bat / 100.0 * barW).toNumber();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);

        // "R BAT" label
        dc.drawText(_width * 0.0821 + 2, _topBarBelly, _milfont16b, strBat, Graphics.TEXT_JUSTIFY_LEFT);

        // Outline (empty bar)
        dc.drawRectangle(barX, _topBarBelly + (_width * 0.0179), barW, barH);

        // Fill (charged portion)
        if (filled > 2) {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.fillRectangle(barX + 1, _topBarBelly + (_width / 46.6666), filled - 2, barH - 2);
        }
    }

    //GSC - Ground Steps Count
    private function _drawRightPanel(dc as Dc) {
        var steps = DataManager.getSteps();
        var prepSteps = "000000";

        if(steps != 0){
            prepSteps = steps.toString();
            // Keep only the leftmost 6 characters
            if (prepSteps.length() > 6) {
                prepSteps = prepSteps.substring(0, 6);
            }
            
            if(prepSteps.length() < 6) {
            //Formatting steps for display
                while (prepSteps.length() < 6) {
                    prepSteps = prepSteps + "-";
                }
            }
        }
        //Draw step counter
        var gscWidthPos = _width * 0.9107;
        var gscHeightPos = _topBarBelly;
        gscX = gscWidthPos - (gscWidthPos * 0.2);
        gscY = gscHeightPos - (gscHeightPos * 0.2);
        gscWidth = gscWidthPos + (gscWidthPos * 0.2);
        gscHeight = gscHeightPos + (gscHeightPos * 0.2);
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(gscWidthPos, gscHeightPos, _milfont16b,
                    Lang.format("GSC $1$", [prepSteps]),//Ground Steps Count
                    Graphics.TEXT_JUSTIFY_RIGHT);
    }

    private function _drawPrimaryFreq(dc as Dc) {
        
        var t = System.getClockTime();
        // Format as frequency: HH.MMM.SS
        var timeStr = Lang.format("T1:$1$$2$.--", [
            t.hour.format("%02d"),
            t.min.format("%02d")
        ]);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_width / 2, _height * 0.3914, _milfont70b, timeStr,
                    Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function _drawSecondaryFreq(dc as Dc) {
        var utcTime = DataManager.getUtcTime();
        // Format as frequency: HH.MMM.SS
        var utc = Lang.format("T2:$1$$2$.--", [
            utcTime.hour.format("%02d"),
            utcTime.min.format("%02d")
        ]);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_width / 14, _height * 0.55, _milfont26b, utc,
                    Graphics.TEXT_JUSTIFY_LEFT);       
    }

    private function _drawCentralBar(dc as Dc) {
        var cbHeight = _height * 0.675;
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayStr = Lang.format("TYPE M $1$/$2$", [
            today.day, today.month
        ]);

        //Draw calendar
        var cldrWidthPos = _width / 3.5 + 2;;
        var cldrHeightPos = cbHeight;
        cldrX = cldrWidthPos - (cldrWidthPos * 0.2);
        cldrY = cldrHeightPos - (cldrHeightPos * 0.2);
        cldrWidth = cldrWidthPos + (cldrWidthPos * 0.2);
        cldrHeight = cldrHeightPos + (cldrHeightPos * 0.2);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cldrWidthPos, cldrHeightPos, _milfont30b, dayStr,
                    Graphics.TEXT_JUSTIFY_CENTER);

        //Draw notifications counter (MSG)
        var rawNotifs = DataManager.getUnreadNotifications();
        var notifs = "000";

        if(rawNotifs != 0){
            notifs = rawNotifs.toString();
            // Keep only the rightmost 6 characters
            if (notifs.length() > 3) {
                notifs = notifs.substring(0, 3);
            }
            
            if(notifs.length() < 6) {
            //Formatting steps for display
                while (notifs.length() < 3) {
                    notifs = notifs + "-";
                }
            }
        }
        var msgWidthPos = (_width / 4) * 3;
        notifX = msgWidthPos - (msgWidthPos * 0.2);
        notifY = cbHeight - (cbHeight * 0.2);
        notifWidth = msgWidthPos + (msgWidthPos * 0.2);
        notifHeight = cbHeight + (cbHeight * 0.2);
        var notifsStr = Lang.format("MSG $1$", [notifs]);
        dc.drawText(msgWidthPos, cbHeight, _milfont30b, notifsStr,
                    Graphics.TEXT_JUSTIFY_CENTER);
            // dc.drawText(msgWidthPos, _height * 0.65, _milfont18b, "MSG 0001",
            //         Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function _drawBottomBar(dc as Dc) {
        dc.setColor(_basicGreen, Graphics.COLOR_TRANSPARENT);
        var bottomTxtPos = _height - (_bottomBarIcepick * 0.32);
        dc.drawText(_width / 2, bottomTxtPos, _milfont42b_l, "FALCON III",
                    Graphics.TEXT_JUSTIFY_CENTER);
    }
}