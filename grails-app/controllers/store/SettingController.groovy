package store

import grails.gorm.transactions.Transactional
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

class SettingController {
    def passwordEncoder = new BCryptPasswordEncoder()

    def index(Long id) {

        def storeOwnerUsername = session.user?.id
        println("🔐 SettingController.index storeOwnerID: ${storeOwnerUsername}")


        def storeOwner = StoreOwner.get(storeOwnerUsername)
        println("🔐 SettingController.index storeOwner: ${storeOwner}")

        if (!storeOwner) {
            flash.message = "Store Owner not found"
            redirect(controller: "auth", action: "login")
            return
        }

        println("🔍 Debug: storeOwner.logo is ${storeOwner.logo ? 'present' : 'null'}")
        println("🔐 SettingController.index storeOwner's id: ${storeOwner.id}")

        render view: "editStoreOwner", model: [storeOwner: storeOwner]
    }

    def displayLogo() {
        def storeOwnerID = params.id
        def storeOwner = StoreOwner.get(storeOwnerID)

        if (!storeOwner || !storeOwner.logo) {
            response.sendError(404)
            return
        }

        // Set content type
        response.contentType = storeOwner.logoContentType ?: 'image/png'

        // Write bytes directly to output stream
        response.outputStream << storeOwner.logo
        response.outputStream.flush()
        response.outputStream.close()

        // Prevent view rendering
        return false
    }

    @Transactional
    def updateStoreOwner(Long id) {
        def storeOwnerID = session.user?.id
        if (!storeOwnerID) {
            flash.message = "Please log in to update your settings"
            redirect(controller: "auth", action: "login")
            return
        }

        def storeOwner = StoreOwner.get(storeOwnerID)
        if (!storeOwner) {
            flash.message = "Store Owner not found"
            redirect(action: "index")
            return
        }

        // Bind the form data to the storeOwner instance
        bindData(storeOwner, params, [exclude: ['appUser']]) // Exclude appUser to avoid overwriting the relationship

        // Handle password (hash if provided)
        if (params.password) {
            storeOwner.password = passwordEncoder.encode(params.password)
        }
        println("🔐 SettingController.updateStoreOwner ${params.password}")

        // Check if syncing with AppUser is requested
        boolean syncWithAppUser = params.syncWithAppUser == "on" || params.syncWithAppUser == true

        if (storeOwner.validate()) {
            // Update AppUser if syncing is requested
            if (syncWithAppUser && storeOwner.appUser) {
                def appUser = storeOwner.appUser

                // Update AppUser username if it differs (and ensure uniqueness)
                if (params.username && appUser.username != params.username) {
                    if (AppUser.findByUsername(params.username)) {
                        storeOwner.errors.rejectValue('username', 'default.unique.message', [params.username] as Object[], "Username already exists")
                        render(view: "edit", model: [storeOwner: storeOwner])
                        return
                    }
                    appUser.username = params.username
                }

                // Update AppUser password if provided
                if (params.password) {
                    println("🔐 SettingController.updateStoreOwner params.password: ${params.password}")
                    appUser.password = storeOwner.password
                    println("🔐 SettingController.updateStoreOwner appUser.password: ${appUser.password}")
                }

                if (!appUser.validate()) {
                    storeOwner.errors.rejectValue('appUser', 'storeOwner.appUser.invalid')
                    render(view: "editStoreOwner", model: [storeOwner: storeOwner])
                    return
                }
                println("🔐 SettingController.updateStoreOwner bs appUser: ${appUser}")
                appUser.save(failOnError: true)
                println("🔐 SettingController.updateStoreOwner as appUser: ${appUser}")
            }

            // Save the StoreOwner
            storeOwner.save(failOnError: true)
            flash.message = "Store Owner updated successfully"
            redirect(action: "index", id: storeOwner.id)
        } else {
            render(view: "editStoreOwner", model: [storeOwner: storeOwner])
        }
    }

    @Transactional
    def updateLogo() {
        def storeOwnerID = session.user?.id
        def storeOwner = StoreOwner.get(storeOwnerID)

        if (!storeOwner) {
            flash.message = "Store Owner not found"
            redirect(action: "index")
            return
        }

        def logoFile = request.getFile('logo')
        if (!logoFile || logoFile.empty) {
            flash.message = "No file selected"
            redirect(action: "index")
            return
        }

        try {
            // Print debug info
            println("🔍 Received file: ${logoFile.originalFilename}, size: ${logoFile.size} bytes, type: ${logoFile.contentType}")

            // Get the bytes directly
            byte[] fileBytes = logoFile.bytes
            println("🔍 File bytes length: ${fileBytes.length}")

            // Save to database
            storeOwner.logo = fileBytes
            storeOwner.logoContentType = logoFile.contentType

            if (storeOwner.save(flush: true)) {
                // Verify after save
                def savedOwner = StoreOwner.get(storeOwner.id)
                println("🔍 Saved logo: ${savedOwner?.logo?.length} bytes")
                flash.message = "Logo updated successfully"
            } else {
                println("🔍 Save failed: ${storeOwner.errors}")
                flash.message = "Failed to save logo: ${storeOwner.errors}"
            }
        } catch (Exception e) {
            println("🔍 Error: ${e.message}")
            e.printStackTrace()
            flash.message = "Error saving logo: ${e.message}"
        }

        redirect(action: "index")
    }
    def testLogo() {
        def storeOwnerID = params.id ?: session.user?.id
        def storeOwner = StoreOwner.get(storeOwnerID)

        if (storeOwner?.logo) {
            String base64 = storeOwner.logo.encodeBase64().toString()
            render """
            <!DOCTYPE html>
            <html>
            <head><title>Logo Test</title></head>
            <body>
                <h1>Logo Test</h1>
                <p>Size: ${storeOwner.logo.length} bytes</p>
                <p>Type: ${storeOwner.logoContentType}</p>
                <img src="data:${storeOwner.logoContentType};base64,${base64}" alt="Logo" style="max-width:300px"/>
            </body>
            </html>
        """
        } else {
            render "No logo found"
        }
    }
}