from rest_framework import serializers
from .models import ClassSession

class ClassSessionSerializer(serializers.ModelSerializer):
    subject_name = serializers.CharField(source = 'subject.name', read_only = True)
    class Meta:
        model = ClassSession
        fields = [
            'id',
            'subject',
            'subject_name',
            'day_of_week',
            'start_time',
            'end_time',
        ]
        read_only_fields = ['id', 'subject_name']
        
    def validate(self, attrs):
        if attrs['end_time'] <= attrs['start_time']:
            raise serializers.ValidationError(
                'End time must be after start time.'
            )
        return attrs