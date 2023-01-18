<?php

namespace App\Http\Controllers;
// namespace App\Http\AuthController;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use DateInterval;
use DateTime;

use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class DocController extends AuthController {

     public function __construct(){
          $this->middleware('auth:api', ['except' => [
               // 'getDoctors'
               // 'bookDoctor'
               'testapi',
               'getapi'
          ]]);
     }

     private function userId(){
          return Auth::user()->id;
     }

     public function getDoctors(){
          $doctors = DB::select("select * from users where user_class='doctor' limit 10");
          $res = response()->json($doctors);
          return $res;
     }

     public function bookDoctor(Request $request){
          $patient_id = $this->userId();

          $random = '2';
          for ($i = 0; $i < 6; $i++) {
               $random .= rand(0, 1) ? rand(0, 9) : chr(rand(ord('A'), ord('Z')));
          }

          $this->validate($request, [
               'appointment_tracking_id' => 'string',
               'doctor_id' => 'required|integer',
               'patient_id' => 'integer',
               'scheduled_in' => 'required|date_format:Y-m-d H:i:s',
               'status' => 'required|string',
          ]);

          $input = $request->only(
               'appointment_tracking_id',
               'doctor_id',
               'patient_id',
               'scheduled_in',
               'status',
          );

          $date = new DateTime($input['scheduled_in']);

          $format_interval = $date->add(new DateInterval('PT31M'))->format('Y-m-d H:i:s');

          $startTime = $input['scheduled_in'];
          $endTime = $format_interval;

          // check if theres an existig booking within 30 mins of given datetime
          $existingBooking = DB::table('appointments')
          ->where(function($query) use($startTime, $endTime) {
               $query->where('scheduled_view', '>=', $startTime)
               ->where('scheduled_view', '<', $endTime);
          })
          ->orWhere(function($query) use($startTime, $endTime) {
               $query->where('scheduled_in', '>', $startTime)
               ->where('scheduled_in', '<=', $endTime);
          })
          ->first();
          //done checking

          //if theres an existing booking
          if($existingBooking){

               $code = 403;
                    $output = [
                    'code' => $code,
                    'message' => 'There is an existing booking within the given schedule',
               ];
          //if theres no existing booking
          } else {
               
               try {
                    $appointment_data = [];
                    $appointment_data['appointment_tracking_id'] = $random;
                    $appointment_data['doctor_id'] = $input['doctor_id'];
                    $appointment_data['patient_id'] = $patient_id;
                    $appointment_data['scheduled_in'] = $format_interval; //->add(new DateInterval('PT30M'))
                    $appointment_data['scheduled_view'] = $input['scheduled_in'];
                    $appointment_data['status'] = $input['status'];
     
                    // $appointments = DB::insert("insert into appointments (".implode(",", array_keys($appointment_data)) . ') VALUES (\'' . implode("','", array_values($appointment_data)) . "')");
                    $appointments = DB::table('appointments')->insert($appointment_data);
               
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

          }

          return response()->json($output, $code);
     }

     public function viewMyAppointments(){
          $patient_id = $this->userId();

          // $user_appointments = DB::select("select * from appointments where patient_id='$patient_id' limit 15");
          $user_appointments = DB::table('appointments')
                              ->where('patient_id', $patient_id)
                              ->limit(15)
                              ->get();

          $count = count($user_appointments); //rowCount

          $appointments = [];

          foreach($user_appointments as $user_appointment){
               $doctor = User::find($user_appointment->doctor_id);
               $patient = User::find($user_appointment->patient_id);

               $appointments[] = [
                    "id" => $user_appointment->id,
                    "appointment_tracking_id" => $user_appointment->appointment_tracking_id,
                    "doctor" => $doctor['first_name'],
                    "patient" => $patient['first_name'],
                    "scheduled_view" => $user_appointment->scheduled_view,
                    "findings" => $user_appointment->findings,
                    "prescription" => $user_appointment->prescription,
                    "notes" => $user_appointment->notes,
                    "status" => $user_appointment->status,
               ];
          }

          if($count === 0){
               $code = 400;
               $output = [
                    'message' => 'you have no appointments record',
               ];
          } else {
               if(!empty($user_appointments)){
                    $code = 200;
                    $output = $appointments;
               }
          }
          return response()->json($output, $code);
     }

     public function viewDocAppointments(){
          $doctor_id = $this->userId();

          // $user_appointments = DB::select("select * from appointments where patient_id='$patient_id' limit 15");
          $user_appointments = DB::table('appointments')
                              ->where('doctor_id', $doctor_id)
                              ->limit(15)
                              ->get();

          $count = count($user_appointments); //rowCount

          $appointments = [];

          foreach($user_appointments as $user_appointment){
               $doctor = User::find($user_appointment->doctor_id);
               $patient = User::find($user_appointment->patient_id);

               $appointments[] = [
                    "id" => $user_appointment->id,
                    "appointment_tracking_id" => $user_appointment->appointment_tracking_id,
                    "doctor" => $doctor['first_name'],
                    "patient" => $patient['first_name'],
                    "scheduled_view" => $user_appointment->scheduled_view,
                    "findings" => $user_appointment->findings,
                    "prescription" => $user_appointment->prescription,
                    "notes" => $user_appointment->notes,
                    "status" => $user_appointment->status,
               ];
          }

          if($count === 0){
               $code = 400;
               $output = [
                    'message' => 'you have no appointments record',
               ];
          } else {
               if(!empty($user_appointments)){
                    $code = 200;
                    $output = $appointments;
               }
          }
          return response()->json($output, $code);
     }

     public function updateAppointmentStatus(){
          // $all_appointments = DB::select("UPDATE appointments SET status = 'cancelled' WHERE scheduled_in < NOW() AND status = 'scheduled'");
          $all_appointments = DB::table('appointments')
                              ->where('scheduled_in', '<', DB::raw('NOW()'))
                              ->where('status', 'scheduled')
                              ->update(['status' => 'cancelled']);
     }

     public function cancelApppointment($id){
          // $appointment = DB::select("UPDATE appointments SET status = 'cancelled' WHERE id = '$id' AND status = 'scheduled'");
          $appointment = DB::table('appointments')
                         ->where('id', $id)
                         ->where('status', 'scheduled')
                         ->update(['status' => 'cancelled']);

          if($appointment){
               $code = 200;
               $output = [
                    'message' => 'Successfully Cancelled Appointment'
               ];
          } else {
               $code = 400;
               $output = [
                    'message' => 'An Error Occured'
               ];
          }

          return response()->json($output, $code);
     }

     public function addFindings(Request $request, $appointment_id){

          $this->validate($request, [
               // 'id' => 'string',
               'findings' => 'required|string',
          ]);

          $input = $request->only(
               // 'id',
               'findings',
          );

          $insert_findings = DB::table('appointments')
          ->where('id', $appointment_id)
          ->update(['findings' => $input['findings']]);

          if($insert_findings){
               $code = 200;
               $output = [
                    'message' => 'Record Added'
               ];
          } else {
               $code = 400;
               $output = [
                    'message' => 'An Error Occured'
               ];
          }

          return response()->json($output, $code);
     }

     // public function getMyAppointments(){
          //      $patient_id = $this->userId();

          //      $my_appointments = B::select("select * from appointments where patient_id='$patient_id' limit 15");
          // }

          // public function testapi(Request $request){

          //      // Get the name value from the request payload
          //      $name = $request->input('name');
          //      // Do something with the name value
          //      // ...
          //      // $test = $request->session()->put(['saved_name' => $name]);

          //      $test = $request->session(['saved_name' => $name]);
          //      // Return a response
          //       return response()->json([
          //           'success' => true,
          //           'massage' => 'ok'
          //      ]);
          // }
     
          // public function getapi(Request $request){
          //      $value = $request->session('saved_name');
               
          //      return response()->json([
          //           'name' => $value
          //      ]);
     
          // }

     
}