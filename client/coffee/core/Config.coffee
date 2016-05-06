class Config
    @.VIRTICAL_DEVICE_MIN_WIDTH = 420
    @.HORIZONTAL_DEVICE_MIN_WIDTH = 600

    @.DEFAULT_LANGUAGE = 'ru'
    @.SERVER_URL = 'https://cc.orange-business.ru/api/WcfService.svc'
    @.APP_NAME = 'Clarins'

    @.GEOLOCATION_TIMEOUT_ANDROID = 3000
    @.GEOLOCATION_TIMEOUT_OTHER = 3000

    @.LOADING_TIME_OUT_DELAY = 20000

    @.STATUS_DAY = {
      'CheckIn': 0 #Производится регистрация
      'CheckOut': 1, #Производится закрытие дня
      'Reporting': 2, #Производится отчёт
      'None': 3 #Можно только поправить
    }

    @.ORDER_TYPE = {
      0: 'Standart', #Стандартный
      1: 'Customer', #Клиентский
      2: 'Spa', # СПА
      3: 'RegionSupervisor' #Региональный представитель
    }

    @.TYPE_EMPLOYEE = {
      'Employer': 0, #Простой консультант
      'Supervisor': 1 #Супервизор
    }

    @.TYPE_POINT_DAY = {
      'None': 0, #Отсутствие
      'Done': 1, #Пройден
      'Fail': 2 #Пройден, но с ошибкой
    }
