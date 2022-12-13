<?php

namespace App\Models;

use Illuminate\Auth\Authenticatable;
use Laravel\Lumen\Auth\Authorizable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Contracts\Auth\Access\Authorizable as AuthorizableContract;

//this is new
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Model implements AuthenticatableContract, AuthorizableContract, JWTSubject 
{
    use Authenticatable, Authorizable;

    /**
     * Get the identifier that will be stored in the subject claim of the JWT.
     *
     * @return mixed
     */
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
     * Return a key value array, containing any custom claims to be added to the JWT.
     *
     * @return array
     */
    public function getJWTCustomClaims()
    {
        return [];
    }
}

// namespace App\Models;

// use Illuminate\Auth\Authenticatable;
// use Illuminate\Contracts\Auth\Access\Authorizable as AuthorizableContract;
// use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
// use Illuminate\Database\Eloquent\Factories\HasFactory;
// use Illuminate\Database\Eloquent\Model;
// use Laravel\Lumen\Auth\Authorizable;

// class User extends Model implements AuthenticatableContract, AuthorizableContract
// {
//     use Authenticatable, Authorizable, HasFactory;

//     /**
//      * The attributes that are mass assignable.
//      *
//      * @var string[]
//      */
//     protected $fillable = [
//         'name', 'email',
//     ];

//     /**
//      * The attributes excluded from the model's JSON form.
//      *
//      * @var string[]
//      */
//     protected $hidden = [
//         'password',
//     ];
// }
