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
            'user_class' => 'patient',
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
            'bio' => 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using Content here, content here, making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for lorem ipsum will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).',
            'password' => Hash::make('123123'),
            'status' => 'active',
            'user_class' => 'doctor',
            'hcp' => 'Chong Hua Hospital',
            'hcp_addr' => 'Fuente Osmeña Cir, Cebu City,',
        ],
    );
        foreach($users as $key => $user){
            $users = User::create($user);
        }
    }
}
