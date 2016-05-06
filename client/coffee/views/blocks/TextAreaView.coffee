#= extern Backbone.View

class TextAreaView extends Backbone.View
    template: JST['b-text-area']

    constructor: (placeholder, value, maxlength=255) ->
        TextAreaView.__super__.constructor.apply(@)

        @.placeholder= placeholder
        @.value = value
        @.maxlength = maxlength

    remove: ->
        if @.html
            @.html.off()
            @.html.remove()

        TextAreaView.__super__.remove.apply(@)

    render: ->
        @.html = $(@.template(@))
        @.html.on('keypress', @._onKeyPress)

    getValue: ->
        @.html.val()

    clear: ->
        @.html.val('')

    setFocus: =>
        @.html.focus()

    _onKeyPress: (event) =>
        @.trigger('keypress', event)
