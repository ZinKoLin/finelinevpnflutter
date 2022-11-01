<?php

use App\Http\Controllers\api\VPNController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return "endpoint";
});
Route::group(['prefix' => 'allservers'], function () {
    Route::get('/', [VPNController::class, "allVPNServer"]);
    Route::get('/free',  [VPNController::class, "allVPNFreeServer"]);
    Route::get('/pro', [VPNController::class, "allVPNProServer"]);
});


Route::get('/detail/{id}',  [VPNController::class, "detailVpn"]);
Route::get('/detail/random',  [VPNController::class, "randomVpn"]);
