using Clang.Generators
using igraph_jll

cd(@__DIR__)

include_dir = normpath(igraph_jll.artifact_dir, "include")
igraph_dir = joinpath(include_dir, "igraph")
lib_dir = dirname(igraph_jll.libigraph_path)

options = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()  # Note you must call this function firstly and then append your own flags
push!(args, "-I$include_dir", "-L$(lib_dir)", "-ligraph")

#headers = [joinpath(igraph_dir, header) for header in readdir(igraph_dir) if endswith(header, ".h")]
# there is also an experimental `detect_headers` function for auto-detecting top-level headers in the directory
headers = detect_headers(igraph_dir, args)

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)
