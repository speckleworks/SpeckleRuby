var _callRuby = function (method, args) {//TODO replace this old method with the new "sketchup." syntax
    window.location.href = 'skp:' + method + '@' + JSON.stringify(args);
};
var logCall = function (callName, args) {
    console.log('logCall ' + callName);
    _callRuby('logCall', {callName: callName, args: args});
};
var _prepData = function (data) {
    //Note: some methods using base64 encoding (temporary workaround for a bug on the Rhino side)
    var jsonStr = JSON.stringify(data);
    return window.btoa(jsonStr);
};

//SketchUp-specific implementation of Rhino
//-- SpeckleRhino/SpeckleRhinoPlugin/src/Interop.cs
var Interop = {
    UserAccounts: [],
    UserClients: [],
    SpeckleObjectCache: {},
    SpeckleIsReady: false,
    _returnValues: {},
    NotifySpeckleFrame: function (method, streamId, data) {
        //TODO note btoa is only needed for certain specific methods...
        EventBus.$emit(method, streamId, _prepData(data))
    },
    getHostApplicationType: function () {
        logCall('getHostApplicationType');
        return new Promise(function (resolve, reject) {
            resolve('SketchUp');
        });
    },
    getUserAccounts: function () {
        logCall('getUserAccounts');
        return new Promise(function (resolve, reject) {
            sketchup.getUserAccounts({
                onCompleted: function () {
                    //sketchup.getUserAccounts updates Interop.UserAccounts directly as we cannot return a value in onCompleted
                    resolve(JSON.stringify(Interop.UserAccounts));
                    console.log('Ruby side done: ' + JSON.stringify(Interop.UserAccounts));
                }
            });

        });
    },
    getLayersAndObjectsInfo: function () {
        logCall('getLayersAndObjectsInfo');
        return new Promise(function (resolve, reject) {
            sketchup.getLayersAndObjectsInfo({
                onCompleted: function () {
                    console.log('Ruby side done for getLayersAndObjectsInfo: ' + JSON.stringify(Interop._returnValues.getLayersAndObjectsInfo));
                    resolve(_prepData(Interop._returnValues.getLayersAndObjectsInfo));
                }
            });
        });
    },
    getAllClients: function () {
        logCall('getAllClients');
        return new Promise(function (resolve, reject) {
            resolve([]);
        });
    },
    removeClient: function (clientId) {
        logCall('removeClient');
        return new Promise(function (resolve, reject) {
            resolve([]);
        });
    },
    appReady: function () {
        Interop.SpeckleIsReady = true;
        _callRuby('appReady');
    },
    bakeClient: function (clientId) {
        logCall('bakeClient');
    },
    addSenderClientFromSelection: function (clientId) {
        logCall('addSenderClientFromSelection');
    },
    bakeLayer: function (clientId, layerGuid) {
        logCall('bakeLayer');
    },
    setClientPause: function (clientId, status) {
        logCall('setClientPause');
    },
    setClientVisibility: function (clientId, status) {
        logCall('setClientVisibility');
    },
    setClientHover: function (clientId, status) {
        logCall('setClientHover');
    },
    setLayerVisibility: function (clientId, layerId, status) {
        logCall('setLayerVisibility');
    },
    setLayerHover: function (clientId, layerId, status) {
        logCall('setLayerHover');
    },
    setObjectHover: function (clientId, layerId, status) {
        logCall('setObjectHover');
    },
    addRemoveObjects: function (clientId, _guids, remove) {
        logCall('addRemoveObjects');
        sketchup.addRemoveObjects({
            clientId: clientId
        });
        // _callRuby('addRemoveObjects', clientId, _guids, remove);
    },
    refreshClient: function (clientId) {
        logCall('refreshClient');
    },
    forceSend: function (clientId) {
        logCall('forceSend');
    },
    openUrl: function (url) {
        logCall('openUrl');
    },
    setName: function (clientId, name) {
        _callRuby('setName', clientId, name);
    },
};
