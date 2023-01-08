<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('user_name');
            $table->string('first_name');
            $table->string('middle_name');
            $table->string('last_name');
            $table->string('address');
            $table->string('suffix')->nullable();
            $table->string('email')->unique();
            $table->string('phone')->unique();
            $table->longText('bio');
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->enum('status',['active','inactive']);
            $table->string('hcp')->nullable();
            $table->string('hcp_addr')->nullable();
            $table->enum('user_class',['patient','doctor']);
            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');
    }
};
