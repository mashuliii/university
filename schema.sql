DROP TABLE IF EXISTS reviews, enrollments, lessons, courses, users CASCADE;
-- 1. Таблица пользователей (Студенты и Преподаватели)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('student', 'teacher')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Таблица курсов
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- Цена курса
    teacher_id INTEGER NOT NULL,
    is_published BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_course_teacher FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Таблица уроков
CREATE TABLE lessons (
    id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    order_index INTEGER NOT NULL, -- Порядковый номер урока
    CONSTRAINT fk_lesson_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- 4. Таблица записей на курсы (Enrollment)
CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    progress DECIMAL(5, 2) DEFAULT 0.00, -- Прогресс в процентах
    CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE(student_id, course_id) -- Студент не может записаться на один курс дважды
);

-- 5. Таблица отзывов
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_student FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_review_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);
-- 6. Таблица прогресса по урокам
CREATE TABLE lesson_progress (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    lesson_id INTEGER NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP,
    CONSTRAINT fk_progress_student FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_progress_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    UNIQUE(student_id, lesson_id) -- Студент может пройти урок только один раз
);

-- 7. Таблица платежей
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'failed')),
    CONSTRAINT fk_payment_student FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_payment_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);
-- Индексы для ускорения поиска
CREATE INDEX idx_courses_teacher ON courses(teacher_id);
CREATE INDEX idx_lessons_course ON lessons(course_id);
CREATE INDEX idx_enrollments_student ON enrollments(student_id);
CREATE INDEX idx_enrollments_course ON enrollments(course_id);
CREATE INDEX idx_reviews_course ON reviews(course_id);
CREATE INDEX idx_payments_student ON payments(student_id);
CREATE INDEX idx_progress_student ON lesson_progress(student_id);