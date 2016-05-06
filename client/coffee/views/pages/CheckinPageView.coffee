#= require ../../core/baseView.coffee


class CheckinPageView extends BaseView
    @.CACHE_CHECKIN_SHOP_MODEL = 'checkinShopModel'
    @.LAST_CHECKIN_TYPE = 'lastCheckinType'
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-start'
    ###
    template: JST['b-checkin-page']

    constructor: (checkinType = MainViewRouter.TYPE_CHECKIN_STANDART) ->
        @._mainView = null
        @._checkinType = checkinType
        @._statusDay = app.auth.getUser().get('dayStatus')

        if checkinType == MainViewRouter.TYPE_CHECKIN_RP
            @._statusDay = 0

        @._lastShopModel = app.register.getItem(CheckinPageView.CACHE_CHECKIN_SHOP_MODEL, null)
        CheckinPageView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @.address.off()
        @.btnSend.off()
        @.btnAddPhoto.off()
        @.imagePhoto.off()

        @.checkinSelector.remove()
        @.address.remove()
        @.comment.remove()
        @.imagePhoto.remove()
        @.btnAddPhoto.remove()
        @.btnSend.remove()
        if @.listSearchView
            @.listSearchView.off()
            @.listSearchView.remove()

        @._html.remove()
        CheckinPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        CheckinPageView.__super__.render.apply(@)
        @._html = $(@.template())
        @.checkinSelectorView = @._html.find('.b-checkin-page-selector')
        @.labelView = @._html.find('.b-checkin-page-type-label')
        @.addressView = @._html.find('.b-checkin-page-address')
        @.commentView = @._html.find('.b-checkin-page-comment')
        @.imageView = @._html.find('.b-checkin-page-image')
        @.btnAddPhotoView = @._html.find('.b-checkin-page-btn-add-photo')
        @.btnSendView = @._html.find('.b-checkin-page-send')

        @.checkinSelector = new CheckinSelectorView(@._checkinType)
        @.address = new AddressView('', '')
        @.comment = new TextAreaView(getText('Комментарий'));
        @.imagePhoto = new PhotoAttachView();
        @.btnAddPhoto = new ButtonView({text: getText('Добавить фотографию')})
        @.btnSend = new ButtonView({text: getText('Отправить'),checkConnection:true})

        @.checkinSelectorView.html(@.checkinSelector.render())
        @.labelView.html(
            if @._statusDay == 0 then getText('Открытие дня') else getText('Закрытие дня'))
        @.addressView.html(@.address.render())
        @.commentView.html(@.comment.render())
        @.imageView.html(@.imagePhoto.render())
        @.btnAddPhotoView.html(@.btnAddPhoto.render())
        @.btnSendView.html(@.btnSend.render())

        @.imageView.hide()
        @.address.on('click', @._showSearchShop)
        @.btnSend.on('click', @._onClickSend)
        @.btnAddPhoto.on('click', @._onChangePhoto)
        @.imagePhoto.on('close', @._onDeletePhoto)

        if (@._checkinType != MainViewRouter.TYPE_CHECKIN_RP)
            @.imageView.hide()
            @.commentView.hide()
            @.btnAddPhotoView.hide()

        if (@._statusDay == 1 && @._lastShopModel)
            @.address.off()
            @.address.setAddressId(@._lastShopModel['id'])
            @.address.setAddressName(@._lastShopModel['name'])
        else if (@._statusDay == 0)
            data = {type: Config.ORDER_TYPE[@._checkinType]}
            @._html.hide()
            app.soap.send(SOAPRequests.ACTION_GET_SHOP_SCHEDULE, data, @._onGetSchedule, @._onErrorGetSchedule)

        @._html

    _onGetSchedule: (response) =>
        shopId = 0
        shopName = getText('Неизветно')
        modelShop = null
        try
            shopId = parseInt(response['a:ShopId'])
            shopName = response['a:Name']
        catch error
            console.log(error)

        if shopId > 0
            collection = app.multitone.getShopCollection()
            modelShop = collection.getModelById(shopId)

            if modelShop == null
                modelShop = new ShopModel({id: shopId})
                modelShop.set('name', shopName)
                collection.add(modelShop, {at: 0})

            @.address.setModelShop(modelShop)

        @._html.show()

    _onErrorGetSchedule:(error) =>
        @._html.show()

    _showSearchShop: =>
        @.listSearch = [];
        collection = app.multitone.getShopCollection()
        collection.each (model) =>
            @.listSearch.push(new ShopListItemView(model))
        @.listSearchView = new ListSearchShopView(@.listSearch)

        @._mainView.showSearch(@.listSearchView)
        @.listSearchView.on(ListSearchShopView.EVENT_CHANGE_ITEM, @._onChangeItem)

        return false

    setMainView: (view) ->
        @._mainView = view

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>

    headerTitle: =>
        return null;

    _onChangeItem: (model) =>
        @.address.setModelShop(model)
        @._mainView.hideSearch()

    _onClickSend: =>
        if @.address.getAddressId().length <= 0
            nativeAlert(getText('Укажите ID магазина.'))
            return

        coord = app.device.coordinates

        dataSend = {}

        if (@._statusDay == 0)
            dataSend['shopId'] = parseInt(@.address.getAddressId())

        dataSend['location'] = {
            Accuracy: coord.accuracy
            Latitude: coord.latitude,
            Longitude: coord.longitude,
        }

        if (@._statusDay == 0)
            dataSend['typeDay'] = Config.ORDER_TYPE[@._checkinType]
            dataSend['comments'] = @.comment.getValue()
            dataSend['images'] = @.imagePhoto.getImage()
            modelShop = {id: @.address.getAddressId(), name: @.address.getAddressName()}
            app.register.setItem(CheckinPageView.CACHE_CHECKIN_SHOP_MODEL, modelShop)

        action = SOAPRequests.ACTION_SET_CHECKIN

        if (@._statusDay == 1)
            action = SOAPRequests.ACTION_SET_CHECKOUT

        app.soap.send(action, dataSend, @._onSuccessSend, @._onFailSend)

    _onSuccessSend: =>
        @.rout = "menu/"
        app.auth.getUser().updateDayStatus()
        app.register.setItem(CheckinPageView.LAST_CHECKIN_TYPE, @._checkinType)

        options = {trigger: true}

        if (@._statusDay == 1)
            options['replace'] = true
            if (@._checkinType == MainViewRouter.TYPE_CHECKIN_STANDART)
                @.rout = 'menu/reports/checkin-standart/report/'
            else if (@._checkinType == MainViewRouter.TYPE_CHECKIN_CLIENT)
                @.rout = 'menu/reports/checkin-client/report/'
            else if (@._checkinType == MainViewRouter.TYPE_CHECKIN_SPA)
                @.rout = 'menu/reports/checkin-spa/report/'

        app.router.navigate(@.rout, options)

    _onFailSend: =>

    _onChangePhoto: =>
        try
            navigator.camera.getPicture(
                @._onSuccessChangePhoto, @._onFailChangePhoto,
                { quality: 45, destinationType: 0, targetWidth: 800, targetHeight: 600, correctOrientation: true }
            )
        catch Error
            console.log(Error)

    _onDeletePhoto: =>
        @.imageView.hide()
        @.btnAddPhotoView.show()

    _onSuccessChangePhoto:(imageBase64) =>
        if (imageBase64)
            @.imagePhoto.setImage(imageBase64)
            @.imageView.show();
            @.btnAddPhotoView.hide();

    _onFailChangePhoto: =>
        console.log('fail or ')
