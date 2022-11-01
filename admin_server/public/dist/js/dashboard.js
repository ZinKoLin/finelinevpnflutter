function clearFormEdit() {
    $("#edit_flag_logo").val("");
    $("#edit_vpn_country").val("");
    $("#edit_server_name").val("");
    $("#edit_vpn_username").val("");
    $("#edit_vpn_password").val("");
    $("#edit_vpn_config").val("");
    $("#edit_vpn_protocol").val("udp").change();
    $("#edit_vpn_status").val("0");
    $("#edit_vpn_slug").val("");
}

function clearFormAdd() {
    $("#add_flag_logo").val("");
    $("#add_vpn_country").val("");
    $("#add_server_name").val("");
    $("#add_vpn_username").val("");
    $("#add_vpn_password").val("");
    $("#add_vpn_config").val("");
    $("#add_vpn_protocol").val("udp").change();
    $("#add_vpn_status").val("0");
    $("#add_vpn_slug").val("");
}

function serverDetail(slug) {
    $("#loaddataoverlay").show();
    $("#edit-modal").on(function (e) {
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
        error: function (resp) {
            $('#loaddataoverlay').attr("style", "display: none !important");
            toastr.error('Failed to load data!');
        },
        success: function (response) {
            $('#loaddataoverlay').attr("style", "display: none !important");
            if (response.success) {
                var data = response.data;
                $("#edit_flag_logo").val(data.flag);
                $("#edit_vpn_country").val(data.country);
                $("#edit_server_name").val(data.name);
                $("#edit_vpn_username").val(data.username);
                $("#edit_vpn_password").val(data.password);
                $("#edit_vpn_slug").val(data.slug);
                $("#edit_vpn_config").val(data.config);
                $("#edit_vpn_protocol").val(data.protocol);
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
        error: function (resp) {
            $('#loaddataoverlay').attr("style", "display: none !important");
            toastr.error('Failed to delete data!');
        },
        success: function (response) {
            toastr.error('Server deleted!');
            table.ajax.reload();
        }
    });
}

$("#edit_form").on("submit", function (event) {
    $("#loaddataoverlay").show();
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
            protocol: $("#edit_vpn_protocol").val(),
            config: $("#edit_vpn_config").val()
        },
        error: function (resp) {
            $('#loaddataoverlay').attr("style", "display: none !important");
            toastr.error('Failed updating data!');
        },
        success: function (response) {
            $('#loaddataoverlay').attr("style", "display: none !important");
            if (response.success) {
                toastr.success('Server updated successfully!');
                table.ajax.reload();
            } else {
                toastr.error(response.message);
            }
        }
    });
});

$("#add_form").on("submit", function (event) {
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
            protocol: $("#add_vpn_protocol").val(),
            config: $("#add_vpn_config").val()
        },
        error: function (resp) {
            toastr.error('Failed adding data!');
        },
        success: function (response) {
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
        data: 'status_detail',
        name: 'status'
    },
    {
        data: 'protocol',
        name: 'protocol'
    },
    {
        data: 'action',
        name: 'action',
        orderable: true,
        searchable: true
    },
    ]
});
