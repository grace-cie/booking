<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/




$router->get('/', function () use ($router) {
    echo "<center> Welcome </center>";
});

$router->get('/version', function () use ($router) {
    return $router->app->version();
});

Route::group([

    'prefix' => 'auth'

], function ($router) {
    Route::post('checkmail', 'AuthController@authenticateUser');
    Route::post('login', 'AuthController@login');
    Route::post('register-user', 'AuthController@register');
    Route::post('logout', 'AuthController@logout');
    Route::post('refresh', 'AuthController@refresh');
    Route::post('user-profile', 'AuthController@me');
    Route::post('doctors', 'DocController@getDoctors');
    Route::post('book-doctor', 'DocController@bookDoctor');
    Route::post('my-appointments', 'DocController@viewMyAppointments');
    Route::post('doc-appointments', 'DocController@viewDocAppointments');
    Route::post('cancel-appointment/{id}', 'DocController@cancelApppointment');
    Route::post('complete-appointment/{id}', 'DocController@completeApppointment');
    // Route::post('add-findings/{appointment_id}', 'DocController@addFindings');
    // Route::post('add-prescription/{appointment_id}', 'DocController@addPrescription');
    // Route::post('add-notes/{appointment_id}', 'DocController@addNotes');
    Route::post('add-fpn/{appointment_id}', 'DocController@addFPN');
    Route::post('getusers', 'AuthController@getUsers');
    // Route::post('face', 'DocController@testapi');
    // Route::post('faceget', 'DocController@getapi');
});
