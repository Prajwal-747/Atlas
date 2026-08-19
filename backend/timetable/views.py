from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone
from .models import ClassSession
from .serializers import ClassSessionSerializer

class ClassSessionListCreateView(generics.ListCreateAPIView):
    serializer_class = ClassSessionSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return ClassSession.objects.filter(
            subject__user=self.request.user
        )
    def perform_create(self, serializer):
        subject = serializer.validated_data['subject']
        if subject.user != self.request.user:
            from rest_framework import PermissionDenied
            
            raise PermissionDenied(
                'You cannot add a class to another user\'s subject.'
            )
        serializer.save()
        
class ClassSessionDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class=ClassSessionSerializer
    permission_classes=[IsAuthenticated]
    def get_queryset(self):
        return ClassSession.objects.filter(
            subject__user=self.req.user
        )
        
class TodayClassSessionView(generics.ListAPIView):
    serializer_class = ClassSessionSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        today = timezone.localtime().strftime('%A').lower()
        return ClassSession.objects.filter(
            subject__user = self.request.user,
            day_of_week=today,
        ).order_by('start_time')