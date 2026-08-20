from django.db import models
from subjects.models import Subject

class AttendanceRecord(models.Model):
    class Status(models.TextChoices):
        PRESENT = 'present', 'Present'
        ABSENT = 'absent', 'Absent'
        LATE = 'late', 'Late'
        
    subject = models.ForeignKey(
        Subject,
        on_delete=models.CASCADE,
        related_name='attendance_records',
    )
    date = models.DateField()
    status = models.CharField(
        max_length=10,
        choices = Status.choices,
    )
    class Meta:
        ordering = ['-date']
        constraints = [
            models.UniqueConstraint(
                fields=['subject', 'date'],
                name='unique_attendance_per_day', 
            ),
        ]
    def __str__(self):
        return f'{self.subject.code} - {self.date} - {self.status}'