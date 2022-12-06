#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["DockerHostTest.csproj", "."]
RUN dotnet restore "./DockerHostTest.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DockerHostTest.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DockerHostTest.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerHostTest.dll"]