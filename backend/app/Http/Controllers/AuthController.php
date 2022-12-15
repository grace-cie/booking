<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class AuthController extends Controller
{


    public function __construct()
    {
        $this->middleware('auth:api', ['except' => [
            'login', 
            'refresh', 
            'logout',
            'register', 
            'searchUserById'
        ]]);
    }

    public function login(Request $request){
        $token_state = $this->checkTokens($request);

        $check_user = Auth::user();

        if(!$token_state){

            $this->validate($request, [
                'email' => 'required|string',
                'password' => 'required|string',
            ]);

            $credentials = $request->only(['email', 'password']);

            if(!$token = Auth::attempt($credentials)){
                return response()->json(['message' => 'Invalid Credentials'], 401);
            }
            
            $check_status = Auth::user()->status;

            if($check_status === 'active'){
                $request->session()->put([
                    'saved_token' => $token,
                    'name' => Auth::user()->user_name
                ]);
        
                
            } else {
                $this->logout($request);
                return response()->json(['message' => 'This user is inactive'], 202);
            }
    
            
            
            return $this->respondWithToken($token); 

        } else {

            $to_array = (array) $token_state;

            return response()->json([
                'message' => 'Already Logged in as '.$to_array[0],
                'token' => $to_array[1],
                'hint' => 'You must Logout first before logging in again'
            ]);

        }
        
    }

    public function register(Request $request){
        // dd($request);
        $this->validate($request, [
            'name' => 'required|string',
            'email' => 'required|email|unique:users',
            'password' => 'required|confirmed'
        ]);
        $input = $request->only('name', 'email', 'password');
        // dd($input);
        try{
            $user = new User;
            $user->name = $input['name'];
            $user->email = $input['email'];
            $password = $input['password'];
            $user->password = Hash::make($password);

            if ($user->save()) {
                $code = 200;
                $output = [
                    'user' => $user,
                    'code' => $code,
                    'message' => 'User created Successfully',
                ];
            } else {
                $code = 500;
                $output = [
                    'code' => $code,
                    'message' => 'Error creating user',
                ];
            }
            
        } catch(Exception $e) {
            // dd($e->getMessage());
            $code = 500;
            $output = [
                'code' => $code,
                'message' => 'Error creating user',
            ];
        }

        return response()->json($output, $code);
    }

    public function courseDetails($id){
        $courses = DB::select("select * from users_course where id='$id'");
        // $res = response()->json($courses);
        return $courses[0]->name;
    }

    public function checkUsers($user_id){
        $user = User::find($user_id);
        if(isset($user)){
            return $user;
        } else {
            return false;
        }
    }

    public function searchUserById($user_id){
        $validated_user = $this->checkUsers($user_id);

        if(!$validated_user){
            $code = 200;
            $output = [
                'code' => $code,
                'message' =>'User not found',
            ];
            return response()->json($output, $code);
        } else {
            $course_id = $validated_user->course_id;
        
            $res = $this->courseDetails($course_id);
            return response()->json([
                'name' => $validated_user->name,
                'course' => $res,
                'status' => $validated_user->status
            ]);
        }
        
    }

    public function me(){
        $user = Auth::user();
        return response()->json($user);
        // $res = $this->courseDetails($user_course_id);
        // return response()->json([
        //     "user details" => [
        //         "name" => Auth::user()->name,
        //         "course" => $res,
        //         "status" => Auth::user()->status],
        // ]);
    }

    public function logout(Request $request){
        auth()->logout();
        $request->session()->forget('saved_token');

        return response()->json(['message' => 'Successfully logged out']);
    }

    public function refresh(){
        return $this->respondWithToken(auth()->refresh());
    }


    public function checkTokens(Request $request){
        $serialize = $request->session()->get('saved_token');
        if(isset($serialize)){
            $data1 = $request->session()->get('name');
            $data2 = $request->session()->get('saved_token');
            return (object) array_merge((array)$data1, (array)$data2);
        } else {
            return false;
        }
    }

    protected function respondWithToken($token){
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'user' => auth()->user(),
            'expires_in' => auth()->factory()->getTTL() * 60 * 24
        ]);
    }
}