<?php

namespace App\Http\Controllers;

use App\Models\VpnServer as ModelsVpnServer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Yajra\DataTables\DataTables;

class AdminController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth');
    }

    public function index(Request $request)
    {
        return redirect()->route("dashboard");
    }

    public function addServer(Request $request)
    {

        $validator = Validator::make(
            $request->all(),
            [
                "flag" => "required",
                "country" => "required",
                "name" =>  "required",
                "status" =>  "required",
            ],
        );

        if ($validator->fails()) {
            return $this->printJson($validator->errors()->first());
        }

        if (strlen(trim($request->input("config_tcp"))) == 0 && strlen(trim($request->input("config_udp"))) == 0)
            return $this->printJson("Fill in at least 1 protocol");

        $add = ModelsVpnServer::create([
            "flag" => $request->input("flag"),
            "country" => $request->input("country"),
            "name" => $request->input("name"),
            "username" => $request->input("username"),
            "password" => $request->input("password"),
            "config_tcp" => $request->input("config_tcp"),
            "config_udp" => $request->input("config_udp"),
            "status" => $request->input("status"),
            "slug" => Str::random(64),
        ]);

        if (!$add) return $this->printJson("Something went wrong");
        return $this->printJson("Data added", true);
    }

    public function updateServer(Request $request)
    {

        $validator = Validator::make(
            $request->all(),
            [
                "flag" => "required",
                "country" => "required",
                "name" =>  "required",
                "status" =>  "required",
            ],
        );

        if ($validator->fails()) return $this->printJson($validator->errors()->first());

        if (strlen(trim($request->input("config_tcp"))) == 0 && strlen(trim($request->input("config_udp"))) == 0)
            return $this->printJson("Fill in at least 1 protocol");

        $update = ModelsVpnServer::where("slug", $request->input("slug"))->update([
            "flag" => $request->input("flag"),
            "country" => $request->input("country"),
            "name" => $request->input("name"),
            "username" => $request->input("username"),
            "password" => $request->input("password"),
            "config_udp" => $request->input("config_udp"),
            "config_tcp" => $request->input("config_tcp"),
            "status" => $request->input("status"),
        ]);

        if (!$update) return $this->printJson("Something went wrong", false, $update);
        return $this->printJson("Data updated", true);
    }

    public function deleteServer(Request $request)
    {
        return  ModelsVpnServer::where("slug", $request->input("slug"))->delete();
    }

    public function switch(Request $request)
    {
        return ModelsVpnServer::where("slug", $request->input("slug"))->update(["status" => (int) $request->input("value")]);
    }

    public function dashboard(Request $request)
    {
        if ($request->ajax()) {
            //Get detail by slug
            if ($request->input("slug") != null) {
                $detail = ModelsVpnServer::where("slug", $request->input("slug"))->get()->makeVisible(["config_udp", "config_tcp", "username", "password"])->first()->toArray();
                $detail["protocol"] = $this->supportedProtocol($detail);
                if ($detail != null) {
                    return $this->printJson("Detail's server loaded", true, $detail);
                } else {
                    return $this->printJson("Something went wrong, can not find your server's detail!");
                }
            }

            $data = ModelsVpnServer::latest()->get()->makeVisible(["username", "password"]);
            $output = $data->map(function ($item) {
                $item["status_detail"] = $item["status"] == 1 ? "PRO User" : "Free User";
                $item["protocol"] = $this->supportedProtocol($item);

                $config = $item["config_udp"] != null  ? $item["config_udp"] : $item["config_tcp"];
                $servers = [];
                preg_match('/(?<=remote)\s.+\s/', $config, $servers);
                if ($servers != null && count($servers) > 0) {
                    $item["vpn_host"] = explode(" ", trim($servers[0]))[0] ?? null;
                    $item["vpn_port"] = explode(" ", trim($servers[0]))[1] ?? null;
                    $item["vpn_ip"] = $item["vpn_host"] != null ? gethostbyname($item["vpn_host"]) : null;
                }

                return $item;
            });

            return DataTables::of($output)
                ->addIndexColumn()
                ->addColumn('pro_switcher', function ($row) {
                    return '<div class="custom-control custom-switch"><input onClick="switcher(\'' . $row["slug"] . '\',\'' . ($row["status"] == 1 ? 0 : 1) . '\')" ' . ($row["status"] == 1 ? 'checked' : '') . ' type="checkbox" class="custom-control-input"  id="checkbox-' . $row["id"] . '" value="' . $row["slug"] . '"><label class="custom-control-label" for="checkbox-' . $row["id"] . '"></label></div>';
                })
                ->addColumn('name_with_flag', function ($row) {
                    $image = '<img src="' . $row->flag . '" width=30px height=30px class="mr-2"/>&nbsp;' . $row->name;
                    return $image;
                })
                ->addColumn('action', function ($row) {
                    $btn = '<button onclick="serverDetail(\'' . $row->slug . '\')" class="btn btn-warning">Edit</button> ' . '<button onclick="removeServer(\'' . $row->slug . '\')" class="btn btn-danger">Delete</button> ';
                    return $btn;
                })
                ->rawColumns(['action', 'name_with_flag', 'pro_switcher'])
                ->make(true);
        }

        return view("dashboard");
    }

    private function supportedProtocol($item)
    {
        $output = "";
        if ($item["config_udp"] != null && strlen(trim($item["config_udp"])) > 0) {
            $output = "UDP";
        }

        if ($item["config_tcp"] != null &&  strlen(trim($item["config_tcp"])) > 0) {
            $output = "TCP";
        }

        if (strlen(trim($item["config_udp"])) > 0 && strlen(trim($item["config_tcp"])) > 0) {
            $output = "UDP/TCP";
        }

        return $output;
    }
}
