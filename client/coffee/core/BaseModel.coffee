#= extern Backbone.Model

class BaseModel extends Backbone.Model
    constructor: (params) ->
        BaseModel.__super__.constructor.apply(@, [params])
        @._parseRelations()

    getNameModel: ->
        @.__proto__.constructor.name

    parse: (response) ->
        if not @relations or not @relations.length
            return response

        for item in @relations
            if not response[item.key]
                continue

            if item.relatedModel
                obj = @.get(item.key)
                obj.set(response[item.key])
                response[item.key] = obj

            else if item.relatedCollection
                collection = @.get(item.key)

                for json in response[item.key]
                    collection.push(json)

                response[item.key] = collection

            else if item.singeltonCollection
                collection = item.singeltonCollection.getSingelton()
                id = response[item.key]
                response[item.write_to] = collection.get(id)

            else if item.relatedClass
                response[item.key] = new item.relatedClass(
                    response[item.key]
                )

            else if item.relatedFunction
                if response[item.key]
                    response[item.key] = new item.relatedFunction(
                        response[item.key]
                    )
            else
                throw new Error()

        response

    _parseRelations: ->
        if not @relations or not @relations.length
            return

        for item in @relations
            if item.relatedModel
                @._parseRelationsModel(item.key, item.relatedModel)

            else if item.relatedCollection
                @._parseRelationsCollection(
                    item.key, item.relatedCollection, item.setParent
                )

            else if item.relatedClass
                if @.has(item.key)
                    obj = new item.relatedClass(@.get(item.key))
                    @.set(item.key, obj)

            else if item.singeltonCollection
                collection = item.singeltonCollection.getSingelton()
                id = @.get(item.key)
                @.set(item.write_to, collection.get(id))

            else if item.relatedFunction
                if @.has(item.key)
                    obj = new item.relatedFunction(@.get(item.key))
                    @.set(item.key, obj)

            else
                throw new Error()

    _parseRelationsModel: (property, model) ->
        if @.has(property)
            item = new model(@.get(property))
        else
            item = new model()

        @.set(property, item)

    _parseRelationsCollection: (property, collection, setParent=false) ->
        items = new collection()

        if setParent
            items.setParent(@)

        if @.has(property)
            for json in @.get(property)
                items.push(json)

        @.set(property, items)
