#= require ../../core/baseView.coffee


class ConsultantStatPageView extends BaseView
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-start'
    ###
    template: JST['b-consultant-stat-page']

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        if @._listViews
            for i in [0...@._listViews.length]
                @._listViews[i].remove();

            @._listViews = null;
        @._html.remove()

        ConsultantStatPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        ConsultantStatPageView.__super__.render.apply(@)
        @._html = $(@.template())
        @._listViews = [];

        @.list = @._html.find('.b-consultant-stat-page-list')

        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>
        app.soap.send(SOAPRequests.ACTION_GET_DAY_RESULT_EMPLOYEE, '', @._onSuccessLoad, @._onFailLoad)

    headerTitle: =>
        return getText('Статистика по консультантам')

    _onSuccessLoad:(data) =>
        if !data['a:DayEmployeResult']
            app.router.navigate('menu/', {trigger: true, replace: true})
            app.errorsManager.throwException(ErrorsManager.ERROR_EMPLOEE_STAT_NOT_LOAD)
            return;

        @model = null;
        @.collection = new CollectionStatisticEmployee()
        @.collection.parseData(data['a:DayEmployeResult'])

        @.collection.each (model) =>
            @._listViews.push(new ConsultantStatView(model))
            @.list.append(@._listViews[@._listViews.length - 1].render())

    _onFailLoad: =>
