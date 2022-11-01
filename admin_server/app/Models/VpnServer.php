<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VpnServer extends Model
{
    use HasFactory;
    protected $table = "vpnserver";
    protected $hidden = ["config_udp", "config_tcp", "username", "password", "hastcp", "hasudp", "tcp_port", "udp_port"];
    protected $fillable = ["name", "config_udp", "config_tcp", "flag", "slug", "username", "password", "status",  "country"];
    protected $casts = ["status" => "integer"];
    protected $appends = ["hastcp", "hasudp", "server_ip", "tcp_port", "udp_port"];

    public function getHasTCPAttribute()
    {
        return $this->attributes["config_tcp"] != null && strlen(trim($this->attributes["config_tcp"])) > 0;
    }
    public function getHasUDPAttribute()
    {
        return $this->attributes["config_udp"] != null && strlen(trim($this->attributes["config_udp"])) > 0;
    }

    public function getServerIPAttribute()
    {
        $config = $this->attributes["config_udp"] ?? ($this->attributes["config_tcp"] ?? null);
        if ($config == null) return null;

        $servers = [];
        preg_match('/(?<=remote)\s.+\s/', $config, $servers);
        if ($servers != null && count($servers) > 0) {
            $result["vpn_host"] = explode(" ", trim($servers[0]))[0] ?? null;
            return $result["vpn_host"] != null ? gethostbyname($result["vpn_host"]) : null;
        }
        return null;
    }

    public function getTcpPortAttribute()
    {
        $config = $this->attributes["config_tcp"];
        $servers = [];
        preg_match('/(?<=remote)\s.+\s/', $config, $servers);
        if ($servers != null && count($servers) > 0) return explode(" ", trim($servers[0]))[1] ?? null;
    }
    public function getUdpPortAttribute()
    {
        $config = $this->attributes["config_udp"];
        $servers = [];
        preg_match('/(?<=remote)\s.+\s/', $config, $servers);
        if ($servers != null && count($servers) > 0)
            if ($servers != null && count($servers) > 0) return explode(" ", trim($servers[0]))[1] ?? null;
    }
}
