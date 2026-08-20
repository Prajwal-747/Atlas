from django.utils import timezone
from rest_framework import generics
from rest_framework.exceptions import PermissionDenied
from rest_framework.permissions import IsAuthenticated
from .models import Assignment
from .serializers import AssignmentSerializer

class AssignmentListCreateView(generics.ListCreateAPIView):
    serializer_class = AssignmentSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Assignment.objects.filter(
            subject__user = self.request.user
        )
    def perform_create(self, serializer):
        subject = serializer.validated_data['subject']
        if subject.user != self.request.user:
            raise PermissionDenied(
                'You cannot add an assignment to another user\'s subject'
            )
        serializer.save()

class AssignmentDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = AssignmentSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Assignment.objects.filter(
            subject__user=self.request.user
        )
        
class DueSoonAssignmentView(generics.ListAPIView):
    serializer_class = AssignmentSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        now = timezone.now()
        return Assignment.objects.filter(
            subject__user = self.request.user,
            due_date__gte = now,
        ).exclude(
            status__in = [
                Assignment.Status.SUBMITTED,
                Assignment.Status.GRADED,
            ]
        ).order_by('due_date')[:5]