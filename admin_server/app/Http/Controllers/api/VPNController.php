<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\VpnServer as ModelsVpnServer;
use App\VPNServer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class VPNController extends Controller
{
    function allVPNServer(Request $request)
    {
        $output = [];
        $allData = [];
        if ($request->input("page") != null) {
            $page = $request->input("page");
            $page--;
            if ($page < 0) $page = 0;
            $allData = ModelsVpnServer::orderBy("status")->limit(10)->offset(10 *  $page)->get();
        } else {
            $allData = ModelsVpnServer::orderBy("status")->get();
        }

        foreach ($allData as $item) {
            if ($item->hasUdp) {
                $outputItem = $item->toArray();
                $outputItem["port"] = $item->udpPort;
                $outputItem["protocol"] = "udp";
                $outputItem["id"] = $item->slug . $item->tcpPort . "udp";
                $output[] = $outputItem;
            }

            if ($item->hasTcp) {
                $outputItem = $item->toArray();
                $outputItem["port"] = $item->tcpPort;
                $outputItem["protocol"] = "tcp";
                $outputItem["id"] = $item->slug . $item->tcpPort . "tcp";
                $output[] = $outputItem;
            }
        }
        return $this->printJson("All Servers loaded", true, $output);
    }

    function allVPNProServer(Request $request)
    {
        $output = [];
        $allData = [];
        if ($request->input("page") != null) {
            $page = $request->input("page");
            $page--;
            if ($page < 0) $page = 0;
            $allData = ModelsVpnServer::where("status", 1)->limit(10)->offset(10 *  $page)->get();
        } else {
            $allData = ModelsVpnServer::where("status", 1)->get();
        }

        foreach ($allData as $item) {
            if ($item->hasUdp) {
                $outputItem = $item->toArray();
                $outputItem["port"] = $item->udpPort;
                $outputItem["protocol"] = "udp";
                $outputItem["id"] = $item->slug . $item->tcpPort . "udp";
                $output[] = $outputItem;
            }

            if ($item->hasTcp) {
                $outputItem = $item->toArray();
                $outputItem["port"] = $item->tcpPort;
                $outputItem["protocol"] = "tcp";
                $outputItem["id"] = $item->slug . $item->tcpPort . "tcp";
                $output[] = $outputItem;
            }
        }
        return $this->printJson("All Servers loaded", true, $output);
    }

    function allVPNFreeServer(Request $request)
    {
        $output = [];
        $allData = [];
        if ($request->input("page") != null) {
            $page = $request->input("page");
            $page--;
            if ($page < 0) $page = 0;
            $allData = ModelsVpnServer::where("status", 0)->limit(10)->offset(10 *  $page)->get();
        } else {
            $allData = ModelsVpnServer::where("status", 0)->get();
        }

        foreach ($allData as $item) {
            if ($item->hasUdp) {
                $outputItem = $item->toArray();
                $outputItem["port"] = $item->udpPort;
                $outputItem["protocol"] = "udp";
                $outputItem["id"] = $item->slug . $item->udpPort . "udp";
                $output[] = $outputItem;
            }

            if ($item->hasTcp) {
                $outputItem = $item->toArray();
                $outputItem["port"] = $item->tcpPort;
                $outputItem["protocol"] = "tcp";
                $outputItem["id"] = $item->slug . $item->tcpPort . "tcp";
                $output[] = $outputItem;
            }
        }
        return $this->printJson("All Servers loaded", true, $output);
    }

    function detailVpn(Request $request, $id)
    {
        if (strtolower($id) == "random") return $this->randomVpn($request);
        $vpnServer = ModelsVpnServer::where("slug", $id)->get()->first();
        if ($vpnServer == null) return $this->printJson("VPN is not valid");
        $result = $vpnServer->toArray();
        $result["username"] = $vpnServer->username;
        $result["password"] = $vpnServer->password;
        if ($request->input("protocol") == "tcp") {
            $result["id"] = $vpnServer->slug . $vpnServer->tcpPort . "tcp";
            $result["port"] = $vpnServer->tcpPort;
            $result["protocol"] = "tcp";
            $result["config"] = $vpnServer->config_tcp;
        } else if (($request->input("protocol") == "udp")) {
            $result["id"] = $vpnServer->slug .  $vpnServer->udpPort . "udp";
            $result["port"] = $vpnServer->udpPort;
            $result["protocol"] = "udp";
            $result["config"] = $vpnServer->config_udp;
        } else {
            if ($vpnServer->config_udp != null) {
                $result["id"] = $vpnServer->slug .  $vpnServer->udpPort . "udp";
                $result["port"] = $vpnServer->udpPort;
                $result["protocol"] = "udp";
                $result["config"] = $vpnServer->config_udp;
            } else {
                $result["id"] = $vpnServer->slug .  $vpnServer->udpPort . "tcp";
                $result["port"] = $vpnServer->tcpPort;
                $result["protocol"] = "tcp";
                $result["config"] = $vpnServer->config_tcp;
            }
        }
        return $this->printJson("Success load VPN Detail", true,  $result);
    }

    function randomVpn(Request $request)
    {
        $vpnServer = ModelsVpnServer::where(["status" => 0])->get()->random();

        if ($vpnServer == null || count($vpnServer->toArray()) == 0) return $this->printJson("There is no data");

        $result = $vpnServer->toArray();
        $result["username"] = $vpnServer->username;
        $result["password"] = $vpnServer->password;
        if ($request->input("protocol") == "tcp") {
            $result["id"] = $vpnServer->slug . $vpnServer->tcpPort . "tcp";
            $result["port"] = $vpnServer->tcpPort;
            $result["protocol"] = "tcp";
            $result["config"] = $vpnServer->config_tcp;
        } else if (($request->input("protocol") == "udp")) {
            $result["id"] = $vpnServer->slug .  $vpnServer->udpPort . "udp";
            $result["port"] = $vpnServer->udpPort;
            $result["protocol"] = "udp";
            $result["config"] = $vpnServer->config_udp;
        } else {
            if ($vpnServer->config_udp != null) {
                $result["id"] = $vpnServer->slug .  $vpnServer->udpPort . "udp";
                $result["port"] = $vpnServer->udpPort;
                $result["protocol"] = "udp";
                $result["config"] = $vpnServer->config_udp;
            } else {
                $result["id"] = $vpnServer->slug .  $vpnServer->udpPort . "tcp";
                $result["port"] = $vpnServer->tcpPort;
                $result["protocol"] = "tcp";
                $result["config"] = $vpnServer->config_tcp;
            }
        }

        return $this->printJson("Berhasil mendapatkan random VPN", true,  $result);
    }
    
    function preference(Request $request){
        $data = DB::table("preference")->get();
        return $data;
    }


    function preference_switch(Request $request){
        $data = DB::table("preference")->where(["name"=>"show_ads"])->get();
        return $data[0]["id"];
    }
}
