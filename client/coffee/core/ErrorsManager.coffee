class ErrorsManager
    @.ERROR_LOCAL_PLAN_NOT_LOAD = 'PlanNotLoad'
    @.ERROR_EMPLOEE_STAT_NOT_LOAD = 'EmployeeStatNotLoad'
    @.ERROR_GEOPOSITION_PERMISSION_DENIED = 'GeopositionDenied'

    _errors: {
        'FailStepByStep': getText('Недопустимое действие!'),
        'LoginNotValide': getText('Консультант с таким ID не найден в базе.'),
        'ShopNotValide': getText('Магазин с таким ID не найден в базе.'),
        'ErrorTypeDay': getText('Магазин для данного типа отчета не найден!'),
        'PlanNotLoad': getText('Ошибка получения плана!'),
        'EmployeeStatNotLoad': getText('Отсутстувет статистика по консультантам!'),
        'NoInternetConnection': getText('Подключение к интернету отсутствует'),
        'GeopositionDenied': getText('Приложение запрашивает ваши геоданные. Проверьте настройки геопозиции!')
    }

    constructor: ->
        _.extend(@, Backbone.Events)

    throwException: (exceptionName) ->
        @.trigger('error:unknown')
        message = @._errors[exceptionName]
        if !message
            message = getText('Неизвестная ошибка!')
        nativeAlert(message)
