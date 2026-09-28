# 1. Проверка наличия гит
---

```PowerShell
git --version  #Проверка наличия гит
```

Если ошибка, то необходимо скачать и установить: https://github.com/git-for-windows/git/releases


# 2. Настройка имени и email

Git записывает автора каждого изменения.

```PowerShell
git config --global user.name "Иван Иванов"
git config --global user.email "ivan@example.com"
```

Проверить:
```PowerShell
git config --global --list
```

Это делается обычно один раз на компьютере.

На общем учебном компьютере --global использовать не всегда удобно, потому что следующий студент получит имя предыдущего. Там лучше настраивать только текущий проект:

```PowerShell
git config user.name "Иван Иванов"
git config user.email "ivan@example.com"
```

# 3. Создать Git-репозиторий из вашей текущей папки

Например, у вас сейчас открыт каталог:

```D:\Институт\Работа\1. Дисциплины\Базы данных (прикладники)```

В терминале VS Code:

```PowerShell
git init
```

После этого Git создаст скрытую папку: **.git**

И текущая папка станет Git-репозиторием.

В VS Code слева есть значок:

![alt text](image.png) **Source Control**

или сочетание: **Ctrl + Shift + G**

Там появятся ваши файлы.

# 4. Обязательно создайте .gitignore

В корне проекта создайте файл: **.gitignore**

Например:

```PowerShell
# VS Code
.vscode/

# временные файлы
*.tmp
*.log

# резервные копии
*.bak

# секреты
.env

# Python, если потом будет использоваться
.venv/
__pycache__/
*.pyc
```

При этом не нужно игнорировать:
```powershell
compose.yaml
*.sql
*.md
```

Именно их как раз желательно хранить в Git.

Например, ваш учебный репозиторий может выглядеть так:
```
database-course/
│
├── .gitignore
├── compose.yaml
├── README.md
│
├── sql/
│   ├── seminar1_setup.sql
│   ├── homework1.sql
│   └── test_data.sql
│
├── homework/
│   └── dz1.md
│
└── diagrams/
    └── er-diagram.png
```

# 5. Что происходит после изменения файла

Предположим, вы изменили: **homework1.sql**  
VS Code покажет возле Source Control цифру: **1**  
Это означает, что Git увидел одно изменение.  
Открываете: **Source Control → Changes**  
и увидите:
```shell
Changes
    M homework1.sql
```

M означает: **Modified**, то есть файл изменён.

# 6. Посмотреть, что именно изменилось

Просто нажмите на файл в `Source Control`.  
VS Code покажет сравнение:
`старый вариант    |    новый вариант`

**Красным** — удалённые строки  
**Зелёным** — добавленные  
Это одна из самых полезных возможностей Git.

# 7. Добавляем изменения в commit

Возле файла есть кнопка: `+`  
Она означает: `Stage Changes`

После нажатия файл перейдёт из: `Changes` в `Staged Changes`

Через терминал это аналог:
```shell
git add homework1.sql
```

Если нужно добавить всё: `git add`.

# 8. Создаём commit

В поле сверху **Source Control** пишете, например:
```text
Добавил физическую модель БД
```

и нажимаете: **Commit**

Через терминал это:
```shell
git commit -m "Добавил физическую модель БД"
```

Commit — это сохранённая версия проекта.

Например:

```shell
Commit 1
Создан compose.yaml

Commit 2
Добавлена концептуальная модель

Commit 3
Добавлена логическая модель

Commit 4
Добавлена физическая модель

Commit 5
Исправлены внешние ключи
```

Это уже история работы.

# 9. Очень важное различие

Есть три состояния файла:
```
Рабочий файл
     ↓
git add
     ↓
Staged
     ↓
git commit
     ↓
Commit
```
То есть:
```
изменить файл
     ↓
добавить изменения
     ↓
зафиксировать изменения
```
Не стоит воспринимать `git add` как «добавить файл в проект».

Точнее это:
```text
добавить текущую версию изменения в следующий commit.
```

# 10. Проверить состояние репозитория

Очень полезная команда: `git status`

Например:
```shell
Changes not staged for commit:
    modified: homework1.sql
```
или:
```shell
Changes to be committed:
    new file: compose.yaml
```
или: `nothing to commit, working tree clean`

Последнее означает: **всё сохранено в Git**

# 11. Теперь подключаем GitHub

Сначала на GitHub создаёте новый репозиторий, например: `database-course`

Лучше при создании не добавлять `README` и `.gitignore`, если они уже есть локально.

GitHub даст адрес примерно такого вида:

https://github.com/username/database-course.git

В терминале VS Code:
```shell
git remote add origin https://github.com/username/database-course.git
```
Затем:
```shell
git branch -M main
```
И первый раз:
```shell
git push -u origin main
```
После этого проект появится на GitHub.

# 12. В дальнейшем всё намного проще

Во время работы:
```
Изменили файлы
     ↓
Source Control
     ↓
Stage
     ↓
Commit
     ↓
Sync Changes / Push
```
Через терминал:
```shell
git add .
git commit -m "Завершил задание 1"
git push
```

# 13. Если хотите продолжить работу дома

В аудитории в конце:
```shell
git add .
git commit -m "Работа на семинаре"
git push
```
Дома один раз:
```shell
git clone https://github.com/username/database-course.git
```

Дальше открываете эту папку в VS Code.

При следующих переходах между компьютерами: `
git pull`, получаете последние изменения.

Поработали дома:
```shell
git add .
git commit -m "Продолжил домашнюю работу"
git push
```
На компьютере в аудитории: `git pull`

И работа продолжается.

Получается:
```
Компьютер в аудитории
        │
        │ git push
        ▼
      GitHub
        ▲
        │ git pull
        │
Домашний компьютер
```

### Минимальный набор команд, который реально нужно знать
---

Для начала достаточно всего семи:
```shell
git status
git add .
git commit -m "Описание изменений"
git push
git pull
git clone <адрес>
git log
```

А в VS Code первые четыре можно делать вообще мышкой через Source Control.