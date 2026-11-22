from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db.session import SessionLocal
from app.models.course import CourseModel, LessonModel, ModuleModel
from app.models.quiz import QuizModel, QuizQuestionModel


CATALOG = [
    {
        "id": "course-python-foundations",
        "slug": "python-foundations",
        "title": "Python dasturlash",
        "description": "Python sintaksisi, o‘zgaruvchilar, shartlar va funksiyalar.",
        "category": "Backend va algoritmlar",
        "level": "beginner",
        "language": "Python",
        "estimated_hours": 2,
        "position": 1,
        "module_id": "module-python-core",
        "module_title": "Python asoslari",
        "module_description": "Python dasturlash tilining birinchi qadamlari.",
        "lessons": [
            {
                "id": "lesson-python-variables",
                "title": "O‘zgaruvchilar va ma’lumot turlari",
                "summary": "Qiymatlarni o‘zgaruvchilarda saqlashni o‘rganing.",
                "content": """# O‘zgaruvchilar

O‘zgaruvchi — dastur ishlashi davomida foydalaniladigan qiymatga berilgan nom. Python’da o‘zgaruvchi yaratish uchun oldindan turini e’lon qilish shart emas.

str matn, int butun son, float kasr son, bool mantiqiy qiymat saqlaydi. type() funksiyasi qiymat turini ko‘rsatadi.""",
                "code": "name = \"Ali\"\nage = 20\nheight = 1.75\nis_student = True\n\nprint(name, age)\nprint(type(height))",
                "minutes": 12,
            },
            {
                "id": "lesson-python-conditions",
                "title": "Shart operatorlari",
                "summary": "if, elif va else yordamida qaror qabul qilish.",
                "content": """# Shart operatorlari

Shart operatorlari dasturga vaziyatga qarab turli yo‘nalishda ishlash imkonini beradi. if shartni tekshiradi, elif qo‘shimcha shartlarni tekshiradi, else esa qolgan holatni bajaradi.

Taqqoslash operatorlari: ==, !=, >, <, >=, <=.""",
                "code": "age = 20\n\nif age >= 18:\n    print(\"Voyaga yetgan\")\nelse:\n    print(\"Voyaga yetmagan\")",
                "minutes": 15,
            },
        ],
    },
    {
        "id": "course-dart-foundations",
        "slug": "dart-foundations",
        "title": "Dart dasturlash",
        "description": "Dart tili, turlar, funksiyalar va obyektga yo‘naltirilgan dasturlash.",
        "category": "Mobil dasturlash",
        "level": "beginner",
        "language": "Dart",
        "estimated_hours": 2,
        "position": 2,
        "module_id": "module-dart-core",
        "module_title": "Dart asoslari",
        "module_description": "Dart sintaksisi va funksiyalar.",
        "lessons": [
            {
                "id": "lesson-dart-variables",
                "title": "Dart’da o‘zgaruvchilar",
                "summary": "var, final, const va asosiy ma’lumot turlari.",
                "content": """# Dart o‘zgaruvchilari

Dart statik tipli til. var turini qiymatdan aniqlaydi, final qiymatni bir marta belgilaydi, const esa kompilyatsiya vaqtida ma’lum bo‘lgan o‘zgarmas qiymat yaratadi.""",
                "code": "String name = 'Ali';\nint age = 21;\nfinal country = 'Uzbekistan';\nconst pi = 3.14159;\n\nprint('$name, $age, $country');",
                "minutes": 12,
            },
            {
                "id": "lesson-dart-functions",
                "title": "Funksiyalar",
                "summary": "Qayta foydalaniladigan kod bloklarini yozish.",
                "content": """# Funksiyalar

Funksiya muayyan vazifani bajaruvchi kod blokidir. Parametrlar funksiya ichiga qiymat uzatadi, return esa natijani qaytaradi.""",
                "code": "int add(int a, int b) {\n  return a + b;\n}\n\nvoid main() {\n  print(add(4, 6));\n}",
                "minutes": 14,
            },
        ],
    },
    {
        "id": "course-flutter-apps",
        "slug": "flutter-apps",
        "title": "Flutter",
        "description": "Widgetlar, layout, holat va mobil interfeyslar.",
        "category": "Mobil dasturlash",
        "level": "intermediate",
        "language": "Dart",
        "estimated_hours": 3,
        "position": 3,
        "module_id": "module-flutter-ui",
        "module_title": "Flutter UI asoslari",
        "module_description": "Widget va layout tizimi.",
        "lessons": [
            {
                "id": "lesson-flutter-widgets",
                "title": "Widget tushunchasi",
                "summary": "Flutter interfeysi widgetlar daraxti asosida quriladi.",
                "content": """# Widget nima?

Flutter’da deyarli har bir UI elementi widget hisoblanadi. Text, Icon, Container, Row, Column va Scaffold keng ishlatiladigan widgetlardir.

StatelessWidget o‘zgarmas ko‘rinish, StatefulWidget esa ichki holati o‘zgaradigan interfeyslar uchun ishlatiladi.""",
                "code": "MaterialApp(\n  home: Scaffold(\n    appBar: AppBar(title: const Text('Salom')),\n    body: const Center(child: Text('EduCode AI')),\n  ),\n)",
                "minutes": 15,
            },
            {
                "id": "lesson-flutter-layout",
                "title": "Row, Column va Container",
                "summary": "Elementlarni ekranda joylashtirish.",
                "content": """# Layout widgetlari

Row elementlarni gorizontal, Column vertikal joylashtiradi. Container o‘lcham, padding, margin, rang va bezak berish uchun ishlatiladi.""",
                "code": "Column(\n  mainAxisAlignment: MainAxisAlignment.center,\n  children: const [\n    Text('Birinchi qator'),\n    SizedBox(height: 12),\n    Text('Ikkinchi qator'),\n  ],\n)",
                "minutes": 15,
            },
        ],
    },
    {
        "id": "course-javascript-web",
        "slug": "javascript-web",
        "title": "JavaScript",
        "description": "JavaScript asoslari va zamonaviy web dasturlash.",
        "category": "Web dasturlash",
        "level": "beginner",
        "language": "JavaScript",
        "estimated_hours": 2,
        "position": 4,
        "module_id": "module-js-core",
        "module_title": "JavaScript asoslari",
        "module_description": "O‘zgaruvchilar va funksiyalar.",
        "lessons": [
            {
                "id": "lesson-js-variables",
                "title": "let, const va ma’lumot turlari",
                "summary": "JavaScript o‘zgaruvchilarini e’lon qilish.",
                "content": """# O‘zgaruvchilar

JavaScript’da odatda const va let ishlatiladi. const qayta qiymat berilmaydigan bog‘lanishlar, let esa o‘zgarishi mumkin bo‘lgan qiymatlar uchun tanlanadi.""",
                "code": "const name = 'Ali';\nlet score = 10;\nscore = 15;\n\nconsole.log(name, score);",
                "minutes": 12,
            },
            {
                "id": "lesson-js-functions",
                "title": "Funksiyalar va parametrlar",
                "summary": "Funksiyalar orqali kodni qayta ishlatish.",
                "content": """# Funksiyalar

Funksiya parametrlar qabul qiladi va natija qaytarishi mumkin. JavaScript’da function declaration va arrow function ko‘p ishlatiladi.""",
                "code": "function add(a, b) {\n  return a + b;\n}\n\nconst multiply = (a, b) => a * b;\nconsole.log(add(2, 3));",
                "minutes": 14,
            },
        ],
    },
    {
        "id": "course-sql-databases",
        "slug": "sql-databases",
        "title": "SQL va ma’lumotlar bazasi",
        "description": "SELECT so‘rovlari, filtrlash, jadval va bog‘lanishlar.",
        "category": "Ma’lumotlar bazasi",
        "level": "intermediate",
        "language": "SQL",
        "estimated_hours": 2,
        "position": 5,
        "module_id": "module-sql-core",
        "module_title": "SQL asoslari",
        "module_description": "Ma’lumotlarni so‘rash va filtrlash.",
        "lessons": [
            {
                "id": "lesson-sql-select",
                "title": "SELECT so‘rovi",
                "summary": "Jadvaldan kerakli ustunlarni olish.",
                "content": """# SELECT

SQL’dagi SELECT operatori jadvaldan ma’lumot olish uchun ishlatiladi. FROM ma’lumot manbasini belgilaydi. WHERE natijalarni shart bo‘yicha filtrlash imkonini beradi.""",
                "code": "SELECT first_name, age\nFROM students\nWHERE age >= 18;",
                "minutes": 12,
            },
            {
                "id": "lesson-sql-joins",
                "title": "Jadvallarni JOIN bilan bog‘lash",
                "summary": "Bir nechta jadvaldan bog‘langan ma’lumotlarni olish.",
                "content": """# JOIN

INNER JOIN ikkala jadvalda mos yozuvlari mavjud qatorlarni qaytaradi. LEFT JOIN chap jadvaldagi barcha qatorlarni saqlaydi va mos kelmagan o‘ng qiymatlarni NULL bilan ko‘rsatadi.""",
                "code": "SELECT students.first_name, groups.name\nFROM students\nINNER JOIN groups\n  ON students.group_id = groups.id;",
                "minutes": 16,
            },
        ],
    },
    {
        "id": "course-cpp-algorithms",
        "slug": "cpp-algorithms",
        "title": "C++ algoritmlar",
        "description": "C++ asoslari va algoritmik fikrlash.",
        "category": "Algoritmlar",
        "level": "advanced",
        "language": "C++",
        "estimated_hours": 3,
        "position": 6,
        "module_id": "module-cpp-core",
        "module_title": "C++ asoslari",
        "module_description": "Dastur tuzilishi va shart operatorlari.",
        "lessons": [
            {
                "id": "lesson-cpp-main",
                "title": "C++ dastur tuzilishi",
                "summary": "main funksiyasi va ekranga chiqarish.",
                "content": """# C++ dasturining tuzilishi

C++ dasturi odatda main() funksiyasidan boshlanadi. iostream kiritish-chiqarish imkoniyatlarini beradi. std::cout natijani konsolga chiqaradi.""",
                "code": "#include <iostream>\n\nint main() {\n    std::cout << \"Hello, EduCode AI!\";\n    return 0;\n}",
                "minutes": 12,
            },
            {
                "id": "lesson-cpp-conditions",
                "title": "if va else shartlari",
                "summary": "Shart asosida kod bajarish.",
                "content": """# Shart operatorlari

if berilgan ifodani tekshiradi. Shart rost bo‘lsa birinchi blok, aks holda else bloki bajariladi.""",
                "code": "#include <iostream>\n\nint main() {\n    int age = 20;\n    if (age >= 18) {\n        std::cout << \"Adult\";\n    } else {\n        std::cout << \"Minor\";\n    }\n    return 0;\n}",
                "minutes": 14,
            },
        ],
    },
]


def seed_learning_content(db: Session) -> tuple[int, int]:
    already_seeded = db.scalar(select(CourseModel.id).limit(1))
    if already_seeded is not None:
        quiz_question_count = seed_quizzes(db)
        if quiz_question_count:
            db.commit()
        return 0, quiz_question_count

    lesson_count = 0
    for item in CATALOG:
        course = CourseModel(
            id=item["id"],
            slug=item["slug"],
            title=item["title"],
            description=item["description"],
            category=item["category"],
            level=item["level"],
            language=item["language"],
            lessons_count=len(item["lessons"]),
            estimated_hours=item["estimated_hours"],
            position=item["position"],
            is_published=True,
        )
        db.add(course)

        module = ModuleModel(
            id=item["module_id"],
            course_id=item["id"],
            title=item["module_title"],
            description=item["module_description"],
            position=1,
            is_published=True,
        )
        db.add(module)

        for position, lesson in enumerate(item["lessons"], start=1):
            db.add(
                LessonModel(
                    id=lesson["id"],
                    module_id=item["module_id"],
                    title=lesson["title"],
                    summary=lesson["summary"],
                    content=lesson["content"],
                    code_example=lesson["code"],
                    language=item["language"],
                    duration_minutes=lesson["minutes"],
                    position=position,
                    is_published=True,
                )
            )
            lesson_count += 1

    db.commit()
    quiz_question_count = seed_quizzes(db)
    if quiz_question_count:
        db.commit()
    return lesson_count, quiz_question_count


def seed_quizzes(db: Session) -> int:
    if db.scalar(select(QuizModel.id).limit(1)) is not None:
        return 0

    quiz = QuizModel(
        id="quiz-python-basics",
        module_id="module-python-core",
        title="Python asoslari: bilimni tekshirish",
        description="O‘zgaruvchilar, ma’lumot turlari va shart operatorlari bo‘yicha qisqa test.",
        duration_minutes=5,
        position=1,
        is_published=True,
    )
    db.add(quiz)
    db.flush()

    questions = [
        {
            "id": "quiz-python-q1",
            "prompt": "Python’da butun sonni saqlash uchun qaysi ma’lumot turi ishlatiladi?",
            "options": ["str", "int", "float", "bool"],
            "correct_answer": "int",
            "explanation": "int — Python’dagi butun sonlar uchun ishlatiladigan ma’lumot turi.",
        },
        {
            "id": "quiz-python-q2",
            "prompt": "Quyidagi qiymatlardan qaysi biri bool turiga tegishli?",
            "options": ["'True'", "1", "True", "1.0"],
            "correct_answer": "True",
            "explanation": "True — qo‘shtirnoqsiz yoziladigan mantiqiy qiymat.",
        },
        {
            "id": "quiz-python-q3",
            "prompt": "Python’da shartni tekshirish uchun qaysi kalit so‘z ishlatiladi?",
            "options": ["for", "def", "if", "import"],
            "correct_answer": "if",
            "explanation": "if operatori shart rost yoki yolg‘onligini tekshiradi.",
        },
    ]

    for position, item in enumerate(questions, start=1):
        db.add(
            QuizQuestionModel(
                id=item["id"],
                quiz_id=quiz.id,
                prompt=item["prompt"],
                options=item["options"],
                correct_answer=item["correct_answer"],
                explanation=item["explanation"],
                points=1,
                position=position,
                is_published=True,
            )
        )

    return len(questions)


if __name__ == "__main__":
    with SessionLocal() as session:
        seeded_lessons, seeded_quiz_questions = seed_learning_content(session)
    print(
        f"Seeded {len(CATALOG)} courses, {seeded_lessons} lessons and "
        f"{seeded_quiz_questions} quiz questions."
    )
