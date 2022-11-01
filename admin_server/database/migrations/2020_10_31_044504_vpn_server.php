<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class VpnServer extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('vpnserver', function (Blueprint $table) {
            $table->id();
            $table->text('name');
            $table->string("flag");
            $table->string('country', 64);
            $table->longText('config_tcp')->nullable();
            $table->longText('config_udp')->nullable();
            $table->string('slug')->unique();
            $table->string("username")->nullable();
            $table->string("password")->nullable();
            $table->tinyInteger("status")->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('vpnserver');
    }
}
