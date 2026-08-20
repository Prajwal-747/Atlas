from rest_framework import serializers
from .models import Assignment

class AssignmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Assignment
        fields = [
            'id',
            'subject',
            'title',
            'description',
            'due_date',
            'status',
            'effort_required',
            'supporting_documents',
            'solution_documents',
        ]
        read_only_fields = ['id']