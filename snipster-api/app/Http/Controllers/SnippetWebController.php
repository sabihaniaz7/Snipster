<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class SnippetWebController extends Controller
{
    public function index(Request $request)
    {
        $snippets = Snippet::when($request->search, fn($q) =>
            $q->where('title', 'ilike', "%{$request->search}%")
        )->latest()->get();

        return view('snippets.index', compact('snippets'));
    }
}
