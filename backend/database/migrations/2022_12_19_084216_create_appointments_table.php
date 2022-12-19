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
        Schema::create('appointments', function (Blueprint $table) {
            $table->id();
            $table->string('appointment_tracking_id')->unique();
            $table->integer('doctor_id');
            $table->integer('patient_id');
            $table->dateTime('scheduled_in')->nullable();
            $table->dateTime('scheduled_view');
            $table->string('findings')->nullable();
            $table->integer('prescription')->nullable();
            $table->string('notes')->nullable();
            $table->enum('status',['scheduled','cancelled','completed']);
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
        Schema::dropIfExists('appointments');
    }
};
