class Device
    @.NAME_IPHONE = 'iphone'
    @.NAME_IPOD = 'ipod'
    @.NAME_IPAD = 'ipad'
    @.NAME_ANDROID = 'android'
    @.NAME_BLACKBERRY = 'blackberry'

    @.TYPE_DESKTOP = 'desktop'
    @.TYPE_MOBILE = 'mobile'
    @.TYPE_TABLE = 'tablet'

    @.OS_IOS = 'ios'
    @.OS_ANDROID = 'android'
    @.OS_WINPHONE = 'wp'

    @.PLATFORM_WEB = 'web'

    @.GEO_PERMISSION_DENIED = 1;
    @.GEO_POSITION_UNAVAILABLE = 2;
    @.GEO_TIMEOUT = 3;

    @.ORIENTATION_UNLOCK = null
    @.ORIENTATION_LANDSCAPE = 'landscape'
    @.ORIENTATION_PORTRAIT = 'portrait'

    _watchLocationEnable: false
    _geolocationMessageShowed: false

    _geoPositionParams: {
        enableHighAccuracy: true,
        maximumAge: 0,
        timeout: 1000
    }

    _waitEnableGPS: false

    constructor: ->
        _.extend(@, Backbone.Events)
        @._watchID = null
        @.language = Config.DEFAULT_LANGUAGE

        @.coordinates = {
            latitude: 0,
            longitude: 0,
            accuracy: 0
        }

        try
            @.name = String(device.platform).toLowerCase()
            @.version = device.version
            @.type = Device.TYPE_MOBILE
        catch Error
            @.type = Device.TYPE_DESKTOP
            console.log('error detect device!')

        @._geoPositionParams.timeout = Config.GEOLOCATION_TIMEOUT_OTHER;

        if @.name == Device.OS_IOS
            @.os = Device.OS_IOS

        if @.name == Device.NAME_ANDROID
            @.os = Device.OS_ANDROID
            @._geoPositionParams.timeout = Config.GEOLOCATION_TIMEOUT_ANDROID;

        if @.name and @.name.length > 0 and @.name.indexOf('win') > -1
            @.os = Device.OS_WINPHONE

        @._enableTrustCertIOS()

        if navigator.globalization
            navigator.globalization.getLocaleName(
              @._onGetDeviceLanguage, @_onErrorGetDeviceLanguage
            )
        else
            @.language = navigator.language

        $(document).on("offline", @._onOfflineConnection)
        $(document).on("online", @._onOnlineConnection)

    checkConnection: ->
        if (@.type == Device.TYPE_DESKTOP)
            return true

        if navigator.connection.type == 'none'
            return false
        else
            return true

    geopositionEnabled: ->
        return @._watchLocationEnable

    enableOrientation:(value) ->
        try
            if value == null
                screen.unlockOrientation();
            else
                screen.lockOrientation(value)
        catch e
            console.log('enableOrientation:' + e);

    enableGeoposition: (value) ->
        @._watchLocationEnable = value
        if value
            @._startWatchLocation()
        else
            @._stopWatchLocation()

    updateGeoposition: =>
        navigator.geolocation.getCurrentPosition(
            @._onGetGeolocationSuccess, @._onGeolocationFail, @._geoPositionParams)

    _startWatchLocation: ->
        @._stopWatchLocation()
        @._geolocationMessageShowed = false
        @._watchID = setInterval(@._getGeoposition, @._geoPositionParams.timeout)

    _getGeoposition: =>
        navigator.geolocation.getCurrentPosition(
            @._onGetGeolocationSuccess, @._onGeolocationFail, @._geoPositionParams)

    _stopWatchLocation: ->
        @._geolocationMessageShowed = false

        if @._watchID != null
            clearInterval(@._watchID)

        @._watchID = null

    _onGetGeolocationSuccess: (data) =>
        @.coordinates = data.coords

    _onGeolocationFail: (error) =>
        if !error or !error['code']
            app.errorsManager.throwException(ErrorsManager.ERROR_GEOPOSITION_PERMISSION_DENIED)
            return

        error.code = parseInt(error.code)

        if @._geoPositionParams.enableHighAccuracy == true and error.code != Device.GEO_TIMEOUT
            @._geoPositionParams.enableHighAccuracy = false
            return

        if @._geolocationMessageShowed
            return

        @._geolocationMessageShowed = true

        if error.code == Device.GEO_PERMISSION_DENIED
            app.errorsManager.throwException(ErrorsManager.ERROR_GEOPOSITION_PERMISSION_DENIED)
        else if @.os == Device.OS_ANDROID
            if error.code == Device.GEO_POSITION_UNAVAILABLE or error.code == Device.GEO_TIMEOUT
                app.errorsManager.throwException(ErrorsManager.ERROR_GEOPOSITION_PERMISSION_DENIED)

    _onGetDeviceLanguage: (data) =>
        if data
          @.language = String(data.value).substr(0, 2).toLowerCase()

    _onErrorGetDeviceLanguage: =>
        return

    _onOfflineConnection: =>
        @.trigger('deviceOffline')

    _onOnlineConnection: =>
        @.trigger('deviceOnline')

    _enableTrustCertIOS: ->
        if @.os == Device.OS_IOS
            cordova.plugins.certificates.trustUnsecureCerts(true)
