#= require ../core/baseModel.coffee

class ModelPlanEmployee extends BaseModel
    date: null
    plan1: null
    plan2: null
    shop: ShopModel
    timeStart: null
    timeStop: null
    typeDay: null

    constructor: (params) ->
        ModelPlanEmployee.__super__.constructor.apply(@, [params])

    parseData: (data) ->
        @.set('date', new Date(data['a:Date']))
        @.set('plan1', data['a:Plan1'])
        @.set('plan2', data['a:Plan2'])
        shopModel = new ShopModel()
        shopModel.parseData(data['a:Shop'])
        @.set('shop', shopModel)
        @.set('timeStart', Date.iso8601Time(data['a:TimeStart']))
        @.set('timeStop', Date.iso8601Time(data['a:TimeStop']))
        @.set('typeDay', data['a:TypeDay'])
