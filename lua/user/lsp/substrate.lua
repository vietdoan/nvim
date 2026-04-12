--- Substrate repo helpers for resolving NuGet Pkg* environment variables.
--- The Substrate build system uses non-standard NuGet output (.pkgrefgen/)
--- and GlobalPackageReferences that require special resolution for Roslyn LSP.
local M = {}

--- Find the Substrate repo root by walking up looking for Directory.Build.props.
--- @param start string
--- @return string|nil
function M.find_repo_root(start)
  return vim.fs.root(start, "Directory.Build.props")
end

--- Find the nearest .csproj directory by walking up from `start`.
--- @param start string
--- @return string|nil
function M.find_csproj_root(start)
  return vim.fs.root(start, function(name)
    return name:match("%.csproj$") ~= nil
  end)
end

--- Parse Pkg* properties from a single .pkgrefgen/*.nuget.g.props XML file.
--- @param props_path string
--- @return table<string, string> vars  { PkgFoo = "relative\\path", ... }
local function parse_nuget_g_props(props_path)
  local vars = {}
  local f = io.open(props_path, "r")
  if not f then
    return vars
  end
  for line in f:lines() do
    local name, rel = line:match("<(Pkg[%w_%-]+)[^>]*>%$%(NugetMachineInstallRoot%)\\(.-)</")
    if name and rel then
      vars[name] = rel
    end
  end
  f:close()
  return vars
end

--- Collect Pkg* variables from a project's .pkgrefgen/ folder.
--- @param project_dir string
--- @return table<string, string>
local function collect_pkg_vars_from_project(project_dir)
  local vars = {}
  local pkgrefgen = vim.fs.joinpath(project_dir, ".pkgrefgen")
  if not vim.uv.fs_stat(pkgrefgen) then
    return vars
  end
  for name, type in vim.fs.dir(pkgrefgen) do
    if type == "file" and name:match("%.nuget%.g%.props$") then
      for k, v in pairs(parse_nuget_g_props(vim.fs.joinpath(pkgrefgen, name))) do
        vars[k] = v
      end
    end
  end
  return vars
end

--- Collect Pkg* variables from a project and all its ProjectReference dependencies.
--- @param project_dir string
--- @param repo_root string|nil  Expands $(INETROOT) in ProjectReference paths
--- @return table<string, string>
local function collect_all_pkg_vars(project_dir, repo_root)
  local vars = collect_pkg_vars_from_project(project_dir)

  -- Find the .csproj file
  local csproj
  for name, type in vim.fs.dir(project_dir) do
    if type == "file" and name:match("%.csproj$") then
      csproj = vim.fs.joinpath(project_dir, name)
      break
    end
  end
  if not csproj then
    return vars
  end

  local f = io.open(csproj, "r")
  if not f then
    return vars
  end
  for line in f:lines() do
    local ref = line:match('<ProjectReference%s+Include="(.-)"')
    if ref then
      if repo_root then
        ref = ref:gsub("%$%(INETROOT%)", repo_root)
      end
      local ref_path = ref:gsub("/", "\\")
      local ref_dir
      if ref_path:match("^%a:") or ref_path:match("^\\\\") then
        ref_dir = vim.fs.dirname(ref_path)
      else
        ref_dir = vim.fs.dirname(vim.fs.joinpath(project_dir, ref_path))
      end
      ref_dir = vim.fs.normalize(ref_dir)
      for k, v in pairs(collect_pkg_vars_from_project(ref_dir)) do
        if not vars[k] then
          vars[k] = v
        end
      end
    end
  end
  f:close()
  return vars
end

--- Resolve Pkg* env vars for all packages listed in Packages.props by probing the
--- NuGet cache.  Packages restored by the Substrate build land in CxCache in one of
--- two layouts:
---   hierarchical: <cache>/<lowercase-id>/<version>/
---   flat:         <cache>/<OriginalId>.<version>/
--- We generate a Pkg* env var (dots→underscores) for every package whose directory
--- exists, so any $(Pkg...) reference in the build system resolves correctly.
--- @param repo_root string
--- @param nuget_cache string
--- @return table<string, string>
local function collect_all_packages_props(repo_root, nuget_cache)
  local vars = {}
  local pf = io.open(vim.fs.joinpath(repo_root, "Packages.props"), "r")
  if not pf then
    return vars
  end
  for line in pf:lines() do
    local pkg_id, version = line:match('<PackageVersion%s+Include="([^"]+)"%s+Version="([^"]+)"')
    if pkg_id and version then
      local prop_name = "Pkg" .. pkg_id:gsub("%.", "_")
      -- Try hierarchical (lowercase id / version) first, then flat (id.version)
      local hier = vim.fs.joinpath(nuget_cache, pkg_id:lower(), version)
      if vim.uv.fs_stat(hier) then
        vars[prop_name] = hier
      else
        local flat = vim.fs.joinpath(nuget_cache, pkg_id .. "." .. version)
        if vim.uv.fs_stat(flat) then
          vars[prop_name] = flat
        end
      end
    end
  end
  pf:close()
  return vars
end

--- Build a complete environment table with all Pkg* variables needed by Roslyn LSP
--- to evaluate a Substrate .csproj.
--- @param project_dir string  Directory containing the .csproj
--- @return table<string, string>
function M.build_env(project_dir)
  local nuget_cache = vim.env.NugetMachineInstallRoot
  if not nuget_cache then
    vim.notify("NugetMachineInstallRoot env var not set", vim.log.levels.WARN)
    return {}
  end

  local repo_root = M.find_repo_root(project_dir)
  local env = {
    DOTNET_FILE_WATCHER_DISABLED = "1",
    NugetMachineInstallRoot = nuget_cache,
  }

  for var, rel_path in pairs(collect_all_pkg_vars(project_dir, repo_root)) do
    env[var] = nuget_cache .. "\\" .. rel_path
  end

  if repo_root then
    for var, abs_path in pairs(collect_all_packages_props(repo_root, nuget_cache)) do
      if not env[var] then
        env[var] = abs_path
      end
    end
  end

  return env
end

return M
