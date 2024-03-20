---@diagnostic disable: undefined-global

--Packages, you can use `xrepo search <name>` to search packages,
--and prefix with other package managers, for example `vcpkg::pcre2` in order to use their packages.
--Documentation: https://xmake.io/#/manual/global_interfaces?id=add_requires
local packages = {

}

--Sanitizers to use when building in debug mode
local sanitizers = { "address", "leak", "undefined" }

--Objective C compilation flags
local mflags = {
    release = {},
    debug = {
        "-Wno-unused-function", "-Wno-unused-parameter", "-Wno-unused-variable"
    },
    regular = {
        "-Wall", "-Wextra", "-Werror",
    }
}

--Objective C linker flags
local ldflags = {
    release = {
        "-flto"
    },
    debug = {},
    regular = {}
}

--C standard to use, `gnulatest` means the latest C standard + GNU extensions
set_languages("gnulatest")

add_requires("objfw", { configs = { shared = is_kind("shared") } })
add_requires(packages, { configs = { shared = is_kind("shared") } })

target("MyProject")
do
    set_kind("binary")
    add_packages("objfw")
    add_packages(packages)

    add_files("src/**.m")
    add_headerfiles("src/**.h")

    add_mflags(mflags.regular)
    add_ldflags(ldflags.regular)

    if is_mode("debug", "check") then
        add_mflags(mflags.debug)
        add_ldflags(ldflags.debug)

        add_defines("PROJECT_DEBUG")
        if is_mode("check") then
            cprint("${yellow}WARNING: Sanitizers make ObjFW run extremely slow")
            for _, v in ipairs(sanitizers) do
                add_mflags("-fsanitize=" .. v)
                add_ldflags("-fsanitize=" .. v)
            end
        end
    elseif is_mode("release", "minsizerel") then
        add_mflags(mflags.release)
        add_ldflags(ldflags.release)
        if is_mode("minsizerel") then
            set_symbols("hidden")
            set_optimize("smallest")
            set_strip("all")
        end
    end
end
target_end()
