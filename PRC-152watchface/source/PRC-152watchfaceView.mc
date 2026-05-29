// Prc152View.mc
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;           // FIX: Required to resolve 'Number' and 'Lang.format'
import Toybox.Time;           // FIX: Required for Time.now() in the bottom bar
import Toybox.Time.Gregorian;

class Prc152View extends WatchUi.WatchFace {

    // Cache screen dimensions — computed once
    private var _width  as Number = 0;
    private var _height as Number = 0;
    private var _strBat as String = "R BAT";
    // 1. Declare class variables to hold your custom fonts
    private var _customFontLarge as Graphics.FontResource? = null;
    private var _customFontSmall as Graphics.FontResource? = null;

    //Fonts
    private var _milfont16b = loadResource(Rez.Fonts.MilFont16Bold);
    private var _milfont15b = loadResource(Rez.Fonts.MilFont15Bold);
    private var _milfont34b = loadResource(Rez.Fonts.MilFont34Bold);
    private var _milfont26b = loadResource(Rez.Fonts.MilFont26Bold);

    private var _topBarBelly = 0;
    private var _bottomBarIcepick = 0;

    function initialize() { WatchFace.initialize(); }

    function onLayout(dc as Dc) {
        _width  = dc.getWidth();   // 280
        _height = dc.getHeight();  // 280
        _topBarBelly = _height * 0.21428571428;
        _bottomBarIcepick = Math.round(_height / 1.4);
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

    // ─── Render Methods ──────────────────────────────────────────

    private function _drawBackground(dc as Dc) {
        // Military phosphor green — closest 64-color match
        dc.setColor(0x005500, Graphics.COLOR_GREEN);
        // dc.setColor(0x336633, 0x1a5410);

        dc.clear();
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
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            _width / 2, _height * 0.125,
            _milfont15b,
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
        var bat    = DataManager.getBattery();
        var barW   = _width * 0.1964;
        var barH   = _height * 0.0321;
        var barX   = _width * 0.2429;
        var filled = (bat / 100.0 * barW).toNumber();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);

        // "R BAT" label
        dc.drawText(_width * 0.0821, _topBarBelly, _milfont15b, _strBat, Graphics.TEXT_JUSTIFY_LEFT);

        // Outline (empty bar)
        dc.drawRectangle(barX, _topBarBelly + (_width * 0.0179), barW, barH);

        // Fill (charged portion)
        if (filled > 2) {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.fillRectangle(barX + 1, _topBarBelly + (_width / 46.6666), filled - 2, barH - 2);
        }
    }

    private function _drawRightPanel(dc as Dc) {
        var steps = "019800";
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_width * 0.9107, _topBarBelly, _milfont15b,
                    Lang.format("GSC $1$", [steps]),//Ground Steps Count
                    Graphics.TEXT_JUSTIFY_RIGHT);
    }

    private function _drawPrimaryFreq(dc as Dc) {
        
        var t = System.getClockTime();
        // Format as frequency: HH.MMM.SS
        var timeStr = Lang.format(">T1:$1$.$2$.000", [
            t.hour.format("%02d"),
            t.min.format("%02d")
        ]);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_width / 14, _height * 0.3214, _milfont34b, timeStr,
                    Graphics.TEXT_JUSTIFY_LEFT);
    }

    private function _drawSecondaryFreq(dc as Dc) {
        var utcTime = DataManager.getUtcTime();
        // Format as frequency: HH.MMM.SS
        var utc = Lang.format("T2:$1$.$2$.00", [
            utcTime.hour.format("%02d"),
            utcTime.min.format("%02d")
        ]);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_width / 14, _height * 0.4643, _milfont26b, utc,
                    Graphics.TEXT_JUSTIFY_LEFT);
    }

    private function _drawCentralBar(dc as Dc) {
        var steps = DataManager.getSteps();
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayStr = Lang.format("TYPE M $1$/$2$", [
            today.day, today.month
        ]);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_width / 4, _height * 0.65, _milfont16b, dayStr,
                    Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText((_width / 4) * 3, _height * 0.65, _milfont16b, "MSG 0001",//Messages, notification count
                    Graphics.TEXT_JUSTIFY_CENTER);
    }
    private function _drawBottomBar(dc as Dc) {
        var steps = DataManager.getSteps();
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        // var dayStr = Lang.format("TYPE M $1$/$2$ TDR", [
        //     today.day, today.month
        // ]);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(_width / 28, _bottomBarIcepick, Math.round(_width * 0.9643), _height / 1.4);
        // dc.drawText(_width / 2, 208, _milfont16b, _bottomBarIcepick,
        //             Graphics.TEXT_JUSTIFY_CENTER);
    }
}