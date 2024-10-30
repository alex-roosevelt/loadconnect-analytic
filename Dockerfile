# Используем официальный образ JDK 21 для сборки
FROM eclipse-temurin:21-jdk AS build

# Устанавливаем рабочую директорию в контейнере
WORKDIR /app

# Копируем файл сборки и исходный код в контейнер
COPY ./pom.xml ./
COPY ./src ./src

# Скачиваем зависимости и собираем приложение
RUN ./mvnw package -DskipTests

# Используем более легкий образ JRE для запуска
FROM eclipse-temurin:21-jre

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранный .jar файл из предыдущего слоя
COPY --from=build /app/target/*.jar app.jar

# Открываем порт, на котором будет работать приложение
EXPOSE 8088

# Команда для запуска приложения
ENTRYPOINT ["java", "-jar", "app.jar"]
