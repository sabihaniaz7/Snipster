<?php

namespace App\Http\Controllers;

use App\Models\Snippet;
use Illuminate\Http\Request;

class SnippetController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Snippet::query();

        if ($search = $request->query('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'ilike', "%{$search}%")
                  ->orWhere('content', 'ilike', "%{$search}%");
            });
        }

        if ($category = $request->query('category')) {
            $query->where('category', $category);
        }

        return response()->json($query->latest()->get());
    }


    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
 public function store(Request $request)
    {
        $validated = $request->validate([
            'title'    => 'required|string|max:255',
            'content'  => 'required|string',
            'language' => 'nullable|string|max:50',
            'category' => 'nullable|string|max:50',
        ]);

        $snippet = Snippet::create($validated);
        return response()->json($snippet, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Snippet $snippet)
    {
        return response()->json($snippet);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Snippet $snippet)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
  public function update(Request $request, Snippet $snippet)
    {
        $validated = $request->validate([
            'title'    => 'sometimes|required|string|max:255',
            'content'  => 'sometimes|required|string',
            'language' => 'nullable|string|max:50',
            'category' => 'nullable|string|max:50',
        ]);

        $snippet->update($validated);
        return response()->json($snippet);
    }

    /**
     * Remove the specified resource from storage.
     */
     public function destroy(Snippet $snippet)
    {
        $snippet->delete();
        return response()->json(null, 204);
    }
}
