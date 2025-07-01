CREATE TABLE IF NOT EXISTS enterprises (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT
);

CREATE TABLE IF NOT EXISTS okrb (
                                             id SERIAL PRIMARY KEY,
                                             okrb VARCHAR(255) NOT NULL,
                                             description TEXT
);

CREATE TABLE IF NOT EXISTS tnved (
                                     id SERIAL PRIMARY KEY,
                                     tnved VARCHAR (255) NOT NULL,
                                     description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS production_type (
                                        id SERIAL PRIMARY KEY,
                                        production_type VARCHAR(255) NOT NULL,
                                        okrb_id    BIGINT NOT NULL,
                                        tnved_id    BIGINT NOT NULL,
                                        FOREIGN KEY (okrb_id) REFERENCES okrb (id) ON DELETE CASCADE,
                                        FOREIGN KEY (tnved_id) REFERENCES tnved (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    import BOOLEAN,
    production_type_id BIGINT NOT NULL,
    FOREIGN KEY (production_type_id) REFERENCES production_type (id) ON DELETE CASCADE,
    enterprise_id BIGINT REFERENCES enterprises(id) ON DELETE CASCADE

);

CREATE TABLE IF NOT EXISTS import_tnved (
                                     id SERIAL PRIMARY KEY,
                                     import_tnved VARCHAR(255) NOT NULL,
                                     description VARCHAR(255)
);

CREATE OR REPLACE FUNCTION set_import_flag()
    RETURNS TRIGGER AS $$
BEGIN
    -- Проверяем, есть ли совпадение tnved в import_tnved
    SELECT INTO NEW.import (COUNT(*) > 0)
    FROM production_type
             JOIN tnved ON production_type.tnved_id = tnved.id
             JOIN import_tnved ON tnved.tnved = import_tnved.import_tnved
    WHERE production_type.id = NEW.production_type_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_set_import_flag
    BEFORE INSERT ON products
    FOR EACH ROW
EXECUTE FUNCTION set_import_flag();

--Test data--

-- Белорусские предприятия
INSERT INTO enterprises (name, address) VALUES
                                            ('ОАО "МАЗ"', 'Республика Беларусь, г. Минск, ул. Ванеева, 100'),
                                            ('ОАО "БЕЛАЗ"', 'Республика Беларусь, Минская обл., г. Жодино, ул. 40 лет Октября, 4'),
                                            ('ОАО "МТЗ"', 'Республика Беларусь, г. Минск, ул. Долгобродская, 29'),
                                            ('ОАО "Гомсельмаш"', 'Республика Беларусь, г. Гомель, ул. Шоссейная, 16'),
                                            ('ОАО "БелАЗ"', 'Республика Беларусь, Минская обл., г. Жодино, ул. 40 лет Октября, 4'),
                                            ('ОАО "Интеграл"', 'Республика Беларусь, г. Минск, ул. Казинца, 121'),
                                            ('ОАО "Белшина"', 'Республика Беларусь, г. Бобруйск, ул. Шинников, 1'),
                                            ('ОАО "Нафтан"', 'Республика Беларусь, г. Новополоцк, ул. Молодежная, 14'),
                                            ('ОАО "Белкард"', 'Республика Беларусь, г. Минск, ул. Славинского, 12'),
                                            ('ОАО "Минский моторный завод"', 'Республика Беларусь, г. Минск, ул. Машиностроителей, 15');

-- Дополнение ОКРБ (белорусские коды)
INSERT INTO okrb (okrb, description) VALUES
                                         ('29.10.00', 'Производство автомобилей и их двигателей'),
                                         ('29.10.10', 'Производство грузовых автомобилей'),
                                         ('29.10.20', 'Производство автобусов'),
                                         ('28.30.00', 'Производство сельскохозяйственной техники'),
                                         ('28.30.10', 'Производство тракторов'),
                                         ('28.30.20', 'Производство комбайнов'),
                                         ('26.20.00', 'Производство электронных компонентов'),
                                         ('26.20.10', 'Производство интегральных схем'),
                                         ('25.10.00', 'Производство резиновых изделий'),
                                         ('25.10.10', 'Производство шин');

-- Дополнение ТН ВЭД (актуальные для Беларуси)
INSERT INTO tnved (tnved, description) VALUES
                                           (8701201000, 'Тракторы колесные'),
                                           (8702109000, 'Автобусы городские'),
                                           (8704221000, 'Автомобили грузовые, дизельные'),
                                           (8517120000, 'Телефоны мобильные'),
                                           (4011100000, 'Шины пневматические новые'),
                                           (8542310000, 'Микропроцессоры'),
                                           (8433510000, 'Комбайны зерноуборочные'),
                                           (8504405000, 'Преобразователи электронные'),
                                           (8708995900, 'Детали для автомобилей'),
                                           (8429520000, 'Подъемники фронтальные');

-- Импортные ТН ВЭД (для импортозамещения)
INSERT INTO import_tnved (import_tnved, description) VALUES
                                                         (8517120000, 'Импортные мобильные телефоны'),
                                                         (8542310000, 'Импортные микропроцессоры'),
                                                         (8701201000, 'Импортные тракторы'),
                                                         (8429520000, 'Импортные подъемники');

-- Типы продукции для белорусских предприятий
INSERT INTO production_type (production_type, okrb_id, tnved_id) VALUES
                                                                     ('Грузовой автомобиль', 2, 3),
                                                                     ('Трактор колесный', 5, 1),
                                                                     ('Автобус городской', 3, 2),
                                                                     ('Микропроцессор', 8, 6),
                                                                     ('Шина автомобильная', 10, 5),
                                                                     ('Комбайн зерноуборочный', 6, 7),
                                                                     ('Телефон мобильный', 7, 4),
                                                                     ('Преобразователь электронный', 7, 8),
                                                                     ('Фронтальный подъемник', 1, 10),
                                                                     ('Деталь автомобильная', 1, 9);

-- Продукция белорусских предприятий (40 записей)
INSERT INTO products (product_name, production_type_id, enterprise_id) VALUES
                                                                           -- МАЗ
                                                                           ('МАЗ-5440М9', 1, 1),
                                                                           ('МАЗ-6430А9', 1, 1),
                                                                           ('МАЗ-4371', 1, 1),
                                                                           ('МАЗ-4571', 1, 1),

                                                                           -- БелАЗ
                                                                           ('БелАЗ-75710', 1, 2),
                                                                           ('БелАЗ-7548', 1, 2),
                                                                           ('БелАЗ-7540', 1, 2),

                                                                           -- МТЗ
                                                                           ('МТЗ-952.4', 2, 3),
                                                                           ('МТЗ-3522', 2, 3),
                                                                           ('МТЗ-622', 2, 3),
                                                                           ('МТЗ-1523', 2, 3),

                                                                           -- Гомсельмаш
                                                                           ('Полесье GS812', 6, 4),
                                                                           ('Полесье GS575', 6, 4),
                                                                           ('Полесье GS12', 6, 4),

                                                                           -- Интеграл
                                                                           ('Микропроцессор КМ2116ХМ1', 4, 6),
                                                                           ('Микросхема 1564ТЛ1', 4, 6),
                                                                           ('Микроконтроллер 1986ВЕ92', 4, 6),

                                                                           -- Белшина
                                                                           ('Шина 12.00 R20 БИ-568', 5, 7),
                                                                           ('Шина 315/80 R22.5 БИ-509', 5, 7),
                                                                           ('Шина 11.00 R20 БИ-308', 5, 7),

                                                                           -- Нафтан
                                                                           ('Масло моторное Naftan Premium', 8, 8),
                                                                           ('Топливо дизельное ЕВРО-5', 8, 8),

                                                                           -- Белкард
                                                                           ('Карданный вал 2101', 10, 9),
                                                                           ('Тормозной диск 3110', 10, 9),

                                                                           -- Минский моторный завод
                                                                           ('Двигатель Д-260.2', 2, 10),
                                                                           ('Двигатель Д-245', 2, 10),
                                                                           ('Двигатель Д-160', 2, 10),

                                                                           -- Дополнительная продукция
                                                                           ('МАЗ-303', 1, 1),
                                                                           ('БелАЗ-7514', 1, 2),
                                                                           ('МТЗ-1025', 2, 3),
                                                                           ('Полесье GS411', 6, 4),
                                                                           ('Микросхема 1554ИР22', 4, 6),
                                                                           ('Шина 385/65 R22.5 БИ-452', 5, 7),
                                                                           ('Масло трансмиссионное Naftan', 8, 8),
                                                                           ('Подшипник 180505', 10, 9),
                                                                           ('Двигатель Д-243', 2, 10),
                                                                           ('МАЗ-6317', 1, 1),
                                                                           ('БелАЗ-7825', 1, 2),
                                                                           ('МТЗ-2022', 2, 3);