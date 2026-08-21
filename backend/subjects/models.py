from django.db import models
from django.conf import settings

class Subject(models.Model):
    class SubjectType(models.TextChoices):
        THEORY = 'theory', 'Theory'
        LAB = 'lab', 'Lab'
        THEORY_AND_LAB = 'theory_and_lab', 'Theory and Lab'
    
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='subjects',
    )
    name = models.CharField(max_length=100)
    code = models.CharField(max_length=30)
    semester = models.PositiveIntegerField()
    credits = models.PositiveIntegerField()
    faculty_name = models.CharField(
        max_length=100,
        blank=True,
        null=True,
    )
    classroom = models.CharField(
        max_length=100,
        blank=True,
        null=True,
    )
    color_value = models.PositiveBigIntegerField(default=0xFF6750A4)
    type = models.CharField(
        max_length=20,
        choices=SubjectType.choices,
    )
    archived = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    class Meta:
        constraints = [models.UniqueConstraint(
            fields=['user', 'code'],
            name = 'unique_subject_code_per_user',
        )]
        ordering = ['name']
        
    def __str__(self):
        return f'{self.code} - {self.name}'
