package store

import grails.gorm.transactions.Transactional


class SystemAdminController {
    def listSubscriptionRequests() {
        def pendingRequests = SubscriptionRequest.findAllByStatus("pending")
        render view: "listSubscriptionRequests", model: [pendingRequests: pendingRequests]
    }

    @Transactional
    def approveSubscriptionRequest(Long id) {
        def request = SubscriptionRequest.get(id)
        if (!request || request.status != "pending") {
            flash.message = "Invalid request"
            redirect(action: "listSubscriptionRequests")
            return
        }

        // Deactivate existing subscription, if any
        if (request.user.activeSubscription) {
            request.user.activeSubscription.isActive = false
            request.user.activeSubscription.save(flush: true)
        }

        // Create new subscription
        def subscription = new UserSubscription(
                user: request.user,
                plan: request.plan,
                startDate: new Date(),
                endDate: new Date() + request.plan.billingCycle * 30, // Approximation in days
                isActive: true
        )
        subscription.save(flush: true)

        // Update AppUser
        request.user.activeSubscription = subscription
        request.user.save(flush: true)

        // Update request
        request.status = "approved"
        request.approvedBy = session.currentAdmin // Adjust based on your admin auth
        request.approvalDate = new Date()
        request.save(flush: true)

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
        request.approvedBy = session.currentAdmin // Adjust based on your admin auth
        request.approvalDate = new Date()
        request.save(flush: true)

        flash.message = "Subscription request rejected"
        redirect(action: "listSubscriptionRequests")
    }
}