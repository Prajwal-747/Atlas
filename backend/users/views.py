from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializers import UserSerializer, RegisterSerializer

class RegisterView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        serializer = RegisterSerializer(data = request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response(
                UserSerializer(user).data,
                status=201
            )
        return Response(
            serializer.errors,
            status=400
        )

class MeView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        serializer = UserSerializer(request.user)
        return Response(serializer.data)
    def patch(self,request):
        serializer = UserSerializer(
            request.user,
            data=request.data,
            partial=True,
        )
        if serializer.is_valid():
            user=serializer.save()
            return Response(
                UserSerializer(user).data,
                status=200
            )
        return Response(
            serializer.errors,
            status=400
        )