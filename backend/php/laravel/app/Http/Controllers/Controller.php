<?php

namespace App\Http\Controllers;

use App\Lib\Message;
use App\Lib\ControllerUtils;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    /** @var mixed */
    protected $model;

    /** @var int */
    protected $perPage = 33;

    /**
     * Base method to get all entities
     *
     * @param \Illuminate\Http\Request $request
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index(Request $request): JsonResponse
    {
        try {
            if (is_null($this->model)) {
                return $this->sendError(Message::BAD_REQUEST, [], 400);
            }

            $query = $request->query();


            $relationships = ControllerUtils::getRequestRelationships($query);

            $entities = $this->model::with($relationships)
                ->orderBy('created_at', 'desc')
                ->get()
                ->toArray();

            return $this->sendResponse($entities, Message::INDEX_OK);
        } catch (\Illuminate\Database\QueryException $ex) {
            // TODO Add log
            // Log::error(Message::FILTER_KO, __METHOD__, new $this->model(), $request, $ex);

            return $this->sendError(Message::FILTER_KO . $ex->getMessage());
        } catch (\Illuminate\Database\Eloquent\RelationNotFoundException $ex) {
            // TODO Add log
            // Log::error(Message::RELATION_KO, __METHOD__, new $this->model(), $request, $ex);

            return $this->sendError(Message::RELATION_KO . $ex->getMessage());
        } catch (\Exception $ex) {
            // TODO Add log
            // Log::error(Message::INDEX_KO, __METHOD__, new $this->model(), $request, $ex);

            return $this->sendError(Message::INDEX_KO  . $ex->getMessage());
        }
    }

    /**
     * Base method to show single entity
     *
     * @param \Illuminate\Http\Request $request
     * @param mixed $id
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function show(Request $request, $id): JsonResponse
    {
        try {
            if (is_null($this->model)) {
                return $this->sendError(Message::BAD_REQUEST, [], 400);
            }

            $query = $request->query();

            $relationships = ControllerUtils::getRequestRelationships($query);

            $entity = $this->model::with($relationships)
                ->find($id);

            if (is_null($entity)) {
                return $this->sendNotFound();
            }

            return $this->sendResponse($entity->toArray(), Message::SHOW_OK);
        } catch (\Illuminate\Database\Eloquent\RelationNotFoundException $ex) {
            // TODO Add log
            // Log::error(Message::RELATION_KO, __METHOD__, new $this->model(), $request, $ex);

            return $this->sendError(Message::RELATION_KO);
        } catch (\Exception $ex) {
            // TODO Add log
            // Log::error(Message::SHOW_KO, __METHOD__, new $this->model(), $request, $ex);

            return $this->sendError(Message::SHOW_KO);
        }
    }

    /**
     * Base method to create a new entity
     *
     * @param \Illuminate\Http\Request $request
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request): JsonResponse
    {
        try {
            if (is_null($this->model)) {
                return $this->sendError(Message::BAD_REQUEST, [], 400);
            }

            $data = $request->all();

            $entity = new $this->model;
            $entity->fill($data);

            // Saves entity with data
            $entity->save();

            // Log::info(Message::CREATE_OK, __METHOD__, $entity, $request);
            $entity = $entity->fresh();

            return $this->sendResponse($entity->toArray(), Message::CREATE_OK, 201);
        } catch (\Exception $ex) {
            // TODO Add log
            // Log::error(Message::CREATE_KO, __METHOD__, new $this->model(), $request, $ex);

            return $this->sendError(Message::CREATE_KO, [$ex->getMessage()]);
        }
    }

    /**
     * Base method to update an entity
     *
     * @param \Illuminate\Http\Request $request
     * @param mixed $id
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $id): JsonResponse
    {
        try {
            if (is_null($this->model)) {
                return $this->sendError(Message::BAD_REQUEST, [], 400);
            }

            $data = $request->all();

            $entity = $this->model::find($id);

            if (is_null($entity)) {
                // TODO Add log
                // Log::error(Message::UPDATE_KO, __METHOD__, new $this->model(), $request);

                return $this->sendNotFound();
            }

            $entity->fill($data);
            $entity->save();

            $entity = $entity->fresh();

            // Log::info(Message::UPDATE_OK, __METHOD__, $entity, $request);
            return $this->sendResponse($entity->toArray(), Message::UPDATE_OK);
        } catch (\Exception $ex) {
            // TODO Add log
            // Log::error(Message::UPDATE_KO, __METHOD__, new $this->model(), $request, $ex);

            return $this->sendError(Message::UPDATE_KO . $ex->getMessage());
        }
    }

    /**
     * Base method to delete an entity
     *
     * @param \Illuminate\Http\Request $request
     * @param mixed $id
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy(Request $request, $id): JsonResponse
    {
        try {
            if (is_null($this->model)) {
                return $this->sendError(Message::BAD_REQUEST, [], 400);
            }

            $entity = $this->model::find($id);

            if (is_null($entity)) {
                return $this->sendNotFound();
            }

            $entity->delete();

            // Log::info(Message::DELETE_OK, __METHOD__, $entity, $request);

            return $this->sendResponse([], Message::DELETE_OK);
        } catch (\Exception $ex) {
            // TODO Add log
            // Log::error(Message::DELETE_KO, __METHOD__, new $this->model(), $request, $ex);

            return $this->sendError(Message::DELETE_KO);
        }
    }

    /**
     * Method to send response
     *
     * @param array $data
     * @param string $message
     * @param int $statusCode
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public static function sendResponse(
        array $data,
        string $message = null,
        int $statusCode = 200
    ): JsonResponse {
        $response = [
            'success' => true,
            'message' => $message,
            'data' => $data
        ];

        return response()->json($response, $statusCode);
    }

    /**
     * Method to send response error
     *
     * @param string $error
     * @param array $errorMessages
     * @param int $statusCode
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public static function sendError(
        string $error = Message::GENERIC_KO,
        array $errorMessages = [],
        int $statusCode = 405
    ): JsonResponse {
        $response = [
            'success' => false,
            'message' => $error
        ];

        if (!empty($errorMessages)) {
            $response['errors'] = $errorMessages;
        }

        return response()->json($response, $statusCode);
    }

    /**
     * Method to send not found error
     *
     * @param string $error
     * @param array $errorMessages
     * @param int $statusCode
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public static function sendNotFound(
        string $error = Message::NOT_FOUND,
        array $errorMessages = []
    ): JsonResponse {
        return self::sendError($error, $errorMessages, 404);
    }
}
