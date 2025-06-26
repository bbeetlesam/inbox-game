-- Folder and files for File Explorer app

return {
    {
        name = "My Computer",
        type = "folder",
        expanded = true,
        children = {
            {
                name = "Documents",
                type = "folder",
                expanded = true,
                children = {
                    { name = "about.txt", type = "file",
                        content = "This game is shit, and you should'nt play it seriously.\nAnyway, I felt like the biggest asshole when I killed your rock 'n roll." },
                    { name = "lucy.txt", type = "file",
                        content = "Picture yourself in a boat on a river\nWith tangerine trees and marmalade skies\nSomebody calls you, you answer quite slowly\nA girl with kaleidoscope eyes" },
                }
            },
            {
                name = "Pictures",
                type = "folder",
                expanded = false,
                children = {}
            },
            {
                name = "Music",
                type = "folder",
                expanded = false,
                children = {}
            },
            {
                name = "Videos",
                type = "folder",
                expanded = false,
                children = {}
            },
        }
    }
}