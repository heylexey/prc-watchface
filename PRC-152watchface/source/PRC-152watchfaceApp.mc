import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class PRC_152watchfaceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
    return [ new Prc152View() ];
}

}

function getApp() as PRC_152watchfaceApp {
    return Application.getApp() as PRC_152watchfaceApp;
}