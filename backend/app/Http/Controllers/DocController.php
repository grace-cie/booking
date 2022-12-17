<?php

namespace App\Http\Controllers;
// namespace App\Http\AuthController;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class DocController extends AuthController {

     public function __construct(){
          $this->middleware('auth:api', ['except' => [
               // 'getDoctors'
          ]]);
     }
     public function getDoctors(){
          $doctors = DB::select("select * from users where user_class='doctor' limit 6");
          $res = response()->json($doctors);
          return $res;
     }
     
}