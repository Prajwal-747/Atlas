from django.contrib import admin
from django.urls import include, path
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView
)
from users.serializers import LoginSerializer

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/token/', TokenObtainPairView.as_view(serializer_class = LoginSerializer)),
    path('api/auth/token/refresh/', TokenRefreshView.as_view()),
    path('api/auth/', include('users.urls')),
    path('api/subjects/', include('subjects.urls')),
    path('api/timetable/', include('timetable.urls')),
    path('api/attendance/', include('attendance.urls')),
    path('api/assignments/', include('assignments.urls')),
]
