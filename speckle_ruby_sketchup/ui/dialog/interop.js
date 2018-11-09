var _callRuby = function (method, args) {
    window.location.href = 'skp:' + method + '@' + JSON.stringify(args);
};
const testUsingSetName = function () {
    _callRuby('setName', {clientId: 'client name', name: 'My Name'});
};
//SketchUp-specific implementation of Rhino
//-- SpeckleRhino/SpeckleRhinoPlugin/src/Interop.cs
var Interop = {
    getHostApplicationType: function () {
        return new Promise(function (resolve, reject) {
            resolve('SketchUp');
        });
    },
    getUserAccounts: function () {
        return new Promise(function (resolve, reject) {
            resolve([]);
        });
    },
    getAllClients: function () {
        return new Promise(function (resolve, reject) {
            resolve([]);
        });
    },
    removeClient: function (clientId) {
        return new Promise(function (resolve, reject) {
            resolve([]);
        });
    },
    appReady: function () {
        testUsingSetName();
    },
    bakeClient: function (clientId) {
        testUsingSetName();
    },
    bakeLayer: function (clientId, layerGuid) {
        testUsingSetName();
    },
    setClientPause: function (clientId, status) {
        testUsingSetName();
    },
    setClientVisibility: function (clientId, status) {
        testUsingSetName();
    },
    setClientHover: function (clientId, status) {
        testUsingSetName();
    },
    setLayerVisibility: function (clientId, layerId, status) {
        testUsingSetName();
    },
    setLayerHover: function (clientId, layerId, status) {
        testUsingSetName();
    },
    setObjectHover: function (clientId, layerId, status) {
        testUsingSetName();
    },
    addRemoveObjects: function (clientId, _guids, remove) {
        testUsingSetName();
    },
    refreshClient: function (clientId) {
        testUsingSetName();
    },
    forceSend: function (clientId) {
        testUsingSetName();
    },
    openUrl: function (url) {
        testUsingSetName();
    },
    setName: function (clientId, name) {
        _callRuby('setName', clientId, name);
    },
};