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
            'user_name' => 'Blez', 
            'first_name' => 'blez',
            'middle_name' => 'd.',
            'last_name' => 'godornes',
            'address' => 'Cebu City',
            'suffix' => '',
            'email' => 'doctor1@mailinator.com',
            'phone' => '09329135808',
            'bio' => 'My name is blez im a professional doctor, graduated in harvard, Im currently working in Harvard medical team.',
            'password' => Hash::make('123123'),
            'status' => 'active',
            'user_class' => 'doctor',
        ],
        [
            'user_name' => 'Rhai', 
            'first_name' => 'rhainne pearl',
            'middle_name' => 'd.',
            'last_name' => 'Signe',
            'address' => 'Cebu City',
            'suffix' => '',
            'email' => 'doctor2@mailinator.com',
            'phone' => '09245367465',
            'bio' => '',
            'password' => Hash::make('123123'),
            'status' => 'active',
            'user_class' => 'doctor',
        ],
        [
            'user_name' => 'Clement', 
            'first_name' => 'clement clay',
            'middle_name' => 'v',
            'last_name' => 'velez',
            'address' => 'Cebu City',
            'suffix' => '',
            'email' => 'doctor3@mailinator.com',
            'phone' => '09087657453',
            'bio' => '',
            'password' => Hash::make('123123'),
            'status' => 'active',
            'user_class' => 'doctor',
        ],
        [
            'user_name' => 'Harvs', 
            'first_name' => 'harvs',
            'middle_name' => 'dakog',
            'last_name' => 'oten',
            'address' => 'Cebu City',
            'suffix' => '',
            'email' => 'doctor4@mailinator.com',
            'phone' => '09696996969',
            'bio' => '',
            'password' => Hash::make('123123'),
            'status' => 'active',
            'user_class' => 'doctor',
        ],
        [
            'user_name' => 'Hose', 
            'first_name' => 'Jose',
            'middle_name' => 'hulk',
            'last_name' => 'alonzo',
            'address' => 'Cebu City',
            'suffix' => '',
            'email' => 'doctor5@mailinator.com',
            'phone' => '09345432536',
            'bio' => '',
            'password' => Hash::make('123123'),
            'status' => 'active',
            'user_class' => 'doctor',
        ],
        [
            'user_name' => 'Jomegs', 
            'first_name' => 'megs',
            'middle_name' => 'daks',
            'last_name' => 'hilom-hilom',
            'address' => 'Cebu City',
            'suffix' => '',
            'email' => 'doctor6@mailinator.com',
            'phone' => '09345098536',
            'bio' => '',
            'password' => Hash::make('123123'),
            'status' => 'active',
            'user_class' => 'doctor',
        ],
        [
            'user_name' => 'Thea',
            'first_name' => 'thea',
            'middle_name' => 'c',
            'last_name' => 'antig',
            'address' => 'Cebu City',
            'suffix' => '',
            'email' => 'thea@mailinator.com',
            'phone' => '09452370354',
            'bio' => '',
            'password' => Hash::make('123123'),
            'status' => 'active',
            'user_class' => 'doctor',
        ],
        [
            'user_name' => 'Riri', 
            'first_name' => 'Jose',
            'middle_name' => 'hulk',
            'last_name' => 'alonzo',
            'address' => 'Cebu City',
            'suffix' => '',
            'email' => 'riri@mailinator.com',
            'phone' => '09164011400',
            'bio' => '',
            'password' => Hash::make('123123'),
            'status' => 'active',
            'user_class' => 'doctor',
        ],
    );
        foreach($users as $key => $user){
            $users = User::create($user);
        }
    }
}
