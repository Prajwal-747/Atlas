from django.urls import path
from .views import SubjectDetailView, SubjectListCreateView

urlpatterns = [
    path('', SubjectListCreateView.as_view()),
    path('<int:pk>/',SubjectDetailView.as_view()),
]