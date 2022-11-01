<nav class="main-header navbar navbar-expand navbar-black navbar-dark">
    <ul class="navbar-nav">
        <li class="nav-item d-none d-sm-inline-block">
            <a href="#" class="nav-link">{{ config('app.name', 'New VPN') }}</a>
        </li>
    </ul>
    <ul class="order-1 order-md-3 navbar-nav navbar-no-expand ml-auto">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" id="userDropdown" href="#" role="button" data-toggle="dropdown"
                aria-haspopup="true" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>

            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
                <a href="{{ route('logout') }}" class="nav-link text-dark"  onclick="event.preventDefault();document.getElementById('logout-form').submit();">
                    Log out
                </a>
                <form id="logout-form" action="{{ route('logout') }}" method="POST" class="d-none">
                    @csrf
                </form>
            </div>
        </li>
    </ul>
</nav>
