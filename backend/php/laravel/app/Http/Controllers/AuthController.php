<?php

namespace App\Http\Controllers;

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
                // TODO Add log
                // Log::error(Message::AUTH_KO, __METHOD__, new $this, $request, null, json_encode($validator->errors()->toArray()));

                return $this->sendError(
                    Message::REGISTER_KO,
                    $validator->errors()->toArray(),
                    400
                );
            }

            $data['password'] = Hash::make($data['password']);

            $user = \App\Models\User::create($data);

            $token = $user->createToken(config('app.name'))->accessToken;

            // TODO Add log
            // Log::info(Message::AUTH_OK, __METHOD__, $user, $request);

            return $this->sendResponse(['token' => $token], Message::REGISTER_OK, 201);
        } catch (\Exception $ex) {
            // TODO Add log
            // Log::error(Message::AUTH_KO, __METHOD__, new $this, $request, $ex);

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
                // TODO Add log
                // Log::error(Message::AUTH_KO, __METHOD__, new $this, $request, null, json_encode($validator->errors()->toArray()));

                return $this->sendError(Message::AUTH_KO, $validator->errors()->toArray(), 400);
            }

            // dd($data);

            if (Auth::attempt([
                'email' => $data['email'],
                'password' => $data['password']
            ])) {
                $user = Auth::user();

                $token = $user->createToken(config('app.name'))->accessToken;

                // TODO Add log
                // Log::info(Message::AUTH_OK, __METHOD__, $user, $request);

                return $this->sendResponse(['token' => $token], Message::AUTH_OK);
            } else {
                return $this->sendError(Message::CREDENTIALS_KO);
            }
        } catch (\Exception $ex) {
            // TODO Add log
            // Log::error(Message::AUTH_KO, __METHOD__, new $this, $request, $ex);

            return $this->sendError(Message::AUTH_KO,  [$ex->getMessage()], 400);
        }
    }
}
