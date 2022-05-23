<?php

namespace App\Http\Controllers;

use App\Events\UserLoggedIn;
use App\Lib\Message;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    /**
     * Registers a single user via API
     *
     * @param \Illuminate\Http\Request $request
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function register(Request $request)
    {
        try {
            $data = $request->all();

            $validator = Validator::make($data, [
                'name' => 'required',
                'email' => 'required|email',
                'password' => 'required'
            ]);

            if ($validator->fails()) {
                return $this->sendError(
                    Message::REGISTER_KO,
                    $validator->errors()->toArray(),
                    400
                );
            }

            $data['password'] = Hash::make($data['password']);

            $user = \App\Models\User::create($data);

            $token = $user->createToken(config('app.name'))->accessToken;

            return $this->sendResponse(['token' => $token], Message::REGISTER_OK, 201);
        } catch (\Exception $ex) {
            return $this->sendError(Message::REGISTER_KO, [$ex->getMessage()], 400);
        }
    }

    /**
     * Loggedin a single user via API
     *
     * @param \Illuminate\Http\Request $request
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request $request)
    {
        try {
            $data = $request->all();

            $validator = Validator::make($data, [
                'email' => 'required|email',
                'password' => 'required'
            ]);

            if ($validator->fails()) {
                return $this->sendError(Message::AUTH_KO, $validator->errors()->toArray(), 400);
            }

            if (Auth::attempt([
                'email' => $data['email'],
                'password' => $data['password']
            ])) {
                /** @var \App\Models\User $user **/
                $user = Auth::user();

                $token = $user->createToken(config('app.name'))->accessToken;

                // Dispatching UserLoggedIn event
                UserLoggedIn::dispatch($user);

                return $this->sendResponse(['token' => $token], Message::AUTH_OK);
            } else {
                return $this->sendError(Message::CREDENTIALS_KO);
            }
        } catch (\Exception $ex) {
            return $this->sendError(Message::AUTH_KO,  [$ex->getMessage()], 400);
        }
    }
}
