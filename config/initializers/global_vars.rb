$current_season = 4

CROPS = {maize: { model: MaizeReport,
                  text: 'Maize'
                },
         rice: { model: RiceReport,
                 text: 'Rice (irrigated)'
                },
         nerica_rice: { model: NericaRiceReport,
                        text: 'NERICA Rice (rainfed)'
                      },
         beans: { model: BeansReport,
                  text: 'Beans'
                },
         green_grams: { model: GreenGramsReport,
                        text: 'Green Grams (Ndengu)'
                      },
         black_eyed_beans: { model: BlackEyedBeansReport,
                             text: 'Black Eyed Beans (Njahi)'
                            },
         soya_beans: { model: SoyaBeansReport,
                       text: 'Soya Beans'
                    },
         pigeon_peas: { model: PigeonPeasReport,
                        text: 'Pigeon Peas'
                      }
        }.freeze