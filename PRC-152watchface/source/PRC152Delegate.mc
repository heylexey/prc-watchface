using Toybox.System;
using Toybox.WatchUi;
using Toybox.Complications;

class PRC152Delegate extends WatchUi.WatchFaceDelegate {

    private var mView;

    function initialize(view) {
        System.println("InputDelegate!");
        WatchUi.WatchFaceDelegate.initialize();
        mView = view;
        System.println("after WatchUi.InputDelegate.initialize();!");
    }

    // Watch faces do not use onTap. They use onPress.
    function onPress(clickEvent) {
        System.println("Watch face pressed!");
        
        var pressType = 0; //Type for further action.
        var coords = clickEvent.getCoordinates();
        var tapX = coords[0];
        var tapY = coords[1];
        System.println("X: " + coords[0] + ", Y: " + coords[1]);

        // --- BOUNDING BOX CHECK ---
        // Is tapX greater than the left edge, but less than the right edge?
        // Is tapY greater than the top edge, but less than the bottom edge?
        System.println("notifX: " + mView.notifX 
        + ", notifY: " + mView.notifY 
        + ", notifY: " + mView.notifWidth 
        + ", notifHeight: " + mView.notifHeight);

        if (tapX >= mView.notifX && tapX <= (mView.notifX + mView.notifWidth) &&
            tapY >= mView.notifY && tapY <= (mView.notifY + mView.notifHeight)) {
            pressType = 17;
            System.println("Notification Area Tapped!");

        } else if(tapX >= mView.gscX && tapX <= (mView.gscX + mView.gscWidth) &&
                 tapY >= mView.gscY && tapY <= (mView.gscY + mView.gscHeight))
        {
            pressType = 2;
            System.println("GSC Area Tapped!");
        } else if(tapX >= mView.cldrX && tapX <= (mView.cldrX + mView.cldrWidth) &&
                 tapY >= mView.cldrY && tapY <= (mView.gscY + mView.cldrHeight))
        {
            pressType = 6;
            System.println("Calendar Area Tapped!");
        } else {
            return true;
        }

        var iterator = Complications.getComplications();
        var complication = iterator.next();

        while (complication != null) {
        System.println("complication.getType()");
    
        if (complication.getType() == pressType) {
            var complicationId = complication.complicationId;
            Complications.exitTo(complicationId);
            break;
            }
            complication = iterator.next();
        } 
        
        return true;
    }
}