#= require ../../core/baseView.coffee


class InfoView extends BaseView
    @.SAVE_INPUT_PREFIX = 'infoViewInput_'
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-start'
    ###
    template: JST['b-info']

    constructor:(field, reportType = '', saveInput = false) ->
        InfoView.__super__.constructor.apply(@)
        @.fieldName = getText(field.name)
        @.savedName = InfoView.SAVE_INPUT_PREFIX + reportType +  field.name
        @.fieldId = field.id
        @.fieldValue = field.value || ''
        @._needSaveValue = saveInput
        if @._needSaveValue
            @.fieldValue = app.register.getItem(@.savedName, '')

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        InfoView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        InfoView.__super__.render.apply(@)
        @._html = $(@.template(@))

        input = new InputTextView(
          '', @.fieldValue, InputTextView.TYPE_NUMBER, InputTextView.SIZE_TINY,
          null, 255, @.fieldId).on('inputError',@._onInputError)

        if @._needSaveValue
            input.on('input', @._onInputText)

        @._html.append(input.render())
        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>

    clearSavedValue: ->
        app.register.setItem(@.savedName, '')

    _onInputText: (event) =>
        value = $(event.target).val()
        app.register.setItem(@.savedName, value)

    _onInputError: (event) =>
        @.trigger('inputError',event)
