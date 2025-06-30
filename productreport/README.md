# Product Report Backend

Backend часть приложения для генерации отчетов о продукции, реализованная на Spring Boot.

## Требования

- Java 17
- Maven 3.8+
- PostgreSQL 14+
- Docker (опционально)

## Установка и настройка

1. **Настройка базы данных**:
   - Установите PostgreSQL
   - Создайте базу данных (по умолчанию используется `postgres`)
   - Выполните SQL-скрипт из `src/main/resources/init.sql` для инициализации структуры БД

2. **Настройка приложения**:
   Скопируйте `application.properties` из `src/main/resources` и настройте подключение к БД:
   ```properties
   spring.datasource.url=jdbc:postgresql://localhost:5432/postgres
   spring.datasource.username=postgres
   spring.datasource.password=your_password
## Запуск приложения
Способ 1: Через Maven
```bash
mvn spring-boot:run
```
Способ 2: Сборка и запуск JAR
```bash
mvn clean package
java -jar target/productreport-0.0.1-SNAPSHOT.jar
```
Способ 3: Через Docker (опционально)
```bash
docker build -t productreport-backend .
docker run -p 8080:8080 productreport-backend
```
## Структура проекта
```text
src/
├── main/
│   ├── java/org/productreport/
│   │   ├── config/       - Конфигурационные классы
│   │   ├── controllers/  - REST контроллеры
│   │   ├── dto/         - Data Transfer Objects
│   │   ├── entity/      - Сущности JPA
│   │   ├── repository/  - JPA репозитории
│   │   ├── service/     - Бизнес-логика
│   │   └── ProductreportApplication.java - Главный класс
│   └── resources/
│       ├── static/images/templates/ - Шаблоны отчетов
│       ├── application.properties   - Конфигурация
│       └── init.sql                - Инициализация БД
```
## API Endpoints
### Продукция
GET /api/products - Получить список продуктов с фильтрацией
Параметры:

+ name - Фильтр по наименованию

+ type - Фильтр по типу продукции

+ isImport - Фильтр по импортозамещению (true/false)

### Отчеты
GET /api/report/download - Скачать отчет в формате DOCX
Параметры:

+ template - Имя шаблона (template1/template2)

+ name - Фильтр по наименованию

+ type - Фильтр по типу продукции

+ isImport - Фильтр по импортозамещению

## Документация API
После запуска приложения доступна Swagger-документация:

UI: 
```url
http://localhost:8080/swagger-ui
```
JSON:
```url
http://localhost:8080/v3/api-docs
```
## Настройки по умолчанию

Порт: 
```text
8080
```

CORS: 
```text
Разрешены запросы с http://localhost:3000
```

База данных:

URL: 
```url
jdbc:postgresql://localhost:5432/postgres
```
Пользователь:
```text
postgres
```
Пароль: 
```text
устанавливаете свой (по умолчанию root)
```
## Шаблоны отчетов
Система поддерживает 2 шаблона отчетов:

template1 - Базовый отчет с основной информацией

template2 - Расширенный отчет с отметкой об импортозамещении

Можно легко добавлять новые шаблоны посредством паттерна проектирования "Стратегия"

## Логирование
Настроено логирование через Log4j2. Конфигурация может быть изменена в log4j2.xml.

## Зависимости
Основные зависимости:

* Spring Boot 3.5.3

* Spring Data JPA

* PostgreSQL Driver

* Apache POI (для генерации Word-отчетов)

* Lombok

* Springdoc OpenAPI (Swagger)
