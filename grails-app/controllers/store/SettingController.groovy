package store

class SettingController {
    def settingService

    def index() {
        if (!session.user?.isAdmin) {
            flash.message = "Unauthorized access!"
            redirect(controller: "dashboard", action: "dashboard")
            return
        }

        def settings = settingService.getSettings()
        [settings: settings]
    }

    def update() {
        if (!session.user?.isAdmin) {
            flash.message = "Unauthorized action!"
            redirect(action: 'index')
            return
        }

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

        flash.message = "Settings updated successfully!"
        redirect(action: 'index')
    }
}
