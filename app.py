import sys
from django.conf import settings
from django.urls import path
from django.core.management import execute_from_command_line
from django.http import HttpResponse

settings.configure(
    DEBUG=True,
    IGNORABLE_404_URLS=[r'^favicon\.ico$'],
    ROOT_URLCONF=sys.modules[__name__],
    DEFAULT_AUTO_FIELD='django.db.models.AutoField',
    INSTALLED_APPS=[
        # 'django.contrib.admin',
        'django.contrib.auth',
        'django.contrib.contenttypes',
        'django.contrib.sessions',
        'django.contrib.messages',
        'django.contrib.staticfiles',
        'app'
    ],
    MIDDLEWARE=[
        'django.middleware.security.SecurityMiddleware',
        'django.contrib.sessions.middleware.SessionMiddleware',
        'django.middleware.common.CommonMiddleware',
        'django.middleware.csrf.CsrfViewMiddleware',
        'django.contrib.auth.middleware.AuthenticationMiddleware',
        'django.contrib.messages.middleware.MessageMiddleware',
        'django.middleware.clickjacking.XFrameOptionsMiddleware',
    ],
    AUTH_USER_MODEL='app.User',
    DATABASES={
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": "db.sqlite3",
        }
    }
)


def index(request):
    return HttpResponse('<h1>A minimal Django response!</h1>')


urlpatterns = [
    path(r'', index),
]

if __name__ == '__main__':
    execute_from_command_line(sys.argv)
