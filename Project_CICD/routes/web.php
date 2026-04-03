<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return '
    <div style="font-family: sans-serif; text-align: center; margin-top: 50px;">
        <h1 style="color: #01579b;">🏥 Hospital System V2.0</h1>
        <h3 style="color: #2e7d32;">✅ Deployed Automatically via Jenkins CI/CD to Kubernetes</h3>
        <p>This is a real-time test of our new automated deployment pipeline.</p>
        <p style="color: #888; font-size: 14px;">Updated: ' . date('Y-m-d H:i:s') . '</p>
    </div>';
});
