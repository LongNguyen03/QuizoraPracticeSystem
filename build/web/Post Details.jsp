<%-- 
    Document   : Post Details
    Created on : May 27, 2025, 2:07:34 PM
    Author     : LongNguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
 <head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1" name="viewport"/>
  <title>
   Quizora - Quantum Mechanics
  </title>
  <script src="https://cdn.tailwindcss.com">
  </script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet"/>
 </head>
 <body class="bg-[#181818] text-white font-sans min-h-screen flex flex-col">
  <header class="flex justify-between items-center px-6 py-3 bg-[#222222]">
   <div class="text-white font-bold text-lg">
    Quizora
   </div>
   <nav class="flex items-center space-x-6 text-white text-sm font-normal">
    <a class="hover:underline" href="#">
     Home
    </a>
    <a class="hover:underline" href="#">
     Quizzes
    </a>
    <a class="hover:underline" href="#">
     Forum
    </a>
    <div class="flex items-center space-x-3">
     <i class="fas fa-user text-white text-lg"></i>
     <span class="text-white text-sm font-normal">
      Admin
     </span>
     <button class="bg-green-600 hover:bg-green-700 text-white text-sm font-normal px-3 py-1 rounded">
      Logout
     </button>
    </div>
   </nav>
  </header>
  <main class="max-w-7xl mx-auto px-6 py-6 flex flex-col lg:flex-row gap-6 flex-grow">
   <article class="flex-1">
    <h1 class="text-white font-extrabold text-xl mb-3 leading-tight">
     Understanding the Basics of Quantum Mechanics
    </h1>
    <div class="flex items-center gap-3 mb-4">
     <img alt="Portrait of Dr. Amelia Lane with glasses and dark hair" class="rounded-full" height="40" src="https://storage.googleapis.com/a1aa/image/e59d4d97-664c-4cea-2a11-1173842c49fe.jpg" width="40"/>
     <p class="text-white text-sm font-normal">
      Dr. Amelia Lane
      <span class="text-[#d18b00]">
       | November 5, 2023
      </span>
     </p>
    </div>
    <p class="text-xs text-white leading-tight">
     Quantum mechanics is a fundamental theory in physics that provides a
        description of the physical properties of nature at the scale of atoms
        and subatomic particles. It is the foundation of all quantum physics
        including quantum chemistry, quantum field theory, quantum technology,
        and quantum information science.
    </p>
   </article>
   <aside class="w-full lg:w-72 bg-[#2a2a2a] rounded-md p-4 flex flex-col gap-6">
    <section>
     <h2 class="text-white font-extrabold text-base mb-3 leading-snug">
      Community Interactions
     </h2>
     <div class="bg-[#3a3a3a] rounded-md p-3 space-y-2">
      <h3 class="text-[#d18b00] font-bold text-sm mb-1">
       Recent Discussions
      </h3>
      <ul class="text-xs text-white space-y-1">
       <li>
        Exploring Quantum Entanglement
       </li>
       <li>
        The Double-slit Experiment Insights
       </li>
       <li>
        Quantum Computing: The Future
       </li>
      </ul>
     </div>
    </section>
    <section>
     <div class="bg-[#3a3a3a] rounded-md p-3">
      <h3 class="text-[#d18b00] font-bold text-sm mb-1">
       Top Contributors
      </h3>
      <ul class="text-xs text-white space-y-1">
       <li>
        Dr. Amelia Lane
       </li>
       <li>
        Professor John Doe
       </li>
       <li>
        Dr. Clara Smith
       </li>
      </ul>
     </div>
    </section>
   </aside>
  </main>
 </body>
</html>

