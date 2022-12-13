<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $users = array(
        [
            'user_name' => 'Riri', 
            'first_name' => 'Rey',
            'middle_name' => 'C.',
            'last_name' => 'Antig',
            'address' => 'Cebu City',
            'suffix' => 'Jr.',
            'email' => 'rirei1415@mailinator.com',
            'phone' => '09232309731',
            'password' => Hash::make('12345678'),
            'status' => 'active',
            'user_class' => 'patient',
        ],
        [
            'user_name' => 'Thea', 
            'first_name' => 'Thea',
            'middle_name' => 'C.',
            'last_name' => 'Antig',
            'address' => 'Cebu City',
            'suffix' => 'Jr.',
            'email' => 'thea@mailinator.com',
            'phone' => '09452370354',
            'password' => Hash::make('12345678'),
            'status' => 'active',
            'user_class' => 'patient',
        ],
        [
            'user_name' => 'Alzate', 
            'first_name' => 'Ferdinand',
            'middle_name' => 'Viloria',
            'last_name' => 'Alzate',
            'address' => 'Cebu City',
            'suffix' => '',
            'email' => 'alzate@mailinator.com',
            'phone' => '09514637654',
            'password' => Hash::make('12345678'),
            'status' => 'active',
            'user_class' => 'doctor',
        ],
    );
        foreach($users as $key => $user){
            $users = User::create($user);
        }
    }
}
