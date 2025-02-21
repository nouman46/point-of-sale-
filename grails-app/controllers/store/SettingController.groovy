package store


class SettingController {
    def settingService

    def index() {
        def settings = settingService.getSettings()
        [settings: settings]
    }

    def update() {
        def settings = Setting.list()
        for (setting in settings) {
            String paramName = "setting_" + setting.key
            def paramValue = params[paramName]
            if (setting.type == 'boolean') {
                settingService.updateSetting(setting.key, paramValue ? 'true' : 'false')
            } else {
                settingService.updateSetting(setting.key, paramValue.toString())
            }
        }
        redirect(action: 'index')
    }
}