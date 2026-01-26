PGObject
========

.. py:class:: PGObject

   Перечисление объектов PostgreSQL.

**Описание:**

Enum-класс, представляющий типы объектов PostgreSQL на основе значения 
``relkind``. Наследуется от ``RelClass`` NamedTuple.

**Элементы перечисления:**

.. py:attribute:: r
   :type: PGObject

   Таблица (relation table), доступна для чтения.

.. py:attribute:: p
   :type: PGObject

   Партиционированная таблица, доступна для чтения.

.. py:attribute:: u
   :type: PGObject

   Временная таблица, доступна для чтения.

.. py:attribute:: v
   :type: PGObject

   Представление (view), только для чтения.

.. py:attribute:: m
   :type: PGObject

   Материализованное представление, только для чтения.

.. py:attribute:: f
   :type: PGObject

   Внешняя таблица, только для чтения.

**Остальные типы**

(i, S, t, c, I, o, b, M) - системные объекты, 
недоступные для операций чтения/записи.

**Атрибуты RelClass:**

.. py:attribute:: rel_name
   :type: str

   Человекочитаемое имя типа объекта.

.. py:attribute:: is_readobject
   :type: bool

   Доступен ли объект для чтения как таблица.

.. py:attribute:: is_readable
   :type: bool

   Доступен ли объект для запросов SELECT.
