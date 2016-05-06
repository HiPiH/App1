#= require ../../core/baseView.coffee


class PlanPageView extends BaseView
    @.SAVED_PLAN = 'savedPlan'
    @.SHOW_COUNT_DAYS = 42

    DAYS_WEEK_NAME: [
        getText('Пн'),  getText('Вт'), getText('Ср'), getText('Чт'), getText('Пт'), getText('Сб'), getText('Вс')
    ];

    MONTHS_NAME: [
        getText('Январь'), getText('Февраль'), getText('Март'), getText('Апрель'), getText('Май'),
        getText('Июнь'), getText('Июль'), getText('Август'), getText('Сентябрь'), getText('Октябрь'),
        getText('Ноябрь'), getText('Декабрь')
    ];

    ###
    # Возвращает необходимый темплейт
    # @template {function}
    ###
    template: JST['b-plan-page']

    _calendarItems: null
    _renderedItems: null

    constructor: ->
        PlanPageView.__super__.constructor.apply(@)
        @._calendarItems = []
        @._renderedItems = []

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        if @._html
            for item in @._renderedItems
                item.off()
                item.remove()
            @._calendarItems = null
            @._renderedItems = null
            @._planContainer.remove()
            @._html.remove()
        PlanPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        PlanPageView.__super__.render.apply(@)
        @._html = $(@.template())
        @._planContainer = @._html.find('.b-plan-container')
        @._planTable = @._html.find('.b-plan-page-table')
        @._planDate = @._html.find('.b-plan-day-date')
        @.shopValue = @._html.find('.b-plan-day-shop')
        @.timeStartValue = @._html.find('.b-plan-day-start')
        @.timeStopValue = @._html.find('.b-plan-day-stop')
        @.planValue = @._html.find('.b-plan-day-plan')


        @.headerDays = @._html.find('.header-day')

        for i in [0..@.headerDays.length]
            item = @.headerDays.eq(i)
            item.html(getText(@.DAYS_WEEK_NAME[i]))

        @._html.find('.b-plan-day-shop-caption').html(getText('Магазин'))
        @._html.find('.b-plan-day-start-caption').html(getText('Начало'))
        @._html.find('.b-plan-day-stop-caption').html(getText('Конец'))
        @._html.find('.b-plan-day-plan-caption').html(getText('План'))

        @._html.hide()
        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>
        if app.device.checkConnection() == false
            plan = app.register.getItem(PlanPageView.SAVED_PLAN, null)
            @._onLoadPlan(plan)
        else
            app.soap.send(SOAPRequests.ACTION_GET_PLAN, '', @._onLoadPlan, @._onFailLoadPlan)

    headerTitle: =>
        dateNew = new Date()
        return getText('План ') + getText(@.MONTHS_NAME[dateNew.getMonth()]) + ' ' + dateNew.getFullYear()

    _onLoadPlan: (response) =>
        if (!response || !response['a:PlanEmployer'])
            @._onFailLoadPlan()
            return

        app.register.setItem(PlanPageView.SAVED_PLAN, response)
        app.multitone.getPlanCollection().parseData(response['a:PlanEmployer'])
        collection = app.multitone.getPlanCollection()
        collection.each (model) =>
            modelShop = model.get('shop')

        @._createPlan()

    _onFailLoadPlan: =>
        app.router.navigate('menu/', {trigger: true})
        app.errorsManager.throwException(ErrorsManager.ERROR_LOCAL_PLAN_NOT_LOAD)

    _createPlan: ->
        dateCalendar = null
        collection = app.multitone.getPlanCollection()

        if collection.at(0)
            currentDay = new Date().getUTCDate()
            dateCalendar = collection.at(0).get('date')
            nowMonth = dateCalendar.getMonth() + 1;
            nextMonth = nowMonth + 1;
            year = dateCalendar.getFullYear()

            if nextMonth >= 13
                nextMonth = 1

            monthStart = new Date(year, dateCalendar.getMonth(), 1);
            monthEnd = new Date(year, nowMonth, 1);
            monthLength = (monthEnd - monthStart) / (1000 * 60 * 60 * 24)

            monthEnd = new Date(year, dateCalendar.getMonth(), 0);

            beforeMonthLength = monthEnd.getDate();
            dayWeek = dateCalendar.getDay()

            dayWeek = dayWeek || 7

            lastDays = beforeMonthLength - (dayWeek - 1)

            for i in [1...dayWeek]
                day = lastDays + i
                @._calendarItems.push(new DayCalendarView(day, null))

            calendar = new Array(PlanPageView.SHOW_COUNT_DAYS - @._calendarItems.length)

            collection.each (model) =>
                day = model.get('date').getDate()
                calendar[day] = new DayCalendarView(day, model)

            indexNewDay = 0
            itemDay = null
            for i in [1..calendar.length]
                if calendar[i]
                    itemDay = calendar[i]
                    if (currentDay == itemDay.day)
                        itemDay.applyCurrentDay()
                        @._onClickItem(itemDay)

                    @._calendarItems.push(itemDay)
                else
                    if (i <= monthLength)
                        itemDay = new DayCalendarView(i, null)
                        if (currentDay == itemDay.day)
                            itemDay.applyCurrentDay()

                        @._calendarItems.push(itemDay)
                    else
                        indexNewDay++
                        @._calendarItems.push(new DayCalendarView(indexNewDay, null))

            cursorCountItems = 0;
            for i in [0..5]
                tagTR = $(document.createElement('tr'));
                for j in [0..6]
                    item = @._calendarItems[cursorCountItems]
                    item.on('click', @._onClickItem)
                    @._renderedItems.push(item.render())
                    tagTR.append(@._renderedItems[@._renderedItems.length - 1])
                    cursorCountItems++

                @._planTable.append(tagTR)

            @._html.show()
        else
            @._onFailLoadPlan()

    _onClickItem: (view) =>
        shop = null
        @._planDate.html('')
        @.shopValue.html('')
        @.timeStartValue.html('')
        @.timeStopValue.html('')
        @.planValue.html('')

        if view.model
            datePlan = view.model.get('date')
            shop = view.model.get('shop')
            @._planDate.html(datePlan.getDate() + '.' + (datePlan.getMonth() + 1) + '.' +  datePlan.getFullYear())
            @.shopValue.html(shop.get('id') + '/' + shop.get('name'))
            @.timeStartValue.html(view.model.get('timeStart'))
            @.timeStopValue.html(view.model.get('timeStop'))
            @.planValue.html(view.model.get('plan1'))
