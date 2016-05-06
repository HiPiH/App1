#= require ../core/BaseView.coffee

class BaseModalView extends BaseView
    ###
    # возвращает необходиость отображать крестик
    # @return {Boolean}
    ###
    needButtonClose: ->
        true

    ###
    # возвращает текст для заголовка
    # @return {String}
    ###
    getTitle: ->
        ''
