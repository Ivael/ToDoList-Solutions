const express = require("express");
const { v4: uuidv4 } = require("uuid");
const { readTodos, writeTodos } = require("../dataService");
const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const todos = await readTodos();
    const userTodos = todos.filter((todo) => todo.userId === req.userId);
    res.json(userTodos);
  } catch (error) {
    res.status(500).json({ message: "Failed to retrieve todos" });
  }
});

router.post("/", async (req, res) => {
  try {
    const { title, description, dueDate, priority } = req.body;

    if (!title || typeof title !== "string" || title.trim() === "") {
      return res
        .status(400)
        .json({ message: "Title is required and must be a non-empty string" });
    }

    const validPriorities = ["low", "medium", "high"];
    const taskPriority =
      priority && validPriorities.includes(priority) ? priority : "low";

    const newTodo = {
      id: uuidv4(),
      userId: req.userId,
      title: title.trim(),
      description: description || "",
      dueDate: dueDate || null,
      priority: taskPriority,
      isCompleted: false,
      createdAt: new Date().toISOString(),
    };

    const todos = await readTodos();
    todos.push(newTodo);
    await writeTodos(todos);

    res.status(201).json(newTodo);
  } catch (error) {
    res.status(500).json({ message: "Failed to create todo" });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const todos = await readTodos();
    const todo = todos.find(
      (t) => t.id === req.params.id && t.userId === req.userId
    );

    if (!todo) {
      return res.status(404).json({ message: "Todo not found" });
    }

    res.json(todo);
  } catch (error) {
    res.status(500).json({ message: "Failed to retrieve todo" });
  }
});

router.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, dueDate, priority } = req.body;

    if (
      title !== undefined &&
      (typeof title !== "string" || title.trim() === "")
    ) {
      return res
        .status(400)
        .json({ message: "Title must be a non-empty string" });
    }

    const validPriorities = ["low", "medium", "high"];
    if (priority !== undefined && !validPriorities.includes(priority)) {
      return res
        .status(400)
        .json({ message: "Priority must be one of: low, medium, high" });
    }

    const todos = await readTodos();
    const todoIndex = todos.findIndex(
      (t) => t.id === id && t.userId === req.userId
    );

    if (todoIndex === -1) {
      return res.status(404).json({ message: "Todo not found" });
    }

    const updatedTodo = { ...todos[todoIndex] };
    if (title !== undefined) updatedTodo.title = title.trim();
    if (description !== undefined) updatedTodo.description = description;
    if (dueDate !== undefined) updatedTodo.dueDate = dueDate;
    if (priority !== undefined) updatedTodo.priority = priority;

    todos[todoIndex] = updatedTodo;
    await writeTodos(todos);

    res.json(updatedTodo);
  } catch (error) {
    res.status(500).json({ message: "Failed to update todo" });
  }
});

router.patch("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { isCompleted, dueDate, priority } = req.body;

    // Validate inputs if provided
    if (isCompleted !== undefined && typeof isCompleted !== "boolean") {
      return res
        .status(400)
        .json({ message: "isCompleted must be a boolean value" });
    }

    const validPriorities = ["low", "medium", "high"];
    if (priority !== undefined && !validPriorities.includes(priority)) {
      return res
        .status(400)
        .json({ message: "Priority must be one of: low, medium, high" });
    }

    const todos = await readTodos();
    const todoIndex = todos.findIndex(
      (t) => t.id === id && t.userId === req.userId
    );

    if (todoIndex === -1) {
      return res.status(404).json({ message: "Todo not found" });
    }

    if (isCompleted !== undefined) {
      todos[todoIndex].isCompleted = isCompleted;
    }
    if (dueDate !== undefined) {
      todos[todoIndex].dueDate = dueDate;
    }
    if (priority !== undefined) {
      todos[todoIndex].priority = priority;
    }

    const updatedTodo = todos[todoIndex];

    await writeTodos(todos);

    res.json(updatedTodo);
  } catch (error) {
    res.status(500).json({ message: "Failed to update todo" });
  }
});

router.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const todos = await readTodos();
    const initialLength = todos.length;

    const userTodoExists = todos.some(
      (t) => t.id === id && t.userId === req.userId
    );

    if (!userTodoExists) {
      return res.status(404).json({ message: "Todo not found" });
    }

    const filteredTodos = todos.filter((t) => t.id !== id);

    await writeTodos(filteredTodos);

    res.status(204).send();
  } catch (error) {
    res.status(500).json({ message: "Failed to delete todo" });
  }
});

module.exports = router;
