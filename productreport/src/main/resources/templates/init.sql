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

-- Организации
INSERT INTO enterprises (name, address)
VALUES
    ('ООО "ТехноПром"', 'г. Москва, ул. Промышленная, д. 10'),
    ('АО "ИмпортСервис"', 'г. Санкт-Петербург, Невский пр., д. 45');

-- ОКРБ (с учётом структуры)
INSERT INTO okrb (okrb, description)
VALUES
    ('12.00.00', 'Производство электронного оборудования'),
    ('12.10.00', 'Производство радиоэлектронной аппаратуры'),
    ('12.10.10', 'Производство бытовой электроники'),
    ('12.10.10.01', 'Производство телевизоров'),
    ('12.10.10.02', 'Производство DVD-проигрывателей'),
    ('78.00.00', 'Механическая обработка металлов'),
    ('78.10.00', 'Токарная обработка'),
    ('78.10.10', 'Фрезерная обработка'),
    ('78.10.10.01', 'Обработка деталей для автомобилей'),
    ('78.10.10.02', 'Обработка деталей для станков');

-- ТН ВЭД
INSERT INTO tnved (tnved, description)
VALUES
    (8408203109, 'Двигатели дизельные для легковых автомобилей'),
    (8408203509, 'Двигатели дизельные для грузовых автомобилей'),
    (8471410000, 'Портативные компьютеры'),
    (8504403000, 'Блоки питания импульсные');

-- Импортные ТН ВЭД
INSERT INTO import_tnved (import_tnved, description)
VALUES
    (8408203109, 'Импортный двигатель для легковых авто'),
    (8471410000, 'Импортный ноутбук');

-- Типы продукции
INSERT INTO production_type (production_type, okrb_id, tnved_id)
VALUES
    ('Двигатель для легковых авто', 1, 1),
    ('Двигатель для грузовых авто', 1, 2),
    ('Портативный компьютер', 3, 3),
    ('Блок питания', 2, 4);

-- Продукция
INSERT INTO products (product_name, production_type_id, enterprise_id)
VALUES
    ('Двигатель Легковой Turbo', 1, 2),
    ('Двигатель Грузовой PowerMax', 2, 2),
    ('Ноутбук UltraBook X1', 3, 1),
    ('Блок питания 500W', 4, 1);