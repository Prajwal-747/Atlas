from django.urls import path

from .views import (
    AttendanceDetailView,
    AttendanceListCreateView,
    AttendanceSummaryView,
)

urlpatterns = [
    path('', AttendanceListCreateView.as_view()),
    path('summary/', AttendanceSummaryView.as_view()),
    path('<int:pk>/', AttendanceDetailView.as_view()),
]