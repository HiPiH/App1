#= require ../../core/baseView.coffee


class ResultPageView extends BaseView
    @.DEFAULT_DATA = {
        "a:Cash": "0"
        "a:CountDatInFact": "0"
        "a:CountDayInPlan": "0"
        "a:CountPriority1": "0"
        "a:CountPriority2": "0"
        "a:CountPriority3": "0"
        "a:Plan": "0"
        "done": 0
        "progressWidth": "width:0%"
    }
    @.calculateDone = (cash,plan) ->
        done = 0
        cash = if !_.isNaN(parseInt(cash)) then parseInt(cash) else 0
        plan = parseInt(plan)
        if (plan > 0 and cash >= 0 and !_.isNaN(plan))
            done = parseInt(cash)/parseInt(plan)*100
        return done.toFixed(1)
        
    @.resultMapper = (result) ->
        {
        "Cash": if result['a:Cash']._ then result['a:Cash']._ else result['a:Cash']
        "CountDatInFact": if result['a:CountDatInFact']._ then result['a:CountDatInFact']._ else result['a:CountDatInFact']
        "CountDayInPlan": if result['a:CountDayInPlan']._ then result['a:CountDayInPlan']._ else result['a:CountDayInPlan']
        "CountPriority1": if result['a:CountPriority1']._ then result['a:CountPriority1']._ else result['a:CountPriority1']
        "CountPriority2": if result['a:CountPriority2']._ then result['a:CountPriority2']._ else result['a:CountPriority2']
        "CountPriority3": if result['a:CountPriority3']._ then result['a:CountPriority3']._ else result['a:CountPriority3']
        "Plan": if result['a:Plan']._ then result['a:Plan']._ else result['a:Plan']
        }
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-start'
    ###
    template: JST['b-result-page']

    constructor:->
        @._action = SOAPRequests.ACTION_GET_MONTH_RESULT_EMPLOYEE
        @.data = ResultPageView.DEFAULT_DATA

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @._html.remove()
        ResultPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render:() ->
        ResultPageView.__super__.render.apply(@)
        @._html = $(@.template(@))
        app.soap.send(@._action, '', @._onSuccessSend, @._onFailSend)

        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>

    headerTitle: =>
        return getText('Результаты')

    _onSuccessSend: (result) =>
        @.data = ResultPageView.resultMapper(result)
        @.data.done = ResultPageView.calculateDone(@.data['Cash'],@.data['Plan'])
        @.data.progressWidth = 'width:'+@.data.done+'%'
        @._html.replaceWith($(@.template(@)))
        @._html

    _onFailSend: (error) =>
        @._html.replaceWith($(@.template(@)))
        @._html

