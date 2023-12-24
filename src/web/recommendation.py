import numpy as np
import pandas as pd
from web.models import Myrating
import scipy.optimize

def Myrecommend():
    def normalizeRatings(myY, myR):
        # Нормализация рейтингов
        # Вычисляем среднее значение только для фильмов, которые были оценены
        Ymean = np.sum(myY, axis=1) / np.sum(myR, axis=1)
        Ymean = Ymean.reshape((Ymean.shape[0], 1))
        return myY - Ymean, Ymean

    def flattenParams(myX, myTheta):
        # Преобразование матриц X и Theta в одномерные массивы
        return np.concatenate((myX.flatten(), myTheta.flatten()))

    def reshapeParams(flattened_XandTheta, mynm, mynu, mynf):
        # Восстановление формы матриц X и Theta из одномерных массивов
        assert flattened_XandTheta.shape[0] == int(mynm * mynf + mynu * mynf)
        reX = flattened_XandTheta[:int(mynm * mynf)].reshape((mynm, mynf))
        reTheta = flattened_XandTheta[int(mynm * mynf):].reshape((mynu, mynf))
        return reX, reTheta

    def cofiCostFunc(myparams, myY, myR, mynu, mynm, mynf, mylambda=0.):
        # Функция стоимости для коллаборативной фильтрации
        myX, myTheta = reshapeParams(myparams, mynm, mynu, mynf)
        term1 = myX.dot(myTheta.T)
        term1 = np.multiply(term1, myR)
        cost = 0.5 * np.sum(np.square(term1 - myY))
        # Регуляризация
        cost += (mylambda / 2.) * np.sum(np.square(myTheta))
        cost += (mylambda / 2.) * np.sum(np.square(myX))
        return cost

    def cofiGrad(myparams, myY, myR, mynu, mynm, mynf, mylambda=0.):
        # Вычисление градиента для коллаборативной фильтрации
        myX, myTheta = reshapeParams(myparams, mynm, mynu, mynf)
        term1 = myX.dot(myTheta.T)
        term1 = np.multiply(term1, myR)
        term1 -= myY
        Xgrad = term1.dot(myTheta)
        Thetagrad = term1.T.dot(myX)
        # Регуляризация
        Xgrad += mylambda * myX
        Thetagrad += mylambda * myTheta
        return flattenParams(Xgrad, Thetagrad)

    # Загрузка данных из модели Myrating
    df = pd.DataFrame(list(Myrating.objects.all().values()))
    mynu = df.user_id.unique().shape[0]  # Количество пользователей
    mynm = df.movie_id.unique().shape[0]  # Количество фильмов
    mynf = 10  # Количество признаков

    # Создание матриц Y и R
    Y = np.zeros((mynm, mynu))
    for row in df.itertuples():
        Y[row[2] - 1, row[1] - 1] = row[3]
    R = np.zeros((mynm, mynu))
    for i in range(Y.shape[0]):
        for j in range(Y.shape[1]):
            if Y[i][j] != 0:
                R[i][j] = 1

    # Нормализация рейтингов
    Ynorm, Ymean = normalizeRatings(Y, R)

    # Инициализация матриц X и Theta случайными значениями
    X = np.random.rand(mynm, mynf)
    Theta = np.random.rand(mynu, mynf)

    # Преобразование матриц X и Theta в одномерные массивы
    myflat = flattenParams(X, Theta)

    mylambda = 12.2  # Параметр регуляризации

    # Оптимизация функции стоимости с помощью метода сопряженных градиентов
    result = scipy.optimize.fmin_cg(
        cofiCostFunc, x0=myflat, fprime=cofiGrad,
        args=(Ynorm, R, mynu, mynm, mynf, mylambda),
        maxiter=40, disp=True, full_output=True
    )

    # Восстановление формы матриц X и Theta из одномерного массива
    resX, resTheta = reshapeParams(result[0], mynm, mynu, mynf)

    # Получение матрицы предсказаний
    prediction_matrix = resX.dot(resTheta.T)

    return prediction_matrix, Ymean