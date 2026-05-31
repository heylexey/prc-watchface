import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Complications;
using Toybox.Application;

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

    function getInitialView() {
        var view = new Prc152View();
        var delegate = new PRC152Delegate(view); 

        return [ view, delegate ];
    }

}

function getApp() as PRC_152watchfaceApp {
    return Application.getApp() as PRC_152watchfaceApp;
}