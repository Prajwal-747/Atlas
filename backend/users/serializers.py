from rest_framework import serializers
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

User = get_user_model()

class LoginSerializer(TokenObtainPairSerializer):
    username_field = User.USERNAME_FIELD
    def validate(self, attrs):
        from rest_framework_simplejwt.exceptions import AuthenticationFailed
        login = attrs.pop('email')
        try:
            user = User.objects.get(email=login)
        except User.DoesNotExist:
            try:
                user = User.objects.get(username=login)
            except User.DoesNotExist:
                user = None
        if user is None or not user.check_password(attrs['password']):
            raise AuthenticationFailed('No active account found with the given credentials')
        if not user.is_active:
            raise AuthenticationFailed('User account is disabled')
        refresh = self.get_token(user)
        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
        }

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'username']
        
class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(
        write_only = True,
        min_length = 8
    )
    class Meta:
        model = User
        fields = ['id', 'email', 'username', 'password']
        
    def create(self, validated_data):
        user = User.objects.create_user(
            email=validated_data['email'],
            username=validated_data['username'],
            password=validated_data['password']
        )
        return user