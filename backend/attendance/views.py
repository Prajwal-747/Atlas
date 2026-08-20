from rest_framework import generics
from rest_framework.exceptions import PermissionDenied
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import AttendanceRecord
from .serializers import AttendanceRecordSerializer
from django.db.models import Count

class AttendanceListCreateView(generics.ListCreateAPIView):
    serializer_class = AttendanceRecordSerializer
    permission_classes = [IsAuthenticated]
    def get_queryset(self):
        return AttendanceRecord.objects.filter(subject__user=self.request.user)
    
    def perform_create(self, serializer):
        subject = serializer.validated_data['subject']
        if subject.user != self.request.user:
            raise PermissionDenied("You cannot add attendance to another user's subject.")
        serializer.save()
        
class AttendanceDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = AttendanceRecordSerializer
    permission_classes = [IsAuthenticated]
    def get_queryset(self):
        return AttendanceRecord.objects.filter(
            subject__user=self.request.user
        )
        
class AttendanceSummaryView(generics.GenericAPIView):
    permission_classes=[IsAuthenticated]
    def get(self, request):
        summary = AttendanceRecord.objects.filter(
            subject__user=request.user
        ).values('status').annotate(count=Count('id'))
        result = {
            'present': 0,
            'absent': 0,
            'late': 0,
        }
        for item in summary:
            result[item['status']] = item['count']
            
        return Response(result)