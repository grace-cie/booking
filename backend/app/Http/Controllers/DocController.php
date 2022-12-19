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
               // 'bookDoctor'
          ]]);
     }

     private function patientId(){
          return Auth::user()->id;
     }

     public function getDoctors(){
          $doctors = DB::select("select * from users where user_class='doctor' limit 10");
          $res = response()->json($doctors);
          return $res;
     }

     public function bookDoctor(Request $request){
          $patient_id = $this->patientId();

          $random = '';
          for ($i = 0; $i < 6; $i++) {
               $random .= rand(0, 1) ? rand(0, 9) : chr(rand(ord('A'), ord('Z')));
          }

          $this->validate($request, [
               'appointment_tracking_id' => 'string',
               'doctor_id' => 'required|integer',
               'patient_id' => 'integer',
               'scheduled_in' => 'required|date_format:Y-m-d H:i:s|unique:appointments',
               'status' => 'required|string',
          ]);

          $input = $request->only(
               'appointment_tracking_id',
               'doctor_id',
               'patient_id',
               'scheduled_in',
               'status',
          );

          try {
               $appointment_data = [];
               $appointment_data['appointment_tracking_id'] = $random;
               $appointment_data['doctor_id'] = $input['doctor_id'];
               $appointment_data['patient_id'] = $patient_id;
               $appointment_data['scheduled_in'] = $input['scheduled_in'];
               $appointment_data['scheduled_view'] = $input['scheduled_in'];
               $appointment_data['status'] = $input['status'];

               $appointments = DB::insert("insert into appointments (".implode(",", array_keys($appointment_data)) . ') VALUES (\'' . implode("','", array_values($appointment_data)) . "')");
          
               if (!$appointments) {
                    $code = 500;
                         $output = [
                         'code' => $code,
                         'message' => 'Error creating appointment',
                    ];
               } else {
                    $code = 200;
                    $output = [
                         'code' => $code,
                         'message' => 'Appointment created Successfully',
                    ];
               }
          } catch (Exception $e){
               $code = 500;
               $output = [
                    'code' => $code,
                    'message' => 'Error creating appointment',
               ];
          }

          return response()->json($output, $code);
     }

     public function viewMyAppointments(){
          $patient_id = $this->patientId();

          $user_appointments = DB::select("select * from appointments where patient_id='$patient_id' limit 15");

          if(!empty($user_appointments)){
               return response()->json([
                    'message' => 'appointments found',
                    'appointments' => $user_appointments,
               ], 200);
          } else {
               return response()->json([
                    'message' => 'you have no appointments record',
               ], 200);
          }
     }
     
}