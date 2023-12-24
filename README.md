[![GitHub contributors](https://img.shields.io/github/contributors/BUBLET/Movie-Recommender-System.svg)](https://github.com/BUBLET/Movie-Recommender-System/graphs/contributors)
![Python version](https://img.shields.io/badge/Python-3.6-blue.svg)
![HTML version](https://img.shields.io/badge/HTML-5-orange.svg)
![C language](https://img.shields.io/badge/Language-C-blue.svg)


# Movie-Recommender-System

Система рекомендации фильмов на основе коллаборативной фильтрации с использованием алгоритма матричного разложения. Рекомендации основаны на идее, что если двум пользователям нравятся определенные фильмы, то фильмы, которые один пользователь оценил положительно и другой пользователь еще не смотрел, могут быть рекомендованы второму пользователю.

## Скриншоты

###### Главная страница
![home](https://user-images.githubusercontent.com/20842692/45380125-941d7500-b61f-11e8-852d-c09e9586b35b.png)

###### Страница рекомендаций
![recom](https://user-images.githubusercontent.com/20842692/45380167-b57e6100-b61f-11e8-8ec0-e07c26daa4a3.jpg)

###### Страница оценки фильмов
![rate](https://user-images.githubusercontent.com/20842692/45380186-be6f3280-b61f-11e8-8ad6-8b967d1cba1a.png)

## Технологии

- HTML
- CSS
- JavaScript
- Bootstrap
- Django

## Библиотеки машинного обучения в Python

- NumPy
- Pandas
- SciPy

## База данных

SQLite

## Требования

- Python 3.6
- pip3
- virtualenv

## Установка и запуск

1. Распакуйте архив с проектом на вашем компьютере.

2. Откройте терминал или командную строку.

3. Перейдите в директорию проекта, например:
cd ~/Desktop/Movie-Recommender-System

4. Создайте и активируйте виртуальное окружение:
virtualenv .

   Активация виртуального окружения на Linux:
source bin/activate

   Активация виртуального окружения на Windows:
cd Scripts
activate

5. Установите зависимости:
pip install -r requirements.txt

6. Запуск локального сервера:

   Перейдите в директорию src:
cd ../Movie-Recommender-System/src

   Запустите сервер:
python manage.py runserver

7. Откройте браузер и перейдите по адресу:
http://127.0.0.1:8000

Спасибо за посещение моего репозитория!
