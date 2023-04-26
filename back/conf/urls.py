from django.contrib import admin
from drf_spectacular.views import SpectacularAPIView, SpectacularRedocView, SpectacularSwaggerView
from django.urls import path, include, re_path
from django.http import HttpResponse
from django_nextjs.render import render_nextjs_page_sync, render_nextjs_page_async
from django.conf.urls.static import static
from django.conf import settings
from django_nextjs.proxy import NextJSProxyView
from django_nextjs import urls

urlpatterns = [
    *static(settings.STATIC_URL, document_root=settings.STATIC_ROOT),
]


if settings.USE_NEXTJS_PROXY_ROUTES:
    urlpatterns += [
        # Route for static files / public folder
        re_path(r"^(?:_nstat).*$", NextJSProxyView.as_view()),
        path("", include("django_nextjs.urls")),
    ]

urlpatterns += [
    path("", include("core.urls")),
]
