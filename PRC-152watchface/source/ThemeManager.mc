import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;

class ThemeManager {

    static const PALETTE as Array<Number> = [
        Graphics.COLOR_GREEN,           // 0 – Green
        Graphics.COLOR_BLUE,            // 1 – Blue
        Graphics.COLOR_DK_BLUE,         // 2 – Dark blue
        Graphics.COLOR_WHITE,           // 3 – white
        #808080,                       // 4 – White phosphorus
        0x005500                       // 5 – PRC Green
    ] as Array<Number>;

    static const LABELS as Array<String> = [
        "GREEN", "BLUE", "DARK BLUE", "WHITE", "WHITE PHOSPHORUS", "RADIO GREEN"
    ] as Array<String>;

    static function getAccentColor() as Number {
        var idx = Application.Properties.getValue("AccentColor");
        if (idx == null || idx < 0 || idx >= PALETTE.size()) {
            idx = 0;
        }
        return PALETTE[idx as Number];
    }

    static function saveAccentColor(idx as Number) as Void {
        Application.Properties.setValue("AccentColor", idx);
    }
}