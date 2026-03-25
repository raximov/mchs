from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('apps.education.urls')),
    path('api/', include('apps.quiz.urls')),
]
