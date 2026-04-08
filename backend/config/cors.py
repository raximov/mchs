import os


class DevCorsMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.method == 'OPTIONS':
            response = self._build_preflight_response()
        else:
            response = self.get_response(request)

        origin = request.headers.get('Origin')
        if origin and self._is_allowed_origin(origin):
            response['Access-Control-Allow-Origin'] = origin
            response['Vary'] = self._merge_vary(response.get('Vary'), 'Origin')
            response['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
            response['Access-Control-Allow-Headers'] = 'Content-Type'
        return response

    def _build_preflight_response(self):
        from django.http import HttpResponse

        return HttpResponse(status=204)

    def _is_allowed_origin(self, origin: str) -> bool:
        allowed_origins = [
            item.strip()
            for item in os.environ.get(
                'CORS_ALLOWED_ORIGINS',
                'http://localhost:3000,http://127.0.0.1:3000,http://localhost:8000,http://127.0.0.1:8000',
            ).split(',')
            if item.strip()
        ]
        return origin in allowed_origins

    def _merge_vary(self, existing: str | None, value: str) -> str:
        if not existing:
            return value
        parts = [part.strip() for part in existing.split(',') if part.strip()]
        if value not in parts:
            parts.append(value)
        return ', '.join(parts)
