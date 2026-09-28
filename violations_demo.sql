-- 1. Нарушение CHECK (Оценка вне диапазона 1-5)
DO $$
BEGIN
    INSERT INTO reviews (student_id, course_id, rating, comment)
    VALUES (1, 1, 10, 'Отличный курс!'); -- 10 баллов, а можно только 1-5
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'Ошибка: Оценка должна быть в диапазоне от 1 до 5. Текст ошибки: %', SQLERRM;
END;
$$;

-- 2. Нарушение FOREIGN KEY (Ссылка на несуществующий курс)
DO $$
BEGIN
    INSERT INTO lessons (course_id, title, order_index)
    VALUES (999, 'Урок-призрак', 1); -- Курса с id=999 не существует
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Ошибка: Нельзя добавить урок к несуществующему курсу. Текст ошибки: %', SQLERRM;
END;
$$;

-- 3. Нарушение UNIQUE (Повторная запись на тот же курс)
DO $$
BEGIN
    -- Предположим, студент с id=1 уже записан на курс с id=1
    INSERT INTO enrollments (student_id, course_id)
    VALUES (1, 1); 
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Ошибка: Студент уже записан на этот курс. Текст ошибки: %', SQLERRM;
END;
$$;

-- 4. Нарушение NOT NULL (Попытка вставить NULL в обязательное поле)
DO $$
BEGIN
    INSERT INTO users (name, email, role)
    VALUES (NULL, 'test@test.com', 'student'); -- Имя не может быть пустым
EXCEPTION
    WHEN not_null_violation THEN
        RAISE NOTICE 'Ошибка: Имя пользователя не может быть пустым. Текст ошибки: %', SQLERRM;
END;
$$;

-- 5. Каскадное удаление (Или сложное CHECK)
-- Здесь мы проверим, что при удалении курса удаляются все его уроки
DO $$
DECLARE
    lesson_count_before INTEGER;
    lesson_count_after INTEGER;
BEGIN
    -- Считаем уроки до удаления (предположим, у курса id=1 есть уроки)
    SELECT COUNT(*) INTO lesson_count_before FROM lessons WHERE course_id = 1;
    
    -- Удаляем курс (должно сработать ON DELETE CASCADE)
    DELETE FROM courses WHERE id = 1;
    
    -- Считаем уроки после удаления
    SELECT COUNT(*) INTO lesson_count_after FROM lessons WHERE course_id = 1;
    
    IF lesson_count_after = 0 THEN
        RAISE NOTICE 'Успех: При удалении курса все его уроки были удалены (каскадное удаление).';
    ELSE
        RAISE NOTICE 'Ошибка: Каскадное удаление не сработало.';
    END IF;
END;
$$;