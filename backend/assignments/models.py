from django.db import models
from subjects.models import Subject

class Assignment(models.Model):
    class Status(models.TextChoices):
        NOT_STARTED = 'not_started', 'Not Started'
        IN_PROGRESS = 'in_progress', 'In Progress'
        SUBMITTED = 'submitted', 'Submitted'
        GRADED = 'graded', 'Graded'
    class EffortRequired(models.TextChoices):
        VERY_LOW='very_low', 'Very Low'
        LOW='low', 'Low'
        MEDIUM='medium', 'Medium'
        HIGH='high', 'High'
        VERY_HIGH='very_high', 'Very High'
        
    subject = models.ForeignKey(
        Subject,
        on_delete=models.CASCADE,
        related_name='assignments',
    )
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    due_date = models.DateTimeField()
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.NOT_STARTED,
    )
    effort_required = models.CharField(
        max_length=20,
        choices=EffortRequired.choices,
        default=EffortRequired.MEDIUM,
    )
    supporting_documents = models.JSONField(default=list, blank=True)
    solution_documents = models.JSONField(default=list, blank=True)
    
    class Meta:
        ordering = ['due_date']
        
    def __str__(self):
        return f'{self.title} - {self.subject.code}'
