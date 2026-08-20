from django.urls import path

from .views import (
    AssignmentDetailView,
    AssignmentListCreateView,
    DueSoonAssignmentView,
)

urlpatterns = [
    path('', AssignmentListCreateView.as_view()),
    path('due-soon/', DueSoonAssignmentView.as_view()),
    path('<int:pk>/', AssignmentDetailView.as_view()),
]