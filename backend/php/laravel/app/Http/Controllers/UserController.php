<?php

namespace App\Http\Controllers;

use App\Lib\Message;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    /**
     * @var \App\Models\User
     */
    protected $model = User::class;

    /**
     * Return user logged profile
     *
     * @param \Illumiante\Http\Request
     * @return \Illuminate\Http\JsonResponse
     */
    public function me(Request $request): JsonResponse
    {
        try {
            $userLogged = is_null(auth()->user())
                ? auth('api')->user()
                : auth()->user();

            if (is_null($userLogged)) {
                // TODO Add log
                // Log::error(Message::SHOW_KO, __METHOD__, new $this->entityClass, $request);

                return $this->sendError(Message::SHOW_KO);
            }

            return $this->show($request, $userLogged->id);
        } catch (\Exception $e) {
            // TODO Add log here
            return $this->sendError($e->getMessage());
        }
    }
}
