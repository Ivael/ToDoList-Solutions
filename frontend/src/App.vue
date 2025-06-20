<template>
  <div id="app" class="main-container">
    <header class="app-header">
      <div class="app-title">BetaTask</div>
      <div class="auth-section" v-if="isAuthenticated">
        <span class="welcome-text">Welcome, {{ user.name }}!</span>
        <button @click="handleLogout" class="logout-btn">Logout</button>
      </div>
    </header>

    <main class="content-area">
      <section v-if="!isAuthenticated" class="hero-section">
        <div class="hero-content">
          <h1>Welcome to BetaTask</h1>
          <p>Organize your life, one task at a time.</p>
          <button @click="showLoginModal = true" class="login-btn">Get Started</button>
        </div>
                 <div class="hero-image">
           <!-- Placeholder for future illustration -->
           <div class="placeholder-graphic">
             <div class="check-circle">✓</div>
             <div class="task-lines">
               <div class="line"></div>
               <div class="line"></div>
               <div class="line"></div>
             </div>
           </div>
         </div>
      </section>

      <section v-if="isAuthenticated" class="authenticated-layout">
        <aside class="sidebar">
          <div class="nav-buttons">
                         <button @click="currentView = 'dashboard'" :class="{ active: currentView === 'dashboard' }">Dashboard</button>
             <button @click="currentView = 'todos'" :class="{ active: currentView === 'todos' }">My Todos</button>
             <button @click="currentView = 'calendar'" :class="{ active: currentView === 'calendar' }">Calendar</button>
             <button @click="currentView = 'notes'" :class="{ active: currentView === 'notes' }">Notes</button>
             <button @click="currentView = 'tags'" :class="{ active: currentView === 'tags' }">🏷️ Tags Manager</button>
          </div>
        </aside>

        <div class="main-content-view">
          <div v-if="currentView === 'dashboard'">
            <DashboardPage />
          </div>

          <div v-if="currentView === 'calendar'">
            <CalendarPage />
          </div>

          <div v-if="currentView === 'notes'">
             <Notes :tasks="todos" />
          </div>

          <div v-if="currentView === 'tags'">
            <TagsManager :todos="todos" />
          </div>

          <div v-if="currentView === 'todos'">
            <div class="header-controls">
              <button @click="handleAddTodoClick" class="add-todo-btn">
                <span class="plus-icon">+</span> Add Todo
              </button>
              <TodoControls
                v-model:currentFilter="currentFilter"
                v-model:categoryFilter="categoryFilter"
                v-model:tagFilter="tagFilter"
                v-model:sortBy="sortBy"
                v-model:sortDirection="sortDirection"
              />
            </div>
            <div v-if="loading" class="loading-msg">Loading tasks...</div>
            <div v-if="error" class="error">{{ error }}</div>
            <ul v-if="!loading && !error" class="todo-list">
              <TodoItem
                v-for="todo in filteredAndSortedTodos"
                :key="todo.id"
                :todo="todo"
                @toggle-complete="toggleComplete"
                @delete-todo="deleteTodo"
                @edit-todo="editTodo"
              />
              <li v-if="filteredAndSortedTodos.length === 0 && !loading" class="no-tasks">
                {{
                  todos.length > 0 ? "No tasks match the current filter." : "No tasks yet! Add one above."
                }}
              </li>
            </ul>
          </div>
        </div>
      </section>
    </main>

    <LoginModal
      :show-modal="showLoginModal"
      @close-modal="showLoginModal = false"
      @login="handleLogin"
      @signup="handleSignup"
      ref="loginModalRef"
    />
    <AddTodoModal
      :show-modal="showModal"
      :todo="currentTodo"
      @close-modal="() => { showModal = false; currentTodo = null; }"
      @add-todo="addTodo"
      @edit-todo="handleEditTodo"
    />
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from "vue";
import { useAuth } from "./composables/useAuth";
import { db } from "./firebase";
import { collection, query, where, onSnapshot, addDoc, doc, updateDoc, deleteDoc } from "firebase/firestore";
import TodoItem from "./components/TodoItem.vue";
import AddTodoModal from "./components/AddTodoModal.vue";
import LoginModal from "./components/LoginModal.vue";
import TodoControls from "./components/TodoControls.vue";
import DashboardPage from "./components/DashboardPage.vue";
import CalendarPage from "./components/CalendarPage.vue";
import Notes from "./components/Notes.vue";
import TagsManager from "./components/TagsManager.vue";

const todos = ref([]);
const loading = ref(false);
const error = ref(null);
const showModal = ref(false);
const showLoginModal = ref(false);
const currentTodo = ref(null);
const loginModalRef = ref(null);

// Auth state from composable
const { user, isAuthenticated, login, signup, logout, initAuth } = useAuth();
const currentView = ref('dashboard');

const currentFilter = ref("all");
const categoryFilter = ref("");
const tagFilter = ref("");
const sortBy = ref("createdAt");
const sortDirection = ref("desc");

async function fetchTodos() {
  if (!isAuthenticated.value || !user.value?.userId) {
    todos.value = [];
    return;
  }
  
  loading.value = true;
  error.value = null;
  
  try {
    const todosCollectionRef = collection(db, "todos");
    // Only fetch todos that belong to the current user
    const q = query(todosCollectionRef, where("userId", "==", user.value.userId));

    onSnapshot(q, (snapshot) => {
      const fetchedTodos = [];
      snapshot.forEach((doc) => {
        fetchedTodos.push({ id: doc.id, ...doc.data() });
      });
      todos.value = fetchedTodos;
      loading.value = false;
      console.log("User-specific todos fetched from Firestore:", fetchedTodos);
    }, (err) => {
      console.error("Error fetching todos from Firestore:", err);
      error.value = "Failed to load todos from Firestore.";
      loading.value = false;
    });
  } catch (err) {
    console.error("Error setting up todos listener:", err);
    error.value = "Failed to load todos.";
    loading.value = false;
  }
}

async function addTodo(payload) {
  if (!isAuthenticated.value) {
    showLoginModal.value = true;
    return;
  }

  error.value = null;
  try {
    const todoData = {
      ...payload,
      createdAt: new Date().toISOString(),
      isCompleted: false,
      userId: user.value?.userId,
    };

    await addDoc(collection(db, "todos"), todoData);
    showModal.value = false;
  } catch (err) {
    console.error("Error adding todo:", err);
    error.value = "Failed to add todo. Please try again.";
  }
}

async function toggleComplete(todo) {
  if (!isAuthenticated.value) return;
  
  error.value = null;
  try {
    const todoRef = doc(db, "todos", todo.id);
    await updateDoc(todoRef, {
      isCompleted: !todo.isCompleted,
    });
  } catch (err) {
    console.error("Error updating todo status:", err);
    error.value = "Failed to update task status.";
  }
}

async function deleteTodo(id) {
  if (!isAuthenticated.value) return;
  
  error.value = null;
  try {
    await deleteDoc(doc(db, "todos", id));
  } catch (err) {
    console.error("Error deleting todo:", err);
    error.value = "Failed to delete task.";
  }
}

async function editTodo(id) {
  error.value = null;
  try {
    const todo = todos.value.find(t => t.id === id);
    if (!todo) return;
    
    currentTodo.value = todo;
    showModal.value = true;
  } catch (err) {
    console.error("Error preparing todo edit:", err);
    error.value = "Failed to prepare task for editing.";
  }
}

async function handleEditTodo(payload) {
  if (!isAuthenticated.value) return;
  
  error.value = null;
  try {
    const todoRef = doc(db, "todos", currentTodo.value.id);
    await updateDoc(todoRef, payload);
    showModal.value = false;
    currentTodo.value = null;
  } catch (err) {
    console.error("Error editing todo:", err);
    error.value = "Failed to edit task.";
  }  
}

// Auth functions
const handleLogin = async (userData) => {
  try {
    await login(userData.email, userData.password);
    error.value = null;
    showLoginModal.value = false;
    await fetchTodos();
  } catch (err) {
    if (loginModalRef.value) {
      loginModalRef.value.handleError(err);
    }
  }
};

const handleSignup = async (userData) => {
  try {
    await signup(userData.email, userData.password, userData.name);
    error.value = null;
    showLoginModal.value = false;
    await fetchTodos();
  } catch (err) {
    if (loginModalRef.value) {
      loginModalRef.value.handleError(err);
    }
  }
};

const handleLogout = async () => {
  try {
    await logout();
    todos.value = [];
    currentView.value = 'dashboard';
  } catch (err) {
    error.value = "Failed to logout. Please try again.";
  }
};

function handleAddTodoClick() {
  if (!isAuthenticated.value) {
    showLoginModal.value = true;
    return;
  }
  currentTodo.value = null;
  showModal.value = true;
}

// Initialize auth state from localStorage
onMounted(() => {
  if (isAuthenticated.value) {
    currentView.value = 'dashboard';
  }
  fetchTodos();
});

// Watch for changes in currentView to fetch todos if switching to todos view
watch(currentView, (newView) => {
  if (newView === 'todos' && isAuthenticated.value) {
    fetchTodos();
  }
});

const filteredAndSortedTodos = computed(() => {
  let result = [...todos.value];

  // Filter by completion status
  if (currentFilter.value === "incomplete") {
    result = result.filter((todo) => !todo.isCompleted);
  } else if (currentFilter.value === "completed") {
    result = result.filter((todo) => todo.isCompleted);
  }

  // Filter by category
  if (categoryFilter.value) {
    result = result.filter((todo) => todo.category === categoryFilter.value);
  }

  // Filter by tag
  if (tagFilter.value) {
    result = result.filter((todo) => {
      if (!todo.tags || todo.tags.length === 0) return false;
      return todo.tags.some(tag => {
        if (typeof tag === 'string') return tag === tagFilter.value;
        return tag.id === tagFilter.value;
      });
    });
  }

  // Sort results
  result.sort((a, b) => {
    let valA, valB;

    if (sortBy.value === "dueDate") {
      valA = a.dueDate
        ? new Date(a.dueDate + "T00:00:00")
        : sortDirection.value === "asc"
        ? Infinity
        : -Infinity;
      valB = b.dueDate
        ? new Date(b.dueDate + "T00:00:00")
        : sortDirection.value === "asc"
        ? Infinity
        : -Infinity;
    } else if (sortBy.value === "priority") {
      const priorityOrder = { high: 3, medium: 2, low: 1 };
      valA = priorityOrder[a.priority] || 1;
      valB = priorityOrder[b.priority] || 1;
    } else {
      valA = new Date(a.createdAt);
      valB = new Date(b.createdAt);
    }

    let comparison = 0;
    if (valA < valB) {
      comparison = -1;
    } else if (valA > valB) {
      comparison = 1;
    }

    return sortDirection.value === "desc" ? comparison * -1 : comparison;
  });

  return result;
});
</script>

<style>
/* Basic Reset and Body Styles */
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  line-height: 1.6;
  color: #333; /* Darker text for better contrast on light background */
  background-color: #f7f6f3; /* Light background color */
  margin: 0;
  padding: 0;
}

.main-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px; 
  display: flex;
  flex-direction: column;
  min-height: 100vh; 
}

.app-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 0;
  border-bottom: 1px solid #eee;
}

.app-title {
  font-size: 1.8em;
  margin: 0;
  color: #333;
  font-weight: bold;
}

.auth-section {
  display: flex;
  align-items: center;
  gap: 15px;
}

.welcome-text {
  color: #555;
  font-size: 0.9em;
}

.logout-btn {
  padding: 8px 16px;
  border: 1px solid #ccc;
  background-color: transparent;
  color: #555;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.9em;
  transition: all 0.3s ease;
}

.logout-btn:hover {
  background-color: #eee;
}


.content-area {
  flex-grow: 1; /* Allow content area to take up remaining space */
  padding: 20px 0;
}

.hero-section {
  display: flex; /* Use flexbox to align content and image */
  align-items: center; /* Vertically center content */
  justify-content: space-between; /* Space out content and image */
  padding: 80px 40px; /* Ample padding, maybe more horizontal */
  background-color: #fff; /* White background for hero */
  margin-bottom: 40px; /* Space below hero */
  border-radius: 8px; /* Rounded corners */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); /* Subtle shadow */
  flex-wrap: wrap; /* Allow wrapping on smaller screens */
}

.hero-content {
  max-width: 50%;
  flex-grow: 1;
}

.hero-section h1 {
  font-size: 3em;
  margin-bottom: 15px;
  color: #333;
}

 .hero-section p {
   font-size: 1.2em;
   color: #555;
   margin-bottom: 30px;
 }

 .hero-section .login-btn {
   background-color: #007bff;
   color: white;
   border: none;
   padding: 12px 30px;
   font-size: 1.1em;
   border-radius: 6px;
   cursor: pointer;
   transition: background-color 0.3s ease;
 }

 .hero-section .login-btn:hover {
   background-color: #0056b3;
 }

.hero-image {
  max-width: 40%; /* Limit image width */
  flex-shrink: 0; /* Prevent image from shrinking too much */
}

 .placeholder-graphic {
   display: flex;
   align-items: center;
   justify-content: center;
   gap: 20px;
   padding: 40px;
   background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
   border-radius: 12px;
   box-shadow: 0 10px 30px rgba(0,0,0,0.1);
 }

 .check-circle {
   width: 80px;
   height: 80px;
   background-color: #4CAF50;
   border-radius: 50%;
   display: flex;
   align-items: center;
   justify-content: center;
   color: white;
   font-size: 2em;
   font-weight: bold;
   box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
 }

 .task-lines {
   display: flex;
   flex-direction: column;
   gap: 8px;
 }

 .task-lines .line {
   height: 4px;
   background-color: rgba(255, 255, 255, 0.8);
   border-radius: 2px;
 }

 .task-lines .line:nth-child(1) {
   width: 120px;
 }

 .task-lines .line:nth-child(2) {
   width: 90px;
 }

 .task-lines .line:nth-child(3) {
   width: 110px;
 }

/* Add responsive adjustments for smaller screens */
@media (max-width: 768px) {
  .hero-section {
    flex-direction: column; /* Stack content and image vertically */
    padding: 40px 20px;
  }

  .hero-content,
  .hero-image {
    max-width: 100%; /* Allow both to take full width */
    text-align: center; /* Center text content */
  }

  .hero-image {
    margin-top: 30px; /* Add space between content and image */
  }
}

.authenticated-layout {
  display: flex; /* Use flexbox for sidebar and content */
  gap: 30px; /* Space between sidebar and content */
}

.sidebar {
  width: 250px; /* Fixed sidebar width */
  flex-shrink: 0; /* Prevent sidebar from shrinking */
  background-color: #fff; /* White background for sidebar */
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.nav-buttons {
  display: flex;
  flex-direction: column; /* Stack navigation buttons vertically */
  gap: 10px; /* Space between buttons */
}

.nav-buttons button {
  display: block; /* Make buttons block level */
  width: 100%; /* Full width buttons */
  text-align: left; /* Align text to the left */
  padding: 10px 15px;
  border: none;
  background-color: transparent;
  color: #555;
  cursor: pointer;
  font-size: 1em;
  transition: background-color 0.3s ease, color 0.3s ease;
  border-radius: 4px;
}

.nav-buttons button:hover {
  background-color: #f0f0f0;
  color: #000;
}

.nav-buttons button.active {
  background-color: #e9e9e9;
  color: #000;
  font-weight: bold;
}


.main-content-view {
  flex-grow: 1; /* Allow main content to take up remaining space */
  background-color: #fff; /* White background for content */
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.header-controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  flex-wrap: wrap;
  gap: 20px;
}

.add-todo-btn {
  background-color: #007bff; /* Example accent color */
  color: white;
  border: none;
  padding: 10px 18px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1em;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  transition: background-color 0.3s ease;
  white-space: nowrap;
}
.add-todo-btn:hover {
  background-color: #0056b3;
}
.plus-icon {
  font-size: 1.2em;
  font-weight: bold;
}

.todo-list {
  list-style: none;
  padding: 0;
  margin-top: 30px;
}

.no-tasks,
.loading-msg {
  text-align: center;
  color: #888;
  padding: 30px;
  font-size: 1.1em;
}

.error {
  color: #ff6b6b;
  text-align: center;
  margin: 15px 0;
  background-color: rgba(255, 107, 107, 0.1);
  padding: 12px;
  border-radius: 4px;
  border: 1px solid rgba(255, 107, 107, 0.3);
}

/* Add more styles for other sections and components */

</style>
