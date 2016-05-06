class Localization
    languageList: ['ru', 'en']

    constructor: (fncSuccess) ->
        @.fncSuccess = fncSuccess
        @.isActive = false

        jsonDataTranslate = translate_en()
        if $.i18n().locale == 'ru'
            jsonDataTranslate = translate_ru()

        $.i18n().load(jsonDataTranslate).done(fncSuccess)

    getLocal: =>
        $.i18n().locale
