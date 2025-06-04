<%-- 
    Document   : Slider Details
    Created on : May 27, 2025, 2:08:04 PM
    Author     : LongNguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
 <head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1" name="viewport"/>
  <title>
   Quizora
  </title>
  <script src="https://cdn.tailwindcss.com">
  </script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet"/>
  <style>
   @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap');
    body {
      font-family: 'Inter', sans-serif;
    }
  </style>
 </head>
 <body class="bg-[#121212] text-white min-h-screen flex flex-col">
  <header class="flex justify-between items-center px-6 py-3 border-b border-gray-700">
   <div class="text-white font-semibold text-lg">
    Quizora
   </div>
   <div class="flex items-center space-x-2 text-white text-sm font-semibold">
    <i class="fas fa-user">
    </i>
    <span>
     Admin
    </span>
    <button class="bg-[#22A022] text-white text-xs font-semibold px-3 py-1 rounded-full hover:bg-[#1b7f1b] transition">
     Logout
    </button>
   </div>
  </header>
  <main class="flex-grow px-6 py-6 max-w-7xl">
   <section class="mb-6">
    <h2 class="font-semibold text-white text-base mb-4">
     Quiz Objectives &amp; Details
    </h2>
    <div class="flex flex-col sm:flex-row sm:items-start sm:space-x-6 max-w-4xl">
     <img alt="Illustration showing hands holding a card with a question mark and icons representing quiz objectives" class="mb-4 sm:mb-0 flex-shrink-0" height="120" src="https://storage.googleapis.com/a1aa/image/65cda892-6ec9-478c-1ac4-47cfa2b7eb53.jpg" width="150"/>
     <div class="text-xs text-white max-w-xl">
      <p class="mb-2">
       <strong>
        Objective 1:
       </strong>
       Understand the basics of photosynthesis.
      </p>
      <p class="mb-2">
       <strong>
        Objective 2:
       </strong>
       Identify major parts of a plant cell.
      </p>
      <p>
       <strong>
        Objective 3:
       </strong>
       Explain the process of cellular respiration.
      </p>
     </div>
    </div>
   </section>
   <section class="mb-6">
    <h3 class="font-semibold text-white text-base mb-4">
     Points System &amp; Streaks
    </h3>
    <div class="bg-[#222222] rounded-lg max-w-md p-4 text-center text-xs font-semibold">
     <div>
      Points Earned
     </div>
     <div class="font-normal mt-1">
      You have accumulated 850 points this week!
     </div>
    </div>
   </section>
   <section>
    <h3 class="font-semibold text-white text-base mb-4">
     Achievements &amp; Connections
    </h3>
    <div class="flex flex-col sm:flex-row sm:space-x-6 max-w-4xl">
     <div class="bg-[#222222] rounded-lg p-4 mb-4 sm:mb-0 flex-1 text-xs font-semibold text-center">
      <div class="mb-2">
       Achievements
      </div>
      <div class="font-normal">
       Completed 10 quizzes in a row
       <br/>
       Scored 100% in three consecutive quizzes
       <br/>
       Active participation in quiz discussions
      </div>
     </div>
     <div class="bg-[#222222] rounded-lg p-4 flex-1 text-xs font-semibold text-center">
      <div class="mb-2">
       Connections
      </div>
      <div class="font-normal mb-3">
       Connect with peers and instructors to enhance your learning experience.
      </div>
      <button class="bg-[#22A022] text-white text-xs font-semibold px-3 py-1 rounded-full hover:bg-[#1b7f1b] transition">
       View Connections
      </button>
     </div>
    </div>
   </section>
  </main>
  <footer class="flex justify-between items-center px-6 py-3 border-t border-gray-700 text-xs font-semibold text-white">
   <div class="flex space-x-4">
    <a class="hover:underline" href="#">
     Stats
    </a>
    <a class="hover:underline" href="#">
     Leaderboard
    </a>
    <a class="hover:underline" href="#">
     Contact Us
    </a>
   </div>
   <div class="flex space-x-6">
    <a class="hover:underline" href="#">
     Privacy Policy
    </a>
    <a class="hover:underline" href="#">
     Terms of Service
    </a>
   </div>
  </footer>
 </body>
</html>