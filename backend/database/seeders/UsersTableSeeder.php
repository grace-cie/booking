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
            'user_name' => 'Bill',
            'first_name' => 'Bill',
            'middle_name' => 'D',
            'last_name' => 'Gates',
            'address' => 'Ohio City',
            'suffix' => '',
            'email' => 'bill@mailinator.com',
            'phone' => '09234567896',
            'bio' => '',
            'password' => Hash::make('123123'),
            'status' => 'active',
            'user_class' => 'doctor',
        ],
        [
            'user_name' => 'Mark', 
            'first_name' => 'Mark',
            'middle_name' => 'C',
            'last_name' => 'Zuckerberg',
            'address' => 'New York City',
            'suffix' => '',
            'email' => 'mark@mailinator.com',
            'phone' => '09098011400',
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
