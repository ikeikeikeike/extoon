use Mix.Config

config :quantum,
  # global?: true,
  cron: [
    publish_run: [
      schedule: "10 * * * *",
      task: "Extoon.Builders.Publish.run",
      args: []
    ],
    info_run: [
      schedule: "20 */2 * * *",
      task: "Extoon.Builders.Info.run",
      args: []
    ],
    ranking_run: [
      schedule: "50,59 * * * *",
      task: "Extoon.Builders.Ranking.run",
      args: []
    ],
    hottest_run: [
      schedule: "55 * * * *",
      task: "Extoon.Builders.Hottest.run",
      args: []
    ]
  ]
