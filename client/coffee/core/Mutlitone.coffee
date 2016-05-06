class Multitone

    _collectionShops: null
    _collectionPlans: null

    constructor: ->
        @._collectionShops = new CollectionShop()
        @._collectionPlans = new CollectionPlan()

    getShopCollection: ->
        return @._collectionShops

    getPlanCollection: ->
        return @._collectionPlans
