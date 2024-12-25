"""
Django admin custumization.
"""

from django.contrib import admin  # noqa
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.translation import gettext_lazy as translate

from core import models


# Register your models here.
class UserAdmin(BaseUserAdmin):
    """Define the admin pages for users."""

    ordering = ["id"]
    list_display = ["email", "name"]
    fieldsets = (
        (None, {"fields": ("email", "password")}),
        (
            translate("Permissions"),
            {"fields": ("is_active", "is_staff", "is_superuser")},
        ),
        (translate("Importante dates"), {"fields": ("last_login",)}),
    )
    readonly_fields = ["last_login"]
    add_fieldsets = (
            (None, {
                "classes": ("wide",),
                "fields": (
                    "email",
                    "password1",
                    "password2",
                    "name",
                    "is_active",
                    "is_staff",
                    "is_superuser",
                )
            }),
    )


admin.site.register(models.User, UserAdmin)
