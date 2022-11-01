   @include('templates.headers')

   @include('templates.topbar')

   <div class="content-wrapper pt-4">

       <section class="content">
           <div class="container-fluid">
               @yield('content')
           </div>
       </section>
   </div>
   @include('templates.footers')
