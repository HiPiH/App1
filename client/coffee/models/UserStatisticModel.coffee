#= require ../core/baseModel.coffee

class UserStatisticModel extends BaseModel
    name: null
    checkinStatus: null
    checkoutStatus: null
    reportStatus: null

    constructor: (params) ->
        UserStatisticModel.__super__.constructor.apply(@, [params])

    parseData: (data) ->
        checkin = ''
        checkout = ''
        report = ''

        try
            checkin = data['a:CheckIn'].toLowerCase()
        catch e

        try
            checkout = data['a:CheckOut'].toLowerCase()
        catch e

        try
            report = data['a:Report'].toLowerCase()
        catch e

        @.set('name', data['a:EmployeName'])
        @.set('checkinStatus', checkin)
        @.set('checkoutStatus', checkout)
        @.set('reportStatus', report)
