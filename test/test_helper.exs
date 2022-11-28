Mox.defmock(SponsoredImagesBehaviourMock, for: Nappy.SponsoredImagesBehaviour)
Application.put_env(:nappy, :sponsored_images, SponsoredImagesBehaviourMock)

Mox.defmock(UploadImagesBehaviourMock, for: Nappy.UploadImagesBehaviour)
Application.put_env(:nappy, :upload_images, UploadImagesBehaviourMock)

# ExUnit.configure(exclude: :feature)
ExUnit.start()
Nappy.GlobalSetup.init_seed()
Ecto.Adapters.SQL.Sandbox.mode(Nappy.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, NappyWeb.Endpoint.url())
