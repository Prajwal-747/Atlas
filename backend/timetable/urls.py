from django.urls import path

from .views import (
    ClassSessionDetailView,
    ClassSessionListCreateView,
    TodayClassSessionView,
)

urlpatterns = [
    path('', ClassSessionListCreateView.as_view()),
    path('today/', TodayClassSessionView.as_view()),
    path('<int:pk>/', ClassSessionDetailView.as_view()),
]