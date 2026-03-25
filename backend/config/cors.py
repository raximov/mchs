from typing import Iterable


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
        allowed_prefixes: Iterable[str] = (
            'http://localhost:',
            'http://127.0.0.1:',
            'https://localhost:',
            'https://127.0.0.1:',
        )
        return any(origin.startswith(prefix) for prefix in allowed_prefixes)

    def _merge_vary(self, existing: str | None, value: str) -> str:
        if not existing:
            return value
        parts = [part.strip() for part in existing.split(',') if part.strip()]
        if value not in parts:
            parts.append(value)
        return ', '.join(parts)
