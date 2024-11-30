local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ImageLabel = Instance.new("ImageLabel")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIGridLayout = Instance.new("UIGridLayout")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local ParticleEmitter = Instance.new("ParticleEmitter")
local ButtonGradient = Instance.new("UIGradient")
local hologram = Instance.new("ImageLabel")
local NeonEffect = Instance.new("ImageLabel")
local TweenService = game:GetService("TweenService")
local dragging, dragInput, dragStart, startPos

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 300) -- Ajustado para 600 pixels de largura e 400 pixels de altura
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Cor mais escura para mais contraste
MainFrame.BackgroundTransparency = 0.1

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(150, 0, 255) -- Azul Neon
UIStroke.Thickness = 3
UIStroke.Parent = MainFrame

ButtonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- Neon ciano
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 0)) -- Tom ciano
}
ButtonGradient.Rotation = 90
ButtonGradient.Parent = MainFrame

TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Position = UDim2.new(0, 0, 0, -50)
TitleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.BackgroundTransparency = 0.3
TitleLabel.Text = "BROOKHAVEN SCRIPTS"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Branco
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 32
TitleLabel.TextStrokeTransparency = 0.1
TitleLabel.TextStrokeColor3 = Color3.fromRGB(200, 0, 255) -- Azul Neon

local ImageShadow = Instance.new("ImageLabel")
ImageShadow.Size = ImageLabel.Size
ImageShadow.Position = ImageLabel.Position + UDim2.new(0, 2, 0, 2)
ImageShadow.Image = ImageLabel.Image
ImageShadow.ImageTransparency = 0.5
ImageShadow.Parent = TitleLabel

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = TitleLabel

ScrollingFrame.Parent = MainFrame
ScrollingFrame.Size = UDim2.new(1, -40, 1, -80)
ScrollingFrame.Position = UDim2.new(0, 20, 0, 60)
local maxButtons = 22
local buttonHeight = 60
local spacing = 10
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, maxButtons * (buttonHeight + spacing) / 4) -- Ajustado para quatro colunas
ScrollingFrame.ScrollBarThickness = 8
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Preto mais escuro
ScrollingFrame.BackgroundTransparency = 0.1

UIGridLayout.Parent = ScrollingFrame
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellSize = UDim2.new(0.25, -5, 0, buttonHeight) -- Ajustado para quatro colunas
UIGridLayout.CellPadding = UDim2.new(0, 5, 0, spacing) -- Espaçamento ajustado

local scripts = {
    {"ROCHIPS", "https://glot.io/snippets/gzrux646yj/raw/main.ts"},
    {"SanderXV4.2.2", "https://raw.githubusercontent.com/kigredns/SanderXV4.2.2/refs/heads/main/NormalSS.lua"},
    {"VEGAX", "https://raw.githubusercontent.com/V31nc/discord.com/invite/3NN5zTW7h2"},
    {"Universal-Script-REDZ", "https://rawscripts.net/raw/Universal-Script-REDZ-BrookhavenRP-20468"},
    {"AstroXTeam", "https://raw.githubusercontent.com/AstroXTeam/AstroXTeam/refs/heads/main/%D9%87%D9%84%D9%88.lua"},
    {"xXSAMUELXx", "https://raw.githubusercontent.com/SAMUCARARONOB/PizzeriaTycoon.com.BR/refs/heads/main/PIZZARIABRASILEIRA"},
    {"INFINITEYIELD", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {"NamelessAdmin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"},
    {"NewIceHub", "https://raw.githubusercontent.com/IceMae17/NewIceHub/main/Brookhaven"},
    {"REDzHUB", "https://raw.githubusercontent.com/REDzHUB/REDzHUB/main/REDzHUB"},
    {"BROOKHAVEN", "https://robloxdatabase.com/script/brookhaven-script/"},
    {"BROOKHAVEN-ADMIN", "https://raw.githubusercontent.com/NotAtomz/brookhaven-admin/main/script"},
    {"CMD-X", "https://raw.githubusercontent.com/CMD-X/CMD-X/main/CMD-X"},
    {"Hydroxide", "https://raw.githubusercontent.com/Upbolt/Hydroxide/main/init"},
    {"OwlHub", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt"},
    {"V.Ghub", "https://raw.githubusercontent.com/1201for/V.G-Hub/main/V.Ghub"},
    {"EclipseHub", "https://raw.githubusercontent.com/Ethanoj1/EclipseHub/main/EclipseHub"},
    {"HOHO_Hub", "https://raw.githubusercontent.com/acsu123/HOHO_H/main/hohohub"},
    {"ProjectEvolution", "https://raw.githubusercontent.com/Project-Evolution/Project-Evolution/main/ProjectEvolution"},
    {"FatesAdmin", "https://raw.githubusercontent.com/fatesc/fates-admin/main/main"},
    {"InfiniteYield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {"SimpleSpy", "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"}
}
local function createDetailedButton(scriptInfo)
    local Button = Instance.new("TextButton")
    Button.Parent = ScrollingFrame
    Button.Text = scriptInfo[1]
    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Azul Neon
    Button.BorderSizePixel = 0
    Button.TextColor3 = Color3.fromRGB(255, 255, 255) -- preto
    Button.Font = Enum.Font.SourceSansBold
    Button.TextScaled = true

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(0, 0, 0) -- Branco
    ButtonStroke.Thickness = 2
    ButtonStroke.Parent = Button

    local ButtonGradient = Instance.new("UIGradient")
    ButtonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),  -- Branco
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 255)) -- Tom ciano
    }
    ButtonGradient.Rotation = 45
    ButtonGradient.Parent = Button

    Button.MouseEnter:Connect(function()
        Button.TextColor3 = Color3.fromRGB(0, 255, 255) -- Amarelo ao passar o mouse
    end)

    Button.MouseLeave:Connect(function()
        Button.TextColor3 = Color3.fromRGB(255, 255, 255) -- Volta ao preto
    end)

    Button.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet(scriptInfo[2]))()
    end)

    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true)
    local goal = {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}
    local tween = tweenService:Create(Button, tweenInfo, goal)
    tween:Play()
end

for i = 1, #scripts do
    createDetailedButton(scripts[i])
end

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
