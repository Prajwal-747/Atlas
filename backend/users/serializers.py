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
    current_password = serializers.CharField(
        write_only=True,
        required=False,
    )
    new_password = serializers.CharField(
        write_only=True,
        required=False,
        min_length=8,
    )

    class Meta:
        model = User
        fields = ['id', 'email', 'username', 'current_password', 'new_password']

    def update(self, instance, validated_data):
        current_password = validated_data.pop('current_password', None)
        new_password = self.validated_data.pop('new_password', None)
        
        if new_password:
            if not current_password:
                raise serializers.ValidationError({
                    'current_password': 'Current password is required.'
                })
            if not instance.check_password(current_password):
                raise serializers.ValidationError({
                    'current_password': 'Current password is incorrect.'
                })
            instance.set_password(new_password)
        instance.email = validated_data.get('email', instance.email)
        instance.save()
        return instance
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