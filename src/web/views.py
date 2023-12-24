from django.contrib.auth import authenticate, login
from django.contrib.auth import logout
from django.shortcuts import render, get_object_or_404, redirect
from django.db.models import Q
from django.http import Http404
from .models import Movie, Myrating
from django.contrib import messages
from .forms import UserForm
from django.db.models import Case, When
from .recommendation import Myrecommend
import numpy as np
import pandas as pd

# Функция для рекомендаций фильмов
def recommend(request):
    if not request.user.is_authenticated:
        return redirect("login")
    if not request.user.is_active:
        raise Http404

    # Получение данных о рейтингах пользователей из базы данных
    df = pd.DataFrame(list(Myrating.objects.all().values()))
    nu = df.user_id.unique().shape[0]
    current_user_id = request.user.id

    # Если новый пользователь не оценил ни одного фильма, добавляем для него фиктивный рейтинг
    if current_user_id > nu:
        movie = Movie.objects.get(id=15)
        q = Myrating(user=request.user, movie=movie, rating=0)
        q.save()

    print("Текущий идентификатор пользователя: ", current_user_id)

    # Получение предсказаний рейтингов для текущего пользователя
    prediction_matrix, Ymean = Myrecommend()
    my_predictions = prediction_matrix[:, current_user_id - 1] + Ymean.flatten()

    # Сортировка предсказанных рейтингов и получение индексов в порядке убывания
    pred_idxs_sorted = np.argsort(my_predictions)
    pred_idxs_sorted[:] = pred_idxs_sorted[::-1]
    pred_idxs_sorted = pred_idxs_sorted + 1
    print(pred_idxs_sorted)

    preserved = Case(*[When(pk=pk, then=pos) for pos, pk in enumerate(pred_idxs_sorted)])

    # Получение списка фильмов, соответствующих отсортированным предсказанным рейтингам
    movie_list = list(Movie.objects.filter(id__in=pred_idxs_sorted).order_by(preserved)[:10])

    return render(request, 'web/recommend.html', {'movie_list': movie_list})


# Главная страница со списком фильмов
def index(request):
    movies = Movie.objects.all()
    query = request.GET.get('q')

    # Фильтрация фильмов по поисковому запросу
    if query:
        movies = Movie.objects.filter(Q(title__icontains=query)).distinct()
        return render(request, 'web/list.html', {'movies': movies})

    return render(request, 'web/list.html', {'movies': movies})


# Просмотр деталей фильма
def detail(request, movie_id):
    if not request.user.is_authenticated:
        return redirect("login")
    if not request.user.is_active:
        raise Http404

    # Получение информации о фильме
    movies = get_object_or_404(Movie, id=movie_id)

    # Оценка фильма пользователем
    if request.method == "POST":
        rate = request.POST['rating']
        ratingObject = Myrating()
        ratingObject.user = request.user
        ratingObject.movie = movies
        ratingObject.rating = rate
        ratingObject.save()
        messages.success(request, "Ваша оценка сохранена")
        return redirect("index")

    return render(request, 'web/detail.html', {'movies': movies})


# Register user
def signUp(request):
	form =UserForm(request.POST or None)
	if form.is_valid():
		user      = form.save(commit=False)
		username  =	form.cleaned_data['Имя пользователя']
		password  = form.cleaned_data['Пароль']
		user.set_password(password)
		user.save()
		user = authenticate(username=username,password=password)
		if user is not None:
			if user.is_active:
				login(request,user)
				return redirect("index")
	context ={
		'form':form
	}
	return render(request,'web/signUp.html',context)				


# Login User
def Login(request):
	if request.method=="POST":
		username = request.POST['username']
		password = request.POST['password']
		user     = authenticate(username=username,password=password)
		if user is not None:
			if user.is_active:
				login(request,user)
				return redirect("index")
			else:
				return render(request,'web/login.html',{'error_message':'Ваш аккаунт недоступен'})
		else:
			return render(request,'web/login.html',{'error_message': 'Неправильный пароль'})
	return render(request,'web/login.html')

#Logout user
def Logout(request):
	logout(request)
	return redirect("login")