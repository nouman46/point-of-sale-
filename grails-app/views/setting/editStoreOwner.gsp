<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="main" />
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'theme.css')}"/>
    <title>Edit Store Owner</title>
    <!-- Updated to Bootstrap 5.3 CSS -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
    />
  </head>
<body class="${session.themeName ?: 'theme-default'}">
    <div class="container mt-4">
      <!-- Edit Store Owner Section (Card layout removed) -->
      <div class="row">
        <div class="col-md-12">
          <h3 class="text-primary mb-4">Edit Store Owner</h3>

          <g:if test="${flash.message}">
            <div class="alert alert-info" role="status">
              ${flash.message}
            </div>
          </g:if>

          <g:hasErrors bean="${storeOwner}">
            <div class="alert alert-danger">
              <ul>
                <g:eachError bean="${storeOwner}" var="error">
                  <li>
                    <g:message error="${error}" />
                  </li>
                </g:eachError>
              </ul>
            </div>
          </g:hasErrors>

          <g:hasErrors bean="${storeOwner?.appUser}">
            <div class="alert alert-danger">
              <ul>
                <g:eachError bean="${storeOwner?.appUser}" var="error">
                  <li>
                    <g:message error="${error}" />
                  </li>
                </g:eachError>
              </ul>
            </div>
          </g:hasErrors>

          <h4>Update Logo</h4>
          <g:form
            controller="setting"
            action="updateLogo"
            method="POST"
            enctype="multipart/form-data"
          >
            <g:hiddenField name="id" value="${storeOwner?.id}" />
            <div class="form-group mb-3">
              <g:if test="${storeOwner?.logo}">
                <g:set
                  var="base64Logo"
                  value="${storeOwner.logo.encodeBase64().toString()}"
                />
                <img
                  src="data:${storeOwner.logoContentType ?: 'image/png'};base64,${base64Logo}"
                  alt="Store Logo"
                  class="img-thumbnail mb-3"
                  style="max-width: 200px;"
                />
              </g:if>
              <input type="file" name="logo" class="form-control" />
              <small class="form-text text-muted">
                Upload a new logo to replace the current one. Max size: 5MB.
              </small>
            </div>
            <div class="d-flex justify-content-end mt-4">
              <g:actionSubmit
                class="btn btn-primary"
                action="updateLogo"
                value="Update Logo"
              />
            </div>
          </g:form>

          <hr class="my-4" />

          <g:form
            resource="${storeOwner}"
            method="PUT"
            enctype="multipart/form-data"
          >
            <g:hiddenField name="id" value="${storeOwner?.id}" />
            <div class="form-group mb-3">
              <label for="username" class="form-label"
                >Username <span class="text-danger">*</span></label
              >
              <g:textField
                name="username"
                value="${storeOwner.appUser?.username}"
                class="form-control"
              />
            </div>
            <div class="form-group mb-3">
              <label for="password" class="form-label"
                >Password <span class="text-danger">*</span></label
              >
              <g:passwordField
                name="password"
                value=""
                class="form-control"
              />
            </div>
            <div class="form-group mb-3">
              <label for="email" class="form-label"
                >Email <span class="text-danger">*</span></label
              >
              <g:textField
                name="email"
                value="${storeOwner?.email}"
                class="form-control"
              />
            </div>
            <div class="form-group mb-3">
              <label for="storeName" class="form-label"
                >Store Name <span class="text-danger">*</span></label
              >
              <g:textField
                name="storeName"
                value="${storeOwner?.storeName}"
                class="form-control"
              />
            </div>
            <div class="d-flex justify-content-between mt-4">
              <g:link action="index" id="${storeOwner?.id}" class="btn btn-secondary"
                >Cancel</g:link
              >
              <g:actionSubmit
                class="btn btn-primary"
                action="updateStoreOwner"
                value="Update"
              />
            </div>
          </g:form>

          <hr class="my-4" />

          <h4>Manage Subscription</h4>
          <g:if test="${currentSubscription && currentSubscription.isActive}">
            <div class="mb-3">
              <h5>Current Subscription</h5>
              <p>
                <strong>Plan:</strong>
                ${currentSubscription.plan.name}
              </p>
              <p>
                <strong>Start Date:</strong>
                <g:if test="${currentSubscription.startDate}">
                  <g:formatDate
                    date="${currentSubscription.startDate}"
                    format="yyyy-MM-dd"
                  />
                </g:if>
              </p>
              <p>
                <strong>End Date:</strong>
                <g:formatDate
                  date="${currentSubscription.endDate}"
                  format="yyyy-MM-dd"
                />
              </p>
              <p>
                <strong>Features:</strong>
                ${currentSubscription.plan.features.join(', ')}
              </p>
            </div>
          </g:if>
          <g:if test="${pendingRequest}">
            <div class="alert alert-warning" role="alert">
              You have a pending subscription request for plan:
              <strong>${pendingRequest.plan.name}</strong>
            </div>
          </g:if>
          <g:else>
            <!-- Available Subscription Plans -->
            <h5>Available Plans</h5>
            <g:form
              controller="setting"
              action="requestSubscription"
              method="POST"
            >
              <table class="table table-bordered">
                <thead>
                  <tr>
                    <th>Select</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Billing Cycle</th>
                    <th>Features</th>
                  </tr>
                </thead>
                <tbody>
                  <g:each in="${allPlans}" var="plan">
                    <tr>
                      <td>
                        <g:radio
                          name="planId"
                          value="${plan.id}"
                          checked="${false}"
                        />
                      </td>
                      <td>${plan.name}</td>
                      <td>${plan.description ?: 'No description'}</td>
                      <td>$${plan.price}</td>
                      <td>
                        ${plan.billingCycle} month
                        ${plan.billingCycle > 1 ? 's' : ''}
                      </td>
                      <td>${plan.features.join(', ')}</td>
                    </tr>
                  </g:each>
                </tbody>
              </table>
              <div class="d-flex justify-content-end">
                <g:submitButton
                  name="subscribe"
                  value="Subscribe"
                  class="btn btn-primary"
                />
              </div>
            </g:form>
          </g:else>
        </div>
      </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        var deleteUserUrl = "${createLink(controller: 'setting', action: 'deleteUser')}";
        var deleteRoleUrl = "${createLink(controller: 'setting', action: 'deleteRole')}";

        document.querySelectorAll(".delete-user-btn").forEach((button) => {
          button.addEventListener("click", function () {
            let userId = this.dataset.id;
            if (confirm("Are you sure you want to delete this user?")) {
              fetch(deleteUserUrl + "?id=" + userId, {
                method: "POST",
                headers: {
                  "X-HTTP-Method-Override": "DELETE",
                },
              })
                .then((response) => response.text())
                .then((data) => {
                  alert(data);
                  location.reload();
                })
                .catch((error) =>
                  alert("Error deleting user: " + error)
                );
            }
          });
        });

        document.querySelectorAll(".delete-role-btn").forEach((button) => {
          button.addEventListener("click", function () {
            let roleId = this.dataset.roleId;
            document.getElementById("deleteRoleId").value = roleId;
            new bootstrap.Modal(
              document.getElementById("deleteRoleModal")
            ).show();
          });
        });

        document.querySelectorAll(".edit-role-btn").forEach((button) => {
          button.addEventListener("click", function () {
            let roleId = this.dataset.roleId;
            let roleName = this.dataset.roleName;
            document.getElementById("editRoleId").value = roleId;
            document.getElementById("editRoleName").value = roleName;
            new bootstrap.Modal(
              document.getElementById("editRoleModal")
            ).show();
          });
        });

        document.querySelectorAll(".edit-user-btn").forEach((button) => {
          button.addEventListener("click", function () {
            let userId = this.dataset.id;
            let username = this.dataset.username;
            let rolesData = this.dataset.roles || "";
            let assignedRoles = rolesData.split(",");

            document.getElementById("editUserId").value = userId;
            document.getElementById("editUsername").value = username;

            document.querySelectorAll(".role-checkbox").forEach((checkbox) => {
              checkbox.checked = assignedRoles.includes(checkbox.value);
            });

            new bootstrap.Modal(
              document.getElementById("editUserModal")
            ).show();
          });
        });
      });
    </script>
  </body>
</html>
