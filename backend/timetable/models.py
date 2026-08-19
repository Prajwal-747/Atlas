from django.db import models
from subjects.models import Subject

class ClassSession(models.Model):
    class DayOfWeek(models.TextChoices):
        MONDAY = 'monday', 'Monday'
        TUESDAY = 'tuesday', 'Tuesday'
        WEDNESDAY = 'wednesday', 'Wednesday'
        THURSDAY = 'thursday', 'Thursday'
        FRIDAY = 'friday', 'Friday'
        SATURDAY = 'saturday', 'Saturday'
        SUNDAY = 'sunday', 'Sunday'
        
    subject =  models.ForeignKey(
        Subject,
        on_delete=models.CASCADE,
        related_name='class_sessions',
    )
    day_of_week = models.CharField(
        max_length=10,
        choices=DayOfWeek.choices,
    )
    start_time = models.TimeField()
    end_time = models.TimeField()
    
    class Meta:
        ordering = ['day_of_week', 'start_time']
        
    def __str__(self):
        return (
            f'{self.subject.code} - '
            f'{self.day_of_week} '
            f'{self.start_time}-{self.end_time}'
        )