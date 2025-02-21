package store

import grails.gorm.transactions.Transactional

@Transactional
class SettingService {
    def getSettings() {
        Setting.list()
    }

    def updateSetting(String key, String value) {
        Setting setting = Setting.findWhere(key: key)
        if (setting) {
            setting.value = value
            setting.save()
        }
    }
}