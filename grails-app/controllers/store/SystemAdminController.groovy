package store

import grails.gorm.transactions.Transactional


class SystemAdminController {
    def listSubscriptionRequests() {
        if (!session.user || !session.user.isSystemAdmin) {
            flash.message = "Admin not authenticated"
            redirect(controller: "auth", action: "login")
            return
        }
        println("session user: ${session.user}")
        def pendingRequests = SubscriptionRequest.findAllByStatus("pending")
        render(view: "listSubscriptionRequests", model: [pendingRequests: pendingRequests])
    }

    @Transactional
    def approveSubscriptionRequest(Long id) {
        if (!session.user || !session.user.isSystemAdmin) {
            flash.message = "Admin not authenticated"
            redirect(action: "listSubscriptionRequests")
            return
        }
        def request = SubscriptionRequest.get(id)
        if (!request || request.status != "pending") {
            flash.message = "Invalid request"
            redirect(action: "listSubscriptionRequests")
            return
        }

        if (!session.user) {
            flash.message = "Admin not authenticated"
            redirect(action: "listSubscriptionRequests")
            return
        }

        // Deactivate existing subscription, if any
        if (request.user.activeSubscription) {
            request.user.activeSubscription.isActive = false
            if (!request.user.activeSubscription.save(flush: true)) {
                println("Failed to deactivate existing subscription: ${request.user.activeSubscription.errors}")
                flash.message = "Error approving subscription 1"
                redirect(action: "listSubscriptionRequests")
                return
            }
        }

        def startDate = new Date()
        def cal = Calendar.getInstance()
        cal.time = startDate
        cal.add(Calendar.DATE, request.plan.billingCycle * 30)
        def endDate = cal.time

        def subscription = new UserSubscription(user: request.user,
                plan: request.plan,
                startDate: startDate,
                endDate: endDate,
                isActive: true)
        subscription.save(flush: true)

        if (!subscription.save(flush: true)) {
            println("Failed to save new subscription: ${subscription.errors}")
            flash.message = "Error approving subscription 2"
            redirect(action: "listSubscriptionRequests")
            return
        }

        // Update AppUser
        request.user.activeSubscription = subscription
        if (!request.user.save(flush: true)) {
            println("Failed to update user: ${request.user.errors}")
            flash.message = "Error approving subscription 3"
            redirect(action: "listSubscriptionRequests")
            return
        }

        // Update request
        request.status = "approved"
        request.approvedBy = session.user
        request.approvalDate = new Date()
        if (!request.save(flush: true)) {
            println("Failed to update request: ${request.errors}")
            flash.message = "Error approving subscription 4"
            redirect(action: "listSubscriptionRequests")
            return
        }

        println("Subscription approved for ${request.user.username}")
        flash.message = "Subscription request approved"
        redirect(action: "listSubscriptionRequests")
    }

    @Transactional
    def rejectSubscriptionRequest(Long id) {
        def request = SubscriptionRequest.get(id)
        if (!request || request.status != "pending") {
            flash.message = "Invalid request"
            redirect(action: "listSubscriptionRequests")
            return
        }

        request.status = "rejected"
        request.approvedBy = session.user
        request.approvalDate = new Date()
        request.save(flush: true)

        println("Subscription rejected for ${request.user.username}")

        flash.message = "Subscription request rejected"
        redirect(action: "listSubscriptionRequests")
    }
}