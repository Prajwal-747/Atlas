from django.db import models
from django.conf import settings

class Subject(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='subjects',
    )
    name = models.CharField(max_length=100)
    code = models.CharField(max_length=30)
    color = models.CharField(max_length=20, default="#6750A4")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    class Meta:
        unique_together = ('user', 'code')
        ordering = ['name']
        
    def __str__(self):
        return f'{self.code} - {self.name}'
