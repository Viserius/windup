package org.jboss.windup.graph.service;

import org.jboss.windup.graph.GraphContext;
import org.jboss.windup.graph.model.WindupConfigurationModel;

import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Helper methods for accessing the WindupConfigurationModel and associated data.
 * 
 * @author <a href="mailto:jesse.sightler@gmail.com">Jesse Sightler</a>
 */
public class WindupConfigurationService extends GraphService<WindupConfigurationModel>
{
    public WindupConfigurationService(GraphContext context)
    {
        super(context, WindupConfigurationModel.class);
    }

    /**
     * Mark Soelman
     * Add archive path so they can be shared between multiple reports
     */
    public static Path getArchivesPath(final GraphContext graphContext)
    {
        WindupConfigurationModel cfg = WindupConfigurationService.getConfigurationModel(graphContext);
        String archiveOutputFolder = cfg.getArchivePath().getFilePath();
        // old String archiveOutputFolder = cfg.getOutputPath().getFilePath();
        return Paths.get(archiveOutputFolder);
    }

    /**
     * Return the global {@link WindupConfigurationModel} configuration for this execution of Windup.
     */
    public static synchronized WindupConfigurationModel getConfigurationModel(GraphContext context)
    {
        WindupConfigurationModel config = new GraphService<>(context, WindupConfigurationModel.class).getUnique();
        if (config == null)
            config = new GraphService<>(context, WindupConfigurationModel.class).create();
        return config;
    }

}
