@extends('templates.content')

@section('title_page', config('app.name') . ' | Dashboard')

@section('linkstyles')
    <link rel="stylesheet" href="{{ asset('plugins/datatables-bs4/css/dataTables.bootstrap4.min.css') }}">
    <link rel="stylesheet" href="{{ asset('plugins/datatables-responsive/css/responsive.bootstrap4.min.css') }}">
    <link rel="stylesheet" href="{{ asset('plugins/toastr/toastr.min.css') }}">
@endsection

@section('content')

    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">All Servers</h3>
                    <div class="card-tools">
                        <ul class="nav nav-pills ml-auto">
                            <li class="nav-item">
                                <button class="btn btn-primary" data-backdrop="static" data-keyboard="false"
                                    data-toggle="modal" data-target="#add-modal">+ Add</button>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="card-body">
                    <div class="dataTables_wrapper dt-bootstrap4">
                        <table id="allservers" role="grid" class="table table-bordered table-hover dataTable"
                            style="width: 100%">
                            <thead>
                                <th>Server Name</th>
                                <th>Country</th>
                                <th>Username</th>
                                <th>Password</th>
                                <th>IsPro?</th>
                                <th>Protocol</th>
                                <th>Action</th>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('footer')

    <div class="modal fade" id="add-modal" style="display: none;" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div id="add_modal_loading" class="overlay d-flex justify-content-center align-items-center hide"
                    style="display:none !important">
                    <i class="fas fa-2x fa-sync fa-spin"></i>
                </div>
                <form method="POST" id="add_form" action={{ route('add_server') }}>
                    @csrf
                    <div class="modal-header">
                        <h4 class="modal-title">Add Server</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="flag_logo">Flag Logo URL</label>
                            <input type="text" class="form-control" name="flag_logo" id="add_flag_logo"
                                placeholder="Ex: https://www.countryflags.io/ID/flat/64.png">
                        </div>
                        <div class="form-group">
                            <label for="vpn_country">Country VPN</label>
                            <input type="text" class="form-control" name="vpn_country" id="add_vpn_country"
                                placeholder="Ex: Indonesia">
                        </div>
                        <div class="form-group">
                            <label for="server_name">Server Name</label>
                            <input type="text" class="form-control" name="server_name" id="add_server_name"
                                placeholder="Ex: Indonesia - Jakarta">
                        </div>
                        <div class="form-group">
                            <label for="vpn_username">VPN Username</label>
                            <input type="text" class="form-control" name="vpn_username" id="add_vpn_username"
                                placeholder="Ex: username">
                        </div>
                        <div class="form-group">
                            <label for="vpn_password">VPN Password</label>
                            <input type="text" class="form-control" name="vpn_password" id="add_vpn_password"
                                placeholder="Ex: password">
                        </div>
                        <div class="form-group">
                            <label for="vpn_config_udp">OVPN Config Script [UDP]</label>
                            <textarea class="form-control" name="vpn_config_udp" id="add_vpn_config_udp" placeholder="Left it blank if you don't have one"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="vpn_config_tcp">OVPN Config Script [TCP]</label>
                            <textarea class="form-control" name="vpn_config_tcp" id="add_vpn_config_tcp" placeholder="Left it blank if you don't have one"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="vpn_status">Provide to</label>
                            <select class="form-control" name="vpn_status" id="add_vpn_status">
                                <option value="0">Free User</option>
                                <option value="1">Pro User</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Add Server</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="edit-modal" style="display: none;" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div id="edit_modal_loading" class="overlay d-flex justify-content-center align-items-center">
                    <i class="fas fa-2x fa-sync fa-spin"></i>
                </div>
                <form method="POST" id="edit_form" action={{ route('update_server') }}>
                    @csrf
                    <input type="hidden" name="vpn_slug" id="edit_vpn_slug">
                    <div class="modal-header">
                        <h4 class="modal-title">Edit Server</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="flag_logo">Flag Logo URL</label>
                            <input type="text" class="form-control" name="flag_logo" id="edit_flag_logo"
                                placeholder="Ex: https://www.countryflags.io/ID/flat/64.png">
                        </div>
                        <div class="form-group">
                            <label for="vpn_country">Country VPN</label>
                            <input type="text" class="form-control" name="vpn_country" id="edit_vpn_country"
                                placeholder="Ex: Indonesia">
                        </div>
                        <div class="form-group">
                            <label for="server_name">Server Name</label>
                            <input type="text" class="form-control" name="server_name" id="edit_server_name"
                                placeholder="Ex: Indonesia - Jakarta">
                        </div>
                        <div class="form-group">
                            <label for="vpn_username">VPN Username</label>
                            <input type="text" class="form-control" name="vpn_username" id="edit_vpn_username"
                                placeholder="Ex: username">
                        </div>
                        <div class="form-group">
                            <label for="vpn_password">VPN Password</label>
                            <input type="text" class="form-control" name="vpn_password" id="edit_vpn_password"
                                placeholder="Ex: password">
                        </div>

                        <div class="form-group">
                            <label for="vpn_config_udp">OVPN Config Script [UDP]</label>
                            <textarea class="form-control" name="vpn_config_udp" id="edit_vpn_config_udp" placeholder="Left it blank if you don't have one"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="vpn_config_tcp">OVPN Config Script [TCP]</label>
                            <textarea class="form-control" name="vpn_config_tcp" id="edit_vpn_config_tcp" placeholder="Left it blank if you don't have one"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="vpn_status">Provide to</label>
                            <select class="form-control" name="vpn_status" id="edit_vpn_status">
                                <option value="0">Free User</option>
                                <option value="1">Pro User</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

@endsection
@section('javascripts')
    <script src="{{ asset('plugins/datatables/jquery.dataTables.min.js') }}"></script>
    <script src="{{ asset('plugins/datatables-bs4/js/dataTables.bootstrap4.min.js') }}"></script>
    <script src="{{ asset('plugins/datatables-responsive/js/dataTables.responsive.min.js') }}"></script>
    <script src="{{ asset('plugins/datatables-responsive/js/responsive.bootstrap4.min.js') }}"></script>
    <script src="{{ asset('plugins/toastr/toastr.min.js') }}"></script>
    <script>
        function switcher(slug, value) {
            $.ajax({
                url: "{{ route('switch_status') }}",
                type: 'POST',
                data: {
                    _token: "{{ csrf_token() }}",
                    value: value,
                    slug: slug,
                },
                error: function(resp) {
                    toastr.error('Failed updating data!');
                },
                success: function(response) {
                    toastr.success('Server updated successfully!');
                    clearFormAdd();
                },
                done: function(resp) {
                    table.ajax.reload();
                }
            });
        }

        function clearFormEdit() {
            $("#edit_flag_logo").val("");
            $("#edit_vpn_country").val("");
            $("#edit_server_name").val("");
            $("#edit_vpn_username").val("");
            $("#edit_vpn_password").val("");
            $("#edit_vpn_config_udp").val("");
            $("#edit_vpn_config_tcp").val("");
            $("#edit_vpn_status").val("0");
            $("#edit_vpn_slug").val("");
        }

        function clearFormAdd() {
            $("#add_flag_logo").val("");
            $("#add_vpn_country").val("");
            $("#add_server_name").val("");
            $("#add_vpn_username").val("");
            $("#add_vpn_password").val("");
            $("#add_vpn_config_udp").val("");
            $("#add_vpn_config_tcp").val("");
            $("#add_vpn_status").val("0");
            $("#add_vpn_slug").val("");
        }


        function serverDetail(slug) {
            $("#edit_modal_loading").show();
            $("#edit-modal").on(function(e) {
                clearForm();
            });
            $("#edit-modal").modal({
                backdrop: 'static',
                keyboard: false,
                show: true
            });
            $.ajax({
                url: "{{ route('dashboard') }}",
                data: {
                    "slug": slug
                },
                error: function(resp) {
                    $('#edit_modal_loading').attr("style", "display: none !important");
                    toastr.error('Failed to load data!');
                },
                success: function(response) {
                    $('#edit_modal_loading').attr("style", "display: none !important");
                    if (response.success) {
                        var data = response.data;
                        $("#edit_flag_logo").val(data.flag);
                        $("#edit_vpn_country").val(data.country);
                        $("#edit_server_name").val(data.name);
                        $("#edit_vpn_username").val(data.username);
                        $("#edit_vpn_password").val(data.password);
                        $("#edit_vpn_slug").val(data.slug);
                        $("#edit_vpn_config_udp").val(data.config_udp);
                        $("#edit_vpn_config_tcp").val(data.config_tcp);
                        $("#edit_vpn_status").val(data.status);
                    } else {
                        toastr.error(response.message);
                    }
                }
            });
        }

        function removeServer(slug) {
            $.ajax({
                url: "{{ route('delete_server') }}",
                method: "post",
                data: {
                    _token: "{{ csrf_token() }}",
                    "slug": slug
                },
                error: function(resp) {
                    $('#edit_modal_loading').attr("style", "display: none !important");
                    toastr.error('Failed to delete data!');
                },
                success: function(response) {
                    toastr.error('Server deleted!');
                    table.ajax.reload();
                }
            });
        }

        $("#edit_form").on("submit", function(event) {
            $("#edit_modal_loading").show();
            event.preventDefault();
            var form = $(this);
            $.ajax({
                url: form.attr("action"),
                method: "POST",
                data: {
                    _token: "{{ csrf_token() }}",
                    flag: $("#edit_flag_logo").val(),
                    country: $("#edit_vpn_country").val(),
                    name: $("#edit_server_name").val(),
                    username: $("#edit_vpn_username").val(),
                    password: $("#edit_vpn_password").val(),
                    slug: $("#edit_vpn_slug").val(),
                    status: $("#edit_vpn_status").val(),
                    config_udp: $("#edit_vpn_config_udp").val(),
                    config_tcp: $("#edit_vpn_config_tcp").val()
                },
                error: function(resp) {
                    $('#edit_modal_loading').attr("style", "display: none !important");
                    toastr.error('Failed updating data!');
                },
                success: function(response) {
                    $('#edit_modal_loading').attr("style", "display: none !important");

                    if (response.success) {
                        toastr.success('Server updated successfully!');

                        $("#edit-modal").modal("hide");
                        table.ajax.reload();
                    } else {
                        toastr.error(response.message);
                    }
                }
            });
        });

        $("#add_form").on("submit", function(event) {
            $("#add_modal_loading").show();
            event.preventDefault();
            var form = $(this);
            $.ajax({
                url: form.attr("action"),
                method: "POST",
                data: {
                    _token: "{{ csrf_token() }}",
                    flag: $("#add_flag_logo").val(),
                    country: $("#add_vpn_country").val(),
                    name: $("#add_server_name").val(),
                    username: $("#add_vpn_username").val(),
                    password: $("#add_vpn_password").val(),
                    slug: $("#add_vpn_slug").val(),
                    status: $("#add_vpn_status").val(),
                    config_udp: $("#add_vpn_config_udp").val(),
                    config_tcp: $("#add_vpn_config_tcp").val()
                },
                error: function(resp) {
                    $('#add_modal_loading').attr("style", "display: none !important");
                    toastr.error('Failed adding data!');
                },
                success: function(response) {
                    $('#add_modal_loading').attr("style", "display: none !important");
                    if (response.success) {
                        toastr.success('Server added successfully!');
                        clearFormAdd();
                        table.ajax.reload();
                    } else {
                        toastr.error(response.message);
                    }
                }
            });
        });

        var table = $('#allservers').DataTable({
            processing: true,
            serverSide: true,
            ajax: "{{ route('dashboard') }}",
            columns: [{
                    data: 'name_with_flag',
                    name: 'name_with_flag'
                },
                {
                    data: 'country',
                    name: 'country'
                },
                {
                    data: 'username',
                    name: 'username',
                    defaultContent: "<i>Not set</i>"
                },
                {
                    data: 'password',
                    name: 'password',
                    defaultContent: "<i>Not set</i>"
                },
                {
                    data: 'pro_switcher',
                    name: 'status'
                },
                {
                    data: 'protocol',
                    name: 'protocol'
                },
                {
                    data: 'action',
                    name: 'action',
                },
            ],

            orderable: true,
            searchable: true,
            autoWidth: false,
            responsive: true,
        });

    </script>
@endsection
